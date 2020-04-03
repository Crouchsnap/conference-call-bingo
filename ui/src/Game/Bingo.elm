module Game.Bingo exposing (isWinner, randomBoard)

import Game.Board exposing (Board, areIndicesChecked, possibleWinningCombinations)
import Game.Square exposing (Category(..), Square, centerSquare, squaresByCategory)
import Random
import Random.List


randomBoard : List Category -> Random.Seed -> ( Board msg, Random.Seed )
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


isWinner : Board msg -> Bool
isWinner board =
    possibleWinningCombinations
        |> List.any (areIndicesChecked board)
