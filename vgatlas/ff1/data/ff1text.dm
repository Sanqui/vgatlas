!import ff1char

ff1text {
    basic           @0x2B712 {
        items    [27]string_ptr
        weapons  [40]string_ptr
        armor    [40]string_ptr
        golds    [68]string_ptr
        magic    [64]string_ptr
        classes  [12]string_ptr
    }
    monsters        @0x2d4f0 [128]string_ptr
    attacks         @0x2B610 [26]string_ptr
    dialogue        @0x28010 [256]string_ptr
    battle_messages @0x2CF60 [78]string_ptr
    
    intro           @0x37F30 [0]char
    shop            @0x38010 [38]string_ptr
    status          @0x38510 [64]string_ptr
    story           @0x36810 [25]string_ptr
}

string {
    _str []char
    _val = _str[0] if _str else ""
}

nesptr {
    _ptr        u16
    _ptr_abs    = ((_pos - 0x10) // 0x4000)*0x4000 + (_ptr-0x8000) + 0x10
    _val        = _ptr_abs
}

nesbankptr {
    _ptr        u16
    _ptr_abs    = ((_pos - 0x10) // 0x4000)*0x4000 + (_ptr) + 0x10
    _val        = _ptr_abs
}

string_ptr {
    ptr        nesptr
    str        @ptr string
    //_val        = _str
}

