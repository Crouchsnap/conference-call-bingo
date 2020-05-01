module Header.MobilHeader exposing (view)

import Game.Timer as Timer
import Html exposing (div)
import Options.OptionsPopup as OptionsPopup
import Options.TopicChoicePopup as TopicChoicePopup


view model =
    div [ model.class "mobile-options-header" ]
        [ TopicChoicePopup.view model
        , Timer.view model "timer-container-mobile"
        , OptionsPopup.view model
        ]
