module Options.ThemeChoices exposing (themeToggle, view)

import Html exposing (Html, div, label, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Options.Theme exposing (Theme(..), themedClass)


view :
    { model
        | state : { selectedTheme : Theme }
        , systemTheme : Theme
    }
    -> Html Msg
view { state, systemTheme } =
    div [ themedClass state.selectedTheme "options-container" ]
        [ themeToggle state.selectedTheme systemTheme
        ]


themeToggle selectedTheme systemTheme =
    div
        [ themedClass selectedTheme "tri-toggle-container"
        ]
        [ themeToggleOption selectedTheme Light "Light"
        , themeToggleOption selectedTheme systemTheme "System Settings"
        , themeToggleOption selectedTheme Dark "Dark"
        ]


themeToggleOption selectedTheme theme label =
    div
        ([ themedClass selectedTheme "tri-toggle-option"
         , onClick (UpdateTheme theme)
         ]
            ++ (if selectedTheme == theme then
                    [ themedClass selectedTheme "tri-toggle-selected" ]

                else
                    []
               )
        )
        [ themeToggleSelected label ]


themeToggleSelected label =
    div [] [ text label ]
