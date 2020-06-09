module View.FeedbackView exposing (view)

import Html exposing (Html, button, div, label, text, textarea)
import Html.Attributes exposing (for, maxlength, name, placeholder, style, title, value)
import Html.Events exposing (onClick, onInput)
import Msg exposing (Msg(..))
import Rating
import View.Feedback exposing (Feedback)


view :
    { model
        | class : String -> Html.Attribute Msg
        , ratingState : Rating.State
        , feedbackErrors : List String
        , feedback : Feedback
    }
    -> Html Msg
view model =
    div
        [ model.class "feedback-container" ]
        (submitView model)


submitView { class, ratingState, feedbackErrors, feedback } =
    [ ratingTitle class
    , div []
        [ subtitle class
        , Html.map RatingMsg (Rating.classView [ "star-rating" ] ratingState)
        , viewFormErrors class feedbackErrors
        ]
    , div []
        [ suggestionLabel
        , suggestion class feedback
        ]
    , submitButton class
    ]


ratingTitle class =
    label [ class "topic-title" ] [ text "give us feedback" ]


subtitle class =
    div [] [ text "Please rate your experience" ]


suggestionLabel =
    label [ for "suggestion" ] [ text "Give us feedback or tell us what squares you’d like to add!" ]


suggestion class feedback =
    div []
        [ textarea
            [ name "suggestion"
            , class "suggestion-input"
            , placeholder "I loved it! I want to add..."
            , title "Enter a suggestion (max 100 characters)"
            , maxlength 100
            , onInput Suggestion
            , value (feedback.suggestion |> Maybe.withDefault "")
            ]
            []
        ]


submitButton class =
    button
        [ class "submit-button"
        , onClick SubmitFeedback
        ]
        [ text "Submit" ]


viewFormErrors : (String -> Html.Attribute msg) -> List String -> Html msg
viewFormErrors class errors =
    errors
        |> List.map (\error -> div [ class "form-errors" ] [ text error ])
        |> div [ class "form-errors" ]
