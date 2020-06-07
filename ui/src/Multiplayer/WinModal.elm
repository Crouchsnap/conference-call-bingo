module Multiplayer.WinModal exposing (view)

import Bootstrap.Modal as Modal
import Html exposing (Html, button, text)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Multiplayer.Multiplayer exposing (MultiplayerScore, StartMultiplayerResponseBody)
import Multiplayer.WinningView as WinningView
import Rating exposing (State)
import RemoteData exposing (WebData)
import Time exposing (Posix)
import UserSettings exposing (UserSettings)
import Win.Score exposing (Score)


view :
    { a
        | class : String -> Html.Attribute Msg
        , startTime : Posix
        , endTime : Posix
        , highScores : WebData (List Score)
        , score : Score
        , ratingState : State
        , submittedScoreResponse : WebData ()
        , userSettings : UserSettings
        , startMultiplayerResponseBody : WebData StartMultiplayerResponseBody
        , multiplayerScores : List MultiplayerScore
    }
    -> Bool
    -> Html Msg
view model show =
    Modal.config NewGame
        |> Modal.attrs [ model.class "modal-container" ]
        |> Modal.body []
            [ button [ model.class "close", onClick NewGame ] [ text "×" ]
            , WinningView.view model
            ]
        |> Modal.view
            (if show then
                Modal.shown

             else
                Modal.hidden
            )
