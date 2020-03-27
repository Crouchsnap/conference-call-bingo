module Msg exposing (Msg(..))

import Browser
import Browser.Dom exposing (Viewport)
import Rating
import RemoteData exposing (WebData)
import Score exposing (GameResult, Score)
import Square exposing (Category, Square)
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
    | GotViewportSize Viewport
    | WindowResized Int Int
