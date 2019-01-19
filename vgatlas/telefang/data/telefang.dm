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
NUM_PERSONALITIES=12
NUM_ITEMS = 66

text {
    // 75:4000
    denjuu        @0x1d4000 [NUM_DENJUU]        [8]Char
    moves         @0x1d46f8 [NUM_MOVES]         [8]Char
    types         @0x1d5628 [NUM_TYPES]         [4]Char
    personalities @0x1d7928 [NUM_PERSONALITIES] [8]Char
    items         @0x2e652  [NUM_ITEMS]         [8]Char
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

_palettes {
    denjuu     @0x34800 [NUM_DENJUU]GBPalette
    items {
        pics   @0x34f00 [NUM_ITEMS] GBPalette
        icons  @0x36d80 [NUM_ITEMS] GBPalette
    }
    zodiac     @0x35680 [NUM_PERSONALITIES]GBPalette
}

_tiles {
    denjuu    @0x1ac000  [NUM_DENJUU] GBBankFit | [7][8]GBTile
    items {
        pics  @0xac000   [NUM_ITEMS]  GBBankFit | [5][6]GBTile
        icons @0xaacc6   [NUM_ITEMS] [2][2]GBTile
    }
    
    zodiac    @0x1f5b40  [NUM_PERSONALITIES] [2][2]GBTile
}
gfx = _tiles | _palettes
!save gfx

// 75:4b48
denjuu @0x1d4b48 [NUM_DENJUU] :Denjuu {
    id          = _i
    number      = id + 1
    name        = text.denjuu[id]
    pic         {= id} -> gfx.denjuu
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
    // TODO dict (see https://github.com/Sanqui/datamijn/issues/23)
    items           [64] {
        _id         = _i
        item        {=_id} -> items
        favorite    b1
    }
    favorite_item   u8  -> items
}

secret_denjuu @0x13c0d [14] :SecretDenjuu {
    denjuu      DenjuuNo
    level       u8
    fd          u8
    personality u8  -> personalities
}

types [NUM_TYPES] :Type {
    name    = text.types[_i]
}

personalities [NUM_PERSONALITIES] :Personality {
    _id     = _i
    name    = text.personalities[_id]
    icon    {=_id}   -> gfx.zodiac
}

moves @0x9cb29 [NUM_MOVES] :Move {
    name            = text.moves[_i]
    power           u8
}

items [NUM_ITEMS] :Item {
    _id     = _i
    // XXX when #22 is fixed just text.items
    name    = text['items'][_id]
    pic     {=_id}   -> gfx.items.pics
    icon    {=_id}   -> gfx.items.icons
}
// TODO item prices

