module Options.TopicChoicePopup exposing (view)

import Assets.Caret as Caret
import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Options.TopicChoices as TopicChoices
import UserSettings exposing (UserSettings)


view :
    { model
        | class : String -> Html.Attribute Msg
        , showTopics : Bool
        , userSettings : UserSettings
    }
    -> Html Msg
view model =
    div
        [ model.class "topic-mobile-wrapper"
        , onClick ToggleTopics
        ]
        [ text "Topics"
        , div [ model.class "caret-container" ]
            [ Caret.view model.userSettings.selectedTheme ]
        , popup model
        ]


popup model =
    if model.showTopics then
        div [ model.class "mobile-menu mobile-topics" ]
            [ TopicChoices.view model "topic-wrapper-mobile" True ]

    else
        text ""
