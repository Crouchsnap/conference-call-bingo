module Multiplayer.Join exposing (view)

import Html exposing (Html, button, div, input, label, li, text, ul)
import Html.Attributes exposing (disabled, for, maxlength, minlength, name, placeholder, style, title, value)
import Html.Events exposing (onClick, onInput)
import Msg exposing (Msg(..))


view model =
    div
        [ model.class ""
        , style "margin" "1rem"
        , style "display" "flex"
        , style "flex-direction" "column"
        , style "align-items" "center"
        , style "min-height" "10rem"
        ]
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
        , let
            length =
                String.length model.score.player
          in
          button
            [ model.class "submit-button"
            , onClick JoinMultiplayerGame
            ]
            [ text "Start Game" ]
        ]


viewFormErrors : (String -> Html.Attribute msg) -> List String -> Html msg
viewFormErrors class errors =
    errors
        |> List.map (\error -> div [ class "form-errors" ] [ text error ])
        |> div [ class "form-errors" ]
