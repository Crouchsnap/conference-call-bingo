module Game.GameOptions exposing (view)

import Game.Timer as Timer
import Html exposing (Html, div, text)
import Msg exposing (Msg)
import Multiplayer.Multiplayer exposing (MultiplayerScore, StartMultiplayerResponseBody)
import Multiplayer.MultiplayerView as MultiplayerView
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
        | userSettings : UserSettings
        , systemTheme : Theme
        , class : String -> Html.Attribute Msg
        , startTime : Posix
        , time : Posix
        , ratingState : Rating.State
        , score : Score
        , startMultiplayerResponseBody : WebData StartMultiplayerResponseBody
        , multiplayerScores : List MultiplayerScore
        , url : Url
        , betaMode : Bool
        , errors : List String
    }
    -> String
    -> Html Msg
view model wrapperClass =
    div [ model.class wrapperClass ]
        [ TopicChoices.view model (topicTitle model.class)
        , if model.betaMode then
            MultiplayerView.view model "desktop-only" "Desktop" False

          else
            text ""
        , Timer.view model "timer-container options-container bottom-item"
        ]


topicTitle class =
    div [ class "topic-title" ] [ text "topics" ]
