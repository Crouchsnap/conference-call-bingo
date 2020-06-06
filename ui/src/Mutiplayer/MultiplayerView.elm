module Mutiplayer.MultiplayerView exposing (view)

import Html exposing (Html, button, div, input, label, text)
import Html.Attributes exposing (disabled, for, maxlength, minlength, name, placeholder, style, title, value)
import Html.Events exposing (onClick, onInput)
import Msg exposing (Msg(..))
import Mutiplayer.Multiplayer exposing (MultiplayerScore, StartMultiplayerResponseBody)
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
    case startMultiplayerResponseBody of
        NotAsked ->
            startMultiplayerGame class score

        Loading ->
            div [] [ text "Starting Game..." ]

        Success response ->
            showScores class url response score multiplayerScores

        _ ->
            tryAgainView class score


tryAgainView class score =
    div [] [ text "Try again?" ]


showScores class url response score multiplayerScores =
    div []
        ([ div [] [ div [] [ text "Link to share" ], div [] [ text (Url.toString url ++ "?id=" ++ response.id) ] ]
         , div [] [ div [] [ text "Player" ], div [] [ text "Squares in a Row" ] ]
         ]
            ++ (multiplayerScores |> List.map scoreRow)
        )


scoreRow : MultiplayerScore -> Html Msg
scoreRow multiplayerScore =
    div []
        [ div [] [ text multiplayerScore.initials ]
        , div [] [ text (String.fromInt multiplayerScore.score) ]
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
