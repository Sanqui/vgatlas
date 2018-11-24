!import ff1text

text            FF1Text
_NUM_MONSTERS   = 128
//monstersx {
//    _names          @0x2d4f0        [_NUM_MONSTERS]string_ptr
//    _names2         @_names[0]._ptr [_NUM_MONSTERS]string
//    !assert _names == _names2
//    _val            @0x30530 [_NUM_MONSTERS]monster
//}
monsters        @0x30530 [_NUM_MONSTERS]Monster
weapons         @0x30010 [ 40]Weapon // XXX 50?
armor           @0x30150 [100]Armor
classes         @0x03050 [ 12]Class
item_prices     @0x37c10 [256]u16
//maps            @0x10010 [  1]Map

//map {
//    _ptr        nesbankptr
//    metatiles   @_ptr [] {
//        byte        u8
//        !if byte != 0xff {
//            !if byte < 0x80 {
//                run     = [byte]
//            } !else {
//                length  u8
//                run     = [byte-0x80] * ((length - 1) % 100)
//            }
//        }
//        _add    = run
//        _stop   = byte == 0xff
//    }
//}

:Monster {
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
    effects         Effects
    categories      Categories
    unk1            u8
    weakness        Elements
    resistences     Elements
}

:Effects {
    death      b1
    stone      b1
    poison     b1
    dark       b1
    stun       b1
    sleep      b1
    unk1       b1
    unk2       b1
}

:Categories {
    unknown      b1
    dragon       b1
    giant        b1
    undead       b1
    were         b1
    water        b1
    mage         b1
    regenerative b1
}

:Elements {
    stun      b1
    bane      b1
    dark      b1
    conf      b1
    fire      b1
    ice       b1
    lit       b1
    earth     b1
}

:Weapon {
    hit_rate        u8
    damage          u8
    crit_rate       u8
    spell           u8
    element         Elements
    specialization  Categories
    graphic         u8
    palette         u8
}

:Class {
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
    
:Armor {
    evade       u8
    absorb      u8
    effect      {
        unk1        b1
        stun        b1
        poison      b1
        death       b1
        fire        b1
        ice         b1
        lit         b1
        unk2        b1
    }
    spell       u8
}
