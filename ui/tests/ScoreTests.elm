module ScoreTests exposing (suite)

import Expect exposing (Expectation)
import Json.Decode exposing (decodeString)
import Score exposing (decodeGameResult, decodeScore, decodeScores, encodeGameResult, encodeScore)
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
        , test "should decode a game result" <|
            \_ ->
                decodeString
                    decodeGameResult
                    """
                      { "score": 123, "player": "sam", "suggestion": null, "rating": 5 }
                    """
                    |> Expect.equal (Ok { score = 123, player = "sam", suggestion = Nothing, rating = 5 })
        , test "should encode game result" <|
            \_ ->
                Json.Decode.decodeValue
                    decodeGameResult
                    (encodeGameResult { score = 123, player = "sam", suggestion = Nothing, rating = 5 })
                    |> Expect.equal (Ok { score = 123, player = "sam", suggestion = Just "", rating = 5 })
        ]
