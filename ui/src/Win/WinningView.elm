module Win.WinningView exposing (winningScoreHeader, winningView)

import Assets.Star as Star
import Html exposing (Html, div, text)
import Html.Attributes exposing (id, style)
import Msg exposing (Msg)
import Rating
import RemoteData exposing (WebData)
import Time exposing (Posix)
import Win.GameResultForm as GameResultForm
import Win.Score exposing (GameResult, Score)
import Win.TopScoresView as TopScoresView


winningView :
    { model
        | class : String -> Html.Attribute Msg
        , startTime : Posix
        , endTime : Posix
        , highScores : WebData (List Score)
        , formData : GameResult
        , ratingState : Rating.State
        , submittedScoreResponse : WebData ()
    }
    -> Html Msg
winningView model =
    div [ model.class "winning-container" ]
        (winningScoreHeader model
            ++ [ div
                    [ id "table" ]
                    [ TopScoresView.topScoreView model
                    , GameResultForm.submitGame model
                    ]
               ]
        )


winningScoreHeader : { model | class : String -> Html.Attribute Msg, startTime : Posix, endTime : Posix } -> List (Html Msg)
winningScoreHeader { startTime, endTime, class } =
    [ div
        [ class "winning-header" ]
        [ div [ class "winning-header-emoji" ] [ text "🎉" ]
        , div [ style "z-index" "10" ]
            [ text "Bingo!"
            , div [ class "winning-star" ]
                [ Star.view "160" ]
            ]
        , div [ class "winning-header-emoji" ] [ text "🎉" ]
        ]
    ]
