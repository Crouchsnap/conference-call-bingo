module View.BingoCard exposing (view)

import Game.Square exposing (Square)
import Game.Squares as Squares
import Html exposing (br, div, text)
import Msg exposing (Msg)
import Options.BoardStyle as BoardStyle
import Rating
import Time exposing (Posix)
import UserSettings exposing (UserSettings)
import Win.Score exposing (Score)


view :
    { model
        | class : String -> Html.Attribute Msg
        , userSettings : UserSettings
        , startTime : Posix
        , endTime : Posix
        , score : Score
        , ratingState : Rating.State
        , board : List (Square Msg)
    }
    -> Html.Html Msg
view model =
    div [ model.class ("board-container " ++ (model.userSettings.boardColor |> BoardStyle.toString)) ]
        [ div [ model.class "board-header mt-1" ] [ text "international" ]
        , br [] []
        , div [ model.class "board-header mb-1" ] [ text "women's day" ]
        , div [ model.class "board-header-bingo" ] bingoTitle
        , Squares.view model
        ]


bingoTitle =
    [ "B", "I", "N", "G", "O" ]
        |> List.map
            (\letter -> div [] [ text letter ])
