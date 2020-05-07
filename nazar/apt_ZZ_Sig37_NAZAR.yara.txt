import "pe"
import "hash"

rule apt_ZZ_SIG37_NAZAR_GpUpdatesExe
{
	meta:
		desc = "SIG37 GpUpdates dropper, Chilkat Zip2Secure"
		author = "JAG-S"
		hash = "75e4d73252c753cd8e177820eb261cd72fecd7360cc8ec3feeab7bd129c01ff6"
	strings:
		$open = "open" ascii wide fullword
		$regsrv = "regsvr32.exe" ascii wide
		$filename1 = "Godown.dll -s" ascii wide
		$filename2 = "ViewScreen.dll -s" ascii wide
		$filename3 = "Filesystem.dll -s" ascii wide

	condition:
		uint16(0) == 0x5a4d
		and
		($open and $regsrv and (1 of ($filename*))) 
}

rule apt_ZZ_SIG37_NAZAR_FarsiResources
{
	meta:
		desc = "SIG37 GpUpdates Shared Farsi resources"
		author = "JAG-S"
		hash = "75e4d73252c753cd8e177820eb261cd72fecd7360cc8ec3feeab7bd129c01ff6"
	condition:
		uint16(0) == 0x5a4d
		and
		for any i in (0..pe.number_of_resources - 1): //FARSI resources
			(
				hash.sha256(pe.resources[i].offset, pe.resources[i].length) == "893cf8c164106784669b395825f17c21f46a345babfff6144686e8e1a48bf2f1"
				or
				hash.sha256(pe.resources[i].offset, pe.resources[i].length) == "26ee0ff37e6ffd30ca5415992ececc5faeb8e6a937fcbeb3952ce5581456b7b5"
			)
}

rule apt_ZZ_SIG37_NAZAR_GoDownDll
{
	meta:
		desc = "SIG37 Dropped TypeLibrary"
		author = "JAG-S"		
		hash = "8fb9a22b20a338d90c7ceb9424d079a61ca7ccb7f78ffb7d74d2f403ae9fbeec" //??
	strings:
		$godown1 = /Godown [0-9.]{1,4} Type LibraryWWW/ ascii wide
		$godown2 = "Godown.Shutdown.1" ascii wide
		$godown3 = "qGODOWNLibWWW" ascii wide

		$guid1 = "{772BA12D-8A62-4DD3-B3E8-92DA702E6F3D}" ascii wide //TypeLib reg
		$guid2 = "{B64E94AF-D56B-48B4-B178-AF0723E72AB5}" ascii wide //TypeLib reg
		$guid3 = "{DBCB4B31-21B8-4A0F-BC69-0C3CE3B66D00}" ascii wide

		$shutdown1 = "aShutdownd" ascii wide
		$shutdown2 = "IShutdownWWWd" ascii wide
		$shutdown3 = "IShutdown InterfaceWWW" ascii wide
		$shutdown4 = "method PowerOffWWW" ascii wide		
		$shutdown5 = "property TimeoutWW" ascii wide

	condition:
		uint16(0) == 0x5a4d
		and
		(
			any of ($godown*)
			or
			any of ($guid*)
			or
			2 of ($shutdown*)
		)
}

rule apt_ZZ_SIG37_NAZAR_Kzher_pdb
{
	meta:
		desc = "GoDown PDB Path"
		author = "JAG-S"		
		hash = "4d0ab3951df93589a874192569cac88f7107f595600e274f52e2b75f68593bca"
		hash = "d9801b4da1dbc5264e83029abb93e800d3c9971c650ecc2df5f85bcc10c7bd61"
		hash = "1110c3e34b6bbaadc5082fabbdd69f492f3b1480724b879a3df0035ff487fd6f"
	strings:
		$pdb_spec = "C:\\khzer\\DLLs\\DLL's Source\\" ascii wide
		$pdb_gen = "C:\\khzer\\" ascii wide

	condition:
		uint16(0) == 0x5a4d
		and
		any of them
}


rule apt_ZZ_SIG37_NAZAR_GpUpdates_Distribute
{
	meta:
		desc = "SIG37 GpUpdates unpacked distributor: Distribute.exe"
		author = "JAG-S"
		hash = "6b8ea9a156d495ec089710710ce3f4b1e19251c1d0e5b2c21bbeeab05e7b331f"
		parent = "d34a996826ea5a028f5b4713c797247913f036ca0063cc4c18d8b04736fa0b65"
	strings:
		$uniq_filename1 = "\\godown.dll" ascii wide
		
		
		$common_filename1 = "\\ViewScreen.dll" ascii wide
		$common_filename2 = "\\filesystem.dll" ascii wide
		$common_filename3 = "\\dllcache\\svchost.exe" ascii wide
		$common_filename4 = "\\lame_enc.dll" ascii wide
		$common_filename5 = "\\hodll.dll" ascii wide

		$service1 = "Provides basic host functionality" ascii wide
		$service2 = "EYService" ascii wide
		$service3 = "Windows Host Service" ascii wide
	condition:
		uint16(0) == 0x5a4d
		and
		(
			any of ($uniq_filename*)
			or
			all of ($common_filename*)
			or
			(all of ($service*) and 3 of ($common_filename*))
		)
}