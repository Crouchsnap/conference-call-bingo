module TopScoresView exposing (scoreRow, scoresWithYourScore, topScoreView)

import Html exposing (Html, div, input, text)
import Html.Attributes exposing (maxlength, minlength, name, placeholder, title)
import Html.Events exposing (onInput)
import List.Extra
import Msg exposing (Msg(..))
import RemoteData exposing (WebData)
import Score exposing (Score)
import Time exposing (Posix)
import TimeFormatter


topScoreView : { model | highScores : WebData (List Score), startTime : Posix, endTime : Posix, class : String -> Html.Attribute Msg } -> Html Msg
topScoreView { highScores, startTime, endTime, class } =
    div []
        [ div
            [ class "topScoreHeaderStyle" ]
            [ text "High Scores" ]
        , div [ class "topScoreTableStyle" ]
            ([ div
                [ class "topScoreColumnHeaderStyle", class "centered" ]
                [ text "Rank" ]
             , div
                [ class "topScoreColumnHeaderStyle" ]
                [ text "Player Initials" ]
             , div
                [ class "topScoreColumnHeaderStyle" ]
                [ text "Time" ]
             ]
                ++ (scoresWithYourScore 5 highScores startTime endTime
                        |> List.map (scoreRow class)
                        |> List.concat
                   )
            )
        ]


scoresWithYourScore : Int -> WebData (List Score) -> Posix -> Posix -> List ( Int, Score )
scoresWithYourScore size highScores startTime endTime =
    case highScores of
        RemoteData.Success scores ->
            let
                yourScore =
                    Score.yourScore (TimeFormatter.timeDifference startTime endTime)

                scoresWithYourRow =
                    Score.insertYourScore yourScore scores

                yourScoreTupe =
                    scoresWithYourRow
                        |> List.Extra.find (\( _, score ) -> score == yourScore)
                        |> Maybe.withDefault ( -1, Score -1 "" )

                yourRow =
                    if (yourScoreTupe |> Tuple.first) > (size - 1) then
                        [ yourScoreTupe ]

                    else
                        []

                rows =
                    List.append (scoresWithYourRow |> List.take size) yourRow
            in
            rows

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
        [ class "topScoreRow", class "centered" ]
        [ text (String.fromInt (rank + 1)) ]
    , div
        [ class "topScoreRow" ]
        [ text score.player ]
    , div
        [ class "topScoreRow" ]
        [ text (TimeFormatter.winingTime score.score) ]
    ]


yourScoreRow : (String -> Html.Attribute Msg) -> ( Int, Score ) -> List (Html Msg)
yourScoreRow class ( rank, score ) =
    [ div
        [ class "topScoreRow", class "centered" ]
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
        [ class "topScoreRow" ]
        [ text (TimeFormatter.winingTime score.score) ]
    ]
