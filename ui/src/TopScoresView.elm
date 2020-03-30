module TopScoresView exposing (newGameButton, scoreRow, topScoreView)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import List.Extra
import Msg exposing (Msg(..))
import RemoteData exposing (WebData)
import Score exposing (Score)
import Style exposing (..)
import Time exposing (Posix)
import TimeFormatter


topScoreView : { model | highScores : WebData (List Score), startTime : Posix, endTime : Posix } -> Html Msg
topScoreView { highScores, startTime, endTime } =
    div topScoreContainerStyle
        [ div
            topScoreTableStyle
            ([ div
                topScoreHeaderStyle
                [ text "High Scores" ]
             , div
                topScoreColumnHeaderStyle
                [ text "Rank" ]
             , div
                topScoreColumnHeaderStyle
                [ text "Player" ]
             , div
                topScoreColumnHeaderStyle
                [ text "Time" ]
             ]
                ++ (case highScores of
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
                                    if (yourScoreTupe |> Tuple.first) > 9 then
                                        [ yourScoreTupe ]

                                    else
                                        []

                                rows =
                                    List.append (scoresWithYourRow |> List.take 10) yourRow
                                        |> List.map (scoreRow yourScore)
                                        |> List.concat
                            in
                            rows

                        _ ->
                            []
                   )
            )
        , newGameButton
        ]


newGameButton =
    button (newButtonStyle ++ [ onClick NewGame ]) [ text "Play Again" ]


scoreRow : Score -> ( Int, Score ) -> List (Html Msg)
scoreRow yourScore ( rank, score ) =
    let
        calculatedFormat =
            if score == yourScore then
                yourScoreRowStyle

            else
                scoreRowStyle
    in
    [ div
        calculatedFormat
        [ text (String.fromInt (rank + 1)) ]
    , div
        calculatedFormat
        [ text score.player ]
    , div
        calculatedFormat
        [ text (TimeFormatter.winingTime score.score) ]
    ]
