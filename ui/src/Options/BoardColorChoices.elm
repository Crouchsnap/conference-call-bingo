module Options.BoardColorChoices exposing (view)

import Html exposing (Html, div, label, text)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Options.BoardStyle exposing (Color(..), className)
import View.Style exposing (colorSelectorClasses)


view : { model | boardColor : Color, class : String -> Html.Attribute Msg } -> Html Msg
view { boardColor, class } =
    div [ class "boardStyleSelectorWrapper" ]
        [ div [ class "options-title" ] [ text "bingo sheet color" ]
        , boardColorSelector class boardColor OriginalRed "Original Red"
        , boardColorSelector class boardColor FadedBlue "Faded Blue"
        , boardColorSelector class boardColor LuckyPurple "Lucky Purple"
        , boardColorSelector class boardColor GoofyGreen "Goofy Green"
        , boardColorSelector class boardColor FordBlue "Ford Blue"
        ]


boardColorSelector class selectedColor color colorLabel =
    div
        [ onClick (BoardColorSelected color)
        , class (colorSelectorClasses selectedColor color)
        ]
        [ div [ class ("square-color-chip " ++ (color |> className)) ] []
        , label [ class "color-chip-label" ] [ text colorLabel ]
        ]
