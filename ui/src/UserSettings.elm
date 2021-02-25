module UserSettings exposing (UserSettings, decodeUserSettings, decodeUserSettingsValue, defaultUserSettings, encodeUserSettings)

import Game.Board exposing (Board)
import Game.Dot as Dot exposing (Color(..))
import Game.Square as Square
import Game.Topic as Topic exposing (Topic)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline
import Json.Encode as Encode
import Msg exposing (Msg)
import Options.BoardStyle as BoardStyle exposing (Color(..))
import Options.Theme as Theme exposing (Theme)


type alias UserSettings =
    { selectedTheme : Theme
    , topics : List Topic
    , dauberColor : Dot.Color
    , boardColor : BoardStyle.Color
    , board : Board Msg
    }


defaultUserSettings selectedTheme =
    { selectedTheme = selectedTheme
    , topics = []
    , dauberColor = Blue
    , boardColor = OriginalRed
    , board = []
    }


encodeUserSettings : UserSettings -> Encode.Value
encodeUserSettings userSettings =
    Encode.object
        [ ( "selectedTheme", Theme.themeEncoder <| userSettings.selectedTheme )
        , ( "topics", Encode.list Topic.encodeTopic <| userSettings.topics )
        , ( "dauberColor", Encode.string <| Dot.toString <| userSettings.dauberColor )
        , ( "boardColor", Encode.string <| BoardStyle.toString <| userSettings.boardColor )
        , ( "board", Encode.list Square.encode <| userSettings.board )
        ]


decodeUserSettings : Theme -> Decoder UserSettings
decodeUserSettings systemTheme =
    Decode.succeed UserSettings
        |> Json.Decode.Pipeline.optional "selectedTheme" (Theme.themeDecoder systemTheme) systemTheme
        |> Json.Decode.Pipeline.optional "topics" (Decode.list Topic.topicDecoder) []
        |> Json.Decode.Pipeline.optional "dauberColor" Dot.colorDecoder Blue
        |> Json.Decode.Pipeline.optional "boardColor" BoardStyle.colorDecoder OriginalRed
        |> Json.Decode.Pipeline.optional "board" (Decode.list Square.decoder) []


decodeUserSettingsValue : Theme -> Decode.Value -> UserSettings
decodeUserSettingsValue systemTheme value =
    case Decode.decodeValue (decodeUserSettings systemTheme) value of
        Ok value_ ->
            value_

        Err _ ->
            defaultUserSettings systemTheme
