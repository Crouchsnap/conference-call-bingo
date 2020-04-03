module Msg exposing (Msg(..))

import Browser
import Browser.Dom exposing (Viewport)
import Game.Dot as Dot
import Game.Options.BoardStyle as BoardStyle
import Game.Square exposing (Category, Square)
import Rating
import RemoteData exposing (WebData)
import Time exposing (Posix)
import Url exposing (Url)
import View.Theme exposing (Theme)
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
    | CategoryToggled Category
    | DauberSelected Dot.Color
    | BoardColorSelected BoardStyle.Color
    | GotViewportSize Viewport
    | WindowResized Int Int
    | UpdateTheme Theme
