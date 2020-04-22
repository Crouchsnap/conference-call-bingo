module View.Board exposing (view)

import Game.Dot exposing (Color)
import Game.GameView as GameView
import Game.Square exposing (Square)
import Html exposing (div, text)
import Msg exposing (Msg)
import Options.BoardStyle as BoardStyle
import Ports
import Rating exposing (State)
import RemoteData exposing (WebData)
import Time exposing (Posix)
import Win.Score exposing (GameResult, Score)
import Win.WinningView as WinningView


view :
    { model
        | class : String -> Html.Attribute Msg
        , state : Ports.State
        , startTime : Posix
        , endTime : Posix
        , highScores : WebData (List Score)
        , gameResult : GameResult
        , ratingState : State
        , submittedScoreResponse : WebData ()
        , board : List (Square Msg)
    }
    -> Bool
    -> Html.Html Msg
view model gameFinished =
    div [ model.class ("board-container " ++ (model.state.boardColor |> BoardStyle.className)) ]
        [ div [ model.class "board-header" ] [ text "conference call" ]
        , div [ model.class "board-header-bingo" ] bingoTitle
        , if gameFinished then
            WinningView.view model

          else
            GameView.boardGridView model
        ]


bingoTitle =
    [ "B", "I", "N", "G", "O" ]
        |> List.map
            (\letter -> div [] [ text letter ])
