module Requests exposing (errorToString, getHighScores, getHostFromLocation, joinMultiplayerGame, sendMultiplayerScore, startMultiplayerGame, submitFeedback, submitScore)

import Http exposing (Error(..), expectJson, expectWhatever)
import Msg exposing (Msg(..))
import Multiplayer.Multiplayer exposing (GameUpdate, StartMultiplayerResponseBody, decodeStartMultiplayerResponseBody, encodeStartMultiplayerBody, gameUpdateToString)
import RemoteData exposing (RemoteData, WebData)
import Url exposing (Url)
import Win.Feedback exposing (Feedback, encodeFeedback)
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


sendMultiplayerScore : Url -> GameUpdate -> StartMultiplayerResponseBody -> Cmd Msg
sendMultiplayerScore url gameUpdate startMultiplayerResponseBody =
    Http.post
        { url =
            getHostFromLocation url
                ++ "/api/multiplayer/"
                ++ (gameUpdate |> gameUpdateToString)
                ++ "/"
                ++ startMultiplayerResponseBody.id
                ++ "/"
                ++ startMultiplayerResponseBody.playerId
        , body = Http.emptyBody
        , expect = expectWhatever (RemoteData.fromResult >> MultiplayerScoreUpdated)
        }


startMultiplayerGame : Url -> String -> Int -> Cmd Msg
startMultiplayerGame url initials score =
    Http.post
        { url = getHostFromLocation url ++ "/api/multiplayer/start"
        , body = Http.jsonBody (encodeStartMultiplayerBody initials score)
        , expect = expectJson (RemoteData.fromResult >> MultiplayerStartResponse) decodeStartMultiplayerResponseBody
        }


joinMultiplayerGame : Url -> String -> String -> Int -> Cmd Msg
joinMultiplayerGame url gameId initials score =
    Http.post
        { url = getHostFromLocation url ++ "/api/multiplayer/join/" ++ gameId
        , body = Http.jsonBody (encodeStartMultiplayerBody initials score)
        , expect = expectJson (RemoteData.fromResult >> MultiplayerStartResponse) decodeStartMultiplayerResponseBody
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


errorToString : Http.Error -> String
errorToString err =
    case err of
        Timeout ->
            "Timeout exceeded"

        NetworkError ->
            "Network error"

        BadStatus code ->
            "Status: " ++ String.fromInt code

        BadBody message ->
            "BadBody: " ++ message

        BadUrl url ->
            "Malformed url: " ++ url
