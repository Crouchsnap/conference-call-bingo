module Header.MobilHeader exposing (view)

import Html exposing (div)
import Options.OptionsPopup as OptionsPopup
import Options.TopicChoicePopup as CategoryPopup


view model =
    div [ model.class "mobile-options-header" ]
        [ CategoryPopup.view model
        , OptionsPopup.view model
        ]
