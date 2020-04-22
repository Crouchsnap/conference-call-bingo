port module Ports exposing (State, decodeState, saveState, storeState)

import Json.Decode as Decode exposing (Decoder, string)
import Json.Decode.Pipeline
import Json.Encode as Encode
import Options.Theme as Theme exposing (Theme(..))


type alias State =
    { selectedTheme : Theme
    }


port storeState : String -> Cmd msg


saveState : State -> Cmd msg
saveState state =
    Encode.object (stateEncoder state)
        |> Encode.encode 0
        |> storeState


stateEncoder : State -> List ( String, Encode.Value )
stateEncoder state =
    [ ( "selectedTheme", Theme.themeEncoder <| state.selectedTheme )
    ]


decodeState : Decoder State
decodeState =
    Decode.succeed State
        |> Json.Decode.Pipeline.required "selectedTheme" (Theme.themeDecoder Light)
