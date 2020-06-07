module Mutiplayer.Multiplayer exposing (GameUpdate(..), MultiplayerScore, StartMultiplayerResponseBody, buildJoinLink, decodeMultiplayerScores, decodeMultiplayerScoresToResult, decodeStartMultiplayerResponseBody, encodeStartMultiplayerBody, gameUpdateToString)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline
import Json.Encode
import Url


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


encodeStartMultiplayerBody : String -> Int -> Json.Encode.Value
encodeStartMultiplayerBody initials score =
    Json.Encode.object
        [ ( "initials", Json.Encode.string initials )
        , ( "score", Json.Encode.int score )
        ]


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


buildJoinLink url id =
    { url | fragment = Just id }
        |> Url.toString
