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
        , test "should encode remove topic event" <|
            \_ ->
                Json.Encode.encode 0
                    (encodeGaEvent
                        (TopicChange False Fordism)
                    )
                    |> Expect.equal
                        """{"eventType":"remove-topic","eventCategory":"fordism"}"""
        , test "should encode add topic event" <|
            \_ ->
                Json.Encode.encode 0
                    (encodeGaEvent
                        (TopicChange True Generic)
                    )
                    |> Expect.equal
                        """{"eventType":"add-topic","eventCategory":"generic"}"""
        , test "should encode square daubed event" <|
            \_ ->
                let
                    square =
                        Square.genericSquare "text"

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
                        (SquareDaub (Square.genericSquare "text"))
                    )
                    |> Expect.equal
                        """{"eventType":"square-clear","eventCategory":"text"}"""
        ]