module Win.Feedback exposing (Feedback, emptyFeedback, encodeFeedback, updateRating, updateSuggestion)

import Json.Encode


type alias Feedback =
    { suggestion : Maybe String
    , rating : Int
    }


emptyFeedback =
    Feedback Nothing 0


updateSuggestion : Maybe String -> Feedback -> Feedback
updateSuggestion suggestion feedback =
    { feedback | suggestion = suggestion }


updateRating : Int -> Feedback -> Feedback
updateRating rating feedback =
    { feedback | rating = rating }


encodeFeedback : Feedback -> Json.Encode.Value
encodeFeedback record =
    Json.Encode.object
        [ ( "suggestion"
          , case record.suggestion of
                Just suggestion ->
                    Json.Encode.string <| suggestion

                Nothing ->
                    Json.Encode.null
          )
        , ( "rating", Json.Encode.int <| record.rating )
        ]
