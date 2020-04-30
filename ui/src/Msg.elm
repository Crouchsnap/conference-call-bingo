module Msg exposing (Msg(..))

import Browser
import Browser.Dom exposing (Viewport)
import GA
import Game.Dot as Dot
import Game.Square exposing (Square)
import Game.Topic exposing (Topic)
import Options.BoardStyle as BoardStyle
import Options.Theme exposing (Theme)
import Rating
import RemoteData exposing (WebData)
import Time exposing (Posix)
import Url exposing (Url)
import Win.Score exposing (GameResult, Score)


type Msg
    = GotCurrentTime Time.Posix
    | GotEndTime Time.Posix
    | ToggleCheck (Square Msg)
    | NewGame
    | HighScoresResponse (WebData (List Score))
    | GameResponse (WebData ())
    | SubmitGame
    | RequestHighScores
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | Player String
    | Suggestion String
    | RatingMsg Rating.Msg
    | TopicToggled Topic
    | DauberSelected Dot.Color
    | BoardColorSelected BoardStyle.Color
    | GotViewportSize Viewport
    | WindowResized Int Int
    | UpdateTheme Theme
    | ToggleTopics
    | ToggleOptions
    | GAEvent (GA.Event Msg)
    | Tick Time.Posix
