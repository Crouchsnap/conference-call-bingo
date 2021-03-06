module View.BingoCard exposing (view)

import Game.Square exposing (Square)
import Game.Squares as Squares
import Html exposing (div, text)
import Msg exposing (Msg)
import Options.BoardStyle as BoardStyle
import Rating
import RemoteData exposing (WebData)
import Time exposing (Posix)
import UserSettings exposing (UserSettings)
import Win.Score exposing (Score)


view :
    { model
        | class : String -> Html.Attribute Msg
        , userSettings : UserSettings
        , startTime : Posix
        , highScores : WebData (List Score)
        , score : Score
        , ratingState : Rating.State
        , submittedScoreResponse : WebData ()
        , board : List (Square Msg)
    }
    -> Html.Html Msg
view model =
    div [ model.class ("board-container " ++ (model.userSettings.boardColor |> BoardStyle.toString)) ]
        [ div [ model.class "board-header" ] [ text "conference call" ]
        , div [ model.class "board-header-bingo" ] bingoTitle
        , Squares.view model
        ]


bingoTitle =
    [ "B", "I", "N", "G", "O" ]
        |> List.map
            (\letter -> div [] [ text letter ])
