port module Ports exposing (listenToMultiplayerScores, multiplayerScoresListener, saveUserSettings, sendGaEvent)

import GA exposing (encodeGaEvent)
import Json.Decode as Decode
import Json.Encode as Encode
import UserSettings exposing (UserSettings, encodeUserSettings)


port multiplayerScoresListener : (Decode.Value -> msg) -> Sub msg


port listenToMultiplayerScores : String -> Cmd msg


port storeUserSettings : String -> Cmd msg


saveUserSettings : UserSettings -> Cmd msg
saveUserSettings userSettings =
    encodeUserSettings userSettings
        |> Encode.encode 0
        |> storeUserSettings


port publishGaEvent : String -> Cmd msg


sendGaEvent : GA.Event msg -> Cmd msg
sendGaEvent event =
    encodeGaEvent event
        |> Encode.encode 0
        |> publishGaEvent
