module View.CategoryPopup exposing (view)

import Assets.Caret as Caret
import Game.Options.CategoryView as CategoryView
import Html exposing (div, text)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))


view model =
    div
        [ model.class "category-mobile-wrapper"
        , onClick ToggleTopics
        ]
        [ text "Topics"
        , div [ model.class "caret-container" ]
            [ Caret.svg model.selectedTheme ]
        , popup model
        ]


popup model =
    if model.showTopics then
        div [ model.class "mobile-menu mobile-topics" ]
            [ CategoryView.categoryView model "categoryWrapper-mobile" True ]

    else
        text ""
