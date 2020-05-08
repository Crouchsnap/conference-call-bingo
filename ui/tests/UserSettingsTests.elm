module UserSettingsTests exposing (suite)

import Expect exposing (Expectation)
import Game.Dot exposing (Color(..))
import Game.Topic exposing (Topic(..))
import Json.Decode exposing (Decoder)
import Options.BoardStyle exposing (Color(..))
import Options.Theme exposing (Theme(..))
import Test exposing (..)
import UserSettings exposing (decodeUserSettings, encodeUserSettings)


suite : Test
suite =
    describe "UserSettings Tests"
        [ test "UserSettings decodes to Light" <|
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
                            (decodeUserSettings Dark)
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
        , test "UserSettings decodes to default theme if missing" <|
            \() ->
                let
                    input =
                        """
                        {}
                        """

                    decodedOutput =
                        Json.Decode.decodeString
                            (decodeUserSettings Dark)
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
        , test "should encode UserSettings" <|
            \_ ->
                Json.Decode.decodeValue
                    (decodeUserSettings Dark)
                    (encodeUserSettings
                        { selectedTheme = Light
                        , topics = [ Fordism, Coronavirus, Kanye, ITFCG ]
                        , dauberColor = Keylime
                        , boardColor = GoofyGreen
                        }
                    )
                    |> Expect.equal
                        (Ok
                            { selectedTheme = Light
                            , topics = [ Fordism, Coronavirus, Kanye, ITFCG ]
                            , dauberColor = Keylime
                            , boardColor = GoofyGreen
                            }
                        )
        ]
