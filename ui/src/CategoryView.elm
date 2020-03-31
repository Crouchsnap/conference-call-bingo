module CategoryView exposing (categoryView)

import Html exposing (div, input, label, text)
import Html.Attributes exposing (class, for, name, style, type_)
import Html.Events exposing (onCheck)
import Msg exposing (Msg(..))
import Square exposing (Category(..))
import Style exposing (bold, fontStyle)


categoryView =
    div [ class "categoryWrapper" ]
        [ div [ style "text-transform" "uppercase", style "font-size" "1.25rem", bold, fontStyle, style "margin-bottom" ".5rem" ] [ text "topical bingo" ]
        , categoryToggle Fordism "Fordisms"
        , categoryToggle Coronavirus "Coronavirus"
        ]


categoryToggle category categoryLabel =
    div [ style "padding" ".5rem .75rem" ]
        [ input [ name categoryLabel, type_ "checkbox", onCheck (CategoryToggled category) ] []
        , label [ for categoryLabel, style "font-size" "1rem", bold, fontStyle, style "padding" ".75rem" ] [ text categoryLabel ]
        ]
