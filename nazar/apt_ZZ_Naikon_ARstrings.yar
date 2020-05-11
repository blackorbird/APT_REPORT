rule apt_ZZ_Naikon_ARstrings : Naikon 
{
    meta:
        copyright = "Kaspersky"
        description = "Rule to detect Naikon aria samples"
        hash = "2B4D3AD32C23BD492EA945EB8E59B758"
        date = "2020-05-07"
        version = "1.0"

    strings:
        $a1 = "Terminate Process [PID=%d] succeeds!" fullword wide
        $a2 = "TerminateProcess [PID=%d] Failed:%d" fullword wide
        $a3 = "Close tcp connection returns: %d!" fullword wide
        $a4 = "Delete Directory [%s] returns:%d" fullword wide
        $a5 = "Delete Directory [%s] succeeds!" fullword wide
        $a6 = "Create Directory [%s] succeeds!" fullword wide
        $a7 = "SHFileOperation [%s] returns:%d" fullword wide
        $a8 = "SHFileOperation [%s] succeeds!" fullword wide
        $a9 = "Close tcp connection succeeds!" fullword wide
        $a10 = "OpenProcess [PID=%d] Failed:%d" fullword wide
        $a11 = "ShellExecute [%s] returns:%d" fullword wide
        $a12 = "ShellExecute [%s] succeeds!" fullword wide
        $a13 = "FindFirstFile [%s] Error:%d" fullword wide
        $a14 = "Delete File [%s] succeeds!" fullword wide
        $a15 = "CreateFile [%s] Error:%d" fullword wide
        $a16 = "DebugAzManager" fullword ascii
        $a17 = "Create Directroy [%s] Failed:%d" fullword wide

        $m1 = "TCPx86.dll" fullword wide ascii
        $m2 = "aria-body" nocase wide ascii

    condition:
        uint16(0) == 0x5A4D and
        filesize &lt; 450000 and
        (2 of ($a*) and 1 of ($m*))
}
