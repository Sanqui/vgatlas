!symfile hp2

//NUM_LANGUAGES = 10
//:NUM_STRINGS 100
:NUM_STRINGS 3796
:NUM_ENEMIES 92
:NUM_BRUTI_ENEMIES 77
:NUM_MAPS 122

enemies @sym.EnemyStatsTable [NUM_ENEMIES] :Enemy {
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
    exp         U16
    sickles     U16
    unk16       U8
    unk17       U8
}

folio_bruti_enemies @sym.FolioBrutiEnemyIdTable [NUM_BRUTI_ENEMIES] :FolioBrutiEnemy {
    bruti_num   I
    enemy_num   U8
    enemy       (enemy_num - 7) -> enemies
    name        (2888 + bruti_num) -> text
}

maps    [NUM_MAPS] :Map {
    id          I
    name        (2429 + id) -> text
}

enemy_rosters  @sym.EnemyRosterPointers [NUM_MAPS] @GBAddr(0x03, U16) :MapRosters {
    i         I
    map       i -> maps
    rosters [3] @GBAddr(0x03, U16) :EnemyRoster [3](U8 - 7) -> enemies
}

text_key @GBAddr(0x1f, 0x6c7d) [U8*2] {
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

text @GBAddr(0x1f, 0x4001) [NUM_STRINGS] {
    bank_offset U8
    address     U16
    string      @GBAddr(0x1f+bank_offset, address) HPString
    = string
}
