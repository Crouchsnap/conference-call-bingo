module Win.TimeFormatterTests exposing (suite)

import Expect exposing (Expectation)
import Test exposing (..)
import Time
import Win.TimeFormatter exposing (formatDifference, winingTimeDifference)


suite : Test
suite =
    describe "Time format"
        [ describe "Timer format"
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
            , test "7 days to go" <|
                \_ ->
                    formatDifference (Time.millisToPosix 1615222800000) (Time.millisToPosix 1615867200000)
                        |> Expect.equal "7 Days "
            , test "Noon on due day" <|
                \_ ->
                    formatDifference (Time.millisToPosix 1615824000000) (Time.millisToPosix 1615867200000)
                        |> Expect.equal "12:00:00"
            , test "3ish on due day" <|
                \_ ->
                    formatDifference (Time.millisToPosix 1615836164964) (Time.millisToPosix 1615867200000)
                        |> Expect.equal "08:37:15"
            ]
        ]
