module BingoTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


suite : Test
suite =
    describe "Bingo"
        [ test "" <|
            \_ -> 1 |> Expect.equal 1
        ]
