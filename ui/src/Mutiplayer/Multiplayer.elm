module Mutiplayer.Multiplayer exposing (GameUpdate(..), MultiplayerScore, StartMultiplayerResponseBody, decodeMultiplayerScores, decodeMultiplayerScoresToResult, decodeStartMultiplayerResponseBody, encodeStartMultiplayerBody, gameUpdateToString)

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


type alias MultiplayerScore =
    { playerId : String
    , initials : String
    , score : Int
    }


decodeMultiplayerScoresToResult : Decode.Value -> Result Decode.Error (List MultiplayerScore)
decodeMultiplayerScoresToResult =
    Decode.decodeValue decodeMultiplayerScores


decodeMultiplayerScores : Decoder (List MultiplayerScore)
decodeMultiplayerScores =
    Decode.list decodeMultiplayerScore


decodeMultiplayerScore : Decoder MultiplayerScore
decodeMultiplayerScore =
    Decode.succeed MultiplayerScore
        |> Json.Decode.Pipeline.required "playerId" Decode.string
        |> Json.Decode.Pipeline.required "initials" Decode.string
        |> Json.Decode.Pipeline.required "score" Decode.int
