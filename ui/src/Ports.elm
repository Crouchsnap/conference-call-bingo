port module Ports exposing (State, decodeState, decodeStateValue, defaultState, encodeState, saveState, storeState)

import Json.Decode as Decode exposing (Decoder, string)
import Json.Decode.Pipeline
import Json.Encode as Encode
import Options.Theme as Theme exposing (Theme(..))


type alias State =
    { selectedTheme : Theme
    }


defaultState selectedTheme =
    { selectedTheme = selectedTheme
    }


port storeState : String -> Cmd msg


saveState : State -> Cmd msg
saveState state =
    encodeState state
        |> Encode.encode 0
        |> storeState


encodeState : State -> Encode.Value
encodeState state =
    Encode.object
        [ ( "selectedTheme", Theme.themeEncoder <| state.selectedTheme )
        ]


decodeState : Theme -> Decoder State
decodeState systemTheme =
    Decode.succeed State
        |> Json.Decode.Pipeline.optional "selectedTheme" (Theme.themeDecoder systemTheme) systemTheme


decodeStateValue : Theme -> Decode.Value -> State
decodeStateValue fallback value =
    case Decode.decodeValue (decodeState fallback) value of
        Ok value_ ->
            value_

        Err error ->
            let
                _ =
                    error |> Debug.log "State Decoder"
            in
            defaultState fallback
