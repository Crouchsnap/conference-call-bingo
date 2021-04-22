module Win.ScoreTests exposing (suite)

import Expect exposing (Expectation)
import Json.Decode exposing (decodeString)
import Test exposing (..)
import Time
import Win.Score exposing (Score, decodeScore, decodeScores, emptyYourScore, encodeScore, insertYourScore, newYourScore, scoresWithYourScore, setScoreTime)


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
                        |> Expect.equal (Ok [ { score = 123, player = "sam", yourScore = False } ])
            , test "should encode score" <|
                \_ ->
                    Json.Decode.decodeValue
                        decodeScore
                        (encodeScore { score = 123, player = "sam", yourScore = False })
                        |> Expect.equal (Ok { score = 123, player = "sam", yourScore = False })
            , test "add in your score" <|
                \_ ->
                    [ Score 12345 "DEF" False, Score 1234567 "ABC" False ]
                        |> insertYourScore (123456 |> newYourScore)
                        |> Expect.equal [ ( 0, Score 12345 "DEF" False ), ( 1, Score 123456 "" True ), ( 2, Score 1234567 "ABC" False ) ]
            ]
        , describe "Adding user score to topscores"
            [ test "should add your score into top 5" <|
                \_ ->
                    scoresWithYourScore
                        (emptyYourScore |> setScoreTime (Time.millisToPosix 0) (Time.millisToPosix 4))
                        5
                        [ Score 1 "p1" False
                        , Score 2 "p2" False
                        , Score 3 "p3" False
                        , Score 5 "p5" False
                        , Score 6 "p6" False
                        ]
                        |> Expect.equal
                            [ ( 0, Score 1 "p1" False )
                            , ( 1, Score 2 "p2" False )
                            , ( 2, Score 3 "p3" False )
                            , ( 3, Score 4 "" True )
                            , ( 4, Score 5 "p5" False )
                            ]
            , test "should add your score after the top 5" <|
                \_ ->
                    scoresWithYourScore
                        (emptyYourScore |> setScoreTime (Time.millisToPosix 0) (Time.millisToPosix 6))
                        5
                        [ Score 1 "p1" False
                        , Score 2 "p2" False
                        , Score 3 "p3" False
                        , Score 4 "p4" False
                        , Score 5 "p5" False
                        ]
                        |> Expect.equal
                            [ ( 0, Score 1 "p1" False )
                            , ( 1, Score 2 "p2" False )
                            , ( 2, Score 3 "p3" False )
                            , ( 3, Score 4 "p4" False )
                            , ( 4, Score 5 "p5" False )
                            , ( 5, Score 6 "" True )
                            ]
            , test "should add your score after the top 5 non contiguous" <|
                \_ ->
                    scoresWithYourScore
                        (emptyYourScore |> setScoreTime (Time.millisToPosix 0) (Time.millisToPosix 6))
                        2
                        [ Score 1 "p1" False
                        , Score 2 "p2" False
                        , Score 3 "p3" False
                        , Score 4 "p4" False
                        , Score 5 "p5" False
                        ]
                        |> Expect.equal
                            [ ( 0, Score 1 "p1" False )
                            , ( 1, Score 2 "p2" False )
                            , ( 5, Score 6 "" True )
                            ]
            ]
        ]
