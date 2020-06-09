module Multiplayer.MultiplayerView exposing (view)

import Assets.CopyIcon as CopyIcon
import Html exposing (Html, button, div, input, label, text)
import Html.Attributes exposing (for, id, maxlength, minlength, name, placeholder, title, value)
import Html.Events exposing (onClick, onInput)
import Msg exposing (Msg(..))
import Multiplayer.Multiplayer exposing (MultiplayerScore, StartMultiplayerResponseBody, buildJoinLink)
import RemoteData exposing (RemoteData(..), WebData)


view { class, score, errors, startMultiplayerResponseBody, multiplayerScores, url } =
    div [ class "multiplayer-container" ]
        ([ div [ class "topic-title" ] [ text "Multiplayer Game" ] ]
            ++ (case startMultiplayerResponseBody of
                    NotAsked ->
                        [ startMultiplayerGame class score errors ]

                    Loading ->
                        [ div [] [ text "Starting Game..." ] ]

                    Success response ->
                        showScores class url response (multiplayerScores |> List.filter (\s -> s.playerId /= response.playerId))

                    _ ->
                        [ tryAgainView class score ]
               )
        )


tryAgainView class score =
    div [] [ text "Try again?" ]


showScores class url response multiplayerScores =
    [ div [ class "multiplayer-game" ]
        [ div [ class "bold" ] [ text "Share URL:" ]
        , button
            [ class "copy-button", onClick (Copy "linkToShare") ]
            [ CopyIcon.view, div [] [ text "Copy" ] ]
        ]
    , div
        [ id "linkToShare", class "mt-2" ]
        [ text (buildJoinLink url response.id) ]
    ]
        ++ (if multiplayerScores |> List.isEmpty then
                [ div [ class "mt-2 bold" ] [ text "Waiting for others to join" ] ]

            else
                [ div
                    [ class "multiplayer-score-table"
                    ]
                    ([ div [ class "bold" ] [ text "Player" ], div [ class "bold" ] [ text "Squares in a Row" ] ]
                        ++ (multiplayerScores |> List.map (scoreRow class) |> List.concat)
                    )
                ]
           )
        ++ [ button [ class "text-button", onClick LeaveMultiplayerGame ] [ text "Leave Multiplayer Game" ]
           ]


scoreRow class multiplayerScore =
    [ div [ class "multiplayer-score-table-cell" ] [ text multiplayerScore.initials ]
    , div [ class "multiplayer-score-table-cell" ] [ text (String.fromInt multiplayerScore.score) ]
    ]


startMultiplayerGame class score errors =
    div
        [ class "multiplayer-start-container" ]
        [ label [ for "initials" ] [ text "Enter your initials to start" ]
        , input
            [ name "initials"
            , class "multiplayer-input"
            , title "Enter 2 to 4 Characters"
            , placeholder "2 to 4"
            , minlength 2
            , maxlength 4
            , onInput Player
            , value score.player
            ]
            []
        , viewFormErrors class errors
        , button
            [ class "submit-button-secondary", onClick StartMultiplayerGame ]
            [ text "Start Game" ]
        ]


viewFormErrors : (String -> Html.Attribute msg) -> List String -> Html msg
viewFormErrors class errors =
    errors
        |> List.map (\error -> div [ class "form-errors" ] [ text error ])
        |> div [ class "form-errors" ]
