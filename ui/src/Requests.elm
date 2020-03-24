module Requests exposing (getHighScores, submitScore)

import Http exposing (expectJson, expectWhatever)
import RemoteData exposing (RemoteData, WebData)
import Score exposing (GameResult, Score, decodeScores, encodeGameResult)
import Url exposing (Url)


getHighScores url msgConstructor =
    Http.get
        { url = getHostFromLocation url ++ "/scores"
        , expect = expectJson (RemoteData.fromResult >> msgConstructor) decodeScores
        }


submitScore url msgConstructor gameResult =
    Http.post
        { url = getHostFromLocation url ++ "/scores"
        , body = Http.jsonBody (encodeGameResult gameResult)
        , expect = expectWhatever (RemoteData.fromResult >> msgConstructor)
        }


getHostFromLocation : Url -> String
getHostFromLocation url =
    if isLocalhost url then
        "http://localhost:8080"

    else
        "https://bingo-api.apps.pd01.useast.cf.ford.com"


isLocalhost : Url -> Bool
isLocalhost { host } =
    String.contains "localhost:" host
