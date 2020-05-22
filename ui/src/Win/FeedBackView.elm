module Win.FeedBackView exposing (view)

import Html exposing (Html, button, div, label, text, textarea)
import Html.Attributes exposing (for, maxlength, name, placeholder, style, title)
import Html.Events exposing (onClick, onInput)
import Msg exposing (Msg(..))
import Rating
import Win.Score exposing (Score)


view :
    { model
        | class : String -> Html.Attribute Msg
        , ratingState : Rating.State
        , feedbackSent : Bool
    }
    -> Html Msg
view model =
    div [ model.class "feedback-container bottom-item" ]
        (if model.feedbackSent then
            [ div [ model.class "feedback-response" ] [ text "Thank you for your feedback!" ] ]

         else
            submitView model
        )


submitView { class, ratingState } =
    [ ratingTitle
    , Html.map RatingMsg (Rating.classView [ "star-rating" ] ratingState)
    , suggestionLabel
    , suggestion class
    , submitButton class
    ]


ratingTitle =
    label [] [ text "Rate Your Experience" ]


suggestionLabel =
    label [ for "suggestion" ] [ text "Give us feedback or tell us what squares you’d like to add!" ]


suggestion class =
    div []
        [ textarea
            [ name "suggestion"
            , class "suggestion-input"
            , placeholder "I loved it! I want to add..."
            , title "Enter a suggestion (max 100 characters)"
            , maxlength 100
            , onInput Suggestion
            ]
            []
        ]


submitButton class =
    button
        [ class "submit-feedback-button"
        , onClick SubmitFeedback
        ]
        [ text "Submit" ]
