module CategoryView exposing (categoryView)

import Html exposing (div, input, label, text)
import Html.Attributes exposing (checked, for, name, style, type_)
import Html.Events exposing (onCheck, onClick)
import Msg exposing (Msg(..))
import Square exposing (Category(..))
import Style exposing (bold, fontStyle)


categoryView { class, categories } =
    div [ class "categoryWrapper" ]
        [ div [ style "text-transform" "uppercase", style "font-size" "1.25rem", bold, fontStyle, style "margin-bottom" ".5rem" ] [ text "topical bingo" ]
        , categoryToggle categories Fordism "Fordisms"
        , categoryToggle categories Coronavirus "Coronavirus"
        ]


categoryToggle categories category categoryLabel =
    div [ style "padding" ".5rem .75rem", onClick (CategoryToggled category) ]
        [ input [ name categoryLabel, checked (categories |> List.member category), type_ "checkbox" ] []
        , label [ for categoryLabel, style "font-size" "1rem", bold, fontStyle, style "padding" ".75rem" ] [ text categoryLabel ]
        ]
