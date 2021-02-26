module Requests exposing (getHighScores, getHostFromLocation, submitFeedback, submitScore)

import Http exposing (Error(..), expectJson, expectWhatever)
import Msg exposing (Msg(..))
import RemoteData exposing (RemoteData, WebData)
import Url exposing (Url)
import View.Feedback exposing (Feedback, encodeFeedback)
import Win.Score exposing (Score, decodeScores, encodeScore)


getHighScores : Url -> Cmd Msg
getHighScores url =
    Http.get
        { url = getHostFromLocation url ++ "/api/scores"
        , expect = expectJson (RemoteData.fromResult >> HighScoresResponse) decodeScores
        }


submitScore : Url -> Score -> Cmd Msg
submitScore url score =
    Http.post
        { url = getHostFromLocation url ++ "/api/scores"
        , body = Http.jsonBody (encodeScore score)
        , expect = expectWhatever (RemoteData.fromResult >> GameResponse)
        }


submitFeedback : Url -> Feedback -> Cmd Msg
submitFeedback url feedback =
    Http.post
        { url = getHostFromLocation url ++ "/api/feedback"
        , body = Http.jsonBody (encodeFeedback feedback)
        , expect = expectWhatever (RemoteData.fromResult >> FeedbackResponse)
        }


getHostFromLocation : Url -> String
getHostFromLocation url =
    if isLocalhost url then
        "http://localhost:8080"

    else
        ""


isLocalhost : Url -> Bool
isLocalhost { host } =
    String.contains "localhost" host
