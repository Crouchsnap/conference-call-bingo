module Header.MobilHeader exposing (view)

import Game.Timer as Timer
import Html exposing (div)
import Options.OptionsPopup as OptionsPopup


view model =
    div [ model.class "mobile" ]
        [ div [ model.class "mobile-options-header" ]
            [ Timer.view model "timer-container-mobile"
            , OptionsPopup.view model
            ]
        ]
