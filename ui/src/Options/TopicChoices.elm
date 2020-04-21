module Options.TopicChoices exposing (view)

import Game.Square exposing (Category(..))
import Html exposing (Html, div, input, label, text)
import Html.Attributes exposing (checked, for, name, style, type_)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))


view :
    { model | class : String -> Html.Attribute Msg, categories : List Category }
    -> String
    -> Bool
    -> Html Msg
view { class, categories } wrapperClass show =
    if show then
        div [ class wrapperClass ]
            [ title class
            , categoryToggle class "Fordisms" Fordism categories
            , categoryToggle class "Coronavirus" Coronavirus categories
            ]

    else
        div [] []


title class =
    div [ class "category-title" ] [ text "topical bingo" ]


categoryToggle class categoryLabel category categories =
    div [ style "display" "flex", onClick (CategoryToggled category) ]
        [ div [ class "container" ]
            [ input [ name categoryLabel, checked (categories |> List.member category), type_ "checkbox" ] []
            , div [ class (classNames category categories) ] []
            ]
        , label
            [ for categoryLabel
            , class "label"
            ]
            [ text categoryLabel ]
        ]


classNames category categories =
    if categories |> List.member category then
        "checkmark checkmark-checked"

    else
        "checkmark"
