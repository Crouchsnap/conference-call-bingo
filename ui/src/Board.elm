module Board exposing (Board, areIndicesChecked, backDiagonal, column, forwardDiagonal, possibleWinningCombinations, row, rowColumnNumbers)

import Array
import Square exposing (Square, falseSquare)


type alias Board =
    List Square


areIndicesChecked : Board -> List Int -> Bool
areIndicesChecked board indices =
    indices
        |> List.map (getSquare board)
        |> List.all .checked


getSquare : Board -> Int -> Square
getSquare board index =
    board
        |> Array.fromList
        |> Array.get index
        |> Maybe.withDefault (falseSquare "")


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
