rule apt28_backdoor_cls
{
            strings:
            $st1 = "AES_256_poco" ascii
                       $st2 = "TEncryption" ascii
                       $st3 = "shell" ascii
            condition:
                       all of them
}

rule apt28_backdoor_crc32
{
               strings:
                              $xor1 = { 48 8B 07 39 48 0C 75 3A 44 8B 70 08 4C 8B 38 4D 85 C0 74 2E 45 85 E4 74 29 }                                      
               condition:
               $xor1
}
