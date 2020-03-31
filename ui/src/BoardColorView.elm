module BoardColorView exposing (boardColorView)

import BoardStyle exposing (Color(..), hexColor)
import Html exposing (div, label, text)
import Html.Attributes exposing (class, for, name, style, type_)
import Html.Events exposing (onCheck, onClick)
import Msg exposing (Msg(..))
import Style exposing (bold, fontColor, fontStyle)


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
                [ style "border" "0.5px solid #545454"
                , style "box-sizing" "border-box"
                , style "box-shadow" "2px 3px 4px rgba(0, 0, 0, 0.15)"
                , style "border-radius" "4px"
                ]

            else
                [ style "border" "none" ]
    in
    div ([ style "padding" ".75rem", onClick (BoardColorSelected color), style "display" "flex", style "align-items" "center" ] ++ borderStyle)
        [ div
            [ style "background" (color |> hexColor)
            , style "height" "3.5rem"
            , style "width" "3.5rem"
            ]
            []
        , label [ style "font-size" "1rem", bold, fontColor, fontStyle, style "padding" ".75rem" ] [ text colorLabel ]
        ]
