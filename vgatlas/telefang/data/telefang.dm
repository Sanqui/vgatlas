!import telefangchar

NUM_DENJUU = 174

type u8 enum {
    mountain
    grassland
    forest
    aquatic
    sky
    desert
}

stats {
    hp              u8
    speed           u8
    attack          u8
    defense          u8
    denma_attack    u8
    denma_defense   u8
}

_start {
    text {
        // ROMX[$4000], BANK[$75]
        denjuu @0x1d4000 [174][8]char
        moves  @0x1d46f8 [200][8]char
    }
    // TODO scope so I can use NUM_DENJUU and _root.NUM_DENJUU
    NUM_DENJUU = 174
    // 75:4b48 TODO gb pointers
    denjuu @0x1d4b48 [NUM_DENJUU]{
        base_stats  stats
        moves       [4]u8
        unk1        u8
        evolution {
            level   u8
            denjuu  u8
        }
        type        u8
        move_learn_levels [2]u8
    }
    
    // This determines how much a stat is gained in two levels.
    denjuu_level_influence @0x9c715 [NUM_DENJUU]stats
    
    evolutions @0xaa0b1 [NUM_DENJUU]{
        items   [2]u8
        denjuu  [2]u8
    }
    
    exp_items @0xa9a93 [NUM_DENJUU]{
        // TODO fix bit structs
        items {
            items           [64]u1
        }
        favorite_item   u8
    }
    secret_denjuu @0x13c0d [14] {
        denjuu      u8
        level       u8
        fd          u8
        personality u8
    }
}
