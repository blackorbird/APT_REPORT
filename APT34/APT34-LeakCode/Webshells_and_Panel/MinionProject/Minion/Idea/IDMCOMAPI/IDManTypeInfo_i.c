/* this file contains the actual definitions of */
/* the IIDs and CLSIDs */

/* link this file in with the server and any clients */


/* File created by MIDL compiler version 5.01.0164 */
/* at Mon Oct 13 07:34:24 2003
 */
/* Compiler settings for C:\users\sansan\testVersion\Downloader\IDManTypeInfo.idl:
    Os (OptLev=s), W1, Zp8, env=Win32, ms_ext, c_ext
    error checks: allocation ref bounds_check enum stub_data 
*/
//@@MIDL_FILE_HEADING(  )
#ifdef __cplusplus
extern "C"{
#endif 


#ifndef __IID_DEFINED__
#define __IID_DEFINED__

typedef struct _IID
{
    unsigned long x;
    unsigned short s1;
    unsigned short s2;
    unsigned char  c[8];
} IID;

#endif // __IID_DEFINED__

#ifndef CLSID_DEFINED
#define CLSID_DEFINED
typedef IID CLSID;
#endif // CLSID_DEFINED

const IID IID_ICIDMLinkTransmitter = {0x4BD46AAE,0xC51F,0x4BF7,{0x8B,0xC0,0x2E,0x86,0xE3,0x3D,0x18,0x73}};


const IID IID_ICIDMLinkTransmitter2 = {0x94D09862,0x1875,0x4FC9,{0xB4,0x34,0x91,0xCF,0x25,0xC8,0x40,0xA1}};


const IID LIBID_IDManLib = {0xECF21EAB,0x3AA8,0x4355,{0x82,0xBE,0xF7,0x77,0x99,0x00,0x01,0xDD}};


const CLSID CLSID_CIDMLinkTransmitter = {0xAC746233,0xE9D3,0x49CD,{0x86,0x2F,0x06,0x8F,0x7B,0x7C,0xCC,0xA4}};


#ifdef __cplusplus
}
#endif

