module TopScoresViewTests exposing (suite)

import Expect exposing (Expectation)
import Json.Decode exposing (decodeString)
import RemoteData
import Score exposing (Score, decodeGameResult, decodeScore, decodeScores, encodeGameResult, encodeScore, insertYourScore, yourScore)
import Test exposing (..)
import Time exposing (Posix)
import TopScoresView exposing (scoresWithYourScore)


suite : Test
suite =
    describe "TopScoresView"
        [ test "should add your score into top 5" <|
            \_ ->
                scoresWithYourScore 5
                    (RemoteData.succeed
                        [ Score 1 "p1"
                        , Score 2 "p2"
                        , Score 3 "p3"
                        , Score 5 "p5"
                        , Score 6 "p6"
                        ]
                    )
                    (Time.millisToPosix 0)
                    (Time.millisToPosix 4)
                    |> Expect.equal
                        [ ( 0, Score 1 "p1" )
                        , ( 1, Score 2 "p2" )
                        , ( 2, Score 3 "p3" )
                        , ( 3, Score 4 "Your Score" )
                        , ( 4, Score 5 "p5" )
                        ]
        , test "should add your score after the top 5" <|
            \_ ->
                scoresWithYourScore 5
                    (RemoteData.succeed
                        [ Score 1 "p1"
                        , Score 2 "p2"
                        , Score 3 "p3"
                        , Score 4 "p4"
                        , Score 5 "p5"
                        ]
                    )
                    (Time.millisToPosix 0)
                    (Time.millisToPosix 6)
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
                scoresWithYourScore 2
                    (RemoteData.succeed
                        [ Score 1 "p1"
                        , Score 2 "p2"
                        , Score 3 "p3"
                        , Score 4 "p4"
                        , Score 5 "p5"
                        ]
                    )
                    (Time.millisToPosix 0)
                    (Time.millisToPosix 6)
                    |> Expect.equal
                        [ ( 0, Score 1 "p1" )
                        , ( 1, Score 2 "p2" )
                        , ( 5, Score 6 "Your Score" )
                        ]
        ]
