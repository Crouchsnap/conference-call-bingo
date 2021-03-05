module Game.GameOptions exposing (aboutModalView, areYouSureModalView, view)

import Bootstrap.Modal as Modal
import Game.Timer as Timer
import Html exposing (Html, a, button, div, h1, h2, p, text)
import Html.Attributes exposing (style)
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
            , div [ model.class "feedback-container" ]
                [ div [] [ h1 [] [ text "Are you sure?" ] ]
                , div [] [ p [] [ text "If you reset the game you will receive a new board with new tiles in an different order. If you accidentally daubed a square you can un-daub it by daubing 3 times." ] ]
                , div [ style "display" "flex" ]
                    [ iNotBeSureButton model.class
                    , iBeSureButton model.class
                    ]
                ]
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
    let
        expandText =
            if model.expandText then
                [ div [] [ p [] [ text "International Women’s Day (IWD) is a day of celebration during which we celebrate and recognize the incredible impact women have in all areas of our global life. During this day, March 8th, and throughout the month of March, find where you can contribute to the work being done to lift up women’s and girls’ voices in your community. In conjunction with the celebration and focus on gender equality, we invite everyone – no matter your gender identity – to celebrate those whose voices have been quieted. Also please take this time to share and celebrate what you do every day to support women, girls and non-binary friends, colleagues and loved ones in your life. This celebratory day is in recognition of those who have been ignored and oppressed AND it serves as a key time to recognize those who make it a priority to lift them up." ] ]
                , div [] [ p [] [ text "The historic significance of the fight for women’s rights is well established. In reaction to growing unrest and social movement surrounding women’s rights throughout the early 1900’s, the first National Women’s Day in the United States was held in 1908. Years later, International Women’s Day was widely recognized through rallies and marches across the world. Gender Equality Month is much younger in its celebratory history but is no less important. An ongoing movement and recently reinvigorated generation of activists is pushing the needle forward and demanding equal rights and opportunities for all gender identities. Gender minorities across the world face such inequities as withheld access to food, healthcare and safety; All genders are not equally represented in political leadership; Basic human autonomous right such as choosing what to learn, where to live and who to marry are denied. " ] ]
                , div [] [ p [] [ text "Gloria Steinem, world-renowned feminist, journalist and activist said, \"The story of women's struggle for equality belongs to no single feminist, nor to any one organization, but to the collective efforts of all who care about human rights.\"" ] ]
                , div []
                    [ p []
                        [ text "This month, we ask you to empower your fellow gender minority community members, address unconscious biases, and help to identify and demystify inequitable patterns we see in the world and at the workplace and discuss with safety and compassion at heart."
                        , button [ model.class "more-button", onClick (ExpandText False) ] [ text "less ↑" ]
                        ]
                    ]
                ]

            else
                [ div []
                    [ p []
                        [ text "International Women’s Day (IWD) is a day of celebration during which we celebrate and recognize the incredible impact women have in all areas of our global life. During this day..."
                        , button [ model.class "more-button", onClick (ExpandText True) ] [ text "more ↓" ]
                        ]
                    ]
                ]
    in
    Modal.config CloseAbout
        |> Modal.attrs [ model.class "modal-container" ]
        |> Modal.body []
            ([ button [ model.class "close", onClick CloseAbout ] [ text "×" ]
             , div [] [ h1 [] [ text "International Women's Day 2021" ] ]
             , div [] [ h2 [] [ text "March 8th" ] ]
             , div [] [ p [] [ text "March is an important month for gender equality and women’s rights. Marking both Gender Equality Month and International Women’s Day on March 8th, the month has become a time of recognition and service every year." ] ]
             ]
                ++ expandText
                ++ [ div [] [ h2 [] [ text "How to Play" ] ]
                   , div [] [ p [] [ text "This version of BINGO! is to encourage you to daub or click/tap on squares that you complete during the week of March 8th. Your progress will be saved on this device and until you complete your card you may return back to your card. To complete your Bingo! card get five squares in a row, column or diagonally then screenshot your accomplishments and share. If you would like a different card you can hit reset. If you accidentally daub a square you can un-daub by daubing three times." ] ]
                   , iBeDoneButton model.class
                   ]
            )
        |> Modal.view model.aboutModalVisibility


iBeDoneButton class =
    button
        [ class "submit-button"
        , onClick CloseAbout
        ]
        [ text "Close" ]
