!import telefangchar

:NUM_DENJUU      174
:NUM_DENJUU_PICS 175
:NUM_TFANGERS    41
:NUM_TYPES       6
// XXX
:NUM_MOVES       200
:NUM_PERSONALITIES 12
:NUM_ITEMS       66
:NUM_SPRITES     104

defaultpal GBPalDefault

:NatsumeBlock {
    _modes   [16] B1
    _bytes   [16] _modes[I] match {
        0 => < Byte
        1 => {
            loc     0 - B11 - 1
            num     B5 + 3
            b       |@loc [num] (< Byte)
        }
    }
}

:NatsumeCompressedGfx {
    _compressed     U8
    _length         U16
    _tiles          _length/8/2
    tiles _compressed match {
        0   => [_tiles]GBTile
        1   => NatsumeBlock | [_tiles]GBTile
    }
    = tiles
}

//owtileset  @0x164000 NatsumeCompressedGfx


map {
    owtileset   @0x164000 NatsumeCompressedGfx
    owextra     @0xe00c0 [16]GBTile
    owtileset   owtileset + owextra
    !save owtileset
    
    metatiles @0x178066 [0x9e][2][2]U8 -> map.owtileset
    metatile_attributes @0x1782DE [0x9e][2][2]U8
    
    acre_data @0x1A0000 [50] :Acre {
        tiles [8][10]U8 -> map.metatiles
    }
}

text {
    // 75:4000
    denjuu        @0x1d4000 [NUM_DENJUU]        [8]Char
    moves         @0x1d46f8 [NUM_MOVES]         [8]Char
    types         @0x1d5628 [NUM_TYPES]         [4]Char
    personalities @0x1d7928 [NUM_PERSONALITIES] [8]Char
    items         @0x2e652  [NUM_ITEMS]         [8]Char
}

:DenjuuNo U8 match {
    0   => Null
    no  => no - 1
} -> denjuu

:MoveNo U8 match {
    0   => Null
    no  => no
} -> moves

// ROM

_palettes {
    denjuu     @0x34800 [NUM_DENJUU_PICS]GBPalette
    tfangers   @0x34d80 [NUM_TFANGERS]GBPalette
    items {
        pics   @0x34f00 [NUM_ITEMS] GBPalette
        icons  @0x36d80 [NUM_ITEMS] GBPalette
    }
    zodiac     @0x35680 [NUM_PERSONALITIES]GBPalette
    
    sprites [NUM_SPRITES] {
        down [3] GBPalDefault
        up   [3] GBPalDefault
        left [3] GBPalDefault
    }
}

_tiles {
    denjuu    @0x1ac000  [NUM_DENJUU_PICS] (GBBankFit | [7][8]GBTile)
    _tfangers1  @0x1f8000  [36] (GBBankFit | [7][8]GBTile)
    _tfangers2  @0x1f4000  [5] [7][8]GBTile
    tfangers  _tfangers1 + _tfangers2
    items {
        pics  @0xac000   [NUM_ITEMS]  (GBBankFit | [5][6]GBTile)
        icons @0xaacc6   [NUM_ITEMS] [2][2]GBTile
    }
    
    zodiac    @0x1f5b40  [NUM_PERSONALITIES] [2][2]GBTile
    
    sprites @0xb8000 [NUM_SPRITES] (GBBankFit | :OWSprite {
        down    [3][2][2]GBTile
        up      [3][2][2]GBTile
        left    [3][2][2]GBTile
    })
}
gfx _tiles | _palettes
!save gfx

:Stats {
    hp              U8
    speed           U8
    attack          U8
    defense         U8
    denma_attack    U8
    denma_defense   U8
}

// 75:4b48
denjuu @0x1d4b48 [NUM_DENJUU] :Denjuu {
    id          I
    num         id + 1
    name        text.denjuu[id]
    pic         id -> gfx.denjuu
    base_stats  Stats
    moves       [4]MoveNo
    unk1        U8
    evolution {
        level       U8
        denjuu      DenjuuNo
    }
    type        U8 -> types
    
    move_learn_levels [2]U8
}

// This determines how much a stat is gained in two levels.
denjuu[].level_influence @0x9c715 [NUM_DENJUU]Stats

denjuu[].evolutions @0xaa0b1 [NUM_DENJUU]{
    items   [2]U8
    denjuu  [2]DenjuuNo
}

denjuu[].exp_items @0xa9a93 [NUM_DENJUU]{
    // TODO dict (see https://github.com/Sanqui/datamijn/issues/23)
    items           [64] {
        _id         I
        item        _id -> items
        favorite    B1
    }
    favorite_item   U8  -> items
}

secret_denjuu @0x13c0d [14] :SecretDenjuu {
    denjuu      DenjuuNo
    level       U8
    fd          U8
    personality U8  -> personalities
}

types [NUM_TYPES] :Type {
    name    text.types[I]
}

personalities [NUM_PERSONALITIES] :Personality {
    _id     I
    name    text.personalities[_id]
    icon    _id   -> gfx.zodiac
}

moves @0x9cb29 [NUM_MOVES] :Move {
    name            text.moves[I]
    power           U8
}

items [NUM_ITEMS] :Item {
    _id     I
    name    text.items[_id]
    pic     _id   -> gfx.items.pics
    icon    _id   -> gfx.items.icons
}
// TODO item prices

