module SquareTests exposing (suite)

import Expect exposing (Expectation)
import Square exposing (Square, centerSquare, falseSquare, toggleSquareInList)
import Test exposing (..)


suite : Test
suite =
    describe "Square"
        [ test "toggle a false Square" <|
            \_ ->
                let
                    testSquare =
                        falseSquare ""
                in
                [ testSquare ]
                    |> toggleSquareInList testSquare
                    |> List.head
                    |> Maybe.withDefault testSquare
                    |> .checked
                    |> Expect.equal True
        , test "toggle a true Square" <|
            \_ ->
                let
                    testSquare =
                        Square "" True
                in
                [ testSquare ]
                    |> toggleSquareInList testSquare
                    |> List.head
                    |> Maybe.withDefault testSquare
                    |> .checked
                    |> Expect.equal False
        , test "not toggle the center" <|
            \_ ->
                [ centerSquare ]
                    |> toggleSquareInList centerSquare
                    |> List.head
                    |> Maybe.withDefault centerSquare
                    |> .checked
                    |> Expect.equal True
        ]
