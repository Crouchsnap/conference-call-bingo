module BingoTests exposing (suite)

import Bingo exposing (allSquares, centerSquare, falseSquare, randomBoard)
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Bingo"
        [ test "board should return 25 squares" <|
            \_ -> (randomBoard 1 |> List.length) |> Expect.equal 25
        , test "board should have Free space int the center square" <|
            \_ ->
                (randomBoard 1 |> List.drop 12 |> List.head |> Maybe.withDefault (falseSquare ""))
                    |> Expect.equal centerSquare
        , test "board should be in random order" <|
            let
                board =
                    randomBoard 1
            in
            \_ ->
                (board |> List.drop 13 |> List.append (board |> List.take 12))
                    |> Expect.notEqual (List.take 24 allSquares)
        ]
