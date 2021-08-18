module Game.Squares exposing (view)

import Assets.Star as Star
import Game.Dot as Dot exposing (Dot)
import Game.Square exposing (Square)
import Game.Topic exposing (Topic(..))
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import View.Style exposing (dotStyle, squareStyle)


view :
    { model
        | class : String -> Html.Attribute Msg
        , board : List (Square Msg)
        , userSettings : { userSettings | dauberColor : Dot.Color }
    }
    -> Html Msg
view { class, board, userSettings } =
    div [ class "board-content board-table" ] (board |> List.indexedMap (squareWrapper class userSettings.dauberColor))


squareWrapper class dauberColor index square =
    div
        [ class "square-container" ]
        [ button
            (squareStyle class index (dauberColor |> Dot.toString) ++ [ onClick (ToggleCheck square) ])
            (squareDiv class square)
        ]


squareDiv class square =
    let
        baseSquare =
            if square.topic == Center then
                [ div [] (centerSquareDiv class square) ]

            else
                [ square.html ]
    in
    baseSquare
        ++ (square.dots |> List.indexedMap (dotDiv class))


centerSquareDiv class square =
    [ div [ class "square-star" ] [ Star.view "125" ]
    , div [ class "square-star-innerHtml" ] [ square.html ]
    ]


dotDiv : (String -> Html.Attribute msg) -> Int -> Dot -> Html msg
dotDiv class index dot =
    div (dotStyle class index dot) []
