module Options.DauberChoices exposing (view)

import Game.Dot as Dot exposing (Color(..))
import Html exposing (Html, div, label, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Ports
import UserSettings exposing (UserSettings)
import View.Style exposing (colorSelectorClasses)


view : { model | class : String -> Html.Attribute Msg, userSettings : UserSettings } -> Html Msg
view { class, userSettings } =
    div [ class "options-container bottom-item" ]
        [ div [ class "options-title" ] [ text "dauber color" ]
        , dauberSelector class userSettings.dauberColor Blue "Blue"
        , dauberSelector class userSettings.dauberColor Keylime "Keylime"
        , dauberSelector class userSettings.dauberColor Magenta "Magenta"
        , dauberSelector class userSettings.dauberColor Ruby "Ruby"
        , dauberSelector class userSettings.dauberColor Tangerine "Tangerine"
        ]


dauberSelector class selectedColor color colorLabel =
    div
        [ onClick (DauberSelected color)
        , class (colorSelectorClasses selectedColor color)
        ]
        [ div [ class ("round-color-chip " ++ (color |> Dot.class)) ] []
        , label [ class "color-chip-label" ] [ text colorLabel ]
        ]
