!symfile pokered

!import pokeredchar

:NUM_POKEMON      190
:NUM_POKEDEX      151
:NUM_MOVES        165
:NUM_ITEMS        97
:NUM_TYPES        27

:MaybeU8 U8 match {
    0 => Null
    i => i - 1
}

:GBPtr       (Pos / 0x4000 * 0x4000) + (U16 % 0x4000)
:PtrString   @GBPtr String

text {
    pokemon     @sym.MonsterNames   [NUM_POKEMON][10]Char
    moves       @sym.MoveNames      [NUM_MOVES]  String
    items       @sym.ItemNames      [NUM_ITEMS]  String
    types       @sym.TypeNames      [NUM_TYPES]  PtrString
}


pokemon_base_stats @sym.BaseStats [NUM_POKEDEX] :PokemonBaseStats {
    num             U8
    stats {
        hp          U8
        attack      U8
        defense     U8
        speed       U8
        special     U8
    }
    type1           U8  -> types
    type2           U8  -> types
    catch_rate      U8
    exp_yield       U8
    
    pic_width       B4
    pic_height      B4
    
    ptr_frontpic    U16
    ptr_backpic     U16
    
    starting_moves  [4]MaybeU8 -> moves
    
    growth_rate     U8
    
    tms             [64]B1
}

evos_moves @sym.EvosMovesPointerTable [NUM_POKEMON] @GBPtr :EvosMoves {
    evolutions [] U8 match {
        0 => Terminator
        1 => :LevelEvolution {
            level       U8
            pokemon     MaybeU8 -> pokemon
        }
        2 => :ItemEvolution {
            item        MaybeU8 -> items
            min_level   U8
            pokemon     MaybeU8 -> pokemon
        }
        3 => :TradeEvolution {
            level       U8
            pokemon     MaybeU8 -> pokemon
        }
    }
    learnset [] U8 match {
        0 => Terminator
        n => {
            level   n
            move    MaybeU8 -> moves
        }    
    }
}

pokemon [NUM_POKEMON] {
    name            text.pokemon[I]
}

types [NUM_TYPES] {
    name            text.types[I]
}

moves [NUM_MOVES] {
    name            text.moves[I]
}

items [NUM_ITEMS] {
    name            text.items[I]
}
