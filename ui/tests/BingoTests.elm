module BingoTests exposing (suite)

import Bingo exposing (Square, allSquares, centerSquare, falseSquare, randomBoard, toggleSquareInList)
import Expect exposing (Expectation)
import Test exposing (..)


fakeSquare : Square
fakeSquare =
    { text = "fake", checked = False }


suite : Test
suite =
    describe "Bingo"
        [ test "board should return 25 squares" <|
            \_ -> (randomBoard 1 |> List.length) |> Expect.equal 25
        , test "board should have Free space in the center square" <|
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
        , test "toggle square should toggle the right square" <|
            let
                board =
                    randomBoard 1

                firstSquare =
                    List.head board |> Maybe.withDefault fakeSquare
            in
            \_ ->
                board
                    |> toggleSquareInList firstSquare
                    |> List.head
                    |> Maybe.withDefault fakeSquare
                    |> Expect.equal { firstSquare | checked = True }
        ]
