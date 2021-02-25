module Game.Square exposing (Square, allTopicSquares, buildSquare, centerSquare, checked, decoder, encode, iwdSquare, squaresByTopic, toggleSquareInList)

import Game.Dot as Dot exposing (Dot, dot)
import Game.Topic as Topic exposing (Topic(..), centerText)
import Html exposing (Html, br, div)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline
import Json.Encode as Encode
import Random exposing (Seed)


type alias Square msg =
    { html : Html msg, topic : Topic, text : String, dots : List Dot }


buildSquare : String -> List Dot -> Square msg
buildSquare text dots =
    Square (Html.text text) Iwd text dots


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


decoder : Decoder (Square msg)
decoder =
    Decode.succeed buildSquare
        |> Json.Decode.Pipeline.optional "text" Decode.string ""
        |> Json.Decode.Pipeline.optional "dots" (Decode.list Dot.decoder) []


encode : Square msg -> Encode.Value
encode square =
    Encode.object
        [ ( "text", Encode.string <| square.text )
        , ( "dots", Encode.list Dot.encode <| square.dots )
        ]
