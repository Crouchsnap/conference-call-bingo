module Multiplayer.Join exposing (view)

import Html exposing (Html, button, div, input, label, text)
import Html.Attributes exposing (disabled, for, maxlength, minlength, name, placeholder, style, title, value)
import Html.Events exposing (onClick, onInput)
import Msg exposing (Msg(..))


view model =
    let
        length =
            String.length model.score.player
    in
    div [ model.class "", style "margin" "1rem" ]
        [ div [] [ text "Join the Game!" ]
        , label [ for "initials" ] [ text "Enter your initials to start" ]
        , input
            [ name "initials"
            , model.class "multiplayer-input"
            , title "Enter 2 to 4 Characters"
            , placeholder "2 to 4"
            , minlength 2
            , maxlength 4
            , onInput Player
            , value model.score.player
            ]
            []
        , button
            [ model.class "submit-feedback-button"
            , onClick JoinMultiplayerGame
            , disabled (length < 1 || length > 5)
            ]
            [ text "Start Game" ]
        ]
