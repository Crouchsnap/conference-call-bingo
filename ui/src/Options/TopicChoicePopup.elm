module Options.TopicChoicePopup exposing (view)

import Assets.Caret as Caret
import Game.Square exposing (Category)
import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Options.Theme exposing (Theme)
import Options.TopicChoices as CategoryView


view :
    { model
        | class : String -> Html.Attribute Msg
        , categories : List Category
        , showTopics : Bool
        , selectedTheme : Theme
    }
    -> Html Msg
view model =
    div
        [ model.class "category-mobile-wrapper"
        , onClick ToggleTopics
        ]
        [ text "Topics"
        , div [ model.class "caret-container" ]
            [ Caret.view model.selectedTheme ]
        , popup model
        ]


popup model =
    if model.showTopics then
        div [ model.class "mobile-menu mobile-topics" ]
            [ CategoryView.view model "categoryWrapper-mobile" True ]

    else
        text ""
