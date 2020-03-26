module Msg exposing (Msg(..))

import Browser
import Rating
import RemoteData exposing (WebData)
import Score exposing (GameResult, Score)
import Square exposing (Square)
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
    | NoOp
