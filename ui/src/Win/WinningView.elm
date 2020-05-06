module Win.WinningView exposing (view)

import Assets.WinStar as WinStar
import Html exposing (Html, div, text)
import Msg exposing (Msg)
import Rating
import RemoteData exposing (WebData)
import Time exposing (Posix)
import Win.FeedBackView as FeedbackView
import Win.Score exposing (Score)
import Win.TopScoresTable as TopScoresView


view :
    { model
        | class : String -> Html.Attribute Msg
        , startTime : Posix
        , endTime : Posix
        , highScores : WebData (List Score)
        , score : Score
        , ratingState : Rating.State
        , submittedScoreResponse : WebData ()
    }
    -> Html Msg
view model =
    div [ model.class "winning-container" ]
        ([ header model.class ]
            ++ content model
        )


content model =
    case model.submittedScoreResponse of
        RemoteData.NotAsked ->
            TopScoresView.view model

        _ ->
            FeedbackView.view model


header class =
    div
        [ class "winning-header" ]
        [ div [ class "winning-header-emoji" ] [ text "🎉" ]
        , WinStar.view
        , div [ class "winning-header-emoji" ] [ text "🎉" ]
        ]
