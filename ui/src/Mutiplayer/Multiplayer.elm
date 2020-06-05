module Mutiplayer.Multiplayer exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline
import Json.Encode


type GameUpdate
    = Increment
    | Decrement
    | Reset


gameUpdateToString : GameUpdate -> String
gameUpdateToString gameUpdate =
    case gameUpdate of
        Increment ->
            "increment"

        Decrement ->
            "decrement"

        Reset ->
            "reset"


type alias StartMultiplayerResponseBody =
    { id : String, playerId : String }


encodeStartMultiplayerBody : String -> Json.Encode.Value
encodeStartMultiplayerBody initials =
    Json.Encode.object [ ( "initials", Json.Encode.string initials ) ]


decodeStartMultiplayerResponseBody : Decoder StartMultiplayerResponseBody
decodeStartMultiplayerResponseBody =
    Decode.succeed StartMultiplayerResponseBody
        |> Json.Decode.Pipeline.required "id" Decode.string
        |> Json.Decode.Pipeline.required "playerId" Decode.string
