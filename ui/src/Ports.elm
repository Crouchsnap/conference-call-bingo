port module Ports exposing (saveState)

import Json.Encode as Encode
import State exposing (State, encodeState)


port storeState : String -> Cmd msg


saveState : State -> Cmd msg
saveState state =
    encodeState state
        |> Encode.encode 0
        |> storeState
