module Options.TopicChoices exposing (view)

import Game.Square exposing (Topic(..))
import Html exposing (Html, div, input, label, text)
import Html.Attributes exposing (checked, for, name, style, type_)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Ports
import State exposing (State)


view :
    { model | class : String -> Html.Attribute Msg, state : State }
    -> String
    -> Bool
    -> Html Msg
view { class, state } wrapperClass show =
    if show then
        div [ class wrapperClass ]
            [ title class
            , topicToggle class "Fordisms" Fordism state.topics
            , topicToggle class "Coronavirus" Coronavirus state.topics
            ]

    else
        div [] []


title class =
    div [ class "topic-title" ] [ text "topical bingo" ]


topicToggle class topicLabel topic topics =
    div [ style "display" "flex", onClick (TopicToggled topic) ]
        [ div [ class "container" ]
            [ input [ name topicLabel, checked (topics |> List.member topic), type_ "checkbox" ] []
            , div [ class (classNames topic topics) ] []
            ]
        , label
            [ for topicLabel
            , class "label"
            ]
            [ text topicLabel ]
        ]


classNames topic topics =
    if topics |> List.member topic then
        "checkmark checkmark-checked"

    else
        "checkmark"
