import "pe"

rule Dropper_APT28XAGENTJuly2018 {
meta:
description = "Yara Rule for dropper of APT28 XAGENT July2018"
tlp = "white"
category = "informational"
strings:
$a = {8B 45 FC 8B 10 FF} 
$b = {33 2E 34 2D 31 39}
condition:
(pe.number_of_sections == 9 
and pe.sections[3].name == ".bss" 
and all of them) 
or (pe.number_of_sections == 3 
and pe.sections[0].name == "UPX0"
and pe.sections[1].name == "UPX1"
and pe.number_of_resources == 70
and pe.resources[61].type == pe.RESOURCE_TYPE_RCDATA
and pe.resources[60].t
ype == pe.RESOURCE_TYPE_RCDATA
and pe.resources[59].type == pe.RESOURCE_TYPE_RCDATA)
} 

rule FirstPayload_upnphost_APT28XAGENTJuly2018 {
meta:
description = "Yara Rule for APT28 XAGENT July2018 First Payload"
tlp = "white"
category = "informational"
strings:
$a = {56 AB 37 92 E8}
$b = {41 75 74 6F 49 74}
condition:
pe.number_of_resources == 26 
and pe.resources[19].type == pe.RESOURCE_TYPE_RCDATA 
and pe.version_info["FileDescription"] contains 
"Compatibility"
and all of them
}

rule SecondPayload_sdbn_APT28XAGENTJuly2018 {
meta:
description = "Yara Rule for AP
T28 XAGENT July2018 Second Payload sdbn.dll"
category = "informational"
strings:
$a = {0F BE C9 66 89}
$b = {8B EC 83 EC 10}
condition:
pe.number_of_sections == 6
and pe.number_of_resources == 1
and pe.resources[0].type == pe.RESOURCE_TYPE_VERSION
and pe.version_info["ProductName"] contains "Microsoft"
and all of them
}