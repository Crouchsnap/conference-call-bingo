module Multiplayer.MultiplayerTests exposing (suite)

import Expect
import Json.Decode
import Json.Encode
import Multiplayer.Multiplayer exposing (buildJoinLink, decodeMultiplayerScores, decodeStartMultiplayerResponseBody, encodeStartMultiplayerBody)
import Test exposing (Test, describe, test)
import Url exposing (Protocol(..))


suite : Test
suite =
    describe "Multiplayer encoder tests"
        [ test "should encode start multiplayer body" <|
            \_ ->
                Json.Encode.encode 0
                    (encodeStartMultiplayerBody "JA" 2)
                    |> Expect.equal """{"initials":"JA","score":2}"""
        , test "should decode to StartMultiplayerResponseBody" <|
            \_ ->
                let
                    input =
                        """{ "id": "gameId", "playerId": "someplayerid"}"""

                    decodedOutput =
                        Json.Decode.decodeString decodeStartMultiplayerResponseBody input
                in
                Expect.equal decodedOutput (Ok { id = "gameId", playerId = "someplayerid" })
        , test "should decode to MultiplayerScore list" <|
            \_ ->
                let
                    input =
                        """
                        [{"playerId":"fb6bae6a-66d7-43f1-a8fb-40ff7d3e73ed","initials":"HH","score":1},{"playerId":"284cb835-44b6-4b5b-bdee-2e31e985b4c6","initials":"jj","score":3}]
                        """

                    decodedOutput =
                        Json.Decode.decodeString
                            decodeMultiplayerScores
                            input
                in
                Expect.equal decodedOutput
                    (Ok
                        [ { playerId = "fb6bae6a-66d7-43f1-a8fb-40ff7d3e73ed"
                          , initials = "HH"
                          , score = 1
                          }
                        , { playerId = "284cb835-44b6-4b5b-bdee-2e31e985b4c6"
                          , initials = "jj"
                          , score = 3
                          }
                        ]
                    )
        , test "add the game id to url fragment" <|
            \_ ->
                buildJoinLink
                    localUrlWithPath
                    "1234567"
                    |> Expect.equal
                        "http://localhost:8000/beta#1234567"
        , test "add the game id to url path without a double slash" <|
            \_ ->
                buildJoinLink
                    localUrlWithoutPath
                    "1234567"
                    |> Expect.equal
                        "http://localhost:8000/#1234567"
        , test "add the game id to url path without a double slash with a query" <|
            \_ ->
                buildJoinLink
                    httpsUrlWithPathEndsInSlash
                    "1234567"
                    |> Expect.equal
                        "https://bingo.ford.com/beta/?q=t&a=b#1234567"
        ]


localUrlWithPath =
    { fragment = Nothing
    , host = "localhost"
    , path = "/beta"
    , port_ = Just 8000
    , protocol = Http
    , query = Nothing
    }


httpsUrlWithPathEndsInSlash =
    { fragment = Nothing
    , host = "bingo.ford.com"
    , path = "/beta/"
    , port_ = Nothing
    , protocol = Https
    , query = Just "q=t&a=b"
    }


localUrlWithoutPath =
    { fragment = Nothing
    , host = "localhost"
    , path = "/"
    , port_ = Just 8000
    , protocol = Http
    , query = Nothing
    }
