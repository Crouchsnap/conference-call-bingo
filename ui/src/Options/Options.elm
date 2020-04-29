module Options.Options exposing (view)

import Html exposing (Html, div)
import Msg exposing (Msg)
import Options.BoardColorChoices as BoardColorChoices
import Options.DauberChoices as DauberChoices
import Options.Theme exposing (Theme)
import Options.ThemeChoices as ThemeChoices
import Ports
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
        ([ ThemeChoices.view model ] ++ colorOptions model)


colorOptions model =
    [ BoardColorChoices.view model
    , DauberChoices.view model
    ]
