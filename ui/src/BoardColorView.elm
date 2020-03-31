module BoardColorView exposing (boardColorView)

import BoardStyle exposing (Color(..), hexColor)
import Html exposing (div, label, text)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Style exposing (bold, fontStyle)


boardColorView { boardColor } =
    div [ class "boardStyleSelectorWrapper" ]
        [ div [ style "text-transform" "uppercase", style "font-size" "1.25rem", bold, fontStyle, style "margin-bottom" ".5rem" ] [ text "bingo sheet color" ]
        , boardColorSelector boardColor OriginalRed "Original Red"
        , boardColorSelector boardColor FadedBlue "Faded Blue"
        , boardColorSelector boardColor LuckyPurple "Lucky Purple"
        , boardColorSelector boardColor GoofyGreen "Goofy Green"
        , boardColorSelector boardColor FordBlue "Ford Blue"
        ]


boardColorSelector selectedColor color colorLabel =
    let
        borderStyle =
            if selectedColor == color then
                [ class "boardOptionSelected"
                ]

            else
                [ class "boardOption" ]

        fordBlueBackGround =
            if color == FordBlue then
                [ class "fordBlueDark" ]

            else
                []
    in
    div ([ style "padding" ".75rem", onClick (BoardColorSelected color), style "display" "flex", style "align-items" "center", style "cursor" "pointer" ] ++ borderStyle)
        [ div
            ([ style "background" (color |> hexColor)
             , style "height" "3.5rem"
             , style "width" "3.5rem"
             ]
                ++ fordBlueBackGround
            )
            []
        , label [ style "font-size" "1rem", bold, fontStyle, style "padding" ".75rem", style "cursor" "pointer" ] [ text colorLabel ]
        ]
