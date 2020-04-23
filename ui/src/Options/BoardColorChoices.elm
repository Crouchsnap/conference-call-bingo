module Options.BoardColorChoices exposing (view)

import Html exposing (Html, div, label, text)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Options.BoardStyle exposing (Color(..), toString)
import Ports
import State exposing (State)
import View.Style exposing (colorSelectorClasses)


view : { model | state : State, class : String -> Html.Attribute Msg } -> Html Msg
view { state, class } =
    div [ class "options-container" ]
        [ div [ class "options-title" ] [ text "bingo sheet color" ]
        , boardColorSelector class state.boardColor OriginalRed "Original Red"
        , boardColorSelector class state.boardColor FadedBlue "Faded Blue"
        , boardColorSelector class state.boardColor LuckyPurple "Lucky Purple"
        , boardColorSelector class state.boardColor GoofyGreen "Goofy Green"
        , boardColorSelector class state.boardColor FordBlue "Ford Blue"
        ]


boardColorSelector class selectedColor color colorLabel =
    div
        [ onClick (BoardColorSelected color)
        , class (colorSelectorClasses selectedColor color)
        ]
        [ div [ class ("square-color-chip " ++ (color |> toString)) ] []
        , label [ class "color-chip-label" ] [ text colorLabel ]
        ]
