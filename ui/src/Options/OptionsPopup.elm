module Options.OptionsPopup exposing (view)

import Assets.Gear as Gear
import Html exposing (div, text)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Options.Options as Options


view model =
    div [ model.class "options-icon", onClick ToggleOptions ]
        [ div [] [ Gear.view model.userSettings.selectedTheme ]
        , popup model
        ]


popup model =
    if model.showOptions then
        div [ model.class "mobile-menu mobile-options" ]
            [ Options.view model "game-selector-view-mobile" ]

    else
        text ""
