module Game.GameView exposing (boardGridView, dotDiv)

import Game.Dot as Dot exposing (Dot)
import Game.Square exposing (Category(..))
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import View.Star as Star
import View.Style exposing (dotStyle, squareStyle)


boardGridView { class, board, dauberColor } =
    div [ class "boardTableStyle" ] (board |> List.indexedMap (squareWrapper class dauberColor))


squareWrapper class dauberColor index square =
    div
        [ class "square-container" ]
        [ div
            (squareStyle class index (dauberColor |> Dot.toString) ++ [ onClick (ToggleCheck square), class "boardBorder" ])
            (squareDiv class square)
        ]


squareDiv class square =
    let
        squareHtml =
            if square.category == Center then
                centerSquareDiv class square

            else
                [ square.html ]
    in
    squareHtml ++ (square.dots |> List.indexedMap (dotDiv class))


centerSquareDiv class square =
    [ div [ class "center-star" ] [ Star.star "125" ], div [ style "position" "relative", style "z-index" "10", style "text-transform" "uppercase" ] [ square.html ] ]


dotDiv : (String -> Html.Attribute msg) -> Int -> Dot -> Html msg
dotDiv class index dot =
    div
        (dotStyle class index dot)
        []
