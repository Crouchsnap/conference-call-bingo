module Bingo exposing (isWinner, randomBoard)

import Board exposing (Board, areIndicesChecked, possibleWinningCombinations)
import Random
import Random.List
import Square exposing (Category(..), Square, centerSquare, squaresByCategory)


randomBoard : List Category -> Random.Seed -> ( Board, Random.Seed )
randomBoard categories seed =
    let
        ( output, next ) =
            seed
                |> Random.step (Random.List.shuffle (squaresByCategory categories))
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
