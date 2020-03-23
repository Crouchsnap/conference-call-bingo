module ScoreTests exposing (suite)

import Expect exposing (Expectation)
import Json.Decode exposing (decodeString)
import Score exposing (decodeScore, decodeScores, encodeScore)
import Test exposing (..)


suite : Test
suite =
    describe "Score Encode and Decode"
        [ test "should decode list of scores" <|
            \_ ->
                decodeString
                    decodeScores
                    """
                      [{"score": 123, "player": "sam"}]
                    """
                    |> Expect.equal (Ok [ { score = 123, player = "sam" } ])
        , test "should encode score" <|
            \_ ->
                Json.Decode.decodeValue
                    decodeScore
                    (encodeScore { score = 123, player = "sam" })
                    |> Expect.equal (Ok { score = 123, player = "sam" })
        ]
