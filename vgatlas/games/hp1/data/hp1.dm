!symfile hp1

:NUM_ENEMIES 61
:NUM_STRINGS 3000
:NUM_ITEMS 113
:NUM_MAPS 2214 - 2116
:NUM_BOSSES 14
:NUM_SPELLS 17
:NUM_CARDS 1723 - 1621
:NUM_DECKS 4

:Enemy {
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
    sickles_rnd U8
    item_drop   U8 match {
        254     => :CardSet2
        253     => :CardSet1
        252     => :CardSet0
        item_id => item_id -> items
    } 
}

enemies @sym.EnemyStats [NUM_ENEMIES] Enemy
_all_enemies @sym.EnemyStats [255] Enemy

_equipment_stat_boosts @sym.EquipmentStatBoostTable [0x23] :EquipmentStatBoosts {
    sp          U8
    strength    U8
    defense     U8
    magic_str   U8
    magic_def   U8
    priority    S8
}

_item_effects @sym.ItemEffectTable [NUM_ITEMS - 0x23] :ItemEffect {
    effect U8 match {
        :CantUseNow
        :RecoverSP
        :RecoverMP
        :FlavorSP
        :List
        :Cauldron
        :CurseBook
        :CloakOfInvisibility
        :ChocolateFrog
        :IngredientEncyclopedia
        :VitamixPotion
        :Disgusting
        :Antidote
        x => :InvalidEffect x
    }
    argument   U8
}

items [NUM_ITEMS] :Item {
    id          I
    name        (1401 + id) -> text
    stat_boost  id match {
        x       => x -> _equipment_stat_boosts
        0x23..0xff => Null
    }
    effect      id match {
        0..0x23 => Null
        x       => (x - 0x23) -> _item_effects
    }
}

maps    [NUM_MAPS] :Map {
    id          I
    name        (2116 + id) -> text
    message     (2215 + id) -> text
}

:EnemyRoster [3] U8 match {
    0        => Null
    enemy_id => (enemy_id - 2) -> enemies
}

enemy_rosters  @sym.EncounterGroupTablePointers [NUM_MAPS] @GBAddr(0x03, U16) :MapRosters {
    i         I
    map       i -> maps
    rosters [3] @GBAddr(0x03, U16) EnemyRoster
}

boss_rosters @sym.BossGroupsPointers [NUM_BOSSES] @GBAddr(0x03, U16) EnemyRoster

_harry_stats {
    _sp        @sym.LevelSPTable [100]U16
    _mp        @sym.LevelMPTable [100]U16
    _priority  @sym.LevelPriorityTable [100]U8
    _strength  @sym.LevelStrengthTable [100]U8
    _defense   @sym.LevelDefenseTable [100]U8
    _magic_str @sym.LevelMagicStrTable [100]U8
    _magic_def @sym.LevelMagicDefTable [100]U8

}

harry_stats   [100] {
    level       I + 1
    sp          _harry_stats._sp[level - 1]
    mp          _harry_stats._mp[level - 1]
    priority    _harry_stats._priority[level - 1]
    strength    _harry_stats._strength[level - 1]
    defense     _harry_stats._defense[level - 1]
    magic_str   _harry_stats._magic_str[level - 1]
    magic_def   _harry_stats._magic_def[level - 1]
}

_spell_data {
    aoe @sym.SpellAOETable [NUM_SPELLS]B1
    mp_costs @sym.SpellMPCosts [NUM_SPELLS]U8
}

spells @sym.SpellDamageTable [NUM_SPELLS] {
    id              I
    name            (id + 9) -> text
    mp_cost         _spell_data.mp_costs[id]
    base_damage     U8
    aoe             _spell_data.aoe[id]
}

cards [NUM_CARDS] {
    _id             I
    name            (_id + 1621) -> text
    description     (_id + 1725) -> text
}

// This can't be expressed nicely in Datamijn :(
_card_sets @sym.RandomCardSets [3] @U16 {
    count U8
    indices [count]U8
}
_card_mappings @sym.RandomCardMappings [255][4] U8 -> cards

decks [NUM_DECKS] {
    _id             I
    name            (_id + 2756) -> text
    card_sets       [3] {
        _set_i      I
        cards       [_card_sets[_set_i].count]{
            _i I
            _indice _card_sets[_set_i].indices[_i]
            = _card_mappings[_indice][_id]
        }
    }
}

rng_table @sym.RNGTable [256]U8

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
