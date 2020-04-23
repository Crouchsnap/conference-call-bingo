port module Ports exposing (saveUserSettings)

import Json.Encode as Encode
import UserSettings exposing (UserSettings, encodeUserSettings)


port storeUserSettings : String -> Cmd msg


saveUserSettings : UserSettings -> Cmd msg
saveUserSettings userSettings =
    encodeUserSettings userSettings
        |> Encode.encode 0
        |> storeUserSettings
