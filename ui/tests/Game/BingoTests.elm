module Game.BingoTests exposing (checkIndices, suite)

import Expect exposing (Expectation)
import Game.Bingo exposing (isWinner, longestRowCount, randomBoard, winningCombos)
import Game.Board exposing (Board, backDiagonal, column, forwardDiagonal, getSquares, row, rowColumnNumbers)
import Game.Dot as Dot
import Game.Square exposing (Square, centerSquare, genericSquare, squaresByTopic, toggleSquareInList)
import Game.Topic exposing (Topic(..))
import Html exposing (text)
import Msg exposing (Msg)
import Random
import Test exposing (..)


fakeSquare : Square Msg
fakeSquare =
    { html = text "fake", dots = [], text = "fake", topic = Generic }


suite : Test
suite =
    let
        ( testBoard, seed ) =
            randomBoard [] (Random.initialSeed 1)
    in
    describe "Bingo"
        [ test "board should return 25 squares" <|
            \_ -> (testBoard |> List.length) |> Expect.equal 25
        , test "board should have Free space in the center square" <|
            \_ ->
                (testBoard |> List.drop 12 |> List.head |> Maybe.withDefault (genericSquare ""))
                    |> Expect.equal centerSquare
        , test "board should be in random order" <|
            \_ ->
                (testBoard |> List.drop 13 |> List.append (testBoard |> List.take 12))
                    |> Expect.notEqual (List.take 24 (squaresByTopic []))
        , test "toggle square should toggle the right square" <|
            let
                firstSquare =
                    List.head testBoard |> Maybe.withDefault fakeSquare
            in
            \_ ->
                testBoard
                    |> toggleSquareInList seed Dot.Magenta firstSquare
                    |> Tuple.first
                    |> List.head
                    |> Maybe.withDefault fakeSquare
                    |> .dots
                    |> List.isEmpty
                    |> Expect.equal False
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
            , test "board with top row toggled is returns top row" <|
                let
                    topRowBoard =
                        testBoard |> checkIndices (row 0)

                    topRow =
                        topRowBoard |> List.take 5
                in
                \_ -> topRowBoard |> winningCombos |> Expect.equal [ topRow ]
            , test "board with top row and left column toggled is returns top row and left column" <|
                let
                    topRowAndLeftColumnBoard =
                        testBoard |> checkIndices (row 0) |> checkIndices (column 0)

                    topRowAndLeftColumn =
                        [ row 0 |> getSquares topRowAndLeftColumnBoard
                        , column 0 |> getSquares topRowAndLeftColumnBoard
                        ]
                in
                \_ -> topRowAndLeftColumnBoard |> winningCombos |> Expect.equal topRowAndLeftColumn
            , test "board with bottom row, right column and back diag toggled is returns bottom row, right column and back diag" <|
                let
                    bottomRowRightColumnAndBackDiagBoard =
                        testBoard |> checkIndices (row 4) |> checkIndices (column 4) |> checkIndices backDiagonal

                    bottonRowRightColumnAndBackDiag =
                        [ row 4 |> getSquares bottomRowRightColumnAndBackDiagBoard
                        , column 4 |> getSquares bottomRowRightColumnAndBackDiagBoard
                        , backDiagonal |> getSquares bottomRowRightColumnAndBackDiagBoard
                        ]
                in
                \_ -> bottomRowRightColumnAndBackDiagBoard |> winningCombos |> Expect.equal bottonRowRightColumnAndBackDiag
            ]
        , describe "longest row count"
            [ test "board with only free space toggled is a 1" <|
                \_ -> testBoard |> longestRowCount |> Expect.equal 1
            , test "board with another square toggled is a 2" <|
                let
                    topRowBoard =
                        testBoard |> checkIndices [ 2 ]
                in
                \_ -> topRowBoard |> longestRowCount |> Expect.equal 2
            , test "board with top row toggled is a 5" <|
                let
                    topRowBoard =
                        testBoard |> checkIndices (row 0)
                in
                \_ -> topRowBoard |> longestRowCount |> Expect.equal 5
            ]
        ]


checkIndices : List Int -> Board msg -> Board msg
checkIndices indices board =
    List.indexedMap
        (\index square ->
            if List.member index indices then
                { square | dots = [ Dot.defaultDot ] }

            else
                square
        )
        board
