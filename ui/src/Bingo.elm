module Bingo exposing (isWinner, randomBoard)

import Board exposing (Board, areIndicesChecked, possibleWinningCombinations)
import Random
import Random.List
import Square exposing (Square, allSquares, centerSquare)


randomBoard : Int -> ( Board, Random.Seed )
randomBoard seed =
    let
        ( output, next ) =
            Random.initialSeed seed
                |> Random.step (Random.List.shuffle allSquares)
    in
    ( List.take 12 output
        ++ [ centerSquare ]
        ++ (output
                |> List.drop 12
                |> List.take 12
           )
    , next
    )


isWinner : Board -> Bool
isWinner board =
    possibleWinningCombinations
        |> List.any (areIndicesChecked board)
