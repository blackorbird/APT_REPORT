import “pe”
rule OceanLotus_Steganography_Loader
{
    meta:
        description = “OceanLotus Steganography Loader”
    strings:
        $data1 = “.?AVCBC_ModeBase@CryptoPP@@” ascii
    condition:\
        // Must be MZ file
        uint16(0) == 0x5A4D and
        // Must be smaller than 2MB
        filesize < 2MB and
        // Must be a DLL
        pe.characteristics & pe.DLL and
        // Must contain the following imports
        pe.imports(“gdiplus.dll”, “GdipGetImageWidth”) and
        pe.imports(“gdiplus.dll”, “GdipCreateBitmapFromFile”) and
        pe.imports(“kernel32.dll”, “WriteProcessMemory”) and
        // Check for strings in .data
        for all of ($data*) :
        (
            $ in
            (
            pe.sections[pe.section_index(“.data”)].raw_data_offset
            ..
                pe.sections[pe.section_index(“.data”)].raw_data_offset + pe.sections[pe.section_index(“.data”)].raw_data_size
             )
         )
}
