module Options.TopicChoices exposing (view)

import Game.Topic exposing (Topic(..))
import Html exposing (Html, div, input, label, text)
import Html.Attributes exposing (checked, for, name, style, type_)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import UserSettings exposing (UserSettings)


view :
    { model | class : String -> Html.Attribute Msg, userSettings : UserSettings }
    -> Html Msg
view { class, userSettings } =
    div [ class "", style "margin" "1rem" ]
        [ title class
        , topicToggle class "Architecture/Engineering" Architect userSettings.topics
        , topicToggle class "Autonomous Vehicle" AV userSettings.topics
        , topicToggle class "Coronavirus" Coronavirus userSettings.topics
        , topicToggle class "Fordisms" Fordism userSettings.topics
        , topicToggle class "IT-FCG" ITFCG userSettings.topics
        , topicToggle class "Kanye" Kanye userSettings.topics
        , topicToggle class "Product Development" VehicleDevelopemnt userSettings.topics
        ]


title class =
    div [ class "topic-title" ] [ text "topical bingo" ]


topicToggle class topicLabel topic topics =
    div [ style "display" "flex", onClick (TopicToggled topic) ]
        [ div [ class "topic-container" ]
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
