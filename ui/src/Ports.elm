port module Ports exposing (saveUserSettings, sendGaEvent)

import Json.Encode as Encode
import UserSettings exposing (UserSettings, encodeUserSettings)


port storeUserSettings : String -> Cmd msg


saveUserSettings : UserSettings -> Cmd msg
saveUserSettings userSettings =
    encodeUserSettings userSettings
        |> Encode.encode 0
        |> storeUserSettings


port publishGaEvent : String -> Cmd msg


type alias GaEvent =
    { eventType : String
    , eventCategory : String
    }


encodeGaEvent eventType eventCategory =
    Encode.object
        [ ( "eventType", Encode.string <| eventType )
        , ( "eventCategory", Encode.string <| eventCategory )
        ]


sendGaEvent : String -> String -> Cmd msg
sendGaEvent eventType eventCategory =
    encodeGaEvent eventType eventCategory
        |> Encode.encode 0
        |> publishGaEvent
