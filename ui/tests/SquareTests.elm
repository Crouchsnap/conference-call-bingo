module SquareTests exposing (suite)

import Expect exposing (Expectation)
import Square exposing (Category(..), Square, centerSquare, genericSquare, toggleSquareInList)
import Test exposing (..)


suite : Test
suite =
    describe "Square"
        [ test "toggle a false Square" <|
            \_ ->
                let
                    testSquare =
                        genericSquare ""
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
                        Square "" True Generic
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
