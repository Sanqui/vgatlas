!symfile hp1

:NUM_ENEMIES 61
:NUM_STRINGS 3000

enemies @sym.EnemyStats [61] :Enemy {
    num         U8
    hp          U16
    mp          U16
    pri         U8
    unk1        U8
    str         U8
    unk2        U8
    flip        U8
    vermi       U8
    verdi       U8
    ince        U8
    psn1        U8
    psn2        U8
    unk12       U8
    unk13       U8
    unk14       U8
    unk15       U8
    unk16       U8
    unk17       U8
}

text_key @0x823e6 [U8*2] {
    next    B7
    end     B1
    
    ascii   next char match {
        0x00 => :V0
        :V1
        :V2
        :V3
        :V4
        :V5
        :V6
        :V7
        :V8
        :V9
        :VA 
        :VB
        0x0c => "\n"
        :VC 
        :VD
        :VE 
        :VF
        :V10
        :V11
        :V12
        :V13
        :V14
        :V15
        :V16
        :V17
        :V18
        :V19
        :V1A
        :V1B
        :V1C
        :V1D
        :V1E
        :V1F
        0x20 => " "
        "!"
        '"'
        "#"
        "$"
        "%"
        "&"
        "'"
        "("
        ")"
        "*"
        "+"
        ","
        "-"
        "."
        "/"
        "0"
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
        ":"
        ";"
        "<"
        "="
        ">"
        "?"
        "@"
        "A"
        "B"
        "C"
        "D"
        "E"
        "F"
        "G"
        "H"
        "I"
        "J"
        "K"
        "L"
        "M"
        "N"
        "O"
        "P"
        "Q"
        "R"
        "S"
        "T"
        "U"
        "V"
        "W"
        "X"
        "Y"
        "Z"
        "["
        :Backslash
        "]"
        "^"
        "_"
        "`"
        "a"
        "b"
        "c"
        "d"
        "e"
        "f"
        "g"
        "h"
        "i"
        "j"
        "k"
        "l"
        "m"
        "n"
        "o"
        "p"
        "q"
        "r"
        "s"
        "t"
        "u"
        "v"
        "w"
        "x"
        "y"
        "z"
        "{"
        "|"
        "}"
        "~"
        Terminator
    }
}

// While this works, it's really slow.  Hitting the limits of
// writing an interpreted language inside Python...

:StringChar {
    keyvalue  0
    :StringBit {
        next    text_key[keyvalue * 2 + B1]
        keyvalue next.next
        = next.end match {
            0   => StringBit
            1   => next.ascii
        }
    }
    = StringBit
}

:HPString ([]StringChar) String

text @GBAddr(0x20, 0x4001) [NUM_STRINGS] {
    bank_offset U8
    address     U16
    string      @GBAddr(0x20+bank_offset, address) HPString
    = string
}