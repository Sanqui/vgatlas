!import telefangchar

NUM_DENJUU = 174

:Stats {
    hp              u8
    speed           u8
    attack          u8
    defense         u8
    denma_attack    u8
    denma_defense   u8
}

NUM_DENJUU = 174
NUM_TYPES = 6
// XXX
NUM_MOVES = 200

text {
    // 75:4000
    denjuu @0x1d4000 [NUM_DENJUU][8]Char
    moves  @0x1d46f8 [NUM_MOVES] [8]Char
    types  @0x1d5628 [NUM_TYPES] [4]Char
}

:DenjuuNo u8 match {
    0   => =None
    no  => =no - 1
} -> denjuu

:MoveNo u8 match {
    0   => =None
    no  => =no
} -> moves

// ROM

gfx {
    denjuu_palettes @0x34800 [NUM_DENJUU]GBPalette
    denjuu @0x1ac000 [NUM_DENJUU] {
        pic     [7][8]GBTile
        
        !if _i % 18 == 17 {
            _       [0x100]byte
        }
        
        = pic | denjuu_palettes[_i]
    }
    !save denjuu
}

// 75:4b48
denjuu @0x1d4b48 [NUM_DENJUU]{
    id          = _i
    number      = id + 1
    name        = text.denjuu[id]
    base_stats  Stats
    moves       [4]MoveNo
    unk1        u8
    evolution {
        level       u8
        denjuu      DenjuuNo
    }
    type        u8 -> types
    
    move_learn_levels [2]u8
}

// This determines how much a stat is gained in two levels.
denjuu[].level_influence @0x9c715 [NUM_DENJUU]Stats

denjuu[].evolutions @0xaa0b1 [NUM_DENJUU]{
    items   [2]u8
    denjuu  [2]DenjuuNo
}

denjuu[].exp_items @0xa9a93 [NUM_DENJUU]{
    items           [64]b1
    favorite_item   u8
}

secret_denjuu @0x13c0d [14] {
    denjuu      DenjuuNo
    level       u8
    fd          u8
    personality u8
}

types [NUM_TYPES] {
    name    = text.types[_i]
}

moves @0x9cb29 [NUM_MOVES] {
    name            = text.moves[_i]
    power           u8
}

