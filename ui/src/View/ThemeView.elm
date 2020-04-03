module View.ThemeView exposing (themeToggle, themeView)

import Html exposing (div, label, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import View.Style exposing (fontStyle)
import View.Theme exposing (Theme(..), themedClass)


themeView { selectedTheme, systemTheme } =
    div [ themedClass selectedTheme "boardStyleSelectorWrapper" ]
        [ themeToggle selectedTheme systemTheme
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
        ([ style "display" "grid"
         , style "text-align" "center"
         , style "line-height" "90%"
         , style "height" "100%"
         , style "width" "100%"
         , style "align-items" "center"
         , style "justify-items" "center"
         , fontStyle
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
    div [ style "line-height" "90%", fontStyle ] [ text label ]
