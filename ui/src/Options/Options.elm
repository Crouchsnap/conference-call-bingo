module Options.Options exposing (view)

import Html exposing (Html, div)
import Msg exposing (Msg)
import Options.BoardColorChoices as BoardColorChoices
import Options.DauberChoices as DauberChoices
import Options.Theme exposing (Theme)
import Options.ThemeChoices as ThemeChoices
import Ports
import State exposing (State)


view :
    { model
        | state : State
        , systemTheme : Theme
        , class : String -> Html.Attribute Msg
    }
    -> String
    -> Bool
    -> Html Msg
view model wrapperClass show =
    div [ model.class wrapperClass ]
        ([ ThemeChoices.view model ] ++ colorOptions model show)


colorOptions model show =
    if show then
        [ BoardColorChoices.view model
        , DauberChoices.view model
        ]

    else
        []
