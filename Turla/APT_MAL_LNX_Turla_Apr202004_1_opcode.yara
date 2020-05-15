rule APT_MAL_LNX_Turla_Apr202004_1_opcode {
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
 $op0 = { 8D 41 05 32 06 48 FF C6 88 81 E0 80 69 00 } /* Xor string loop_p1 x32*/
 $op1 = { 48 FF C1 48 83 F9 49 75 E9 } /* Xor string loop_p2 x32*/
 $op2 = { C7 05 9B 7D 29 00 1D 00 00 00 C7 05 2D 7B 29 00 65 74 68 30 C6 05 2A 7B 29 00 00 E8 }
 /* Load eth0 interface*/
 $op3 = { BF FF FF FF FF E8 96 9D 0A 00 90 90 90 90 90 90 90 90 90 90 89 F0}
 /* Opcode exceptions*/
 $op4 = { 88 D3 80 C3 05 32 9A C1 D6 0C 08 88 9A 60 A1 0F 08 42 83 FA 08 76 E9 }
 /* Xor string loop x64*/
 $op5 = { 8B 8D 50 DF FF FF B8 09 00 00 00 89 44 24 04 89 0C 24 E8 DD E5 02 00 } /* Kill call x32 */
 $op6 = { 8D 5A 05 32 9A 60 26 0C 08 88 9A 20 F4 0E 08 42 83 FA 48 76 EB } /* Decrypt init str */
 $op7 = { 8D 4A 05 32 8A 25 26 0C 08 88 8A 20 F4 0E 08 42 83 FA 08 76 EB} /* Decrypt init str */
 condition:
 uint16(0) == 0x457f and
 filesize < 5000KB and
 2 of them
}
