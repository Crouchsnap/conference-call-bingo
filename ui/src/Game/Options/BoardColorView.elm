module Game.Options.BoardColorView exposing (boardColorView)

import Game.Options.BoardStyle exposing (Color(..), colorClass)
import Html exposing (div, label, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import View.Style exposing (bold, fontStyle)


boardColorView { boardColor, class } =
    div [ class "boardStyleSelectorWrapper" ]
        [ div [ style "text-transform" "uppercase", style "font-size" "1.25rem", bold, fontStyle, style "margin-bottom" ".5rem" ] [ text "bingo sheet color" ]
        , boardColorSelector class boardColor OriginalRed "Original Red"
        , boardColorSelector class boardColor FadedBlue "Faded Blue"
        , boardColorSelector class boardColor LuckyPurple "Lucky Purple"
        , boardColorSelector class boardColor GoofyGreen "Goofy Green"
        , boardColorSelector class boardColor FordBlue "Ford Blue"
        ]


boardColorSelector class selectedColor color colorLabel =
    let
        borderStyle =
            if selectedColor == color then
                [ class "boardOptionSelected"
                ]

            else
                [ class "boardOption" ]
    in
    div ([ style "padding" ".75rem", onClick (BoardColorSelected color), style "display" "flex", style "align-items" "center", style "cursor" "pointer" ] ++ borderStyle)
        [ div
            [ style "height" "3rem"
            , style "width" "3rem"
            , class (color |> colorClass)
            ]
            []
        , label [ style "font-size" "1rem", bold, fontStyle, style "padding" ".75rem", style "cursor" "pointer" ] [ text colorLabel ]
        ]
