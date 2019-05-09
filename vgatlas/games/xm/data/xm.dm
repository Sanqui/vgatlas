!import ascii

text            [17]Char
name            [20]Char
_               Byte
tracker_name    [20]Char
version         U16

header_size     U32
song_length     U16
restart_position    U16
num_channels    U16
num_patterns    U16
num_instruments U16
flags           U16
default_tempo   U16
default_bpm     U16

pattern_order   [256]U8

patterns [1] :Pattern {
    _start_pos       Pos
    header_length    U32
    packing_type     U8
    num_rows         U16
    patterndata_size U16
    data @(_start_pos+header_length) [num_rows] :PatternRow [num_channels] {
        _note @Pos {
            _note   B7
            _compressed B1
        }
        !if _note._compressed {
            _compressed {
                note        B1
                instrument  B1
                volume      B1
                effect      B1
                effect_param B1
                _           B3
            }
            !if _compressed.note {
                note    U8
            } !else {
                note    Null
            }
            !if _compressed.instrument {
                instrument  U8
            } !else {
                instrument    Null
            }
            !if _compressed.volume {
                volume U8
            } !else {
                volume    Null
            }
            !if _compressed.effect {
                effect U8
            } !else {
                effect    Null
            }
            !if _compressed.effect_param {
                effect_param U8
            } !else {
                effect_param    Null
            }
        } !else {
            note        U8
            instrument  U8
            volume      U8
            effect      U8
            effect_param  U8
        }
    }
}

