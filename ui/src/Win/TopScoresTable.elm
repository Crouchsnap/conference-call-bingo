module Win.TopScoresTable exposing (view)

import Game.Board exposing (Board)
import Game.Square exposing (Square)
import Html exposing (Html, button, div, h1, input, li, text)
import Html.Attributes exposing (disabled, maxlength, minlength, name, placeholder, style, title, value)
import Html.Events exposing (onClick, onInput)
import Msg exposing (Msg(..))
import RemoteData exposing (WebData)
import Time exposing (Posix)
import Win.Score as Score exposing (Score)
import Win.TimeFormatter as TimeFormatter


view :
    { model
        | highScores : WebData (List Score)
        , startTime : Posix
        , endTime : Posix
        , class : String -> Html.Attribute Msg
        , score : Score
        , timeZone : Time.Zone
        , board : Board Msg
    }
    -> List (Html Msg)
view { highScores, startTime, endTime, class, score, timeZone, board } =
    [ h1
        [ class "mb-2" ]
        [ text "Congratulations!" ]
    , div
        [ class "top-score-title" ]
        [ text "Thank you for participating in IWD Bingo! Screenshot and share your accomplishments in celebrating and recognizing the incredible impact women have in all areas of our global life." ]
    , div [ class "top-score-title" ] [ text (TimeFormatter.winingTime timeZone endTime) ]
    , div [ class "top-score-title" ] [ text "The squares you completed" ]
    , checkedView board
    , submitButton class
    ]


checkedView : List (Square msg) -> Html msg
checkedView board =
    div []
        (board
            |> List.filter (\square -> square.dots |> List.isEmpty |> not)
            |> List.map .text
            |> List.map checkedItemView
        )


checkedItemView : String -> Html msg
checkedItemView value =
    li [ style "text-transform" "lowercase" ] [ text value ]


submitButton class =
    button
        [ class "submit-button"
        , onClick SubmitGame
        ]
        [ text "Play Again!" ]
