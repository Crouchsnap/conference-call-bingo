module View.FeedbackModal exposing (view)

import Bootstrap.Modal as Modal
import Html exposing (button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Multiplayer.Join as Join
import Win.FeedBackView as FeedBackView


view model show =
    Modal.config NewGame
        |> Modal.attrs [ model.class "modal-container" ]
        |> Modal.body [ style "min-width" "32rem" ]
            [ button [ model.class "close", onClick (FeedbackModal False) ] [ text "×" ]
            , div
                [ style "align-items" "center"
                , style "display" "flex"
                , style "flex-direction" "column"
                ]
                [ FeedBackView.view model ]
            ]
        |> Modal.view
            (if show then
                Modal.shown

             else
                Modal.hidden
            )
