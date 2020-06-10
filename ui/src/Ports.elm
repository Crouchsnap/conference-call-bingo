port module Ports exposing (copy, multiplayerScoresListener, openMultiplayerScoresPort, saveUserSettings, sendGaEvent, stopListeningToMultiplayerScores)

import GA exposing (encodeGaEvent)
import Json.Decode as Decode
import Json.Encode as Encode
import Requests exposing (getHostFromLocation)
import Url exposing (Url)
import UserSettings exposing (UserSettings, encodeUserSettings)


port copy : String -> Cmd msg


port multiplayerScoresListener : (Decode.Value -> msg) -> Sub msg


port listenToMultiplayerScores : String -> Cmd msg


openMultiplayerScoresPort : Url -> String -> Cmd msg
openMultiplayerScoresPort url gameId =
    listenToMultiplayerScores (getHostFromLocation url ++ "/api/multiplayer/scores/" ++ gameId)


port stopListeningToMultiplayerScores : () -> Cmd msg


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
