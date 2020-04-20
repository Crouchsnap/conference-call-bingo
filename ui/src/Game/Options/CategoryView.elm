module Game.Options.CategoryView exposing (categoryView)

import Game.Square exposing (Category(..))
import Html exposing (div, input, label, text)
import Html.Attributes exposing (checked, for, name, style, type_)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))


categoryView { class, categories } className show =
    if show then
        div [ class className ]
            [ div
                [ class "category-title"
                ]
                [ text "topical bingo" ]
            , categoryToggle class categories Fordism "Fordisms"
            , categoryToggle class categories Coronavirus "Coronavirus"
            ]

    else
        div [] []


categoryToggle class categories category categoryLabel =
    let
        classes =
            if categories |> List.member category then
                [ class "checkmark-checked" ]

            else
                []
    in
    div [ style "display" "flex", onClick (CategoryToggled category) ]
        [ div [ class "container" ]
            [ input [ name categoryLabel, checked (categories |> List.member category), type_ "checkbox" ] []
            , div ([ class "checkmark" ] ++ classes) []
            ]
        , label [ for categoryLabel, style "font-size" "1rem", style "font-weight" "bold", style "padding" ".75rem" ] [ text categoryLabel ]
        ]
