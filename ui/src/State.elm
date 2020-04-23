module State exposing (State, decodeState, decodeStateValue, defaultState, encodeState)

import Game.Dot as Dot exposing (Color(..))
import Game.Square as Square exposing (Topic)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline
import Json.Encode as Encode
import Options.BoardStyle as BoardStyle exposing (Color(..))
import Options.Theme as Theme exposing (Theme)


type alias State =
    { selectedTheme : Theme
    , topics : List Topic
    , dauberColor : Dot.Color
    , boardColor : BoardStyle.Color
    }


defaultState selectedTheme =
    { selectedTheme = selectedTheme
    , topics = []
    , dauberColor = Blue
    , boardColor = OriginalRed
    }


encodeState : State -> Encode.Value
encodeState state =
    Encode.object
        [ ( "selectedTheme", Theme.themeEncoder <| state.selectedTheme )
        , ( "topics", Encode.list Square.encodeTopic <| state.topics )
        , ( "dauberColor", Encode.string <| Dot.toString <| state.dauberColor )
        , ( "boardColor", Encode.string <| BoardStyle.className <| state.boardColor )
        ]


decodeState : Theme -> Decoder State
decodeState systemTheme =
    Decode.succeed State
        |> Json.Decode.Pipeline.optional "selectedTheme" (Theme.themeDecoder systemTheme) systemTheme
        |> Json.Decode.Pipeline.optional "topics" (Decode.list Square.topicDecoder) []
        |> Json.Decode.Pipeline.optional "dauberColor" Dot.colorDecoder Blue
        |> Json.Decode.Pipeline.optional "boardColor" BoardStyle.colorDecoder OriginalRed


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
