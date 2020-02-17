ref：
https://www.clearskysec.com/fox-kitten/

https://unit42.paloaltonetworks.com/threat-brief-iranian-linked-cyber-operations/

https://www.fireeye.com/blog/products-and-services/2020/01/fireeye-response-to-mounting-us-iran-tensions.html

-----------------------------------------------------------

## OilRig (AKA APT34/Helix Kitten)

https://attack.mitre.org/groups/G0049/

OilRig is a threat group Unit 42 named and discovered in May 2016. Since then, we have extensively researched their campaigns and operations. This threat group is extremely persistent and relies heavily on spear-phishing as their initial attack vector, but has also been associated with other more sophisticated attacks such credential harvesting campaigns and DNS hijacking. In their spear-phishing attacks, OilRig preferred macro-enabled Microsoft Office (Word and Excel) documents to install their custom payloads that came in the form of portable executables (PE), PowerShell and VBScripts. OilRig’s custom payloads frequently used DNS tunneling as a command and control (C2) channel.

Once gaining access to an end point, actors would use credential dumping tools, such as Mimikatz to gather credentials to legitimate accounts to then move laterally to other systems on the network. When presented with a webserver, OilRig would install a webshell as another ingress point to maintain access to the network.

References

https://www.clearskysec.com/powdesk-apt34/

https://blog.knowbe4.com/iranian-hacker-group-apt34-use-new-tonedeaf-malware-over-linkedin-in-latest-phishing-campaign

https://cyware.com/blog/apt34-the-helix-kitten-cybercriminal-group-loves-to-meow-middle-eastern-and-international-organizations-48ae

https://unit42.paloaltonetworks.com/behind-the-scenes-with-oilrig/

https://unit42.paloaltonetworks.com/dns-tunneling-in-the-wild-overview-of-oilrigs-dns-tunneling/

https://unit42.paloaltonetworks.com/unit42-analyzing-oilrigs-ops-tempo-testing-weaponization-delivery/

https://unit42.paloaltonetworks.com/unit42-oilrig-uses-updated-bondupdater-target-middle-eastern-government/

https://unit42.paloaltonetworks.com/unit42-oilrig-targets-middle-eastern-government-adds-evasion-techniques-oopsie/

https://unit42.paloaltonetworks.com/unit42-oilrig-targets-technology-service-provider-government-agency-quadagent/

https://unit42.paloaltonetworks.com/unit42-oopsie-oilrig-uses-threedollars-deliver-new-trojan/

https://unit42.paloaltonetworks.com/unit42-oilrig-uses-rgdoor-iis-backdoor-targets-middle-east/

https://unit42.paloaltonetworks.com/unit42-oilrig-performs-tests-twoface-webshell/

https://unit42.paloaltonetworks.com/unit42-oilrig-deploys-alma-communicator-dns-tunneling-trojan/

https://unit42.paloaltonetworks.com/unit42-oilrig-group-steps-attacks-new-delivery-documents-new-injector-trojan/

https://unit42.paloaltonetworks.com/unit42-striking-oil-closer-look-adversary-infrastructure/

https://unit42.paloaltonetworks.com/unit42-oilrig-uses-ismdoor-variant-possibly-linked-greenbug-threat-group/

https://unit42.paloaltonetworks.com/unit42-oilrig-actors-provide-glimpse-development-testing-efforts/

https://unit42.paloaltonetworks.com/the-oilrig-campaign-attacks-on-saudi-arabian-organizations-deliver-helminth-backdoor/

https://www.fireeye.com/blog/threat-research/2017/12/targeted-attack-in-middle-east-by-apt34.html

https://www.fireeye.com/blog/threat-research/2019/07/hard-pass-declining-apt34-invite-to-join-their-professional-network.html

https://www.brighttalk.com/webcast/10703/296317/apt34-new-targeted-attack-in-the-middle-east


## Magic Hound (AKA APT35/Newscaster/Cobalt Gypsy)

https://attack.mitre.org/groups/G0059/

The Magic Hound campaign targeted energy, government, and technology organizations with spear-phishing emails as a delivery mechanism. These emails delivered macro-enabled Microsoft Office documents and PE files within attachments. The documents and executables attached to emails would install a variety of tools from portable PE files, .NET Framework PE files, Meterpreter, IRC bots, an open sourced Meterpreter module called Magic Unicorn, and an open sourced Python RAT called Pupy.

The custom tools used in the Magic Hound campaign provided connections to other threat groups, such as the IRC Bot which was very similar to the Parastoo tool associated with the NEWSCASTER threat group. Also, a Magic Hound C2 server was also used as a C2 server for a tool called MPKBot that had been associated with the Rocket Kitten threat group.

References
https://unit42.paloaltonetworks.com/unit42-magic-hound-campaign-attacks-saudi-targets/

## APT33 (AKA Refined Kitten/Elfin)

https://attack.mitre.org/groups/G0064/

APT33 is a threat group thought to have strong interest in the aeronautics and energy sectors. They use spear-phishing attacks with a domain masquerading technique to make the links in their emails appear legitimate. They are known to use custom tools in conjunction with well-known publicly available backdoors that are sold in various hacking forums. A recent report uncovered this threat group’s attack infrastructure, which leveraged commercial VPN providers in addition to compromised systems to use as proxies to further mask their origins. This activity exemplified how this adversary group and other related groups will attack organizations outside of their mission objective to augment their own capabilities to complete their task.

References
https://www.fireeye.com/blog/threat-research/2017/09/apt33-insights-into-iranian-cyber-espionage.html

https://blog.trendmicro.com/trendlabs-security-intelligence/more-than-a-dozen-obfuscated-apt33-botnets-used-for-extreme-narrow-targeting/

https://www.brighttalk.com/webcast/10703/275683?utm_source=FireEye&utm_medium=pressrelease

## DarkHydrus

https://attack.mitre.org/groups/G0079/

The DarkHydrus threat group has targeted government entities and educational institutions with spear-phishing attacks and credential harvesting campaigns. DarkHydrus is a more sophisticated group when compared to others operating in the region, as their toolset and TTPs show a higher skill level. DarkHydrus has used custom tools in addition to publicly available red-teaming tools such as Phishery. They have also been observed using Google Drive for their C2 channel.

References
https://unit42.paloaltonetworks.com/unit42-new-threat-actor-group-darkhydrus-targets-middle-east-government/

https://unit42.paloaltonetworks.com/unit42-darkhydrus-uses-phishery-harvest-credentials-middle-east/

https://unit42.paloaltonetworks.com/darkhydrus-delivers-new-trojan-that-can-use-google-drive-for-c2-communications/

## Shamoon

The original Shamoon attack was launched in 2012 and targeted two specific organizations in the energy sector with the goal of rendering their respective computer systems inoperable by wiping their disks. The attack package included a commercially available driver to execute the wiping tasks and also included a worming component which allowed the package to spread within a target organization in an automated manner. The 2012 incident was one of the first large scale targeted destructive attacks that had been publicly shared. Since the original 2012 attack, two other instances of Shamoon have been discovered, in 2016 as well as 2018. In each instance, the primary capabilities and functionality remained largely the same.

References
https://securelist.com/shamoon-the-wiper-copycats-at-work/57854/

https://unit42.paloaltonetworks.com/unit42-shamoon-2-return-disttrack-wiper/

https://unit42.paloaltonetworks.com/unit42-second-wave-shamoon-2-attacks-identified/

https://unit42.paloaltonetworks.com/unit42-shamoon-2-delivering-disttrack/

https://unit42.paloaltonetworks.com/shamoon-3-targets-oil-gas-organization/

https://unit42.paloaltonetworks.com/shamoon-3-modified-open-source-wiper-contains-verse-from-the-quran/

## MuddyWater (AKA Static Kitten)

MuddyWater is a group that emerged in 2017 and was initially thought to be part of the financially motivated criminal group commonly referred to as FIN7 due to the use of an open source tool that was used by both sets of activity. Additional investigation revealed no other similarities in either tools or tactics, thus concluding that the MuddyWater activity was likely operated by a separate actor. This group generally used spear-phishing with macro-enabled Office documents to deliver their payloads, which were either embedded directly in the macro, or hosted on a first stage C2 server. These C2 servers were observed to be either third party file hosting sites or code sharing repositories such as GitHub. A significant portion of MuddyWater’s toolset consisted of open sourced red-teaming tools such as Invoke-Obfuscation, Lazagne, Mimikatz, etc.

References
https://unit42.paloaltonetworks.com/unit42-muddying-the-water-targeted-attacks-in-the-middle-east/

https://securelist.com/muddywater/88059/

https://www.clearskysec.com/muddywater2/

https://blog.trendmicro.com/trendlabs-security-intelligence/muddywater-resurfaces-uses-multi-stage-backdoor-powerstats-v3-and-new-post-exploitation-tools/


## APT39

https://www.fireeye.com/blog/threat-research/2019/01/apt39-iranian-cyber-espionage-group-focused-on-personal-information.html

## Other

https://www.fireeye.com/blog/threat-research/2019/12/breaking-the-rules-tough-outlook-for-home-page-attacks.html

https://www.fireeye.com/blog/threat-research/2018/03/iranian-threat-group-updates-ttps-in-spear-phishing-campaign.html

https://www.fireeye.com/blog/threat-research/2018/08/suspected-iranian-influence-operation.html

https://www.fireeye.com/blog/threat-research/2018/12/overruled-containing-a-potentially-destructive-adversary.html

https://www.fireeye.com/blog/threat-research/2019/01/global-dns-hijacking-campaign-dns-record-manipulation-at-scale.html

https://www.fireeye.com/blog/threat-research/2019/05/social-media-network-impersonates-us-political-candidates-supports-iranian-interests.html

https://www.fireeye.com/blog/threat-research/2019/12/breaking-the-rules-tough-outlook-for-home-page-attacks.html

https://www.clearskysec.com/iranian-apt-black-box/

https://www.clearskysec.com/fox-kitten/
