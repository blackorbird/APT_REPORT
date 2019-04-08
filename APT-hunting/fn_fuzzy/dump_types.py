import os

def main():
    path = os.path.splitext(get_idb_path())[0] + '.idc'
    gen_file(OFILE_IDC, path, 0, 0, GENFLG_IDCTYPE)
    Exit(0)

if ( __name__ == "__main__" ):
    main()
