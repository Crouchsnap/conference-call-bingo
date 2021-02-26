module Options.Options exposing (view)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Options.BoardColorChoices as BoardColorChoices
import Options.DauberChoices as DauberChoices
import Options.Theme exposing (Theme)
import Options.ThemeChoices as ThemeChoices
import UserSettings exposing (UserSettings)


view :
    { model
        | userSettings : UserSettings
        , systemTheme : Theme
        , class : String -> Html.Attribute Msg
    }
    -> String
    -> Html Msg
view model wrapperClass =
    div [ model.class wrapperClass ]
        [ ThemeChoices.view model
        , BoardColorChoices.view model
        , DauberChoices.view model
        ]
