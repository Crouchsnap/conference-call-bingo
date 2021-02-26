module Game.GameOptions exposing (aboutModalView, areYouSureModalView, view)

import Bootstrap.Modal as Modal
import Game.Timer as Timer
import Html exposing (Html, button, div, h1, h2, p, text)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Options.Theme exposing (Theme)
import Options.TopicChoices as TopicChoices
import Rating
import RemoteData exposing (WebData)
import Time exposing (Posix)
import Url exposing (Url)
import UserSettings exposing (UserSettings)
import Win.Score exposing (Score)


view :
    { model
        | userSettings : UserSettings
        , systemTheme : Theme
        , class : String -> Html.Attribute Msg
        , startTime : Posix
        , time : Posix
        , ratingState : Rating.State
        , score : Score
        , url : Url
        , betaMode : Bool
        , errors : List String
    }
    -> String
    -> Html Msg
view model wrapperClass =
    div [ model.class wrapperClass ]
        [ aboutButton model.class
        , button [ model.class "submit-button-secondary", onClick (FeedbackModal True) ] [ text "Give Us Feedback" ]
        , resetButton model.class
        , Timer.view model "timer-container options-container bottom-item"
        ]


resetButton class =
    button
        [ class "submit-button-secondary"
        , onClick AreYouSureReset
        ]
        [ text "Reset Game" ]


aboutButton class =
    button
        [ class "submit-button-secondary"
        , onClick ShowAbout
        ]
        [ text "About" ]


areYouSureModalView model =
    Modal.config NewGame
        |> Modal.attrs [ model.class "modal-container" ]
        |> Modal.body []
            [ button [ model.class "close", onClick CloseAreYouSureModal ] [ text "×" ]
            , div [] [ h1 [] [ text "Are you sure?" ] ]
            , div [] [ p [] [ text "If you reset the game you will receive a new board with new tiles in an different order. If you accidentally daubed a square you can un-daub it by daubing 3 times." ] ]
            , iNotBeSureButton model.class
            , iBeSureButton model.class
            ]
        |> Modal.view model.areYouSureResetModalVisibility


iNotBeSureButton class =
    button
        [ class "submit-button-secondary"
        , onClick CloseAreYouSureModal
        ]
        [ text "Cancel" ]


iBeSureButton class =
    button
        [ class "submit-button"
        , onClick NewGame
        ]
        [ text "Reset Game" ]


aboutModalView model =
    Modal.config CloseAbout
        |> Modal.attrs [ model.class "modal-container" ]
        |> Modal.body []
            [ button [ model.class "close", onClick CloseAbout ] [ text "×" ]
            , div [] [ h1 [] [ text "International Women's Day 2021" ] ]
            , div [] [ h2 [] [ text "March 8th" ] ]
            , div [] [ p [] [ text "Something" ] ]
            , iBeDoneButton model.class
            ]
        |> Modal.view model.aboutModalVisibility


iBeDoneButton class =
    button
        [ class "submit-button"
        , onClick CloseAbout
        ]
        [ text "Close" ]
