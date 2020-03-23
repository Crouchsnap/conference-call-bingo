module BingoTests exposing (suite)

import Bingo exposing (isWinner, randomBoard)
import Board exposing (Board, backDiagonal, column, forwardDiagonal, row, rowColumnNumbers)
import Expect exposing (Expectation)
import Square exposing (Square, allSquares, centerSquare, falseSquare, toggleSquareInList)
import Test exposing (..)


fakeSquare : Square
fakeSquare =
    { text = "fake", checked = False }


suite : Test
suite =
    let
        testBoard : Board
        testBoard =
            randomBoard 1
    in
    describe "Bingo"
        [ test "board should return 25 squares" <|
            \_ -> (testBoard |> List.length) |> Expect.equal 25
        , test "board should have Free space in the center square" <|
            \_ ->
                (testBoard |> List.drop 12 |> List.head |> Maybe.withDefault (falseSquare ""))
                    |> Expect.equal centerSquare
        , test "board should be in random order" <|
            \_ ->
                (testBoard |> List.drop 13 |> List.append (testBoard |> List.take 12))
                    |> Expect.notEqual (List.take 24 allSquares)
        , test "toggle square should toggle the right square" <|
            let
                firstSquare =
                    List.head testBoard |> Maybe.withDefault fakeSquare
            in
            \_ ->
                testBoard
                    |> toggleSquareInList firstSquare
                    |> List.head
                    |> Maybe.withDefault fakeSquare
                    |> Expect.equal { firstSquare | checked = True }
        , describe "win conditions"
            [ test "board with only free space toggled is a loser" <|
                \_ -> testBoard |> isWinner |> Expect.equal False
            , test "board with top row toggled is winner" <|
                let
                    topRowBoard =
                        testBoard |> checkIndices (row 0)
                in
                \_ -> topRowBoard |> isWinner |> Expect.equal True
            , test "board with second row toggled is winner" <|
                let
                    middleRowBoard =
                        testBoard |> checkIndices (row 2)
                in
                \_ -> middleRowBoard |> isWinner |> Expect.equal True
            , test "All 5 Rows can win" <|
                let
                    canAllRowsWin =
                        rowColumnNumbers
                            |> List.map (\rowNumber -> testBoard |> checkIndices (row rowNumber))
                            |> List.all isWinner
                in
                \_ -> canAllRowsWin |> Expect.equal True
            , test "board with left column toggled is winner" <|
                let
                    leftColumnBoard =
                        testBoard |> checkIndices (column 0)
                in
                \_ -> leftColumnBoard |> isWinner |> Expect.equal True
            , test "board with middle column toggled is winner" <|
                let
                    middleColumnBoard =
                        testBoard |> checkIndices (column 2)
                in
                \_ -> middleColumnBoard |> isWinner |> Expect.equal True
            , test "All 5 Columns can win" <|
                let
                    canAllColumnsWin =
                        rowColumnNumbers
                            |> List.map (\rowNumber -> testBoard |> checkIndices (column rowNumber))
                            |> List.all isWinner
                in
                \_ -> canAllColumnsWin |> Expect.equal True
            , test "board with backDiag toggled is winner" <|
                let
                    backDiagonalBoard =
                        testBoard |> checkIndices backDiagonal
                in
                \_ -> backDiagonalBoard |> isWinner |> Expect.equal True
            , test "board with forwardDiag toggled is winner" <|
                let
                    forwardDiagonalBoard =
                        testBoard |> checkIndices forwardDiagonal
                in
                \_ -> forwardDiagonalBoard |> isWinner |> Expect.equal True
            ]
        ]


checkIndices : List Int -> Board -> Board
checkIndices indices board =
    List.indexedMap
        (\index square ->
            if List.member index indices then
                { square | checked = True }

            else
                square
        )
        board
