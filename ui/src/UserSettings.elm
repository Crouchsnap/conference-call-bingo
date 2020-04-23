module UserSettings exposing (UserSettings, decodeUserSettings, decodeUserSettingsValue, defaultUserSettings, encodeUserSettings)

import Game.Dot as Dot exposing (Color(..))
import Game.Topic as Topic exposing (Topic)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline
import Json.Encode as Encode
import Options.BoardStyle as BoardStyle exposing (Color(..))
import Options.Theme as Theme exposing (Theme)


type alias UserSettings =
    { selectedTheme : Theme
    , topics : List Topic
    , dauberColor : Dot.Color
    , boardColor : BoardStyle.Color
    }


defaultUserSettings selectedTheme =
    { selectedTheme = selectedTheme
    , topics = []
    , dauberColor = Blue
    , boardColor = OriginalRed
    }


encodeUserSettings : UserSettings -> Encode.Value
encodeUserSettings userSettings =
    Encode.object
        [ ( "selectedTheme", Theme.themeEncoder <| userSettings.selectedTheme )
        , ( "topics", Encode.list Topic.encodeTopic <| userSettings.topics )
        , ( "dauberColor", Encode.string <| Dot.toString <| userSettings.dauberColor )
        , ( "boardColor", Encode.string <| BoardStyle.toString <| userSettings.boardColor )
        ]


decodeUserSettings : Theme -> Decoder UserSettings
decodeUserSettings systemTheme =
    Decode.succeed UserSettings
        |> Json.Decode.Pipeline.optional "selectedTheme" (Theme.themeDecoder systemTheme) systemTheme
        |> Json.Decode.Pipeline.optional "topics" (Decode.list Topic.topicDecoder) []
        |> Json.Decode.Pipeline.optional "dauberColor" Dot.colorDecoder Blue
        |> Json.Decode.Pipeline.optional "boardColor" BoardStyle.colorDecoder OriginalRed


decodeUserSettingsValue : Theme -> Decode.Value -> UserSettings
decodeUserSettingsValue systemTheme value =
    case Decode.decodeValue (decodeUserSettings systemTheme) value of
        Ok value_ ->
            value_

        Err _ ->
            defaultUserSettings systemTheme
