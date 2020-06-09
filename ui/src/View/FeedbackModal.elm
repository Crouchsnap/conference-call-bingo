module View.FeedbackModal exposing (view)

import Bootstrap.Modal as Modal
import Html exposing (button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import View.FeedbackView as FeedbackView


view model show =
    Modal.config NewGame
        |> Modal.attrs [ model.class "modal-container" ]
        |> Modal.body [ style "min-width" "32rem" ]
            [ button [ model.class "close", onClick (FeedbackModal False) ] [ text "×" ]
            , div
                [ model.class "modal-content" ]
                [ FeedbackView.view model ]
            ]
        |> Modal.view
            (if show then
                Modal.shown

             else
                Modal.hidden
            )
