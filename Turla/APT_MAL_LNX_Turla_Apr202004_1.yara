rule APT_MAL_LNX_Turla_Apr202004_1 {
 meta:
 description = "Detects Turla Linux malware x64 x32"
 date = "2020-04-24"
 hash1 = "67d9556c695ef6c51abf6fbab17acb3466e3149cf4d20cb64d6d34dc969b6502"
 hash2 = "8ccc081d4940c5d8aa6b782c16ed82528c0885bbb08210a8d0a8c519c54215bc"
 hash3 = "8856a68d95e4e79301779770a83e3fad8f122b849a9e9e31cfe06bf3418fa667"
 hash4 = "1d5e4466a6c5723cd30caf8b1c3d33d1a3d4c94c25e2ebe186c02b8b41daf905"
 hash5 = "2dabb2c5c04da560a6b56dbaa565d1eab8189d1fa4a85557a22157877065ea08"
 hash6 = "3e138e4e34c6eed3506efc7c805fce19af13bd62aeb35544f81f111e83b5d0d4"
 hash7 = "5a204263cac112318cd162f1c372437abf7f2092902b05e943e8784869629dd8"
 hash8 = "8856a68d95e4e79301779770a83e3fad8f122b849a9e9e31cfe06bf3418fa667"
 hash9 = "d49690ccb82ff9d42d3ee9d7da693fd7d302734562de088e9298413d56b86ed0"

 strings:
 $s1 = "/root/.hsperfdata" ascii fullword
 $s2 = "Desc| Filename | size |state|" ascii fullword
 $s3 = "VS filesystem: %s" ascii fullword
 $s4 = "File already exist on remote filesystem !" ascii fullword
 $s5 = "/tmp/.sync.pid" ascii fullword
 $s6 = "rem_fd: ssl " ascii fullword
 $s7 = "TREX_PID=%u" ascii fullword
 $s8 = "/tmp/.xdfg" ascii fullword
 $s9 = "__we_are_happy__" ascii fullword
 $s10 = "/root/.sess" ascii fullword
 $s11 = "ZYSZLRTS^Z@@NM@@G_Y_FE" ascii fullword
 condition:
 uint16(0) == 0x457f and
 filesize < 5000KB and
 4 of them
}
