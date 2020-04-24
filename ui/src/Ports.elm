port module Ports exposing (saveUserSettings, sendGaEvent)

import GA exposing (encodeGaEvent)
import Json.Encode as Encode
import UserSettings exposing (UserSettings, encodeUserSettings)


port storeUserSettings : String -> Cmd msg


saveUserSettings : UserSettings -> Cmd msg
saveUserSettings userSettings =
    encodeUserSettings userSettings
        |> Encode.encode 0
        |> storeUserSettings


port publishGaEvent : String -> Cmd msg


sendGaEvent : GA.Event -> Cmd msg
sendGaEvent event =
    encodeGaEvent event
        |> Encode.encode 0
        |> publishGaEvent
