!symfile pokered

!import pokeredchar

:NUM_POKEMON      190
:NUM_POKEDEX      151
:NUM_MOVES        165
:NUM_ITEMS        97
:NUM_TYPES        27
:NUM_TRAINERS     47

:MaybeU8 U8 match {
    0 => Null
    i => i - 1
}

:GBPtr       (Pos / 0x4000 * 0x4000) + (U16 % 0x4000)
:PtrString   @GBPtr String

text {
    pokemon     @sym.MonsterNames   [NUM_POKEMON] [10]Char
    moves       @sym.MoveNames      [NUM_MOVES]   String
    items       @sym.ItemNames      [NUM_ITEMS]   String
    trainers    @sym.TrainerNames   [NUM_TRAINERS]String
    maps        @sym.PalletTownName [53]          String
    types       @sym.TypeNames      [NUM_TYPES]   PtrString
}


_pokemon_base_stats @sym.BaseStats [NUM_POKEDEX] :PokemonBaseStats {
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
    
    growth_rate     U8 -> growth_rates
    
    tms             [64]B1
}

growth_rates :GrowhRates {
}

_pokemon_evos_moves @sym.EvosMovesPointerTable [NUM_POKEMON] @GBPtr :PokemonEvosMoves {
    evolutions [] :Evolution U8 match {
        0 => Terminator
        1 => :LevelEvolution {
            level       U8
            pokemon     MaybeU8 -> pokemon
        }
        2 => :ItemEvolution {
            item        MaybeU8 -> items
            level       U8
            pokemon     MaybeU8 -> pokemon
        }
        3 => :TradeEvolution {
            level       U8
            pokemon     MaybeU8 -> pokemon
        }
    }
    learnset [] U8 match {
        0 => Terminator
        n => :TaughtMove {
            level   n
            move    MaybeU8 -> moves
        }    
    }
}

pokemon @sym.PokedexOrder [NUM_POKEMON] :Pokemon {
    id              I
    num             U8
    name            text.pokemon[I]
    base_stats      (num - 1) -> _pokemon_base_stats
    evos_moves      id        -> _pokemon_evos_moves
}

type_effectiveness @sym.TypeEffects [] U8 match {
    0xff    => Terminator
    num     => {
        type_attacking  num -> types
        type_defending  U8  -> types
        multiplier      U8
    }
}

types [NUM_TYPES] :Type {
    name            text.types[I]
}

_trainer_data_pointers @sym.TrainerDataPointers [NUM_TRAINERS] GBPtr

trainer_classes [NUM_TRAINERS] :TrainerClass {
    name            text.trainers[I]
    trainers        @(_trainer_data_pointers[I]) [2] {
        x U8
    }
}

moves @sym.Moves [NUM_MOVES] :Move {
    name            text.moves[I]
    animation       U8
    effect          U8
    power           U8
    type            U8 -> types
    accuracy        U8
    pp              U8
}

:BCD3  100000*B4 + 10000*B4 + 1000*B4 + 100*B4 + 10*B4 + 1*B4
:Money BCD3 

_key_items      @sym.KeyItemBitfield [NUM_ITEMS]B1 
_item_prices    @sym.ItemPrices      [NUM_ITEMS]Money

items [NUM_ITEMS] :Item {
    id              I
    name            text.items[I]
    key_item        id -> _key_items
    price           id -> _item_prices
}
