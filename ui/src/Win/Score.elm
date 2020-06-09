module Win.Score exposing
    ( Score
    , decodeScore
    , decodeScores
    , emptyGameResult
    , encodeScore
    , insertYourScore
    , isYourScore
    , scoreValidator
    , scoresWithYourScore
    , updatePlayer
    , yourScore
    )

import Json.Decode as Decode exposing (Decoder, int, nullable, string)
import Json.Decode.Pipeline
import Json.Encode
import List.Extra
import Time exposing (Posix)
import Validate exposing (Validator, ifTrue)
import Win.TimeFormatter as TimeFormatter


type alias Score =
    { score : Int
    , player : String
    }


scoreValidator : Validator String Score
scoreValidator =
    Validate.all
        [ ifTrue isInitialsLengthValid "Please 2 to 4 characters"
        ]


isInitialsLengthValid score =
    let
        length =
            score.player
                |> String.length
    in
    length < 2 || length > 5


updatePlayer : String -> Score -> Score
updatePlayer player score =
    { score | player = player }


emptyGameResult =
    Score 0 ""


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
