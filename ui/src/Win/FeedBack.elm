module Win.FeedBack exposing (view)

import Html exposing (Html, button, div, label, text, textarea)
import Html.Attributes exposing (for, maxlength, name, placeholder, title)
import Html.Events exposing (onClick, onInput)
import Msg exposing (Msg(..))
import Rating
import Win.Score exposing (Score)


view :
    { model
        | class : String -> Html.Attribute Msg
        , ratingState : Rating.State
        , score : Score
    }
    -> Html Msg
view model =
    submitView model


submitView { class, ratingState, score } =
    div
        []
        [ ratingTitle
        , Html.map RatingMsg (Rating.classView [ "star-rating" ] ratingState)
        , suggestionLabel
        , suggestion class
        , submitButton class
        ]


ratingTitle =
    label [] [ text "Please rate Your Experience" ]


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
    div []
        [ button
            [ class "submit-button"
            , onClick SubmitFeedback
            ]
            [ text "Play Again!" ]
        ]
