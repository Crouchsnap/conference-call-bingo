module Game.Square exposing (Square, allTopicSquares, centerSquare, checked, iwdSquare, squaresByTopic, toggleSquareInList)

import Game.Dot as Dot exposing (Dot, dot)
import Game.Topic as Topic exposing (Topic(..), centerText)
import Html exposing (Html, br, div)
import Random exposing (Seed)


type alias Square msg =
    { html : Html msg, topic : Topic, text : String, dots : List Dot }


centerSquare : Square msg
centerSquare =
    Square (Html.text centerText) Iwd centerText []


iwdSquare : String -> Square msg
iwdSquare text =
    Square (Html.text text) Iwd text []


iwdSquares : List (Square msg)
iwdSquares =
    Topic.iwd |> List.map iwdSquare


allTopicSquares : List (Square msg)
allTopicSquares =
    iwdSquares


squaresByTopic : List Topic -> List (Square msg)
squaresByTopic topics =
    iwdSquares


toggleSquareInList : Seed -> Dot.Color -> Square msg -> List (Square msg) -> ( List (Square msg), Seed )
toggleSquareInList seed color squareToToggle squares =
    let
        ( newSquare, nextSeed ) =
            if (squareToToggle.dots |> List.length) < 3 then
                toggleSquare seed color squareToToggle

            else
                unToggleSquare seed squareToToggle
    in
    ( List.map
        (\square ->
            if square == squareToToggle then
                newSquare

            else
                square
        )
        squares
    , nextSeed
    )


unToggleSquare seed square =
    ( { square | dots = [] }, seed )


toggleSquare : Seed -> Dot.Color -> Square msg -> ( Square msg, Seed )
toggleSquare seed color square =
    let
        ( randomDot, nextSeed ) =
            dot seed color
    in
    ( { square | dots = List.append square.dots [ randomDot ] }, nextSeed )


checked : Square msg -> Bool
checked square =
    square.dots |> List.isEmpty |> not
