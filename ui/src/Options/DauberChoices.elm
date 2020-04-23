module Options.DauberChoices exposing (view)

import Game.Dot as Dot exposing (Color(..))
import Html exposing (Html, div, label, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Ports
import State exposing (State)
import View.Style exposing (colorSelectorClasses)


view : { model | class : String -> Html.Attribute Msg, state : State } -> Html Msg
view { class, state } =
    div [ class "options-container bottom-item" ]
        [ div [ class "options-title" ] [ text "dauber color" ]
        , dauberSelector class state.dauberColor Blue "Blue"
        , dauberSelector class state.dauberColor Keylime "Keylime"
        , dauberSelector class state.dauberColor Magenta "Magenta"
        , dauberSelector class state.dauberColor Ruby "Ruby"
        , dauberSelector class state.dauberColor Tangerine "Tangerine"
        ]


dauberSelector class selectedColor color colorLabel =
    div
        [ onClick (DauberSelected color)
        , class (colorSelectorClasses selectedColor color)
        ]
        [ div [ class ("round-color-chip " ++ (color |> Dot.class)) ] []
        , label [ class "color-chip-label" ] [ text colorLabel ]
        ]
