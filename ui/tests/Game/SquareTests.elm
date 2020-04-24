module Game.SquareTests exposing (suite)

import Expect exposing (Expectation)
import Game.Dot as Dot exposing (Dot, defaultDot)
import Game.Square as Square exposing (Square, centerSquare, genericSquare, toggleSquareInList)
import Game.Topic exposing (Topic(..))
import Html exposing (text)
import Random
import Test exposing (..)


suite : Test
suite =
    let
        seed =
            Random.initialSeed 0
    in
    describe "Square"
        [ test "toggle a false Square" <|
            \_ ->
                let
                    testSquare =
                        genericSquare ""
                in
                [ testSquare ]
                    |> toggleSquareInList seed Dot.Blue testSquare
                    |> Tuple.first
                    |> List.head
                    |> Maybe.withDefault testSquare
                    |> Square.checked
                    |> Expect.equal True
        , test "toggle a true Square 3 times to uncheck" <|
            \_ ->
                let
                    testSquare =
                        Square (text "") Generic "" [ defaultDot, defaultDot, defaultDot ]
                in
                [ testSquare ]
                    |> toggleSquareInList seed Dot.Blue testSquare
                    |> Tuple.first
                    |> List.head
                    |> Maybe.withDefault testSquare
                    |> Square.checked
                    |> Expect.equal False
        , test "not toggle the center" <|
            \_ ->
                [ centerSquare ]
                    |> toggleSquareInList seed Dot.Blue centerSquare
                    |> Tuple.first
                    |> List.head
                    |> Maybe.withDefault centerSquare
                    |> Square.checked
                    |> Expect.equal True
        ]
