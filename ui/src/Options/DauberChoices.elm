module Options.DauberChoices exposing (view)

import Game.Dot as Dot exposing (Color(..))
import Html exposing (Html, div, label, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import View.Style exposing (colorSelectorClasses)


view : { model | class : String -> Html.Attribute Msg, dauberColor : Dot.Color } -> Html Msg
view { class, dauberColor } =
    div [ class "boardStyleSelectorWrapper bottom-item" ]
        [ div [ class "options-title" ] [ text "dauber color" ]
        , dauberSelector class dauberColor Blue "Blue"
        , dauberSelector class dauberColor Keylime "Keylime"
        , dauberSelector class dauberColor Magenta "Magenta"
        , dauberSelector class dauberColor Ruby "Ruby"
        , dauberSelector class dauberColor Tangerine "Tangerine"
        ]


dauberSelector class selectedColor color colorLabel =
    div
        [ onClick (DauberSelected color)
        , class (colorSelectorClasses selectedColor color)
        ]
        [ div [ class ("round-color-chip " ++ (color |> Dot.class)) ] []
        , label [ class "color-chip-label" ] [ text colorLabel ]
        ]
