module Requests exposing (errorToString, getHighScores, getHostFromLocation, submitScore)

import Http exposing (Error(..), expectJson, expectWhatever)
import Msg exposing (Msg(..))
import RemoteData exposing (RemoteData, WebData)
import Score exposing (GameResult, Score, decodeScores, encodeGameResult)
import Url exposing (Url)


getHighScores : Url -> Cmd Msg
getHighScores url =
    Http.get
        { url = getHostFromLocation url ++ "/api/scores"
        , expect = expectJson (RemoteData.fromResult >> HighScoresResponse) decodeScores
        }


submitScore : Url -> GameResult -> Cmd Msg
submitScore url gameResult =
    Http.post
        { url = getHostFromLocation url ++ "/api/scores"
        , body = Http.jsonBody (encodeGameResult gameResult)
        , expect = expectWhatever (RemoteData.fromResult >> GameResponse)
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
