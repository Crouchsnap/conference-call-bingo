module Header.MobilHeader exposing (view)

import Html exposing (div)
import Options.OptionsPopup as OptionsPopup
import Options.TopicChoicePopup as TopicChoicePopup


view model =
    div [ model.class "mobile-options-header" ]
        [ TopicChoicePopup.view model
        , OptionsPopup.view model
        ]
