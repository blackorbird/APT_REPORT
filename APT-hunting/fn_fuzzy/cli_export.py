# cli_export.py - batch export script for fn_fuzzy
# Takahiro Haruyama (@cci_forensics)

import argparse, subprocess, os, sqlite3, time, sys
import idb # python-idb
import logging
logging.basicConfig(level=logging.ERROR) # to suppress python-idb warning

# plz edit the following paths
g_ida_dir = r'C:\work\tool\IDAx64'
g_db_path = r'Z:\haru\analysis\tics\fn_fuzzy.sqlite'
g_fn_fuzzy_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'fn_fuzzy.py')

g_min_bytes = 0x10 # minimum number of extracted code bytes per function
g_analyzed_prefix = r'fn_' # analyzed function name prefix (regex)

class LocalError(Exception): pass
class ProcExportError(LocalError): pass

def info(msg):
    print "[*] {}".format(msg)

def success(msg):
    print "[+] {}".format(msg)

def error(msg):
    print "[!] {}".format(msg)

def init_db(cur):
    cur.execute("SELECT * FROM sqlite_master WHERE type='table'")
    if cur.fetchone() is None:
        info('DB initialized')
        cur.execute("CREATE TABLE IF NOT EXISTS sample(sha256 UNIQUE, path)")
        #cur.execute("CREATE INDEX sha256_index ON sample(sha256)")
        cur.execute("CREATE INDEX path_index ON sample(path)")        
        cur.execute("CREATE TABLE IF NOT EXISTS function(sha256, fname, fhd, fhm, f_ana, bsize, ptype, UNIQUE(sha256, fname))")        
        cur.execute("CREATE INDEX f_ana_index ON function(f_ana)")        
        cur.execute("CREATE INDEX bsize_index ON function(bsize)")

def existed(cur, sha256):
    cur.execute("SELECT * FROM sample WHERE sha256 = ?", (sha256,))
    if cur.fetchone() is None:
        return False
    else:
        return True        

def remove(cur, sha256):
    cur.execute("DELETE FROM sample WHERE sha256 = ?", (sha256,))
    cur.execute("DELETE FROM function WHERE sha256 = ?", (sha256,))    
    
def export(f_debug, idb_path, outdb, min_, f_ex_libthunk, f_update, f_ana_exp, ana_pre, f_remove):
    # check the ext and signature
    ext = os.path.splitext(idb_path)[1]
    if ext != '.idb' and ext != '.i64':
        return 0   
    with open(idb_path, 'rb') as f:
        sig = f.read(4)        
    if sig != 'IDA1' and sig != 'IDA2':
        return 0

    # check the database record for the idb
    #print idb_path
    conn = sqlite3.connect(outdb)
    cur = conn.cursor()
    init_db(cur)
    with idb.from_file(idb_path) as db:
        api = idb.IDAPython(db)
        try:
            sha256 = api.ida_nalt.retrieve_input_file_sha256()
        except KeyError:
            error('{}: ida_nalt.retrieve_input_file_sha256() failed. The API is supported in 6.9 or later idb version. Check the API on IDA for validation.'.format(idb_path))
            return 0
    if f_remove:
        remove(cur, sha256)
        success('{}: the records successfully removed (SHA256={})'.format(idb_path, sha256))
        conn.commit()
        cur.close()            
        return 0        
    if existed(cur, sha256) and not f_update:
        info('{}: The sample records are present in DB (SHA256={}). Skipped.'.format(idb_path, sha256))
        return 0
    conn.commit()
    cur.close()    
    
    ida = 'ida.exe' if sig == 'IDA1' else 'ida64.exe'
    ida_path = os.path.join(g_ida_dir, ida)
    #cmd = [ida_path, '-L{}'.format(os.path.join(g_ida_dir, 'debug.log')), '-S{}'.format(g_fn_fuzzy_path), '-Ofn_fuzzy:{}:{}:{}:{}:{}:{}'.format(min_, f_ex_libthunk, f_update, f_ana_exp, ana_pre, outdb), idb_path]
    cmd = [ida_path, '-S{}'.format(g_fn_fuzzy_path), '-Ofn_fuzzy:{}:{}:{}:{}:{}:{}'.format(min_, f_ex_libthunk, f_update, f_ana_exp, ana_pre, outdb), idb_path]
    if not f_debug:
        cmd.insert(1, '-A')
    #print cmd        
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = proc.communicate()
    if proc.returncode == 0:
        success('{}: successfully exported'.format(idb_path))
        return 1
    elif proc.returncode == 2: # skipped
        return 0
    else: # maybe 1
        raise ProcExportError('{}: Something wrong with the IDAPython script (returncode={}). Use -d for debug'.format(idb_path, proc.returncode))

def list_file(d):
    for entry in os.listdir(d):
        if os.path.isfile(os.path.join(d, entry)):
            yield os.path.join(d, entry)

def list_file_recursive(d):
    for root, dirs, files in os.walk(d):
        for file_ in files:
            yield os.path.join(root, file_)    

def main():
    info('start')
    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('target', help="idb file or folder to export")
    parser.add_argument('--outdb', '-o', default=g_db_path, help="export DB path")
    parser.add_argument('--min_', '-m', type=int, default=g_min_bytes, help="minimum number of extracted code bytes per function")
    parser.add_argument('--exclude', '-e', action='store_true', help="exclude library/thunk functions")
    parser.add_argument('--update', '-u', action='store_true', help="update the DB records")
    parser.add_argument('--ana_exp', '-a', action='store_true', help="check analyzed functions")
    parser.add_argument('--ana_pre', '-p', default=g_analyzed_prefix, help="analyzed function name prefix (regex)")    
    parser.add_argument('--recursively', '-r', action='store_true', help="export idbs recursively")
    parser.add_argument('--debug', '-d', action='store_true', help="display IDA dialog for debug")
    parser.add_argument('--remove', action='store_true', help="remove records from db")
    args = parser.parse_args()

    start = time.time()
    cnt = 0
    if os.path.isfile(args.target):
        try:
            cnt += export(args.debug, args.target, args.outdb, args.min_, args.exclude, args.update, args.ana_exp, args.ana_pre, args.remove)
        except LocalError as e:
            error('{} ({})'.format(str(e), type(e)))
            return         
    elif os.path.isdir(args.target):
        gen_lf = list_file_recursive if args.recursively else list_file
        for t in gen_lf(args.target):
            try:
                cnt += export(args.debug, t, args.outdb, args.min_, args.exclude, args.update, args.ana_exp, args.ana_pre, args.remove)
            except LocalError as e:
                error('{} ({})'.format(str(e), type(e)))
                return         
    else:
        error('the target is not file/dir')
        return
    elapsed = time.time() - start
    success('totally {} samples exported'.format(cnt))
    info('elapsed time = {} sec'.format(elapsed))
    info('done')

if __name__ == '__main__':
    main()
