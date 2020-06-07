module Mutiplayer.JoinModal exposing (view)

import Bootstrap.Modal as Modal
import Html exposing (Html)
import Msg exposing (Msg(..))
import Mutiplayer.Join as Join
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
        , modalVisibility : Modal.Visibility
        , userSettings : UserSettings
    }
    -> Bool
    -> Html Msg
view model show =
    Modal.config NewGame
        |> Modal.attrs [ model.class "modal-container" ]
        |> Modal.body []
            [ Join.view model
            ]
        |> Modal.view
            (if show then
                Modal.shown

             else
                Modal.hidden
            )
