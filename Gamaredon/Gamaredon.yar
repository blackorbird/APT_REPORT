rule GamaredonPteranodon_SFX {
meta:
   	 description = "Yara Rule for Pteranodon implant Family"
   	 author = "ZLAB Yoroi - Cybaze"
   	 last_updated = "2019-04-19"
   	 tlp = "white"
   	 category = "informational"

   strings:
      $s1 = "SFX module - Copyright (c) 2005-2012 Oleg Scherbakov"
      $s2 = "7-Zip archiver - Copyright (c) 1999-2011 Igor Pavlov" 
      $s3 = "RunProgram=\"hidcon" 
      $s4 = "7-Zip - Copyright (c) 1999-2011 " ascii
      $s5 = "sfxelevation" ascii wide
      $s6 = "Error in command line:" ascii wide
      $s7 = "%X - %03X - %03X - %03X - %03X" ascii wide
      $s8 = "- Copyright (c) 2005-2012 "  ascii
      $s9 = "Supported methods and filters, build options:" wide ascii
      $s10 = "Could not overwrite file \"%s\"." wide ascii
      $s11 = "7-Zip: Internal error, code 0x%08X." wide ascii
      $s12 = "@ (%d%s)"  wide ascii
      $s13 = "SfxVarCmdLine0" ascii
      $s14 = "11326"
      $s15 = "29225"
      $s16 = "6137"
      $cmd = ".cmd" wide ascii 

condition:
      12 of ($s*) and $cmd
}

import "pe"
rule GamaredonPteranodon_SFX_intermediate_stage{
meta:
	description = "Yara Rule for Pteranodon implant Family Intermediate Stage"
	author = "Cybaze - Yoroi ZLab"
	last_updated = "2019-05-31"
	tlp = "white"
	category = "informational"
strings:
	$a1 = {56 8B F1 8D 46 04 50 FF}
	$a2 = {14 7A 19 5D 01 EB 18 02 85}
	$a3 = {0D 4D 38 B1 2D EE 1E 2B}
   	$b1 = {34 9B 43 00 50 FF 15 30}
    	$b2 = {AB B9 89 97 2F DD 7D 82}
    	$b3 = {9D CA C6 91 EF}
    	$c1 = {24 0C FF 15 34 9B 43 00}
    	$c2 = {32 31 32 F0 32 2E 39}
    	$c3 = {45 3B 4B 21 A7}

condition:
	pe.number_of_sections == 4 and all of ($a*) or
    	pe.number_of_sections == 6 and all of ($b*) or
    	pe.number_of_sections == 6 and all of ($c*)
}
