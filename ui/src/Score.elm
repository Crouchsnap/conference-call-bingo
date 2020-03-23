module Score exposing (Score, decodeScore, decodeScores, encodeScore)

import Json.Decode as Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline
import Json.Encode


type alias Score =
    { score : Int
    , player : String
    }


decodeScores : Decoder (List Score)
decodeScores =
    Decode.list decodeScore


decodeScore : Decoder Score
decodeScore =
    Decode.succeed Score
        |> Json.Decode.Pipeline.required "score" int
        |> Json.Decode.Pipeline.required "player" string


encodeScore : Score -> Json.Encode.Value
encodeScore record =
    Json.Encode.object
        [ ( "score", Json.Encode.int <| record.score )
        , ( "player", Json.Encode.string <| record.player )
        ]
