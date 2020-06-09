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
    }
    -> Html Msg
view model =
    div
        [ model.class "feedback-container" ]
        (submitView model)


submitView { class, ratingState } =
    [ ratingTitle class
    , div []
        [ subtitle class
        , Html.map RatingMsg (Rating.classView [ "star-rating" ] ratingState)
        ]
    , div []
        [ suggestionLabel
        , suggestion class
        ]
    , submitButton class
    ]


ratingTitle class =
    label [ class "topic-title" ] [ text "give us feedback" ]


subtitle class =
    div [] [ text "Please rate your experience" ]


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
        [ class "submit-button"
        , onClick SubmitFeedback
        ]
        [ text "Submit" ]
