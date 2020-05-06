module Win.FeedbackTests exposing (suite)

import Expect exposing (Expectation)
import Json.Encode
import Test exposing (..)
import Win.Feedback exposing (Feedback, encodeFeedback)


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
