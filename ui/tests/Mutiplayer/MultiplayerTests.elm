module Mutiplayer.MultiplayerTests exposing (..)

import Expect
import Json.Decode
import Json.Encode
import Mutiplayer.Multiplayer exposing (decodeStartMultiplayerResponseBody, encodeStartMultiplayerBody)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Multiplayer encoder tests"
        [ test "should encode start multiplayer body" <|
            \_ ->
                Json.Encode.encode 0
                    (encodeStartMultiplayerBody
                        "JA"
                    )
                    |> Expect.equal
                        """{"initials":"JA"}"""
        , test "UserSettings decodes to Light" <|
            \_ ->
                let
                    input =
                        """
                        { "id": "light"
                        , "playerId": "someplayerid"
                        }
                        """

                    decodedOutput =
                        Json.Decode.decodeString
                            decodeStartMultiplayerResponseBody
                            input
                in
                Expect.equal decodedOutput
                    (Ok
                        { id = "light"
                        , playerId = "someplayerid"
                        }
                    )
        ]
