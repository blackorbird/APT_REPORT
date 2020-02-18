rule Gamaredon_Campaign_Genuary_2020_Initial_Dropper {
	meta:
  	description = "Yara Rule for Gamaredon_f_doc"
  	author = "Cybaze Zlab_Yoroi"
  	last_updated = "2020-02-14"
  	tlp = "white"
  	category = "informational"

	strings:
   	 $a1 = { 4B 03 }
	 $a2 = { 8E DA 30 14 DD 57 EA 3F }
	 $a3 = { 3B 93 46 0F AF B0 2B 33 }
	 $a4 = { 50 4B 03 04 14 00 06 00 08 }

    condition:
   	 all of them
}
rule Gamaredon_Campaign_Genuary_2020_Second_Stage {
	meta:
  	description = "Yara Rule for Gamaredon_apu_dot"
  	author = "Cybaze Zlab_Yoroi"
  	last_updated = "2020-02-14"
  	tlp = "white"
  	category = "informational"

	strings:
   	 $a1 = "Menu\\Programs\\Startup\\\""
	 $a2 = "RandStrinh"
	 $a3 = ".txt"
	 $a4 = "templates.vbs"
	 $a5 = "GET"
	 $a6 = "Encode = 1032"
	 $a7 = "WShell=CreateObject(\"WScript.Shell\")"
	 $a8 = "Security"
	 $a9 = "AtEndOfStream"
	 $a10 = "GenRandom"
	 $a11 = "SaveToFile"
	 $a12 = "Sleep"
	 $a13 = "WinMgmts:{(Shutdown,RemoteShutdown)}!"
	 $a14 = "Scripting"
	 $a15 = "//autoindex.php"

    condition:
   	 11 of ($a*)
}
rule Gamaredon_Campaign_Genuary_2020_SFX_Stage_1 {
	meta:
  	description = "Yara Rule for Gamaredon SFX stage 1"
  	author = "Cybaze Zlab_Yoroi"
  	last_updated = "2020-02-14"
  	tlp = "white"
  	category = "informational"

	strings:
   	 $a1 = { 4D 5A }
	 $a2 = { FF 75 FC E8 F2 22 01 00 }
	 $a3 = { FE DE DB DB FE D5 D5 D6 F8 }
	 $a4 = { 22 C6 24 A8 BE 81 DE 63 }
	 $a5 = { CF 4F D0 C3 C0 91 B0 0D }

    condition:
   	 all of them
}
rule Gamaredon_Campaign_Genuary_2020_SFX_Stage_2 {
	meta:
  	description = "Yara Rule for Gamaredon SFX stage 2"
  	author = "Cybaze Zlab_Yoroi"
  	last_updated = "2020-02-14"
  	tlp = "white"
  	category = "informational"

	strings:
   	 $a1 = { 4D 5A }
	 $a2 = { 00 E9 07 D4 FD FF 8B 4D F0 81 }
	 $a3 = { B7 AB FE B2 B1 B5 FA 9B 11 80 }
	 $a4 = { 81 21 25 E0 38 03 FA F0 AF 11 }
	 $a5 = { 0A 39 DF F7 40 8D 7B 44 52 }

    condition:
   	 all of them
}
rule Gamaredon_Campaign_Genuary_2020_dot_NET_stage {
	meta:
  	description = "Yara Rule for Gamaredon dot NET stage"
  	author = "Cybaze Zlab_Yoroi"
  	last_updated = "2020-02-14"
  	tlp = "white"
  	category = "informational"

	strings:
   	 $a1 = { 4D 5A }
	 $a2 = "AssemblyCompanyAttribute"
	 $a3 = "GetDrives"
	 $a4 = "Aversome"
	 $a5 = "TotalMilliseconds"
	 $s1 = { 31 01 C6 01 F2 00 29 01 5C 03 76 }
	 $s2 = { 79 02 38 03 93 03 B5 03 }
	 $s3 = { 00 07 00 00 11 00 00 72 01 }
	 $s4 = { CD DF A6 EF 66 0E 44 D7 }

    condition:
   	 all of ($a*) and 2 of ($s*)
}
