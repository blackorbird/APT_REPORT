rule TREKX_Backdoor

{

meta:

description = “X-Force IRIS TREKX Backdoor”

version = “1”

md5 = “01e4391421d56698bcaa1f3c05bd9818”

strings:

$ = “3.001.” wide ascii

$ = “2.TT.” wide ascii

$ = “4.PSPR.” wide ascii

$ = “4.RSPM.” wide ascii

$ = “TREK” wide ascii

$ = “TREC” wide ascii

$ = “TREX” wide ascii

$ = “*.tmp” wide ascii

$ = “SOFTWARE\\Microsoft\\DRM” wide ascii

$ = “srv.dat” wide ascii

$ = “<dt1>” wide ascii

$ = “File1” wide ascii

$ = “vf%03d” wide ascii

$ = “error 1!” wide ascii

$ = “{????????-????-????-????-????????????}” wide ascii

condition:

(uint16(0) == 0x5a4d) and (5 of them)

}

rule TREKX_Backdoor_Config

{

meta:

description = “X-Force IRIS TREKX Backdoor Configuration”

version = “1”

md5 = “ede89b446d8703dd13d26168e8d58865”

md5 = “7c08601341888b413779a3b33d8bf6dc”

condition:

// These are all the checks performed by the TREKX backdoor

// (md5:01e4391421d56698bcaa1f3c05bd9818) when

// checking the validity of the configuration file

(

(uint32(0) == 0x00AE2A6D)

or

(uint32(0) == 0x031B9D63)

)

and

(

filesize >= 230

)

and

(

uint16(filesize-2) == 0x0054

)

}
