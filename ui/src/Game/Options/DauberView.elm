module Game.Options.DauberView exposing (dauberView)

import Game.Dot as Dot exposing (Color(..))
import Html exposing (div, label, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))


dauberView { class, dauberColor } =
    div [ class "boardStyleSelectorWrapper", style "margin-top" "auto", style "margin-bottom" "0" ]
        [ div [ style "text-transform" "uppercase", style "font-size" "1.25rem", style "font-weight" "bold", style "margin-bottom" ".5rem" ] [ text "dauber color" ]
        , dauberToggle class dauberColor Blue "Blue"
        , dauberToggle class dauberColor Keylime "Keylime"
        , dauberToggle class dauberColor Magenta "Magenta"
        , dauberToggle class dauberColor Ruby "Ruby"
        , dauberToggle class dauberColor Tangerine "Tangerine"
        ]


dauberToggle class selectedColor color colorLabel =
    let
        borderStyle =
            if selectedColor == color then
                [ class "boardOptionSelected" ]

            else
                [ class "boardOption" ]
    in
    div ([ style "padding" ".75rem", onClick (DauberSelected color), style "display" "flex", style "align-items" "center", style "cursor" "pointer" ] ++ borderStyle)
        [ div [ class "dauber-chip", class (color |> Dot.class) ] []
        , label [ style "font-size" "1rem", style "font-weight" "bold", style "padding" ".75rem", style "cursor" "pointer" ] [ text colorLabel ]
        ]
