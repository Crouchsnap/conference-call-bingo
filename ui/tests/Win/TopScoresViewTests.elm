module Win.TopScoresViewTests exposing (suite)

import Expect exposing (Expectation)
import Test exposing (..)
import Time exposing (Posix)
import Win.Score exposing (Score, scoresWithYourScore)


suite : Test
suite =
    describe "TopScoresView"
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
