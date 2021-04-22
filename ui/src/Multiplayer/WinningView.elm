module Multiplayer.WinningView exposing (view)

import Assets.WinStar as WinStar
import Html exposing (Html, div, text)
import Msg exposing (Msg)
import Multiplayer.Multiplayer exposing (MultiplayerScore, StartMultiplayerResponseBody)
import Multiplayer.ScoresTable as ScoresTable
import Rating
import RemoteData exposing (WebData)
import Time exposing (Posix)
import Win.Score exposing (Score)


view :
    { model
        | class : String -> Html.Attribute Msg
        , startTime : Posix
        , highScores : WebData (List Score)
        , score : Score
        , ratingState : Rating.State
        , submittedScoreResponse : WebData ()
        , multiplayerScores : List MultiplayerScore
        , startMultiplayerResponseBody : WebData StartMultiplayerResponseBody
    }
    -> Html Msg
view model =
    div [ model.class "winning-container" ]
        ([ header model.class ]
            ++ content model
        )


content model =
    ScoresTable.view model


header class =
    div
        [ class "winning-header" ]
        [ div [ class "winning-header-emoji" ] [ text "🎉" ]
        , WinStar.view
        , div [ class "winning-header-emoji" ] [ text "🎉" ]
        ]
