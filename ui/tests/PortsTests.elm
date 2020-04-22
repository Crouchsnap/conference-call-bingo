module PortsTests exposing (suite)

import Expect exposing (Expectation)
import Json.Decode exposing (Decoder)
import Options.Theme exposing (Theme(..))
import Ports exposing (decodeState, decodeStateValue, encodeState)
import Test exposing (..)


suite : Test
suite =
    describe "State Tests"
        [ test "State decodes to Light" <|
            \() ->
                let
                    input =
                        """
                        { "selectedTheme" : "light" }
                        """

                    decodedOutput =
                        Json.Decode.decodeString
                            (decodeState Dark)
                            input
                in
                Expect.equal decodedOutput
                    (Ok { selectedTheme = Light })
        , test "State decodes to default theme if missing" <|
            \() ->
                let
                    input =
                        """
                        {}
                        """

                    decodedOutput =
                        Json.Decode.decodeString
                            (decodeState Dark)
                            input
                in
                Expect.equal decodedOutput
                    (Ok { selectedTheme = Dark })
        , test "should encode state" <|
            \_ ->
                Json.Decode.decodeValue
                    (decodeState Dark)
                    (encodeState { selectedTheme = Light })
                    |> Expect.equal (Ok { selectedTheme = Light })
        ]
