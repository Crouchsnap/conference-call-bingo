module Header.MobilHeader exposing (view)

import Html exposing (div)
import View.CategoryPopup as CategoryPopup
import View.OptionsPopup as OptionsPopup


view model =
    div [ model.class "mobile-options-header" ]
        [ CategoryPopup.view model
        , OptionsPopup.view model
        ]
