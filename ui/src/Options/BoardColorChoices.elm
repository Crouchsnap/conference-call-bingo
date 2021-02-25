module Options.BoardColorChoices exposing (view)

import Html exposing (Html, button, div, label, text)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Options.BoardStyle exposing (Color(..), toString)
import Ports
import UserSettings exposing (UserSettings)
import View.Style exposing (colorSelectorClasses)


view : { model | userSettings : UserSettings, class : String -> Html.Attribute Msg } -> Html Msg
view { userSettings, class } =
    div [ class "options-container" ]
        [ div [ class "options-title" ] [ text "bingo sheet color" ]
        , boardColorSelector class userSettings.boardColor OriginalRed "Original Red"
        , boardColorSelector class userSettings.boardColor FadedBlue "Faded Blue"
        , boardColorSelector class userSettings.boardColor LuckyPurple "Lucky Purple"
        , boardColorSelector class userSettings.boardColor GoofyGreen "Goofy Green"
        , boardColorSelector class userSettings.boardColor FordBlue "Ford Blue"
        ]


boardColorSelector class selectedColor color colorLabel =
    button
        [ onClick (BoardColorSelected color)
        , class (colorSelectorClasses selectedColor color)
        ]
        [ div [ class ("square-color-chip " ++ (color |> toString)) ] []
        , label [ class "color-chip-label" ] [ text colorLabel ]
        ]
