module Win.ScoreTests exposing (suite)

import Expect exposing (Expectation)
import Json.Decode exposing (decodeString)
import Test exposing (..)
import Time
import Win.Score exposing (Score, decodeGameResult, decodeScore, decodeScores, encodeGameResult, encodeScore, insertYourScore, scoresWithYourScore, yourScore)


suite : Test
suite =
    describe "Score Tests"
        [ describe "Score Encode and Decode"
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
            , test "add in your score" <|
                \_ ->
                    [ Score 12345 "DEF", Score 1234567 "ABC" ]
                        |> insertYourScore (123456 |> yourScore)
                        |> Expect.equal [ ( 0, Score 12345 "DEF" ), ( 1, Score 123456 "Your Score" ), ( 2, Score 1234567 "ABC" ) ]
            ]
        , describe "Adding user score to topscores"
            [ test "should add your score into top 5" <|
                \_ ->
                    scoresWithYourScore
                        (Time.millisToPosix 0)
                        (Time.millisToPosix 4)
                        5
                        [ Score 1 "p1"
                        , Score 2 "p2"
                        , Score 3 "p3"
                        , Score 5 "p5"
                        , Score 6 "p6"
                        ]
                        |> Expect.equal
                            [ ( 0, Score 1 "p1" )
                            , ( 1, Score 2 "p2" )
                            , ( 2, Score 3 "p3" )
                            , ( 3, Score 4 "Your Score" )
                            , ( 4, Score 5 "p5" )
                            ]
            , test "should add your score after the top 5" <|
                \_ ->
                    scoresWithYourScore
                        (Time.millisToPosix 0)
                        (Time.millisToPosix 6)
                        5
                        [ Score 1 "p1"
                        , Score 2 "p2"
                        , Score 3 "p3"
                        , Score 4 "p4"
                        , Score 5 "p5"
                        ]
                        |> Expect.equal
                            [ ( 0, Score 1 "p1" )
                            , ( 1, Score 2 "p2" )
                            , ( 2, Score 3 "p3" )
                            , ( 3, Score 4 "p4" )
                            , ( 4, Score 5 "p5" )
                            , ( 5, Score 6 "Your Score" )
                            ]
            , test "should add your score after the top 5 non contiguous" <|
                \_ ->
                    scoresWithYourScore
                        (Time.millisToPosix 0)
                        (Time.millisToPosix 6)
                        2
                        [ Score 1 "p1"
                        , Score 2 "p2"
                        , Score 3 "p3"
                        , Score 4 "p4"
                        , Score 5 "p5"
                        ]
                        |> Expect.equal
                            [ ( 0, Score 1 "p1" )
                            , ( 1, Score 2 "p2" )
                            , ( 5, Score 6 "Your Score" )
                            ]
            ]
        ]
