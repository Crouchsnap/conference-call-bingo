module BingoTests exposing (suite)

import Array
import Bingo exposing (Board, Square, allSquares, centerSquare, falseSquare, randomBoard, toggleSquare, toggleSquareInList)
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
        , describe "win conditions"
            [ test "board with only free space toggled is a loser" <|
                \_ -> randomBoard 1 |> isWinner |> Expect.equal False
            , test "board with top row toggled is winner" <|
                let
                    topRowBoard =
                        randomBoard 1 |> toggleIndicies (row 0)
                in
                \_ -> topRowBoard |> isWinner |> Expect.equal True
            , test "board with second row toggled is winner" <|
                let
                    topRowBoard =
                        randomBoard 1 |> toggleIndicies (row 1)
                in
                \_ -> topRowBoard |> isWinner |> Expect.equal True
            ]
        ]


row : Int -> List Int
row rowNumber =
    let
        startIndex =
            rowNumber * 5
    in
    List.range startIndex (startIndex + 4)


toggleIndicies : List Int -> Board -> Board
toggleIndicies indicies board =
    List.indexedMap
        (\index square ->
            if List.member index indicies then
                toggleSquare square

            else
                square
        )
        board


areIndiciesChecked : List Int -> Board -> Bool
areIndiciesChecked indicies board =
    let
        arrayBoard =
            Array.fromList board
    in
    indicies |> List.map (\index -> Array.get index arrayBoard |> Maybe.withDefault fakeSquare) |> List.all (\square -> square.checked)


isWinner : Board -> Bool
isWinner board =
    List.range 0 4 |> List.any (\rowNumber -> areIndiciesChecked (row rowNumber) board)
