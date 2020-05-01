module Win.FeedBack exposing (isFormValid, view)

import Html exposing (Html, button, div, label, text, textarea)
import Html.Attributes exposing (disabled, for, maxlength, name, placeholder, style, title)
import Html.Events exposing (onClick, onInput)
import Msg exposing (Msg(..))
import Rating
import RemoteData exposing (WebData)
import Requests exposing (errorToString)
import Win.Score exposing (Score)


view :
    { model
        | class : String -> Html.Attribute Msg
        , ratingState : Rating.State
        , score : Score
        , submittedScoreResponse : WebData ()
    }
    -> Html Msg
view model =
    case model.submittedScoreResponse of
        RemoteData.NotAsked ->
            submitView model

        RemoteData.Success _ ->
            div
                [ style "font-size" "1.5rem" ]
                [ text "😀Thanks for your feedback!😀" ]

        RemoteData.Failure error ->
            text ("Failed to submit " ++ errorToString error)

        RemoteData.Loading ->
            text "Submitting"


submitView { class, ratingState, score } =
    div
        []
        [ ratingTitle
        , Html.map RatingMsg (Rating.classView [ "star-rating" ] ratingState)
        , suggestionLabel
        , suggestion class
        , submitButton class score
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


submitButton class score =
    div []
        [ button
            [ class "submit-button"
            , disabled (not (isFormValid score))
            , onClick SubmitGame
            ]
            [ text "Play Again!" ]
        ]


isFormValid : Score -> Bool
isFormValid score =
    let
        initialsLength =
            String.length score.player
    in
    initialsLength > 1 && initialsLength < 5
