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
import Win.FeedBackView as Feedback
import Win.Score exposing (Score)


view :
    { model
        | userSettings : UserSettings
        , systemTheme : Theme
        , class : String -> Html.Attribute Msg
        , startTime : Posix
        , time : Posix
        , ratingState : Rating.State
        , feedbackSent : Bool
        , score : Score
        , startMultiplayerResponseBody : WebData StartMultiplayerResponseBody
        , multiplayerScores : List MultiplayerScore
        , url : Url
        , betaMode : Bool
    }
    -> String
    -> Html Msg
view model wrapperClass =
    div [ model.class wrapperClass ]
        [ TopicChoices.view model (topicTitle model.class)
        , if model.betaMode then
            MultiplayerView.view model

          else
            text ""
        , Feedback.view model
        , Timer.view model "timer-container options-container"
        ]


topicTitle class =
    div [ class "topic-title" ] [ text "topical bingo" ]
