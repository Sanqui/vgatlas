!import telefangchar

NUM_DENJUU = 174

:Type u8 match {
    :Mountain
    :Grassland
    :Forest
    :Aquatic
    :Sky
    :Desert
}

:Stats {
    hp              u8
    speed           u8
    attack          u8
    defense         u8
    denma_attack    u8
    denma_defense   u8
}

text {
    // 75:4000
    denjuu @0x1d4000 [174][8]Char
    moves  @0x1d46f8 [200][8]Char
}
NUM_DENJUU = 174

// ROM

// 75:4b48
denjuu @0x1d4b48 [NUM_DENJUU]{
    base_stats  Stats
    moves       [4]u8
    unk1        u8
    evolution {
        level       u8
        denjuu_no   u8
        denjuu      = denjuu_no-1
    }
    type        Type
    
    move_learn_levels [2]u8
    
    //moves       [4] {
    //    move    = moves[i]
    //    level   = move_learn_levels[i]
    //}
}

// This determines how much a stat is gained in two levels.
denjuu[].level_influence @0x9c715 [NUM_DENJUU]Stats

denjuu[].evolutions @0xaa0b1 [NUM_DENJUU]{
    items   [2]u8
    denjuu  [2]u8
}

denjuu[].exp_items @0xa9a93 [NUM_DENJUU]{
    items {
        //items           [64]u1
        items           [64]b1
    }
    favorite_item   u8
}

secret_denjuu @0x13c0d [14] {
    denjuu      u8
    level       u8
    fd          u8
    personality u8
}
