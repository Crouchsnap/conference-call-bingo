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
                [ model.class "modal-content" ]
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
        [ div [ class "topic-title mb-3" ] [ text "Multiplayer game" ]
        , div [ class "mb-3" ] [ text "Select topics for this game" ]
        ]
