module Header.MobilHeader exposing (view)

import Assets.Caret as Caret
import Game.Timer as Timer
import Html exposing (div, text)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Multiplayer.MultiplayerView as MultiplayerView
import Options.OptionsPopup as OptionsPopup
import Options.TopicChoicePopup as TopicChoicePopup
import RemoteData


view model =
    div [ model.class "mobile" ]
        [ div [ model.class "mobile-options-header" ]
            [ TopicChoicePopup.view model
            , if model.startMultiplayerResponseBody == RemoteData.NotAsked then
                div
                    [ model.class "topic-mobile-wrapper"
                    , onClick StartMultiplayerGameModal
                    ]
                    [ text "Multiplayer"
                    , div [ model.class "caret-container" ]
                        [ Caret.view model.userSettings.selectedTheme ]
                    ]

              else
                text ""
            , Timer.view model "timer-container-mobile"
            , OptionsPopup.view model
            ]
        , if model.betaMode && model.startMultiplayerResponseBody /= RemoteData.NotAsked then
            div []
                [ MultiplayerView.view model "" "Mobile" True
                ]

          else
            text ""
        ]
