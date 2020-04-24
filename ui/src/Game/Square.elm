module Game.Square exposing (Square, centerSquare, checked, genericSquare, squaresByTopic, toggleSquareInList)

import Game.Dot as Dot exposing (Dot, dot)
import Game.Topic as Topic exposing (Topic(..))
import Html exposing (Html, br, div)
import Random exposing (Seed)


type alias Square msg =
    { html : Html msg, topic : Topic, text : String, dots : List Dot }


genericSquare : String -> Square msg
genericSquare text =
    Square (Html.text text) Generic text []


fordismSquare : String -> Square msg
fordismSquare text =
    Square (Html.text text) Fordism text []


coronavirusSquare : String -> Square msg
coronavirusSquare text =
    Square (Html.text text) Coronavirus text []


centerSquare : Square msg
centerSquare =
    Square (div [] [ Html.text "Free", br [] [], Html.text "Space" ]) Center "Free Space" []


genericSquares : List (Square msg)
genericSquares =
    Topic.generic |> List.map genericSquare


fordismSquares : List (Square msg)
fordismSquares =
    Topic.fordisms |> List.map fordismSquare


coronavirusSquares : List (Square msg)
coronavirusSquares =
    Topic.coronaviri |> List.map coronavirusSquare


allTopicSquares =
    fordismSquares ++ coronavirusSquares


squaresByTopic : List Topic -> List (Square msg)
squaresByTopic topics =
    genericSquares ++ (allTopicSquares |> List.filter (\square -> List.member square.topic topics))


toggleSquareInList : Seed -> Dot.Color -> Square msg -> List (Square msg) -> ( List (Square msg), Seed )
toggleSquareInList seed color squareToToggle squares =
    let
        ( newSquare, nextSeed ) =
            if (squareToToggle.dots |> List.length) < 3 || squareToToggle.topic == Center then
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
    (square.dots |> List.isEmpty |> not) || square.topic == Center
