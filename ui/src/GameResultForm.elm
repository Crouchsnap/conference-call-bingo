module GameResultForm exposing (isFormValid, submitGame)

import Html exposing (br, button, div, input, label, text, textarea)
import Html.Attributes exposing (disabled, for, maxlength, minlength, name, title)
import Html.Events exposing (onClick, onInput)
import Msg exposing (Msg(..))
import Rating
import RemoteData
import Requests exposing (errorToString)
import Score exposing (GameResult)
import Style exposing (playerInputStyle, submitGameStyle, submitScoreButtonStyle, submitScoreFormStyle, submittedMessageStyle, suggestionInputStyle)


submitGame { submittedScoreResponse, ratingState, formData } =
    div
        submitGameStyle
        (case submittedScoreResponse of
            RemoteData.NotAsked ->
                [ div
                    submitScoreFormStyle
                    [ div [] [ text "Rate Your Experience" ]
                    , Html.map RatingMsg
                        (Rating.styleView
                            [ ( "color", "gold" )
                            , ( "font-size", "2.5rem" )
                            , ( "cursor", "pointer" )
                            ]
                            ratingState
                        )
                    , label [ for "player" ] [ text "Initials" ]
                    , div []
                        [ input
                            (playerInputStyle
                                ++ [ name "player"
                                   , title "Enter 2 to 4 Characters"
                                   , minlength 2
                                   , maxlength 4
                                   , onInput Player
                                   ]
                            )
                            []
                        ]
                    , label [ for "suggestion" ] [ text "What Square would you like to add?", br [] [], text "Or any other feedback?" ]
                    , div []
                        [ textarea
                            (suggestionInputStyle
                                ++ [ name "suggestion"
                                   , title "Enter a suggestion (max 100 characters)"
                                   , maxlength 100
                                   , onInput Suggestion
                                   ]
                            )
                            []
                        ]
                    , div []
                        [ let
                            disable =
                                not (isFormValid formData)
                          in
                          button
                            (submitScoreButtonStyle disable
                                ++ [ disabled disable
                                   , onClick SubmitGame
                                   ]
                            )
                            [ text "Submit Your Score" ]
                        ]
                    ]
                ]

            RemoteData.Success _ ->
                [ div
                    submittedMessageStyle
                    [ text "😀Thanks for your feedback!😀" ]
                ]

            RemoteData.Failure error ->
                [ text ("Failed to submit " ++ errorToString error) ]

            RemoteData.Loading ->
                [ text "Submitting" ]
        )


isFormValid : GameResult -> Bool
isFormValid gameResult =
    let
        initialsLength =
            String.length gameResult.player
    in
    initialsLength > 1 && initialsLength < 5 && gameResult.rating > 0
