module Win.TopScoresTable exposing (view)

import Html exposing (Html, div, input, text)
import Html.Attributes exposing (maxlength, minlength, name, placeholder, title)
import Html.Events exposing (onInput)
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
    }
    -> Html Msg
view { highScores, startTime, endTime, class } =
    div []
        [ div
            [ class "top-score-title" ]
            [ text "High Scores" ]
        , div [ class "top-score-table" ]
            ([ div
                [ class "centered" ]
                [ text "Rank" ]
             , div
                []
                [ text "Player Initials" ]
             , div
                []
                [ text "Time" ]
             ]
                ++ scoreRows class startTime endTime highScores
            )
        ]


scoreRows class startTime endTime highScores =
    highScores
        |> extractScores
        |> Score.scoresWithYourScore startTime endTime 5
        |> List.map (scoreRow class)
        |> List.concat


extractScores : WebData (List Score) -> List Score
extractScores highScores =
    case highScores of
        RemoteData.Success scores ->
            scores

        _ ->
            []


scoreRow : (String -> Html.Attribute Msg) -> ( Int, Score ) -> List (Html Msg)
scoreRow class ( rank, score ) =
    if Score.isYourScore score then
        yourScoreRow class ( rank, score )

    else
        regularScoreRow class ( rank, score )


regularScoreRow : (String -> Html.Attribute Msg) -> ( Int, Score ) -> List (Html Msg)
regularScoreRow class ( rank, score ) =
    [ div
        [ class "top-score-row", class "centered" ]
        [ text (String.fromInt (rank + 1)) ]
    , div
        [ class "top-score-row" ]
        [ text score.player ]
    , div
        [ class "top-score-row" ]
        [ text (TimeFormatter.winingTime score.score) ]
    ]


yourScoreRow : (String -> Html.Attribute Msg) -> ( Int, Score ) -> List (Html Msg)
yourScoreRow class ( rank, score ) =
    [ div
        [ class "top-score-row", class "centered" ]
        [ text (String.fromInt (rank + 1)) ]
    , input
        [ class "player-input"
        , name "player"
        , title "Enter 2 to 4 Characters"
        , placeholder "Enter your initials"
        , minlength 2
        , maxlength 4
        , onInput Player
        ]
        []
    , div
        [ class "top-score-row" ]
        [ text (TimeFormatter.winingTime score.score) ]
    ]
