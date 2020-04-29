module View.Board exposing (view)

import Game.GameView as GameView
import Game.Square exposing (Square)
import Html exposing (div, text)
import Msg exposing (Msg)
import Options.BoardStyle as BoardStyle
import Rating
import RemoteData exposing (WebData)
import Time exposing (Posix)
import UserSettings exposing (UserSettings)
import Win.Score exposing (GameResult, Score)


view :
    { model
        | class : String -> Html.Attribute Msg
        , userSettings : UserSettings
        , startTime : Posix
        , endTime : Posix
        , highScores : WebData (List Score)
        , gameResult : GameResult
        , ratingState : Rating.State
        , submittedScoreResponse : WebData ()
        , board : List (Square Msg)
    }
    -> Html.Html Msg
view model =
    div [ model.class ("board-container " ++ (model.userSettings.boardColor |> BoardStyle.toString)) ]
        [ div [ model.class "board-header" ] [ text "conference call" ]
        , div [ model.class "board-header-bingo" ] bingoTitle
        , GameView.boardGridView model
        ]


bingoTitle =
    [ "B", "I", "N", "G", "O" ]
        |> List.map
            (\letter -> div [] [ text letter ])
