module CategoryView exposing (categoryView)

import Html exposing (div, input, label, text)
import Html.Attributes exposing (for, name, style, type_)
import Html.Events exposing (onCheck, onClick, onInput)
import Msg exposing (Msg(..))
import Square exposing (Category(..))
import Style exposing (bold, fontColor, fontStyle)


categoryView { categories } =
    div [ style "display" "flex", style "flex-direction" "column", style "align-items" "flex-end", style "margin" "1rem ", style "justify-self" "flex-end" ]
        [ div [ style "text-transform" "uppercase", style "font-size" "1.25rem", bold, fontStyle ] [ text "topical bingo" ]
        , categoryToggle
        ]


categoryToggle =
    div [ style "padding" ".75rem" ]
        [ input [ name "fordism", type_ "checkbox", onCheck (CategoryToggled Fordism) ] []
        , label [ for "fordism", style "font-size" "1rem", bold, fontColor, fontStyle, style "padding" ".75rem" ] [ text "Fordisms" ]
        ]
