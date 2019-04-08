'''
IDAPython script that generates a YARA rule to match against the
basic blocks of the current function. It masks out relocation bytes
and ignores jump instructions (given that we're already trying to
match compiler-specific bytes, this is of arguable benefit).

If python-yara is installed, the IDAPython script also validates that
the generated rule matches at least one segment in the current file.

author: Willi Ballenthin <william.ballenthin@fireeye.com>
'''
# 2018/8/6 Takahiro Haruyama modified to calculate fixup (relocation) size correctly
# and exclude direct memory reference data and other ignorable variable code

import logging
from collections import namedtuple

from idc import *
import idaapi
import idautils
import ida_ua, ida_kernwin

logger = logging.getLogger(__name__)

BasicBlock = namedtuple('BasicBlock', ['va', 'size'])


# each rule must have at least this many non-masked bytes
MIN_BB_BYTE_COUNT = 4

def get_basic_blocks(fva):
    '''
    return sequence of `BasicBlock` instances for given function.
    '''
    ret = []
    func = idaapi.get_func(fva)
    if func is None:
        return ret

    for bb in idaapi.FlowChart(func):
        ret.append(BasicBlock(va=bb.startEA,
                              size=bb.endEA - bb.startEA))

    return ret


def get_function(va):
    '''
    return va for first instruction in function that contains given va.
    '''
    return idaapi.get_func(va).startEA


Rule = namedtuple('Rule', ['name', 'bytes', 'masked_bytes', 'cut_bytes_for_hash'])


def is_jump(va):
    '''
    return True if the instruction at the given address appears to be a jump.
    '''
    return GetMnem(va).startswith('j')

def get_fixup_va_and_size(va):
    fva = idaapi.get_next_fixup_ea(va)
    ftype = get_fixup_target_type(fva)
    fsize = ida_fixup.calc_fixup_size(ftype)
    return fva, fsize

def get_basic_block_rule(bb):
    '''
    create and format a YARA rule for a single basic block.
    The following bytes are ignored:
        - relocation bytes
        - the last jump instruction
        - direct memory references / immediate values and other igorable data
    '''
    # fetch the instruction start addresses
    insns = []
    va = bb.va
    while va < bb.va + bb.size:
        insns.append(va)
        va = NextHead(va)

    # drop the last instruction if its a jump
    if insns and is_jump(insns[-1]):
        insns = insns[:-1]

    _bytes = []
    # `masked_bytes` is the list of formatted bytes,
    #   not yet join'd for performance.
    masked_bytes = []
    cut_bytes_for_hash = ''
    for va in insns:
        insn = ida_ua.insn_t()
        size = ida_ua.decode_insn(insn, va)
        mnem = insn.get_canon_mnem()
        op1 = insn.Op1
        op2 = insn.Op2

        fixup_byte_addrs = set([])
        if idaapi.contains_fixups(va, size): # not work for x64 binaries? (e.g., idaapi.contains_fixups(here(), 0x2d000) -> False)
            logging.debug('ea = {:#x}, fixups'.format(va))
            # fetch the fixup locations and sizes within this one instruction.
            fixups = []
            fva, fsize = get_fixup_va_and_size(va)
            fixups.append((fva, fsize))
            fva += fsize
            while fva < va + size:
                fva, fsize = get_fixup_va_and_size(fva - 1) # to detect consecutive fixups
                fixups.append((fva, fsize))
                fva += fsize
            logging.debug('fixups: {}'.format(fixups))
            # compute the addresses of each component byte.
            for fva, fsize in fixups:
                for i in range(fva, fva+fsize):
                    fixup_byte_addrs.add(i)

        # fetch and format each byte of the instruction,
        #  possibly masking it into an unknown byte if its a fixup or several operand types like direct mem ref.
        masked_types = [o_mem, o_imm, o_displ, o_near, o_far]
        #masked_types = [o_mem, o_imm, o_near, o_far]
        bytes_ = get_bytes(va, size)
        if bytes_ is None:
            return None
        for i, byte in enumerate(bytes_):
            _bytes.append(ord(byte))
            byte_addr = i + va
            if byte_addr in fixup_byte_addrs:
                logging.debug('{:#x}: fixup byte (masked)'.format(byte_addr))
                masked_bytes.append('??')
            elif op1.type in masked_types and i >= op1.offb and (i < op2.offb or op2.offb == 0):
                logging.debug('{:#x}: Op1 masked byte'.format(byte_addr))
                masked_bytes.append('??')
            elif op2.type in masked_types and i >= op2.offb:
                logging.debug('{:#x}: Op2 masked byte'.format(byte_addr))
                masked_bytes.append('??')
            else:
                masked_bytes.append('%02X' % (ord(byte)))
                cut_bytes_for_hash += byte

    return Rule('$0x%x' % (bb.va), _bytes, masked_bytes, cut_bytes_for_hash)


def format_rules(fva, rules):
    '''
    given the address of a function, and the byte signatures for basic blocks in
     the function, format a complete YARA rule that matches all of the
     basic block signatures.
    '''
    name = GetFunctionName(fva)
    if not rules:
        logging.info('no rules for {}'.format(name))
        return None

    # some characters aren't valid for YARA rule names
    safe_name = name
    BAD_CHARS = '@ /\\!@#$%^&*()[]{};:\'",./<>?'
    for c in BAD_CHARS:
        safe_name = safe_name.replace(c, '')

    md5 = idautils.GetInputFileMD5()
    ret = []
    ret.append('rule a_{hash:s}_{name:s} {{'.format(
        hash=md5,
        name=safe_name))
    ret.append('  meta:')
    ret.append('    sample_md5 = "{md5:s}"'.format(md5=md5))
    ret.append('    function_address = "0x{fva:x}"'.format(fva=fva))
    ret.append('    function_name = "{name:s}"'.format(name=name))
    ret.append('  strings:')
    for rule in rules:
        formatted_rule = ' '.join(rule.masked_bytes).rstrip('?? ')
        ret.append('    {name:s} = {{ {hex:s} }}'.format(
            name=rule.name,
            hex=formatted_rule))
    ret.append('  condition:')
    ret.append('    all of them')
    ret.append('}')
    return '\n'.join(ret)


def create_yara_rule_for_function(fva):
    '''
    given the address of a function, generate and format a complete YARA rule
     that matches the basic blocks.
    '''
    rules = []
    for bb in get_basic_blocks(fva):
        rule = get_basic_block_rule(bb)

        if rule:
            # ensure there at least MIN_BB_BYTE_COUNT
            #  non-masked bytes in the rule, or ignore it.
            # this will reduce the incidence of many very small matches.
            unmasked_count = len(filter(lambda b: b != '??', rule.masked_bytes))
            if unmasked_count < MIN_BB_BYTE_COUNT:
                continue

            rules.append(rule)

    return format_rules(fva, rules)


def get_segment_buffer(segstart):
    '''
    fetch the bytes of the section that starts at the given address.
    if the entire section cannot be accessed, try smaller regions until it works.
    '''
    segend = idaapi.getseg(segstart).endEA
    buf = None
    segsize = segend - segstart
    while buf is None and segsize > 0:
        buf = GetManyBytes(segstart, segsize)
        if buf is None:
            segsize -= 0x1000
    return buf


Segment = namedtuple('Segment', ['start', 'size', 'name', 'buf'])


def get_segments():
    '''
    fetch the segments in the current executable.
    '''
    for segstart in idautils.Segments():
         segend = idaapi.getseg(segstart).endEA
         segsize = segend - segstart
         segname = str(SegName(segstart)).rstrip('\x00')
         segbuf = get_segment_buffer(segstart)
         yield Segment(segstart, segend, segname, segbuf)


class TestDidntRunError(Exception):
    pass


def test_yara_rule(rule):
    '''
    try to match the given rule against each segment in the current exectuable.
    raise TestDidntRunError if its not possible to import the YARA library.
    return True if there's at least one match, False otherwise.
    '''
    try:
        import yara
    except ImportError:
        logger.warning("can't test rule: failed to import python-yara")
        raise TestDidntRunError('python-yara not available')

    r = yara.compile(source=rule)

    for segment in get_segments():
        if segment.buf is not None:
            matches = r.match(data=segment.buf)
            if len(matches) > 0:
                logger.info('generated rule matches section: {:s}'.format(segment.name))
                return True
    return False


def main():
    print 'Start'
    ans = ida_kernwin.ask_yn(0, 'define only selected function?')
    if ans:
        va = ScreenEA()
        fva = get_function(va)
        print('-' * 80)
        rule = create_yara_rule_for_function(fva)
        if rule:
            print(rule)
            if test_yara_rule(rule):
                logging.info('success: validated the generated rule')
            else:
                logging.error('error: failed to validate generated rule')
    else:
        for fva in idautils.Functions():
            print('-' * 80)
            rule = create_yara_rule_for_function(fva)
            if rule:
                print(rule)
    print 'Done'

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    logging.getLogger().setLevel(logging.INFO)
    #logging.basicConfig(level=logging.DEBUG)
    #logging.getLogger().setLevel(logging.DEBUG)
    main()
