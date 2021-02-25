module Game.Board exposing (Board, backDiagonal, column, countSquaresIfChecked, forwardDiagonal, getSquares, getSquaresIfChecked, possibleWinningCombinations, row, rowColumnNumbers)

import Array
import Game.Square exposing (Square, checked, iwdSquare)
import Game.Topic exposing (iwd)


type alias Board msg =
    List (Square msg)


getSquares : Board msg -> List Int -> List (Square msg)
getSquares board indices =
    indices
        |> List.map (getSquare board)


getSquaresIfChecked : Board msg -> List Int -> List (Square msg)
getSquaresIfChecked board indices =
    let
        squares =
            indices |> getSquares board
    in
    if squares |> List.all checked then
        squares

    else
        []


countSquaresIfChecked : Board msg -> List Int -> Int
countSquaresIfChecked board indices =
    indices
        |> getSquares board
        |> List.filter checked
        |> List.length


getSquare : Board msg -> Int -> Square msg
getSquare board index =
    board
        |> Array.fromList
        |> Array.get index
        |> Maybe.withDefault (iwdSquare "")


backDiagonal : List Int
backDiagonal =
    [ 0, 6, 12, 18, 24 ]


forwardDiagonal : List Int
forwardDiagonal =
    [ 4, 8, 12, 16, 20 ]


row : Int -> List Int
row rowNumber =
    let
        startIndex =
            rowNumber * 5
    in
    List.range startIndex (startIndex + 4)


column : Int -> List Int
column columnNumber =
    rowColumnNumbers
        |> List.map (\index -> index * 5 + columnNumber)


rowColumnNumbers : List Int
rowColumnNumbers =
    List.range 0 4


possibleWinningCombinations : List (List Int)
possibleWinningCombinations =
    rows ++ columns ++ diagonals


rows : List (List Int)
rows =
    rowColumnNumbers |> List.map row


columns : List (List Int)
columns =
    rowColumnNumbers |> List.map column


diagonals : List (List Int)
diagonals =
    [ backDiagonal ] ++ [ forwardDiagonal ]
