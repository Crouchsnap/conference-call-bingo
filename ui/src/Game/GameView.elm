module Game.GameView exposing (boardGridView, dotDiv)

import Game.Dot as Dot exposing (Dot)
import Game.Square exposing (Category(..))
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import View.Star as Star
import View.Style exposing (dotStyle, squareContainerStyle, squareStyle)


boardGridView { class, board, dauberColor } =
    div
        [ class "boardTableStyle" ]
        (List.indexedMap
            (\index square ->
                div
                    squareContainerStyle
                    [ div
                        (squareStyle class index (dauberColor |> Dot.toString) ++ [ onClick (ToggleCheck square), class "boardBorder" ])
                        ((if square.category == Center then
                            [ div [ class "center-star" ] [ Star.star "125" ], div [ style "position" "relative", style "z-index" "10", style "text-transform" "uppercase" ] [ square.html ] ]

                          else
                            [ square.html ]
                         )
                            ++ (square.dots
                                    |> List.indexedMap dotDiv
                               )
                        )
                    ]
            )
            board
        )


dotDiv : Int -> Dot -> Html msg
dotDiv index dot =
    div
        (dotStyle index dot)
        []
