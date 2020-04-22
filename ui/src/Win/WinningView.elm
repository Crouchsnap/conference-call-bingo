module Win.WinningView exposing (view)

import Assets.Star as Star
import Html exposing (Html, div, text)
import Msg exposing (Msg)
import Rating
import RemoteData exposing (WebData)
import Time exposing (Posix)
import Win.FeedBack as Feedback
import Win.Score exposing (GameResult, Score)
import Win.TopScoresTable as TopScoresView


view :
    { model
        | class : String -> Html.Attribute Msg
        , startTime : Posix
        , endTime : Posix
        , highScores : WebData (List Score)
        , gameResult : GameResult
        , ratingState : Rating.State
        , submittedScoreResponse : WebData ()
    }
    -> Html Msg
view model =
    div [ model.class "board-content winning-container" ]
        [ header model.class
        , content model
        ]


content model =
    div []
        [ TopScoresView.view model
        , Feedback.view model
        ]


header class =
    div
        [ class "winning-header" ]
        [ div [ class "winning-header-emoji" ] [ text "🎉" ]
        , div []
            [ text "Bingo!"
            , div [ class "winning-star" ]
                [ Star.view "160" ]
            ]
        , div [ class "winning-header-emoji" ] [ text "🎉" ]
        ]
