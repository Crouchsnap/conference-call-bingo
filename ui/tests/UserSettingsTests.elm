module UserSettingsTests exposing (suite)

import Expect exposing (Expectation)
import Game.Dot exposing (Color(..), Dot)
import Game.Square exposing (Square, buildSquare, iwdSquare)
import Game.Topic exposing (Topic(..))
import Html
import Json.Decode exposing (Decoder)
import Options.BoardStyle exposing (Color(..))
import Options.Theme exposing (Theme(..))
import Test exposing (..)
import Time exposing (ZoneName(..))
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
                            , "topics": [ "iwd" ]
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
                        , topics = [ Iwd ]
                        , dauberColor = Keylime
                        , boardColor = GoofyGreen
                        , board = []
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
                        , board = []
                        }
                    )
        , test "should encode UserSettings" <|
            \_ ->
                Json.Decode.decodeValue
                    (decodeUserSettings Dark)
                    (encodeUserSettings
                        { selectedTheme = Light
                        , topics = [ Iwd ]
                        , dauberColor = Keylime
                        , boardColor = GoofyGreen
                        , board =
                            [ buildSquare "Something" [ Dot (Game.Dot.Offset 1 2) (Game.Dot.Shape 3 4 5 6) Keylime ]
                            , buildSquare "Something Else" []
                            ]
                        }
                    )
                    |> Expect.equal
                        (Ok
                            { selectedTheme = Light
                            , topics = [ Iwd ]
                            , dauberColor = Keylime
                            , boardColor = GoofyGreen
                            , board =
                                [ Square (Html.text "Something") Iwd "Something" [ Dot (Game.Dot.Offset 1 2) (Game.Dot.Shape 3 4 5 6) Keylime ]
                                , Square (Html.text "Something Else") Iwd "Something Else" []
                                ]
                            }
                        )
        ]
