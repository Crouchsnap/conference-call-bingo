module Game.GameView exposing (view)

import Assets.Star as Star
import Game.Dot as Dot exposing (Dot)
import Game.Topic exposing (Topic(..))
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import View.Style exposing (dotStyle, squareStyle)


view { class, board, userSettings } =
    div [ class "board-content board-table" ] (board |> List.indexedMap (squareWrapper class userSettings.dauberColor))


squareWrapper class dauberColor index square =
    div
        [ class "square-container" ]
        [ div
            (squareStyle class index (dauberColor |> Dot.toString) ++ [ onClick (ToggleCheck square) ])
            (squareDiv class square)
        ]


squareDiv class square =
    let
        squareHtml =
            if square.topic == Center then
                centerSquareDiv class square

            else
                [ square.html ]
    in
    [ div
        [ class "square-innerHtml" ]
        squareHtml
    ]
        ++ (square.dots |> List.indexedMap (dotDiv class))


centerSquareDiv class square =
    [ div [ class "square-star square-innerHtml" ] [ Star.view "125" ]
    , div [ class "square-star-innerHtml" ] [ square.html ]
    ]


dotDiv : (String -> Html.Attribute msg) -> Int -> Dot -> Html msg
dotDiv class index dot =
    div
        (dotStyle class index dot)
        []
