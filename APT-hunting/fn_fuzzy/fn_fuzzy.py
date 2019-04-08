# fn_fuzzy.py - IDAPython script for fast multiple binary diffing triage
# Takahiro Haruyama (@cci_forensics)

import os, ctypes, sqlite3, re, time, sys, subprocess
import cProfile
from collections import defaultdict
from pprint import PrettyPrinter
from StringIO import StringIO

from idc import *
import idautils, ida_nalt, ida_kernwin, idaapi, ida_expr

import mmh3
import yara_fn # modified version in the same folder

g_debug = False
g_db_path = r'Z:\haru\analysis\tics\fn_fuzzy.sqlite' # plz edit your path
g_min_bytes = 0x10 # minimum number of extracted code bytes per function
g_analyzed_prefix = r'fn_' # analyzed function name prefix (regex)
g_threshold = 50 # function similarity score threshold without CFG match
g_threshold_cfg = 10 # function similarity score threshold with CFG match
g_max_bytes_for_score = 0x80 # more code bytes are evaluated by only CFG match
g_bsize_ratio = 40 # function binary size correction ratio to compare (40 is enough)

# debug purpose to check one function matching
g_dbg_flag = False
g_dbg_fva = 0xffffffff
g_dbg_fname = ''
g_dbg_sha256 = ''

# initialization for ssdeep
SPAMSUM_LENGTH = 64
FUZZY_MAX_RESULT = (2 * SPAMSUM_LENGTH + 20)
dirpath = os.path.dirname(__file__)
_lib_path = os.path.join(dirpath, 'fuzzy64.dll')
fuzzy_lib = ctypes.cdll.LoadLibrary(_lib_path)

g_dump_types_path = os.path.join(dirpath, 'dump_types.py')

class defaultdictRecurse(defaultdict):
    def __init__(self):
        self.default_factory = type(self)

class import_handler_t(ida_kernwin.action_handler_t):
    def __init__(self, items, idb_path, title):
        ida_kernwin.action_handler_t.__init__(self)
        self.items = items
        self.idb_path = idb_path
        self.title = title
        
    def import_types(self):        
        idc_path = os.path.splitext(self.idb_path)[0] + '.idc'
        # dump type information from the 2nd idb
        if not (os.path.exists(idc_path)):
            with open(self.idb_path, 'rb') as f:
                sig = f.read(4)
            ida = 'ida.exe' if sig == 'IDA1' else 'ida64.exe'
            ida_path = os.path.join(idadir(), ida)                
            cmd = [ida_path, '-S{}'.format(g_dump_types_path), self.idb_path]
            #print cmd        
            proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            stdout, stderr = proc.communicate()
            if proc.returncode == 0:
                success('{}: type information successfully dumped'.format(self.idb_path))
            else: 
                error('{}: type information dumping failed'.format(self.idb_path))
                return False

        # import the type information
        idc_path = os.path.splitext(self.idb_path)[0] + '.idc'
        ida_expr.exec_idc_script(None, str(idc_path), "main", None, 0)
        return True
        
    def activate(self, ctx):
        sel = []
        for idx in ctx.chooser_selection:
            # rename the function
            ea = get_name_ea_simple(self.items[idx][2])
            sfname = str(self.items[idx][4])
            #set_name(ea, sfname)
            idaapi.do_name_anyway(ea, sfname)
            success('{:#x}: renamed to {}'.format(ea, sfname))
            # set the function prototype
            sptype = str(self.items[idx][5])
            if sptype != 'None':
                tinfo = idaapi.tinfo_t()
                idaapi.parse_decl2(idaapi.cvar.idati, sptype, tinfo, 0)
                #idaapi.apply_callee_tinfo(ea, tinfo)
                if idaapi.apply_tinfo(ea, tinfo, 0):
                    success('{:#x}: function prototype set to {}'.format(ea, sptype))
                else:
                    error('{:#x}: function prototype set FAILED (maybe you should import the types?)'.format(ea))
                    if ask_yn(0, 'Do you import types from the secondary idb?') == 1:
                        if self.import_types():
                            tinfo = idaapi.tinfo_t()
                            idaapi.parse_decl2(idaapi.cvar.idati, sptype, tinfo, 0)
                            if idaapi.apply_tinfo(ea, tinfo, 0):
                                success('{:#x}: function prototype set to {}'.format(ea, sptype))
                            else:
                                error('{:#x}: function prototype set FAILED again'.format(ea))
                        
            # insert the comment
            score = self.items[idx][0]
            mmatch = self.items[idx][1]
            cmt = 'fn_fuzzy: ssdeep={}, machoc={}'.format(score, mmatch)
            set_func_cmt(ea, cmt, 1)
            #set_decomplier_cmt(ea, cmt) # not sure how to avoid orphan comment

        # update the Choose rows
        ida_kernwin.refresh_chooser(self.title)

    def update(self, ctx):
        return idaapi.AST_ENABLE_ALWAYS
    '''
        return ida_kernwin.AST_ENABLE_FOR_WIDGET \
            if ida_kernwin.is_chooser_widget(ctx.widget_type) \
          else ida_kernwin.AST_DISABLE_FOR_WIDGET
    '''

class FnCh(ida_kernwin.Choose):
    def __init__(self, title, mfn, idb_path):
        self.mfn = mfn
        self.idb_path = idb_path
        self.title = title
        ida_kernwin.Choose.__init__(
            self,
            title,
            [
              ["ssdeep score",   10 | ida_kernwin.Choose.CHCOL_DEC],
              ["machoc matched",   10 | ida_kernwin.Choose.CHCOL_PLAIN],
              ["primary function", 30 | ida_kernwin.Choose.CHCOL_PLAIN],
              ["primary bsize",   10 | ida_kernwin.Choose.CHCOL_DEC],
              ["secondary analyzed function",   30 | ida_kernwin.Choose.CHCOL_PLAIN], 
              ["secondary prototype", 40 | ida_kernwin.Choose.CHCOL_PLAIN]
            ],
            flags = ida_kernwin.Choose.CH_MULTI)

    def OnInit(self):
        self.items = []
        for fva,v in sorted(self.mfn.items(), key=lambda x:x[1]['score'], reverse=True):
            if v['sfname']:
                self.items.append(['{}'.format(v['score']), '{}'.format(v['cfg_match']), get_name(fva), '{}'.format(v['pbsize']), v['sfname'], '{}'.format(v['sptype'])])
        return True

    def OnPopup(self, form, popup_handle):
        actname = "choose:actFnFuzzyImport"
        desc = ida_kernwin.action_desc_t(actname, 'Import function name and prototype', import_handler_t(self.items, self.idb_path, self.title))
        ida_kernwin.attach_dynamic_action_to_popup(form, popup_handle, desc)

    def OnGetSize(self):
        return len(self.items)

    def OnGetLine(self, n):
        return self.items[n]

    def OnSelectLine(self, n):
        idx = n[0] # due to CH_MULTI
        idc.Jump(get_name_ea_simple(self.items[idx][2]))

    def OnRefresh(self, n):
        self.OnInit()
        # try to preserve the cursor
        #return [ida_kernwin.Choose.ALL_CHANGED] + self.adjust_last_item(n)
        #return n
        return None

    def OnClose(self):
        print "closed ", self.title

class SummaryCh(ida_kernwin.Choose):
    def __init__(self, title, res):
        self.res = res
        ida_kernwin.Choose.__init__(
            self,
            title,
            [ ["SHA256", 20 | ida_kernwin.Choose.CHCOL_PLAIN],
              ["total similar functions",   20 | ida_kernwin.Choose.CHCOL_DEC],
              ["analyzed similar functions",   20 | ida_kernwin.Choose.CHCOL_DEC],
              ["idb path",   80 | ida_kernwin.Choose.CHCOL_PATH] ])
        self.items = []

    def OnInit(self):
        for sha256,v in sorted(self.res.items(), key=lambda x:x[1]['mcnt']['total'], reverse=True):
            if v['mcnt']['total'] > 0:
                self.items.append([sha256, '{}'.format(v['mcnt']['total']), '{}'.format(v['mcnt']['analyzed']), v['path']])
        return True

    def OnGetSize(self):
        return len(self.items)

    def OnGetLine(self, n):
        return self.items[n]

    def OnSelectLine(self, n):
        sha256 = self.items[n][0]
        c = FnCh("similarities with {}(snip)".format(sha256[:8]), self.res[sha256]['mfn'], self.res[sha256]['path'])
        c.Show()

    def OnRefresh(self, n):
        return n

    def OnClose(self):
        print "closed ", self.title

class FnFuzzyForm(ida_kernwin.Form):
    def __init__(self):
        ida_kernwin.Form.__init__(self,
r"""BUTTON YES* Run
BUTTON CANCEL Cancel
fn_fuzzy

{FormChangeCb}
General Options
<DB file path:{iDBSave}>
<minimum function code size:{iMinBytes}>
<exclude library/thunk functions:{cLibthunk}>
<enable debug messages:{cDebug}>{cGroup}>

<##Commands##Export:{rExport}>
<Compare:{rCompare}>{rGroup}>

Export options
<update the DB records:{cUpdate}>
<store flags as analyzed functions:{cAnaExp}>{cEGroup}>
<analyzed function name prefix (regex):{iPrefix}>

Compare options
<compare with only analyzed functions:{cAnaCmp}>
<compare with only idbs in the specified folder:{cFolCmp}>{cCGroup}>
<the folder path:{iFolder}>
<function code size comparison criteria (0-100):{iRatio}>
<function similarity score threshold (0-100) without CFG match:{iSimilarity}>
<function similarity score threshold (0-100) with CFG match:{iSimilarityCFG}>
<function code size threshold evaluated by only CFG match:{iMaxBytesForScore}>
""",
        {
            'FormChangeCb': ida_kernwin.Form.FormChangeCb(self.OnFormChange),
            'cGroup': ida_kernwin.Form.ChkGroupControl(("cLibthunk", "cDebug")),
            'iDBSave': ida_kernwin.Form.FileInput(save=True),
            'iMinBytes': ida_kernwin.Form.NumericInput(tp=ida_kernwin.Form.FT_HEX),
            'rGroup': ida_kernwin.Form.RadGroupControl(("rCompare", "rExport")),
            'cEGroup': ida_kernwin.Form.ChkGroupControl(("cUpdate", "cAnaExp")),
            'iPrefix': ida_kernwin.Form.StringInput(),
            'cCGroup': ida_kernwin.Form.ChkGroupControl(("cAnaCmp", "cFolCmp")),
            'iFolder': ida_kernwin.Form.DirInput(),
            'iRatio': ida_kernwin.Form.NumericInput(tp=ida_kernwin.Form.FT_DEC),
            'iSimilarity': ida_kernwin.Form.NumericInput(tp=ida_kernwin.Form.FT_DEC),
            'iSimilarityCFG': ida_kernwin.Form.NumericInput(tp=ida_kernwin.Form.FT_DEC),
            'iMaxBytesForScore': ida_kernwin.Form.NumericInput(tp=ida_kernwin.Form.FT_HEX),            
        })

    def OnFormChange(self, fid):
        if fid == -1:
            self.SetControlValue(self.cLibthunk, True)
            self.SetControlValue(self.cAnaExp, True)
            self.SetControlValue(self.cAnaCmp, True)
            self.SetControlValue(self.rCompare, True)
            
            self.EnableField(self.cEGroup, False)            
            self.EnableField(self.iPrefix, False)
            self.EnableField(self.cCGroup, True)
            self.EnableField(self.iSimilarity, True)
            self.EnableField(self.iSimilarityCFG, True)
            self.EnableField(self.iMaxBytesForScore, True)
            self.EnableField(self.iRatio, True)
        if fid == self.rExport.id:
            self.EnableField(self.cEGroup, True)
            self.EnableField(self.iPrefix, True)
            self.EnableField(self.cCGroup, False)
            self.EnableField(self.iSimilarity, False)
            self.EnableField(self.iSimilarityCFG, False)
            self.EnableField(self.iMaxBytesForScore, False)
            self.EnableField(self.iRatio, False)
        elif fid == self.rCompare.id:
            self.EnableField(self.cEGroup, False)
            self.EnableField(self.iPrefix, False)
            self.EnableField(self.cCGroup, True)
            self.EnableField(self.iSimilarity, True)
            self.EnableField(self.iSimilarityCFG, True)
            self.EnableField(self.iMaxBytesForScore, True)
            self.EnableField(self.iRatio, True)
        return 1

class FnFuzzy(object):
    def __init__(self, f_debug, db_path, min_bytes, f_ex_libthunk, f_update, f_ana_exp, ana_pre, f_ana_cmp = False, f_fol_cmp = False, ana_fol='', threshold = None, threshold_cfg = None, max_bytes_for_score = None, ratio = 0):
        self.f_debug = f_debug
        self.conn = sqlite3.connect(db_path)
        self.cur = self.conn.cursor()
        self.init_db()
        self.in_memory_db()        
        self.min_bytes = min_bytes
        self.f_ex_libthunk = f_ex_libthunk
        # for export
        self.f_update = f_update
        self.f_ana_exp = f_ana_exp        
        self.ana_pre = ana_pre
        if f_ana_exp:
            self.ana_pat = re.compile(self.ana_pre)
        # for compare
        self.f_ana_cmp = f_ana_cmp
        self.f_fol_cmp = f_fol_cmp
        self.ana_fol = ana_fol
        self.threshold = threshold
        self.threshold_cfg = threshold_cfg
        self.max_bytes_for_score = max_bytes_for_score
        self.ratio = float(ratio)

        self.idb_path = get_idb_path()
        self.sha256 = ida_nalt.retrieve_input_file_sha256().lower()
        self.md5 = ida_nalt.retrieve_input_file_md5().lower()

    def debug(self, msg):
        if self.f_debug:
            print "[D] {}".format(msg)

    def init_db(self):
        self.cur.execute("SELECT * FROM sqlite_master WHERE type='table'")
        if self.cur.fetchone() is None:
            info('DB initialized')
            self.cur.execute("CREATE TABLE IF NOT EXISTS sample(sha256 UNIQUE, path)")
            #self.cur.execute("CREATE INDEX sha256_index ON sample(sha256)")
            self.cur.execute("CREATE INDEX path_index ON sample(path)")
            self.cur.execute("CREATE TABLE IF NOT EXISTS function(sha256, fname, fhd, fhm, f_ana, bsize, ptype, UNIQUE(sha256, fname))")
            self.cur.execute("CREATE INDEX f_ana_index ON function(f_ana)") 
            self.cur.execute("CREATE INDEX bsize_index ON function(bsize)")

    def in_memory_db(self): # for SELECT
        tempfile = StringIO()
        for line in self.conn.iterdump():
            tempfile.write("{}\n".format(line))
        tempfile.seek(0)
        self.mconn = sqlite3.connect(":memory:")
        self.mconn.cursor().executescript(tempfile.read())
        self.mconn.commit()
        self.mconn.row_factory=sqlite3.Row
        self.mcur = self.mconn.cursor()

    def calc_fn_machoc(self, fva, fname): # based on Machoc hash implementation (https://github.com/0x00ach/idadiff)
        func = idaapi.get_func(fva)
        if type(func) == type(None):
            self.debug('{}: ignored due to lack of function object'.format(fname))
            return None, None

        flow = idaapi.FlowChart(f=func)
        cur_hash_rev = ""
        addrIds = []
        cur_id = 1
        for c in range(0,flow.size):
            cur_basic = flow.__getitem__(c)
            cur_hash_rev += shex(cur_basic.startEA)+":"
            addrIds.append((shex(cur_basic.startEA),str(cur_id)))
            cur_id += 1
            addr = cur_basic.startEA
            blockEnd = cur_basic.endEA
            mnem = GetMnem(addr)
            while mnem != "":
                if mnem == "call": # should be separated into 2 blocks by call
                     cur_hash_rev += "c,"
                     addr = NextHead(addr,blockEnd)
                     mnem = GetMnem(addr)
                     if addr != BADADDR:
                        cur_hash_rev += shex(addr)+";"+shex(addr)+":"
                        addrIds.append((shex(addr),str(cur_id)))
                        cur_id += 1
                else:
                    addr = NextHead(addr,blockEnd)
                    mnem = GetMnem(addr)
            refs = []
            for suc in cur_basic.succs():
                refs.append(suc.startEA)
            refs.sort()
            refsrev = ""
            for ref in refs:
                refsrev += shex(ref)+","
            if refsrev != "":
                refsrev = refsrev[:-1]
            cur_hash_rev +=  refsrev+";"

        # change addr to index
        for aid in addrIds:
            #cur_hash_rev = string.replace(cur_hash_rev,aid[0],aid[1])
            cur_hash_rev = cur_hash_rev.replace(aid[0],aid[1])
        # calculate machoc hash value
        self.debug('{}: CFG = {}'.format(fname, cur_hash_rev))
        return mmh3.hash(cur_hash_rev) & 0xFFFFFFFF, cur_id-1

    def calc_fn_ssdeep(self, fva, fname):
        d2h = ''
        for bb in yara_fn.get_basic_blocks(fva):
            rule = yara_fn.get_basic_block_rule(bb)
            if rule:
                chk = rule.cut_bytes_for_hash
                if len(chk) < yara_fn.MIN_BB_BYTE_COUNT:
                    continue
                d2h += chk
                #self.debug('chunk at {:#x}: {}'.format(bb.va, get_hex_pat(chk)))

        #self.debug('total func seq at {:#x}: {}'.format(fva, get_hex_pat(d2h)))
        if len(d2h) < self.min_bytes:
            self.debug('{}: ignored because of the number of extracted code bytes {}'.format(fname, len(d2h)))
            return None, None

        result_buffer = ctypes.create_string_buffer(FUZZY_MAX_RESULT)
        file_buffer = ctypes.create_string_buffer(d2h)
        hash_result = fuzzy_lib.fuzzy_hash_buf(file_buffer, len(file_buffer) - 1, result_buffer)
        hash_value = result_buffer.value.decode("ascii")
        return hash_value, len(d2h)

    def existed(self):
        self.mcur.execute("SELECT sha256 FROM sample WHERE sha256 = ?", (self.sha256,))
        if self.mcur.fetchone() is None:
            return False
        else:
            return True

    def exclude_libthunk(self, fva, fname):
        if self.f_ex_libthunk:
            flags = get_func_attr(fva, FUNCATTR_FLAGS)
            if flags & FUNC_LIB:
                self.debug('{}: ignored because of library function'.format(fname))
                return True
            if flags & FUNC_THUNK:
                self.debug('{}: ignored because of thunk function'.format(fname))
                return True
        return False

    def export(self):
        if self.existed() and not self.f_update:
            info('{}: The sample records are present in DB. skipped.'.format(self.sha256))
            return False

        self.cur.execute("REPLACE INTO sample values(?, ?)", (self.sha256, self.idb_path))

        pnum = tnum = 0
        records = []
        for fva in idautils.Functions():
            fname = get_func_name(fva)
            tnum += 1
            if self.exclude_libthunk(fva, fname):
                continue
            fhd, bsize = self.calc_fn_ssdeep(fva, fname)
            fhm, cfgnum = self.calc_fn_machoc(fva, fname)
            if fhd and fhm:
                pnum += 1
                f_ana = bool(self.ana_pat.search(fname)) if self.f_ana_exp else False
                tinfo = idaapi.tinfo_t()
                idaapi.get_tinfo(fva, tinfo)
                ptype = idaapi.print_tinfo('', 0, 0, idaapi.PRTYPE_1LINE, tinfo, fname, '')
                ptype = ptype + ';' if ptype is not None else ptype                
                records.append((self.sha256, fname, fhd, fhm, f_ana, bsize, ptype)) 
                self.debug('EXPORT {}: ssdeep={} (size={}), machoc={} (num of CFG={})'.format(fname, fhd, bsize, fhm, cfgnum))

        self.cur.executemany("REPLACE INTO function values (?, ?, ?, ?, ?, ?, ?)", records)
        success ('{} of {} functions exported'.format(pnum, tnum))
        return True

    def compare(self):
        res = defaultdictRecurse()
        if self.f_fol_cmp:
            self.mcur.execute("SELECT sha256,path FROM sample WHERE path LIKE ?", (self.ana_fol+'%',))
        else:
            self.mcur.execute("SELECT sha256,path FROM sample")
        frows = self.mcur.fetchall()
        num_of_samples = len(frows)
        for sha256, path in frows:
            res[sha256]['path'] = path
            res[sha256]['mcnt'].default_factory = lambda: 0
        
        #sql = "SELECT sha256,fname,fhd,fhm,f_ana,ptype FROM function WHERE f_ana == 1 AND bsize BETWEEN ? AND ?" if self.f_ana_cmp else "SELECT sha256,fname,fhd,fhm,f_ana,ptype FROM function WHERE bsize BETWEEN ? AND ?"
        sql = "SELECT function.sha256,fname,fhd,fhm,f_ana,ptype FROM function INNER JOIN sample on function.sha256 == sample.sha256 WHERE path LIKE ? AND " if self.f_fol_cmp else "SELECT sha256,fname,fhd,fhm,f_ana,ptype FROM function WHERE "
        sql += "f_ana == 1 AND bsize BETWEEN ? AND ?" if self.f_ana_cmp else "bsize BETWEEN ? AND ?"
        for fva in idautils.Functions():
            fname = get_func_name(fva)
            if self.exclude_libthunk(fva, fname) or not num_of_samples:
                continue
            pfhd, pbsize = self.calc_fn_ssdeep(fva, fname)
            pfhm, pcfgnum = self.calc_fn_machoc(fva, fname)
            if pfhd and pfhm:
                pbuf = ctypes.create_string_buffer(pfhd)                
                self.debug('COMPARE {}: ssdeep={} (size={}), machoc={} (num of bb={})'.format(fname, pfhd, pbsize, pfhm, pcfgnum))                
                min_ = pbsize * (1 - (self.ratio / 100))
                max_ = pbsize * (1 + (self.ratio / 100))
                self.debug('min={}, max={}'.format(min_, max_))
                if self.f_fol_cmp:
                    self.mcur.execute(sql, (self.ana_fol+'%', min_, max_))
                else:
                    self.mcur.execute(sql, (min_, max_))
                frows = self.mcur.fetchall()
                self.debug('targeted {} records'.format(len(frows)))                
                for sha256, sfname, sfhd, sfhm, sf_ana, sptype in frows:
                    if sha256 == self.sha256: # skip the self
                        continue
                    res[sha256]['mfn'][fva].default_factory = lambda: 0
                    sbuf = ctypes.create_string_buffer(sfhd)
                    score = fuzzy_lib.fuzzy_compare(pbuf, sbuf)

                    if g_dbg_flag and fva == g_dbg_fva and sfname == g_dbg_fname and sha256 == g_dbg_sha256:
                        self.debug('{:#x}: compared with {} in {} score = {} machoc match = {}'.format(fva, sfname, sha256, score, bool(pfhm == sfhm)))
                        
                    if (score >= self.threshold) or (score >= self.threshold_cfg and pfhm == sfhm) or (pbsize > self.max_bytes_for_score and pfhm == sfhm):
                        res[sha256]['mcnt']['total'] += 1
                        if sf_ana:
                            res[sha256]['mcnt']['analyzed'] += 1
                            if score > res[sha256]['mfn'][fva]['score'] or (res[sha256]['mfn'][fva]['score'] == 0 and pbsize > self.max_bytes_for_score):
                                res[sha256]['mfn'][fva]['score'] = score
                                res[sha256]['mfn'][fva]['cfg_match'] = bool(pfhm == sfhm)
                                res[sha256]['mfn'][fva]['sfname'] = sfname
                                res[sha256]['mfn'][fva]['sptype'] = sptype
                                res[sha256]['mfn'][fva]['pbsize'] = pbsize

        c = SummaryCh("fn_fuzzy summary", res)
        c.Show()
        success('totally {} samples compared'.format(num_of_samples))

    def close(self):
        self.conn.commit()
        self.cur.close()

def info(msg):
    print "[*] {}".format(msg)

def success(msg):
    print "[+] {}".format(msg)

def error(msg):
    print "[!] {}".format(msg)

def get_hex_pat(buf):
    # get hex pattern
    return ' '.join(['{:02x}'.format(ord(x)) for x in buf])

def shex(a):
    return hex(a).rstrip("L")

def set_decomplier_cmt(ea, cmt):
    cfunc = idaapi.decompile(ea)
    tl = idaapi.treeloc_t()
    tl.ea = ea
    tl.itp = idaapi.ITP_SEMI
    if cfunc:
      cfunc.set_user_cmt(tl, cmt)
      cfunc.save_user_cmts()
    else:
      error("Decompile failed: {:#x}".formart(ea))

def main():
    info('start')
        
    if idaapi.get_plugin_options("fn_fuzzy"): # CLI (export only)
        start = time.time()
        options = idaapi.get_plugin_options("fn_fuzzy").split(':')
        #print options
        min_bytes = int(options[0])
        f_ex_libthunk = eval(options[1])
        f_update = eval(options[2])
        f_ana_exp = eval(options[3])
        ana_pre = options[4]
        db_path = ':'.join(options[5:])
        ff = FnFuzzy(False, db_path, min_bytes, f_ex_libthunk, f_update, f_ana_exp, ana_pre)        
        res = ff.export()
        ff.close()
        elapsed = time.time() - start
        info('done (CLI)')
        if res: # return code 1 is reserved for error
            qexit(0) 
        else:
            qexit(2) # already exported (skipped)
    else: 
        f = FnFuzzyForm()
        f.Compile()
        f.iDBSave.value = g_db_path
        f.iMinBytes.value = g_min_bytes
        f.iPrefix.value = g_analyzed_prefix
        f.iFolder.value = os.path.dirname(get_idb_path())
        f.iSimilarity.value = g_threshold
        f.iSimilarityCFG.value = g_threshold_cfg
        f.iMaxBytesForScore.value = g_max_bytes_for_score
        f.iRatio.value = g_bsize_ratio
        r = f.Execute()
        if r == 1: # Run
            start = time.time()
            ff = FnFuzzy(f.cDebug.checked, f.iDBSave.value, f.iMinBytes.value, f.cLibthunk.checked, f.cUpdate.checked, f.cAnaExp.checked, f.iPrefix.value, f.cAnaCmp.checked, f.cFolCmp.checked, f.iFolder.value, f.iSimilarity.value, f.iSimilarityCFG.value, f.iMaxBytesForScore.value, f.iRatio.value)
            if f.rExport.selected: 
                ff.export()
                #cProfile.runctx('ff.export()', None, locals())
            else: 
                ff.compare()
                #cProfile.runctx('ff.compare()', None, locals())
            ff.close()
            elapsed = time.time() - start
        else:  
            print 'cancel'
            return
    
    info('elapsed time = {} sec'.format(elapsed))            
    info('done')

if __name__ == '__main__':
    main()



