!import ff1char
!import ff1text

//tilerow     [8]u1
//tileplane   [8]u1
//
//tile {
//    _NUM_PLANES = 2
//    _planes     [_NUM_PLANES]tileplane
//    x        = _planes
//    y        = [b0 | b1 << 1 for b0, b1 in _planes]
//}

//_start {
//    font            @0x24810    tile
//}

_start {
    text    ff1text
    _NUM_MONSTERS   = 128
    //monstersx {
    //    _names          @0x2d4f0        [_NUM_MONSTERS]string_ptr
    //    _names2         @_names[0]._ptr [_NUM_MONSTERS]string
    //    !assert _names == _names2
    //    _val            @0x30530 [_NUM_MONSTERS]monster
    //}
    monsters        @0x30530 [_NUM_MONSTERS]monster
    weapons         @0x30010 [ 40]weapon // XXX 50?
    armor           @0x30150 [100]armor
    classes         @0x03050 [ 12]class
    item_prices     @0x37c10 [256]u16
    maps            @0x10010 [  1]map
}

string {
    _str []char
    _val = _str[0]
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
    _ptr        nesptr
    _str        @_ptr string
    _val        = _str
}

map {
    _ptr        nesbankptr
    metatiles   @_ptr [] {
        byte        u8
        !if byte != 0xff {
            !if byte < 0x80 {
                run     = [byte]
            } !else {
                length  u8
                run     = [byte-0x80] * ((length - 1) % 100)
            }
        }
        _add    = run
        _stop   = byte == 0xff
    }
}

monster {
    //name            = _._names[_index]
    
    exp             u16
    gold            u16
    hp              u16
    flee            u8
    ai              u8
    stats           {
        agility         u8
        defense         u8
        hit_rate        u8
        aim_rate        u8
        strength        u8
        critical_rate   u8
    }
    effect_chance   u8
    effects         effects
    categories      categories
    unk1            u8
    weakness        elements
    resistences     elements
}

effects {
    death      u1
    stone      u1
    poison     u1
    dark       u1
    stun       u1
    sleep      u1
    unk1       u1
    unk2       u1
}

categories {
    unknown      u1
    dragon       u1
    giant        u1
    undead       u1
    were         u1
    water        u1
    mage         u1
    regenerative u1
}

elements {
    stun      u1
    bane      u1
    dark      u1
    conf      u1
    fire      u1
    ice       u1
    lit       u1
    earth     u1
}

weapon {
    hit_rate        u8
    damage          u8
    crit_rate       u8
    spell           u8
    element         elements
    specialization  categories
    graphic         u8
    palette         u8
}

class {
    unk1            u8
    hp              u8
    strength        u8
    agility         u8
    intelligence    u8
    vitality        u8
    luck            u8
    damage          u8
    hit_rate        u8
    evasion_rate    u8
    magic_defense   u8
    padding         [5]u8
}
    
armor {
    evade       u8
    absorb      u8
    effect      {
        unk1        u1
        stun        u1
        poison      u1
        death       u1
        fire        u1
        ice         u1
        lit         u1
        unk2        u1
    }
    spell       u8
}
