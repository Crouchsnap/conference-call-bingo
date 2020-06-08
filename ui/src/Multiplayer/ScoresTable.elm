module Multiplayer.ScoresTable exposing (view)

import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Multiplayer.Multiplayer exposing (MultiplayerScore, StartMultiplayerResponseBody)
import RemoteData exposing (WebData)


view :
    { model
        | class : String -> Html.Attribute Msg
        , multiplayerScores : List MultiplayerScore
        , startMultiplayerResponseBody : WebData StartMultiplayerResponseBody
    }
    -> List (Html Msg)
view { class, multiplayerScores, startMultiplayerResponseBody } =
    let
        receivedWinningScores =
            multiplayerScores |> List.any (\score -> score.score > 4)
    in
    if receivedWinningScores then
        [ div
            [ class "top-score-title" ]
            [ text "High Scores" ]
        , div [ class "top-score-table" ]
            ([ div [] [ text "Rank" ]
             , div [] [ text "Player Initials" ]
             , div [] [ text "Squares in a Row" ]
             ]
                ++ scoreRows class startMultiplayerResponseBody multiplayerScores
            )
        , submitButton class
        ]

    else
        [ div [] [ text "Calculating" ] ]


scoreRows class startMultiplayerResponseBody multiplayerScores =
    multiplayerScores
        |> List.sortBy (\score -> score.score)
        |> List.reverse
        |> List.indexedMap Tuple.pair
        |> List.map (scoreRow class startMultiplayerResponseBody)
        |> List.concat


scoreRow : (String -> Html.Attribute Msg) -> WebData StartMultiplayerResponseBody -> ( Int, MultiplayerScore ) -> List (Html Msg)
scoreRow class startMultiplayerResponseBody ( rank, score ) =
    if score |> isYourScore startMultiplayerResponseBody then
        yourScoreRow class ( rank, score )

    else
        regularScoreRow class ( rank, score )


isYourScore : WebData StartMultiplayerResponseBody -> MultiplayerScore -> Bool
isYourScore startMultiplayerResponseBody score =
    case startMultiplayerResponseBody of
        RemoteData.Success body ->
            body.playerId == score.playerId

        _ ->
            False


regularScoreRow : (String -> Html.Attribute Msg) -> ( Int, MultiplayerScore ) -> List (Html Msg)
regularScoreRow class ( rank, score ) =
    [ div [ class "top-score-row" ] [ text (String.fromInt (rank + 1)) ]
    , div [ class "top-score-row" ] [ text score.initials ]
    , div [ class "top-score-row" ] [ text (String.fromInt score.score) ]
    ]


yourScoreRow : (String -> Html.Attribute Msg) -> ( Int, MultiplayerScore ) -> List (Html Msg)
yourScoreRow class ( rank, score ) =
    [ div
        [ class "top-score-row", style "background" "#ED9E28", style "width" "100%" ]
        [ text (String.fromInt (rank + 1)) ]
    , div
        [ class "top-score-row", style "background" "#ED9E28", style "width" "100%" ]
        [ text score.initials ]
    , div
        [ class "top-score-row", style "background" "#ED9E28", style "width" "100%" ]
        [ text (String.fromInt score.score) ]
    ]


submitButton class =
    button [ class "submit-button", onClick NewGame ] [ text "Play Again!" ]
