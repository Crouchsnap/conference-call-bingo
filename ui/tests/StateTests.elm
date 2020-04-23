module StateTests exposing (suite)

import Expect exposing (Expectation)
import Game.Dot exposing (Color(..))
import Game.Square exposing (Topic(..))
import Json.Decode exposing (Decoder)
import Options.BoardStyle exposing (Color(..))
import Options.Theme exposing (Theme(..))
import State exposing (decodeState, encodeState)
import Test exposing (..)


suite : Test
suite =
    describe "State Tests"
        [ test "State decodes to Light" <|
            \() ->
                let
                    input =
                        """
                        { "selectedTheme": "light"
                            , "topics": [ "fordism", "coronavirus" ]
                            , "dauberColor": "keylime"
                            , "boardColor": "goofy-green" }
                        """

                    decodedOutput =
                        Json.Decode.decodeString
                            (decodeState Dark)
                            input
                in
                Expect.equal decodedOutput
                    (Ok
                        { selectedTheme = Light
                        , topics = [ Fordism, Coronavirus ]
                        , dauberColor = Keylime
                        , boardColor = GoofyGreen
                        }
                    )
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
                    (Ok
                        { selectedTheme = Dark
                        , topics = []
                        , dauberColor = Blue
                        , boardColor = OriginalRed
                        }
                    )
        , test "should encode state" <|
            \_ ->
                Json.Decode.decodeValue
                    (decodeState Dark)
                    (encodeState
                        { selectedTheme = Light
                        , topics = [ Fordism, Coronavirus ]
                        , dauberColor = Keylime
                        , boardColor = GoofyGreen
                        }
                    )
                    |> Expect.equal
                        (Ok
                            { selectedTheme = Light
                            , topics = [ Fordism, Coronavirus ]
                            , dauberColor = Keylime
                            , boardColor = GoofyGreen
                            }
                        )
        ]
