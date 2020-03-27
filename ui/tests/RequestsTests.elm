module RequestsTests exposing (suite, url)

import Expect exposing (Expectation)
import Json.Decode exposing (decodeString)
import Requests exposing (getHostFromLocation)
import Score exposing (decodeGameResult, decodeScore, decodeScores, encodeGameResult, encodeScore)
import Test exposing (..)
import Url exposing (Protocol(..), Url)


suite : Test
suite =
    describe "Requests"
        [ test "should be localhost" <|
            \_ ->
                getHostFromLocation
                    (url Http "localhost" (Just 8000))
                    |> Expect.equal "http://localhost:8080"
        , test "should be prod" <|
            \_ ->
                getHostFromLocation
                    (url Https "bingo-api.apps.pd01.useast.cf.ford.com" Nothing)
                    |> Expect.equal ""
        ]


url protocol host port_ =
    { protocol = protocol
    , host = host
    , port_ = port_
    , path = ""
    , query = Nothing
    , fragment = Nothing
    }
