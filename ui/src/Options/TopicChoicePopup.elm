module Options.TopicChoicePopup exposing (view)

import Assets.Caret as Caret
import Game.Square exposing (Topic)
import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Options.Theme exposing (Theme)
import Options.TopicChoices as TopicChoices


view :
    { model
        | class : String -> Html.Attribute Msg
        , topics : List Topic
        , showTopics : Bool
        , state : { selectedTheme : Theme }
    }
    -> Html Msg
view model =
    div
        [ model.class "topic-mobile-wrapper"
        , onClick ToggleTopics
        ]
        [ text "Topics"
        , div [ model.class "caret-container" ]
            [ Caret.view model.state.selectedTheme ]
        , popup model
        ]


popup model =
    if model.showTopics then
        div [ model.class "mobile-menu mobile-topics" ]
            [ TopicChoices.view model "topic-wrapper-mobile" True ]

    else
        text ""
