module Score exposing (Score, decodeGameResult, decodeScore, decodeScores, encodeGameResult, encodeScore)

import Json.Decode as Decode exposing (Decoder, int, nullable, string)
import Json.Decode.Pipeline
import Json.Encode


type alias Score =
    { score : Int
    , player : String
    }


type alias GameResult =
    { score : Int
    , player : String
    , suggestion : Maybe String
    , rating : Int
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


decodeGameResult : Decoder GameResult
decodeGameResult =
    Decode.succeed GameResult
        |> Json.Decode.Pipeline.required "score" int
        |> Json.Decode.Pipeline.required "player" string
        |> Json.Decode.Pipeline.required "suggestion" (nullable string)
        |> Json.Decode.Pipeline.required "rating" int


encodeGameResult : GameResult -> Json.Encode.Value
encodeGameResult record =
    Json.Encode.object
        [ ( "score", Json.Encode.int <| record.score )
        , ( "player", Json.Encode.string <| record.player )
        , ( "suggestion", Json.Encode.string <| Maybe.withDefault "" <| record.suggestion )
        , ( "rating", Json.Encode.int <| record.rating )
        ]
