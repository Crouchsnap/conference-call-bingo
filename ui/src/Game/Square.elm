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


avSquare : String -> Square msg
avSquare text =
    Square (Html.text text) AV text []


vehicleDevelopmentSquare : String -> Square msg
vehicleDevelopmentSquare text =
    Square (Html.text text) VehicleDevelopemnt text []


kanyeSquare : String -> Square msg
kanyeSquare text =
    Square (Html.text text) Kanye text []


itfcgSquare : String -> Square msg
itfcgSquare text =
    Square (Html.text text) ITFCG text []


creditSquare : String -> Square msg
creditSquare text =
    Square (Html.text text) Credit text []


architectSquare : String -> Square msg
architectSquare text =
    Square (Html.text text) Architect text []


centerSquare : Square msg
centerSquare =
    Square (div [] [ Html.text "Free", br [] [], Html.text "Space" ]) Center "Free Space" []


genericSquares : List (Square msg)
genericSquares =
    Topic.generic |> List.map genericSquare


fordismSquares : List (Square msg)
fordismSquares =
    Topic.fordisms |> List.map fordismSquare


kanyeSquares : List (Square msg)
kanyeSquares =
    Topic.kanye |> List.map kanyeSquare


itfcgSquares : List (Square msg)
itfcgSquares =
    Topic.itfcg |> List.map itfcgSquare


creditSquares : List (Square msg)
creditSquares =
    Topic.fordCredit |> List.map creditSquare


architectSquares : List (Square msg)
architectSquares =
    Topic.architect |> List.map architectSquare


vehicleDevelopmentSquares : List (Square msg)
vehicleDevelopmentSquares =
    Topic.vehicleDevelopment |> List.map vehicleDevelopmentSquare


coronavirusSquares : List (Square msg)
coronavirusSquares =
    Topic.coronaviri |> List.map coronavirusSquare


avSquares : List (Square msg)
avSquares =
    Topic.av |> List.map avSquare


allTopicSquares : List (Square msg)
allTopicSquares =
    fordismSquares ++ coronavirusSquares ++ avSquares ++ vehicleDevelopmentSquares ++ kanyeSquares ++ itfcgSquares ++ architectSquares ++ creditSquares


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
