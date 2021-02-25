module Game.Squares exposing (view)

import Assets.Star as Star
import Game.Dot as Dot exposing (Dot)
import Game.Square exposing (Square)
import Game.Topic exposing (Topic(..))
import Html exposing (Html, button, div)
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
        squareHtml =
            [ square.html ]
    in
    [ div [ class "square-innerHtml" ] squareHtml ]
        ++ (square.dots |> List.indexedMap (dotDiv class))


dotDiv : (String -> Html.Attribute msg) -> Int -> Dot -> Html msg
dotDiv class index dot =
    div (dotStyle class index dot) []
