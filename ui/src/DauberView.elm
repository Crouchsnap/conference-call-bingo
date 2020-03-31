module DauberView exposing (dauberView)

import Dot exposing (Color(..))
import Html exposing (div, input, label, text)
import Html.Attributes exposing (class, for, name, style, type_)
import Html.Events exposing (onCheck, onClick)
import Msg exposing (Msg(..))
import Style exposing (bold, fontColor, fontStyle)


dauberView { dauberColor } =
    div [ class "dauberSelectorWrapper" ]
        [ div [ style "text-transform" "uppercase", style "font-size" "1.25rem", bold, fontStyle, style "margin-bottom" ".5rem" ] [ text "dauber color" ]
        , dauberToggle dauberColor Blue "Blue"
        , dauberToggle dauberColor Keylime "Keylime"
        , dauberToggle dauberColor Magenta "Magenta"
        , dauberToggle dauberColor Ruby "Ruby"
        , dauberToggle dauberColor Tangerine "Tangerine"
        ]


dauberToggle selectedColor color colorLabel =
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
    div ([ style "padding" ".5rem .75rem", onClick (DauberSelected color), style "display" "flex" ] ++ borderStyle)
        [ div
            [ style "background-color" (color |> Dot.hexColor)
            , style "height" "2.375rem"
            , style "width" "2.375rem"
            , style "border-radius" "50%"
            ]
            []
        , label [ style "font-size" "1rem", bold, fontColor, fontStyle, style "padding" ".75rem" ] [ text colorLabel ]
        ]
