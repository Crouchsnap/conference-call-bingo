module Win.Score exposing
    ( GameResult
    , Score
    , decodeGameResult
    , decodeScore
    , decodeScores
    , emptyGameResult
    , encodeGameResult
    , encodeScore
    , insertYourScore
    , isYourScore
    , scoresWithYourScore
    , updatePlayer
    , updateRating
    , updateSuggestion
    , yourScore
    )

import Json.Decode as Decode exposing (Decoder, int, nullable, string)
import Json.Decode.Pipeline
import Json.Encode
import List.Extra
import Time exposing (Posix)
import Win.TimeFormatter as TimeFormatter


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


updatePlayer : String -> GameResult -> GameResult
updatePlayer player gameResult =
    { gameResult | player = player }


updateSuggestion : Maybe String -> GameResult -> GameResult
updateSuggestion suggestion gameResult =
    { gameResult | suggestion = suggestion }


updateRating : Int -> GameResult -> GameResult
updateRating rating gameResult =
    { gameResult | rating = rating }


emptyGameResult =
    GameResult 0 "" Nothing 0


yourScore : Int -> Score
yourScore score =
    Score score "Your Score"


isYourScore : Score -> Bool
isYourScore { player } =
    player == "Your Score"


scoresWithYourScore : Posix -> Posix -> Int -> List Score -> List ( Int, Score )
scoresWithYourScore startTime endTime size scores =
    let
        yourScore_ =
            yourScore (TimeFormatter.timeDifference startTime endTime)

        yourPlace =
            findYourPlace yourScore_ scores

        topIndexedScores =
            insertYourScore yourScore_ scores |> List.take size
    in
    if yourPlace > size - 1 then
        topIndexedScores ++ [ ( yourPlace, yourScore_ ) ]

    else
        topIndexedScores


insertYourScore : Score -> List Score -> List ( Int, Score )
insertYourScore score scores =
    scores
        |> List.append [ score ]
        |> List.sortBy .score
        |> List.indexedMap Tuple.pair


findYourPlace : Score -> List Score -> Int
findYourPlace score scores =
    scores
        |> List.append [ score ]
        |> List.sortBy .score
        |> List.Extra.elemIndex score
        |> Maybe.withDefault -1


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
