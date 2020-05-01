module Win.FeedbackEntityTests exposing (suite)

import Expect exposing (Expectation)
import Game.Dot exposing (Color(..))
import Game.Topic exposing (Topic(..))
import Json.Decode exposing (Decoder)
import Json.Encode
import Options.BoardStyle exposing (Color(..))
import Options.Theme exposing (Theme(..))
import Test exposing (..)
import UserSettings exposing (decodeUserSettings, encodeUserSettings)
import Win.FeedbackEntity exposing (Feedback, encodeFeedback)


suite : Test
suite =
    describe "Feedback Tests"
        [ test "should encode feedback" <|
            \_ ->
                Json.Encode.encode 0
                    (encodeFeedback
                        (Feedback (Just "the suggestion") 5)
                    )
                    |> Expect.equal
                        """{"suggestion":"the suggestion","rating":5}"""
        , test "should encode feedback without suggestion" <|
            \_ ->
                Json.Encode.encode 0
                    (encodeFeedback
                        (Feedback Nothing 5)
                    )
                    |> Expect.equal
                        """{"suggestion":null,"rating":5}"""
        ]
