module Multiplayer.JoinModal exposing (view)

import Bootstrap.Modal as Modal
import Html exposing (button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Multiplayer.Join as Join
import Options.TopicChoices as TopicChoices


view model show =
    Modal.config NewGame
        |> Modal.attrs [ model.class "modal-container" ]
        |> Modal.body [ style "min-width" "32rem" ]
            [ button [ model.class "close", onClick CancelJoinMultiplayerGame ] [ text "×" ]
            , div
                [ style "align-items" "center"
                , style "display" "flex"
                , style "flex-direction" "column"
                ]
                [ TopicChoices.view model (topicTitle model.class) ]
            , Join.view model
            ]
        |> Modal.view
            (if show then
                Modal.shown

             else
                Modal.hidden
            )


topicTitle class =
    div []
        [ div [ class "topic-title", style "margin-bottom" "2rem" ] [ text "Multiplayer game" ]
        , div [ style "margin-bottom" "1rem" ] [ text "Select topics for this game" ]
        ]
