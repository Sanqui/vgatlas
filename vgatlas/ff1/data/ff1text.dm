!import ff1char

:FF1Text {
    basic           @0x2B712 {
        items    [27]StringPtr
        weapons  [40]StringPtr
        armor    [40]StringPtr
        golds    [68]StringPtr
        magic    [64]StringPtr
        classes  [12]StringPtr
    }
    monsters        @0x2d4f0 [128]StringPtr
    attacks         @0x2B610 [26] StringPtr
    dialogue        @0x28010 [256]StringPtr
    battle_messages @0x2CF60 [78] StringPtr
    
    intro           @0x37F30 [0] Char
    shop            @0x38010 [38]StringPtr
    status          @0x38510 [64]StringPtr
    story           @0x36810 [25]StringPtr
}

:String     []Char

:NESPtr {
    ptr        u16
    = ((_pos - 0x10) // 0x4000)*0x4000 + (ptr-0x8000) + 0x10
}

:NESBankPtr {
    ptr        u16
    ptr_abs    = ((_pos - 0x10) // 0x4000)*0x4000 + (_ptr) + 0x10
    = _ptr_abs
}

:StringPtr {
    ptr        NESPtr
    str        @ptr String
    = str
}

