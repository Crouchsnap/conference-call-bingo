module GATests exposing (suite)

import Expect
import GA exposing (Event(..), encodeGaEvent)
import Game.Dot as Dot exposing (Color(..))
import Game.Square as Square
import Game.Topic exposing (Topic(..))
import Json.Encode
import Options.BoardStyle exposing (Color(..))
import Options.Theme exposing (Theme(..))
import Test exposing (Test, describe, test)
import Time


suite : Test
suite =
    describe "GA Tests"
        [ test "should encode dauber event" <|
            \_ ->
                Json.Encode.encode 0
                    (encodeGaEvent
                        (DauberColor Keylime Light)
                    )
                    |> Expect.equal
                        """{"eventType":"dauber-color","eventCategory":"keylime"}"""
        , test "should encode dark dauber event" <|
            \_ ->
                Json.Encode.encode 0
                    (encodeGaEvent
                        (DauberColor Keylime (System Dark))
                    )
                    |> Expect.equal
                        """{"eventType":"dauber-color","eventCategory":"keylime-dark"}"""
        , test "should encode light board color event" <|
            \_ ->
                Json.Encode.encode 0
                    (encodeGaEvent
                        (BoardColor GoofyGreen Light)
                    )
                    |> Expect.equal
                        """{"eventType":"board-color","eventCategory":"goofy-green"}"""
        , test "should encode dark board color event" <|
            \_ ->
                Json.Encode.encode 0
                    (encodeGaEvent
                        (BoardColor GoofyGreen Dark)
                    )
                    |> Expect.equal
                        """{"eventType":"board-color","eventCategory":"goofy-green-dark"}"""
        , test "should encode theme event" <|
            \_ ->
                Json.Encode.encode 0
                    (encodeGaEvent
                        (ThemeChange (System Dark))
                    )
                    |> Expect.equal
                        """{"eventType":"theme","eventCategory":"system"}"""
        , test "should encode square daubed event" <|
            \_ ->
                let
                    square =
                        Square.iwdSquare "text"

                    checkedSquare =
                        { square | dots = [ Dot.defaultDot ] }
                in
                Json.Encode.encode 0
                    (encodeGaEvent
                        (SquareDaub checkedSquare)
                    )
                    |> Expect.equal
                        """{"eventType":"square","eventCategory":"text||1"}"""
        , test "should encode square daubed clear event" <|
            \_ ->
                Json.Encode.encode 0
                    (encodeGaEvent
                        (SquareDaub (Square.iwdSquare "text"))
                    )
                    |> Expect.equal
                        """{"eventType":"square-clear","eventCategory":"text"}"""
        , test "should encode win event" <|
            \_ ->
                Json.Encode.encode 0
                    (encodeGaEvent
                        (Winner (Time.millisToPosix 0) (Time.millisToPosix 1252456))
                    )
                    |> Expect.equal
                        """{"eventType":"winner","eventCategory":"20:52.456"}"""
        , test "should encode submit score event" <|
            \_ ->
                Json.Encode.encode 0
                    (encodeGaEvent
                        (SubmittedScore (Time.millisToPosix 0) (Time.millisToPosix 984651651))
                    )
                    |> Expect.equal
                        """{"eventType":"submittedScore","eventCategory":"9:30:51.651"}"""
        , test "should encode link clicked event" <|
            \_ ->
                Json.Encode.encode 0
                    (encodeGaEvent
                        (LinkClickedEvent "the link")
                    )
                    |> Expect.equal
                        """{"eventType":"linkClicked","eventCategory":"the link"}"""
        ]
