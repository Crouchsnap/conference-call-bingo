module TimeFormatterTests exposing (suite)

import Expect exposing (Expectation)
import Test exposing (..)
import Time
import TimeFormatter exposing (winingTimeDifference)


suite : Test
suite =
    describe "Bingo"
        [ test "millis only has leading seconds zero" <|
            \_ ->
                winingTimeDifference (Time.millisToPosix 0) (Time.millisToPosix 10)
                    |> Expect.equal "0.10"
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
