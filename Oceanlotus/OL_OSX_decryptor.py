# String deobfuscation for Oceanlotus OSX backdoor

from __future__ import print_function

import idaapi
import idc
import idautils
import ida_kernwin
import ida_funcs

HELPER_COPY = ["qmemcpy", "memcpy", "strcpy"]
FUNC_COPY = ["_memcpy", "_strcpy"]

from Crypto.Cipher import AES
from base64 import b64decode
import string
import codecs

def search_binary(binary_string):
    for i in range(idaapi.get_segm_qty()):
        segm = idaapi.getnseg(i)
        current_ea = segm.startEA
        while True:
            current_ea = idaapi.find_binary(current_ea + 1, segm.endEA, binary_string, 16, idaapi.SEARCH_DOWN)
            if current_ea == idaapi.BADADDR:
                break
            return current_ea
    return 0

def is_number(n):
    return isinstance(n, int) or isinstance(n, long)

def display_num(n):
    return hex(n) if is_number(n) else n

def add_comment(cfunc, s, ea):
    idc.MakeComm(ea, s)
    tl = idaapi.treeloc_t()
    tl.ea = ea
    tl.itp = idaapi.ITP_SEMI
    cfunc.set_user_cmt(tl, s)
    cfunc.save_user_cmts()

# Generic function arguments extraction methods
def get_var(block, var_expr, stop_ea):
    class ExtractVar(idaapi.ctree_visitor_t):
        def __init__(self, var_expr, stop_ea):
            idaapi.ctree_visitor_t.__init__(self, idaapi.CV_FAST)
            self.var_expr = var_expr
            self.ret_expr = None
            self.stop_ea = stop_ea

        def visit_expr(self, i):
            if i.op == idaapi.cot_asg:
                if i.x.op == idaapi.cot_var:
                    if i.x.v.idx == self.var_expr.v.idx:
                        self.ret_expr = i.y
                elif i.x.op == idaapi.cot_ptr:
                    if i.x.x.op == idaapi.cot_var:
                        if i.x.x.v.idx == self.var_expr.v.idx:
                            self.ret_expr = i.y
                    elif i.x.x.op == idaapi.cot_cast:
                        if i.x.x.x.op == idaapi.cot_var:
                            if i.x.x.x.v.idx == self.var_expr.v.idx:
                                self.ret_expr = i.y
            elif i.op == idaapi.cot_call:
                if i.x.helper in HELPER_COPY or idc.Name(i.x.obj_ea) in FUNC_COPY:
                    if i.a[0].op == idaapi.cot_var:
                        if i.a[0].v.idx == self.var_expr.v.idx:
                            self.ret_expr = i.a[1]
                    elif i.a[0].op == idaapi.cot_cast or i.a[0].op == idaapi.cot_ref:
                        if i.a[0].x.op == idaapi.cot_var:
                            if i.a[0].x.v.idx == self.var_expr.v.idx:
                                self.ret_expr = i.a[1]
                        elif i.a[0].x.op == idaapi.cot_ref:
                            if i.a[0].x.x.op == idaapi.cot_var:
                                if i.a[0].x.x.v.idx == self.var_expr.v.idx:
                                    self.ret_expr = i.a[1]
            if i.ea == self.stop_ea:
                 return 1
            return 0

    x = ExtractVar(var_expr, stop_ea)
    x.apply_to(block, None)
    return x.ret_expr   

def get_args(cfunc, xref_addr, var_prop):
    class ExtractArgs(idaapi.ctree_visitor_t):
        def __init__(self, cfunc, xref_addr, var_prop=False):
            idaapi.ctree_visitor_t.__init__(self, idaapi.CV_POST)
            self.cfunc = cfunc
            self.call_addr = xref_addr
            self.args = []
            self.var_prop = var_prop
            self.blocks = [cfunc.body]
            self.cur_block = self.blocks[-1]


        def handle_expr(self, e):
            if e.op == idaapi.cot_num:
                return int(e.numval())
            elif e.op == idaapi.cot_var:
                v = get_var(self.cur_block, e, self.call_addr)
                if self.var_prop and v:
                    return self.handle_expr(v)
                else:
                    return self.cfunc.get_lvars()[e.v.idx].name
            elif e.op == idaapi.cot_obj:
                return int(e.obj_ea)
            elif e.op == idaapi.cot_cast:
                x = self.handle_expr(e.x)
                return x if is_number(x) else "(%s)%s" % (e.type, x)
            elif e.op == idaapi.cot_ptr:
                x = self.handle_expr(e.x)
                return x if is_number(x) else "*%s" % x
            elif e.op == idaapi.cot_ref:
                x = self.handle_expr(e.x)
                return x if is_number(x) else "&%s" % x
            elif e.op == idaapi.cot_add or e.op == idaapi.cot_sub:
                is_add = e.op == idaapi.cot_add
                x = self.handle_expr(e.x)
                y = self.handle_expr(e.y)
                if is_number(x) and is_number(y):
                    return x + y if is_add else x - y 
                else:
                    return "(%s %s %s)" % (x, "+" if is_add else "-", y)
            elif e.op == idaapi.cot_call:
                args = ', '.join([display_num(self.handle_expr(x)) for x in e.a])
                if e.x.op == idaapi.cot_helper:
                    return "%s(%s)" % (e.x.helper, args)
                else:
                    return "%s(%s)" % (idc.Name(e.x.obj_ea), args)
            elif e.op == idaapi.cot_str:
                binary_string = " ".join(["{:02x}".format(ord(x)) for x in codecs.escape_decode(e.string)[0]])
                occurence_ea = search_binary(binary_string)
                return occurence_ea if occurence_ea else int(e.ea)
            else:
                print("Error: cot_%s not handled" % e.opname)
                

        def visit_expr(self, i):
            if (i.op == idaapi.cot_call and i.ea == self.call_addr):
                self.args = []
                for arg in i.a:
                    self.args.append(display_num(self.handle_expr(arg)))
                return 1
            return 0

        def visit_insn(self, i):
            if (i.op == idaapi.cit_block):
                self.blocks.append(i)
                self.cur_block = self.blocks[-1]
            return 0

        def leave_insn(self, i):
            if (i.op == idaapi.cit_block):
                self.blocks.pop()
                self.cur_block = self.blocks[-1]
            return 0

    x = ExtractArgs(cfunc, xref_addr, var_prop)
    x.apply_to(cfunc.body, None)
    return x.args

class extract_args_t(ida_kernwin.action_handler_t):
    def __init__(self, callback, var_prop=False):
        ida_kernwin.action_handler_t.__init__(self)
        self.var_prop = var_prop
        self.callback = callback

    def activate(self, ctx):
        for pfn_idx in ctx.chooser_selection:
            pfn = ida_funcs.getn_func(pfn_idx)
            if pfn:
                xrefs = [x for x in idautils.CodeRefsTo(pfn.start_ea, 0)]
                for xref in list(set(xrefs)):
                    cfunc = idaapi.decompile(xref)
                    if cfunc:
                        xref_args = get_args(cfunc, xref, self.var_prop)
                        self.callback(xref, cfunc, xref_args)
        return 1

    def update(self, ctx):
        if ctx.widget_type == ida_kernwin.BWN_FUNCS:
            return ida_kernwin.AST_ENABLE_FOR_WIDGET
        else:
            return ida_kernwin.AST_DISABLE_FOR_WIDGET

# Decryption specific methods
def custom_b64decode(encoded_str):
    normal_abc = string.uppercase + string.lowercase + string.digits + "+/"
    custom_abc = GetManyBytes(CUSTOM_B64_ALPHA, 0x40)
    decode_abc = string.maketrans(custom_abc, normal_abc)
    try:
        decoded = b64decode(encoded_str.translate(decode_abc))
    except:
        decoded = ''
    return decoded

def null_pad(s, blocksize):
    return s + "\x00" * (blocksize - len(s))

def PKCS7_unpad(string):
    pad = string[-1]
    if ord(pad) > len(string) or not all(pad == x for x in string[len(string) - ord(pad):]):
        return string
    return string[:len(string) - ord(pad)]

def convert_args_to_long(xref_args):
    try:
        args = [long(l, 16) for l in xref_args]
    except:
        args = []
    return args

def decrypt_data(xref, cfunc, xref_args):
    print("%s: " % hex(int(xref)), end='')
    args = convert_args_to_long(xref_args)
    if args:
        try:
            key = idaapi.get_many_bytes(args[2], args[3] if idc.Dword(args[3]) == 0xffffffff else idc.Dword(args[3]))
            data = idaapi.get_many_bytes(args[0], args[1] if idc.Dword(args[1]) == 0xffffffff else idc.Dword(args[1]))
        except TypeError:
            print("Couldn't retrieve the cipher or the key.")
            print(xref_args)
        else:
            key = null_pad(key, 0x20)
            if args[4] == 1:
                data = custom_b64decode(data)
            plain = PKCS7_unpad(AES.new(key, AES.MODE_CBC, "\x00"*16).decrypt(data))
            #add_comment(cfunc, plain, xref)
            print(plain)
    else:
        print("Not all args are numbers")
        print(xref_args)

CUSTOM_B64_ALPHA = "IJKLMNOPABCDEFGHQRSTUVWXghijklmnYZabcdefopqrstuv456789+/wxyz0123"
ACTION_NAME = "extract-decrypt-arguments-var-prop"
ida_kernwin.unregister_action(ACTION_NAME)
if idaapi.init_hexrays_plugin():
    ida_kernwin.register_action(ida_kernwin.action_desc_t(ACTION_NAME, "Extract and decrypt arguments", extract_args_t(decrypt_data, True), None))
class popup_hooks_t(ida_kernwin.UI_Hooks):
    def finish_populating_widget_popup(self, w, popup):
        if ida_kernwin.get_widget_type(w) == ida_kernwin.BWN_FUNCS:
            ida_kernwin.attach_action_to_popup(w, popup, ACTION_NAME, None)
hooks = popup_hooks_t()
hooks.hook()
