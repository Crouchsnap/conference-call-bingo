module Multiplayer.Join exposing (view)

import Html exposing (Html, button, div, input, label, text)
import Html.Attributes exposing (for, maxlength, minlength, name, placeholder, title, value)
import Html.Events exposing (onClick, onInput)
import Msg exposing (Msg(..))


view model msg =
    div
        [ model.class "multiplayer-start-container centered" ]
        [ label [ for "initials" ] [ text "Enter your initials to start" ]
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
        , viewFormErrors model.class model.errors
        , button
            [ model.class "submit-button"
            , onClick msg
            ]
            [ text "Start Game" ]
        ]


viewFormErrors : (String -> Html.Attribute msg) -> List String -> Html msg
viewFormErrors class errors =
    errors
        |> List.map (\error -> div [ class "form-errors" ] [ text error ])
        |> div [ class "form-errors" ]
