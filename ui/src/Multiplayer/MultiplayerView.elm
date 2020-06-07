module Multiplayer.MultiplayerView exposing (view)

import Html exposing (Html, button, div, input, label, text)
import Html.Attributes exposing (disabled, for, id, maxlength, minlength, name, placeholder, style, title, value)
import Html.Events exposing (onClick, onInput)
import Msg exposing (Msg(..))
import Multiplayer.Multiplayer exposing (MultiplayerScore, StartMultiplayerResponseBody, buildJoinLink)
import RemoteData exposing (RemoteData(..), WebData)
import Url exposing (Url)
import Win.Score exposing (Score)


view :
    { model
        | class : String -> Html.Attribute Msg
        , score : Score
        , startMultiplayerResponseBody : WebData StartMultiplayerResponseBody
        , multiplayerScores : List MultiplayerScore
        , url : Url
    }
    -> Html Msg
view { class, score, startMultiplayerResponseBody, multiplayerScores, url } =
    div [ style "margin-bottom" "2rem" ]
        [ div [ class "topic-title" ] [ text "Multiplayer" ]
        , case startMultiplayerResponseBody of
            NotAsked ->
                startMultiplayerGame class score

            Loading ->
                div [] [ text "Starting Game..." ]

            Success response ->
                showScores class url response score (multiplayerScores |> List.filter (\s -> s.playerId /= response.playerId))

            _ ->
                tryAgainView class score
        ]


tryAgainView class score =
    div [] [ text "Try again?" ]


showScores class url response score multiplayerScores =
    div []
        ([ div [ style "display" "flex" ]
            [ div [] [ text "Share:" ]
            , div
                [ id "linkToShare"
                , style "max-width" "12rem"
                , style "text-overflow" "scroll"
                , style "overflow" "scroll"
                , style "margin-left" ".5rem"
                ]
                [ text (buildJoinLink url response.id) ]
            ]
         , button [ class "submit-feedback-button", onClick (Copy "linkToShare") ] [ text "Copy Shareable Link" ]
         ]
            ++ (if multiplayerScores |> List.isEmpty then
                    [ div [ style "margin-top" ".5rem" ] [ text "Waiting for others to join" ] ]

                else
                    [ div
                        [ style "display" "grid"
                        , style "margin-top" ".5rem"
                        , style "grid-template-columns" "30% auto"
                        , style "font-weight" "bold"
                        ]
                        [ div [] [ text "Player" ], div [] [ text "Squares in a Row" ] ]
                    ]
                        ++ (multiplayerScores |> List.map scoreRow)
               )
        )


scoreRow : MultiplayerScore -> Html Msg
scoreRow multiplayerScore =
    div [ style "display" "grid", style "grid-template-columns" "30% auto" ]
        [ div [ style "margin-left" ".3rem" ] [ text multiplayerScore.initials ]
        , div [ style "margin-left" ".3rem" ] [ text (String.fromInt multiplayerScore.score) ]
        ]


startMultiplayerGame class score =
    let
        length =
            String.length score.player
    in
    div [ class "", style "margin" "1rem" ]
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
        , button
            [ class "submit-feedback-button"
            , onClick StartMultiplayerGame
            , disabled (length < 1 || length > 5)
            ]
            [ text "Start Game" ]
        ]
