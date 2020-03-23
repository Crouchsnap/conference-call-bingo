module Bingo exposing
    ( Board
    , backDiagonal
    , column
    , forwardDiagonal
    , isWinner
    , randomBoard
    , row
    , rowColumnNumbers
    )

import Array
import Random
import Random.List
import Square exposing (Square, allSquares, centerSquare, falseSquare)


type alias Board =
    List Square


randomBoard : Int -> Board
randomBoard seed =
    let
        output =
            Random.initialSeed seed
                |> Random.step (Random.List.shuffle allSquares)
                |> Tuple.first
    in
    List.take 12 output
        ++ [ centerSquare ]
        ++ (output
                |> List.drop 12
                |> List.take 12
           )


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


isWinner : Board -> Bool
isWinner board =
    let
        rows =
            rowColumnNumbers |> List.map row

        columns =
            rowColumnNumbers |> List.map column

        diagonals =
            [ backDiagonal ] ++ [ forwardDiagonal ]
    in
    (rows ++ columns ++ diagonals)
        |> List.any (areIndicesChecked board)


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
