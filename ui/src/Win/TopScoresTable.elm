module Win.TopScoresTable exposing (isFormValid, view)

import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (disabled, maxlength, minlength, name, placeholder, title, value)
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
    }
    -> List (Html Msg)
view { highScores, startTime, endTime, class, score } =
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
            ++ scoreRows class score highScores
        )
    , submitButton class
    ]


scoreRows class score highScores =
    highScores
        |> extractScores
        |> Score.scoresWithYourScore score 5
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
        [ class "top-score-row centered" ]
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
        [ class "player-input selected-border"
        , name "player"
        , title "Enter 2 to 4 Characters"
        , placeholder "Enter your initials"
        , minlength 2
        , maxlength 4
        , onInput Player
        , value score.player
        ]
        []
    , div
        [ class "top-score-row" ]
        [ text (TimeFormatter.winingTime score.score) ]
    ]


submitButton class =
    button
        [ class "submit-button"
        , onClick SubmitGame
        ]
        [ text "Play Again!" ]


isFormValid : Score -> Bool
isFormValid score =
    let
        initialsLength =
            String.length score.player
    in
    initialsLength > 1 && initialsLength < 5
