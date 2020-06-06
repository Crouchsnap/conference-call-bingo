module Game.Bingo exposing (isWinner, longestRowCount, randomBoard, winningCombos)

import Game.Board exposing (Board, countSquaresIfChecked, getSquaresIfChecked, possibleWinningCombinations)
import Game.Square exposing (Square, centerSquare, squaresByTopic)
import Game.Topic exposing (Topic(..))
import Random
import Random.List


randomBoard : List Topic -> Random.Seed -> ( Board msg, Random.Seed )
randomBoard topics seed =
    let
        ( output, next ) =
            seed
                |> Random.step (Random.List.shuffle (squaresByTopic topics))
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
    board |> winningCombos |> List.isEmpty |> not


winningCombos : Board msg -> List (List (Square msg))
winningCombos board =
    possibleWinningCombinations
        |> List.map (getSquaresIfChecked board)
        |> List.filter (\innerList -> innerList |> List.isEmpty |> not)


longestRowCount : Board msg -> Int
longestRowCount board =
    possibleWinningCombinations
        |> List.map (countSquaresIfChecked board)
        |> List.maximum
        |> Maybe.withDefault 1
