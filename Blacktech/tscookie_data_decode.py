#!/usr/bin/env python
#
# LICENSE
# the GNU General Public License version 2
#

import sys
import pefile
import re
import argparse
from struct import unpack, unpack_from

# MZ Header
MZ_HEADER = b"\x4D\x5A\x90\x00"

RC4_KEY_LENGTH = 0x80
KEY_END = b"\x92\x5A\x76\x5D"

# Config pattern
CONFIG_PATTERNS = [re.compile("\x68(....)\xE8(....)\x59\x6A\x01\x58\xC3", re.DOTALL),
                   re.compile("\x68(....)\xE8(....)\x59", re.DOTALL)]
CONFIG_SIZE = 0xBF0

CONNECT_MODE   = {0 : 'TCP' , 1 : 'HTTP with Credentials' , 2 : 'HTTP with Credentials', 3 : 'HTTP with Credentials', 5 : 'HTTP',
                  6 : 'HTTPS' , 7 : 'HTTPS' , 8 : 'HTTPS' ,}
PROXY_MODE     = {0 : 'Detect proxy settings' , 1 : 'Use config'}
INJECTION_MODE = {0 : 'Create process' , 1 : 'Injection running process'}
PROCESS_NAME   = {0 : 'svchost.exe', 1 : 'iexplorer.exe', 2 : 'explorer.exe', 3 : 'Default browser' , 4: 'Setting process'}

parser = argparse.ArgumentParser(description="TSCookie Data Config Parser")
parser.add_argument("file", type=str, metavar="FILE", help="TSCookie Data file")
args = parser.parse_args()


# RC4
def rc4(data, key):
    x = 0
    box = range(256)
    for i in range(256):
        x = (x + box[i] + ord(key[i % len(key)])) % 256
        box[i], box[x] = box[x], box[i]
    x = 0
    y = 0
    out = []
    for char in data:
        x = (x + 1) % 256
        y = (y + box[x]) % 256
        box[x], box[y] = box[y], box[x]
        out.append(chr(ord(char) ^ box[(box[x] + box[y]) % 256]))

    return ''.join(out)


# helper function for formatting string
def __format_string(data):
    return data.split("\x00")[0]


# Parse config
def parse_config(config):
    print("\n[Config data]")
    print("{0}\n".format("-" * 50))
    print("Server name   : {0}".format(__format_string(unpack_from("<1024s", config, 0)[0])))
    print("KEY           : 0x{0:X}".format(unpack_from(">I", config, 0x400)[0]))
    print("Sleep count   : {0}".format(unpack_from("<H", config, 0x404)[0]))
    print("Mutex         : {0}".format(unpack_from("<32s", config, 0x40c)[0]))
    mode = unpack_from("<H", config, 0x44c)[0]
    print("Connect mode  : {0} ({1})".format(mode, CONNECT_MODE[mode]))
    print("Connect keep  : {0}".format(unpack_from("<H", config, 0x454)[0]))
    icmp = unpack_from("<H", config, 0x458)[0]
    if icmp == 100:
        print("ICMP mode     : {0}".format("Enable"))
        print("ICMP bind IP  : {0}".format(__format_string(unpack_from("<330s", config, 0x4D4)[0])))
    else:
        print("ICMP mode     : {0}".format("Disable"))
    injection = unpack_from("<H", config, 0x624)[0]
    print("Injection mode: {0} ({1})".format(injection, INJECTION_MODE[injection]))
    print("  Process name: {0}".format(PROCESS_NAME[unpack_from("<H", config, 0x628)[0]]))
    print("  Custom name : {0}".format(__format_string(unpack_from("<256s", config, 0x62c)[0])))
    if config[0x72c] != "\x00":
        print("Proxy server  : {0}".format(__format_string(unpack_from("<64s", config, 0x72c)[0])))
        print("        port  : {0}".format(unpack_from("<H", config, 0x76c)[0]))
        print("    UserName  : {0}".format(__format_string(unpack_from("<64s", config, 0x770)[0])))
        print("    Password  : {0}".format(__format_string(unpack_from("<64s", config, 0x790)[0])))
    proxy = unpack_from("<H", config, 0x7b0)[0]
    print("Proxy mode    : {0} ({1})".format(proxy, PROXY_MODE[proxy]))
    print("AuthScheme    : {0}".format(unpack_from("<H", config, 0x7b4)[0]))

# Decode data
def decode_data(data, fname):
    try:
        enc_data = data[:-RC4_KEY_LENGTH]
        rc4key = data[-RC4_KEY_LENGTH:-4] + KEY_END
        dec_data = rc4(enc_data, rc4key)
        open(fname, "wb").write(dec_data)
        print("[*] Successful decoding data : {0}".format(fname))
    except:
        sys.exit("[!] Faild to resource decoding.")
    return dec_data

def main():
    with open(args.file, "rb") as fb:
        data = fb.read()

    dec_data = decode_data(data, args.file + ".decode")

    dll_index = dec_data.find(MZ_HEADER)
    if dll_index:
        dll_data = dec_data[dll_index:]
        dll = pefile.PE(data=dll_data)
        print("[*] Found main DLL : 0x{0:X}".format(dll_index))
    else:
        sys.exit("[!] DLL data not found in decoded resource.")

    for pattern in CONFIG_PATTERNS:
        mc = re.search(pattern, dll_data)
        if mc:
            try:
                (config_rva, ) = unpack("=I", dll_data[mc.start() + 1:mc.start() + 5])
                config_addr = dll.get_physical_by_rva(config_rva - dll.NT_HEADERS.OPTIONAL_HEADER.ImageBase)
                enc_config_data = dll_data[config_addr:config_addr + CONFIG_SIZE]
                print("[*] Found config data : 0x{0:X}".format(config_rva))
            except:
                sys.exit("[!] Config data not found in DLL.")

    try:
        enc_config = enc_config_data[RC4_KEY_LENGTH:]
        rc4key = enc_config_data[:RC4_KEY_LENGTH]
        config = rc4(enc_config, rc4key)
        open(args.file + ".config", "wb").write(config)
        print("[*] Successful decoding config: {0}".format(args.file + ".config"))
    except:
        sys.exit("[!] Faild to decoding config data.")

    parse_config(config)

    print("\n[*] Done.")

if __name__ == "__main__":
    main()
