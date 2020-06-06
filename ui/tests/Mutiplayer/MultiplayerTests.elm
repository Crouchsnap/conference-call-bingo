module Mutiplayer.MultiplayerTests exposing (suite)

import Expect
import Json.Decode
import Json.Encode
import Mutiplayer.Multiplayer exposing (decodeMultiplayerScores, decodeStartMultiplayerResponseBody, encodeStartMultiplayerBody)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Multiplayer encoder tests"
        [ test "should encode start multiplayer body" <|
            \_ ->
                Json.Encode.encode 0
                    (encodeStartMultiplayerBody "JA")
                    |> Expect.equal """{"initials":"JA"}"""
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
                        [{"playerId":"daff9d11-e5d5-4f5c-88df-5324d6e57181","initials":"GG","score":1}]
                        """

                    decodedOutput =
                        Json.Decode.decodeString
                            decodeMultiplayerScores
                            input
                in
                Expect.equal decodedOutput
                    (Ok
                        [ { playerId = "daff9d11-e5d5-4f5c-88df-5324d6e57181"
                          , initials = "GG"
                          , score = 1
                          }
                        ]
                    )
        ]
