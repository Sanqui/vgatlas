!symfile hp2

NUM_LANGUAGES = 10
NUM_STRINGS = 3796

text {
    languages @sym.LanguageBanks [NUM_LANGUAGES] {
        bank    u8
        key  @(bank*0x4000+1+NUM_STRINGS*3) [u8]u8
        strings @(bank*0x4000+1) {
            bank_offset u8
            offset      u16
            b           0
            string @((bank+bank_offset)*0x4000+offset) []{
                bit b1
                b   key[b+bit]
                = switch b {
                    0..0x7f => 
                }
            }
        }
    }
    
    
}
