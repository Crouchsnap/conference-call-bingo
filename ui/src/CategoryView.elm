module CategoryView exposing (categoryView)

import Html exposing (div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Square exposing (Category(..))
import Style exposing (categoryButtonStyle)


categoryView { categories } =
    div [ style "justify-content" "right", style "display" "flex", style "padding-top" "5px" ]
        [ div (categoryButtonStyle ++ [ onClick (CategoryToggled Fordism) ])
            [ if List.member Fordism categories then
                text "Remove Fordisms"

              else
                text "Add Fordisms"
            ]
        ]
