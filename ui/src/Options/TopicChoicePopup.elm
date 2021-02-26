module Options.TopicChoicePopup exposing (view)

import Assets.Caret as Caret
import Game.GameOptions as GameOptions
import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Options.Theme exposing (Theme)
import Options.TopicChoices as TopicChoices
import Rating
import RemoteData exposing (WebData)
import Time exposing (Posix)
import Url exposing (Url)
import UserSettings exposing (UserSettings)
import Win.Score exposing (Score)


view :
    { model
        | class : String -> Html.Attribute Msg
        , userSettings : UserSettings
        , showTopics : Bool
        , systemTheme : Theme
        , startTime : Posix
        , time : Posix
        , ratingState : Rating.State
        , score : Score
        , url : Url
        , betaMode : Bool
        , errors : List String
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
            [ GameOptions.view model "topic-container-mobile" ]

    else
        text ""
