module Win.TimeFormatterTests exposing (suite)

import Expect exposing (Expectation)
import Test exposing (..)
import Time
import Win.TimeFormatter exposing (formatDifference, winingTimeDifference)


suite : Test
suite =
    describe "Time format"
        [ describe "Win Time format"
            [ test "6 millis only has leading seconds zero" <|
                \_ ->
                    winingTimeDifference (Time.millisToPosix 0) (Time.millisToPosix 6)
                        |> Expect.equal "0.006"
            , test "10 millis only has leading seconds zero" <|
                \_ ->
                    winingTimeDifference (Time.millisToPosix 0) (Time.millisToPosix 10)
                        |> Expect.equal "0.010"
            , test "less than 10 secs only has 1 sec digit" <|
                \_ ->
                    winingTimeDifference (Time.millisToPosix 0) (Time.millisToPosix 1545)
                        |> Expect.equal "1.545"
            , test "minutes and single digit secs has leading sec zero" <|
                \_ ->
                    winingTimeDifference (Time.millisToPosix 0) (Time.millisToPosix 61545)
                        |> Expect.equal "1:01.545"
            , test "less than 10 mins only has 1 mins digit" <|
                \_ ->
                    winingTimeDifference (Time.millisToPosix 0) (Time.millisToPosix 82545)
                        |> Expect.equal "1:22.545"
            , test "hours, single digit minutes and secs has leading min zero" <|
                \_ ->
                    winingTimeDifference (Time.millisToPosix 0) (Time.millisToPosix 11320545)
                        |> Expect.equal "3:08:40.545"
            ]
        , describe "Timer format"
            [ test "millis is zero" <|
                \_ ->
                    formatDifference (Time.millisToPosix 0) (Time.millisToPosix 10)
                        |> Expect.equal "00:00:00"
            , test "start time is after time" <|
                \_ ->
                    formatDifference (Time.millisToPosix 10) (Time.millisToPosix 0)
                        |> Expect.equal "00:00:00"
            , test "one second and change" <|
                \_ ->
                    formatDifference (Time.millisToPosix 1000) (Time.millisToPosix 2006)
                        |> Expect.equal "00:00:01"
            , test "Fifteen mins and change" <|
                \_ ->
                    formatDifference (Time.millisToPosix 1000) (Time.millisToPosix (3 * 60 * 5108))
                        |> Expect.equal "00:15:18"
            , test "One hour Fifteen mins and change" <|
                \_ ->
                    formatDifference (Time.millisToPosix 1000) (Time.millisToPosix (60 * 60 * 1000 + 1000))
                        |> Expect.equal "01:00:00"
            ]
        ]
