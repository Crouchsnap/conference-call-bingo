module Msg exposing (Msg(..))

import BoardStyle
import Browser
import Browser.Dom exposing (Viewport)
import Dot
import Rating
import RemoteData exposing (WebData)
import Score exposing (GameResult, Score)
import Square exposing (Category, Square)
import Theme exposing (Theme)
import Time exposing (Posix)
import Url exposing (Url)


type Msg
    = GotCurrentTime Time.Posix
    | GotEndTime Time.Posix
    | ToggleCheck Square
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
    | CategoryToggled Category
    | DauberSelected Dot.Color
    | BoardColorSelected BoardStyle.Color
    | GotViewportSize Viewport
    | WindowResized Int Int
    | UpdateTheme Theme
