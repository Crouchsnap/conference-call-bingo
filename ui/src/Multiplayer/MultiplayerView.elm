module Multiplayer.MultiplayerView exposing (view)

import Assets.CopyIcon as CopyIcon
import Html exposing (Html, button, div, input, label, text)
import Html.Attributes exposing (for, id, maxlength, minlength, name, placeholder, style, title, value)
import Html.Events exposing (onClick, onInput)
import Msg exposing (Msg(..))
import Multiplayer.Multiplayer exposing (MultiplayerScore, StartMultiplayerResponseBody, buildJoinLink)
import RemoteData exposing (RemoteData(..), WebData)


view { class, score, errors, startMultiplayerResponseBody, multiplayerScores, url } =
    div [ style "margin-bottom" "2rem" ]
        [ div [ class "topic-title" ] [ text "Multiplayer Game" ]
        , case startMultiplayerResponseBody of
            NotAsked ->
                startMultiplayerGame class score errors

            Loading ->
                div [] [ text "Starting Game..." ]

            Success response ->
                showScores class url response (multiplayerScores |> List.filter (\s -> s.playerId /= response.playerId))

            _ ->
                tryAgainView class score
        ]


tryAgainView class score =
    div [] [ text "Try again?" ]


showScores class url response multiplayerScores =
    div []
        ([ div [ style "display" "flex", style "justify-content" "space-between" ]
            [ div [ style "font-weight" "bold" ] [ text "Share URL:" ]
            , button
                [ style "color" "#ED9E28"
                , style "border" "none"
                , style "display" "flex"
                , style "padding" "0"
                , style "align-items" "center"
                , style "background" "transparent"
                , onClick (Copy "linkToShare")
                ]
                [ CopyIcon.view, div [ style "padding" "0 0 .1rem .3rem" ] [ text "Copy" ] ]
            ]
         , div
            [ id "linkToShare"
            , style "max-width" "12rem"
            , style "text-overflow" "scroll"
            , style "overflow" "scroll"
            , style "margin-top" ".5rem"
            ]
            [ text (buildJoinLink url response.id) ]
         ]
            ++ (if multiplayerScores |> List.isEmpty then
                    [ div [ style "margin-top" ".5rem", style "font-weight" "bold" ] [ text "Waiting for others to join" ] ]

                else
                    [ div
                        [ style "display" "grid"
                        , style "margin-top" ".5rem"
                        , style "grid-template-columns" "30% auto"
                        , style "text-align" "center"
                        ]
                        ([ div [ style "font-weight" "bold" ] [ text "Player" ], div [ style "font-weight" "bold" ] [ text "Squares in a Row" ] ]
                            ++ (multiplayerScores |> List.map scoreRow |> List.concat)
                        )
                    ]
               )
        )


scoreRow multiplayerScore =
    [ div [ style "margin" ".3rem" ] [ text multiplayerScore.initials ]
    , div [ style "margin" ".3rem" ] [ text (String.fromInt multiplayerScore.score) ]
    ]


startMultiplayerGame class score errors =
    div
        [ class ""
        , style "margin" "1rem 0"

        --, style "margin" "1rem"
        , style "display" "flex"
        , style "flex-direction" "column"

        --, style "align-items" "center"
        , style "min-height" "10rem"
        ]
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
            [ class "submit-feedback-button"
            , onClick StartMultiplayerGame
            ]
            [ text "Start Game" ]
        ]


viewFormErrors : (String -> Html.Attribute msg) -> List String -> Html msg
viewFormErrors class errors =
    errors
        |> List.map (\error -> div [ class "form-errors" ] [ text error ])
        |> div [ class "form-errors" ]
