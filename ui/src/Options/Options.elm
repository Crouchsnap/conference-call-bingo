module Options.Options exposing (view)

import Game.Dot as Dot
import Html exposing (Html, div)
import Msg exposing (Msg)
import Options.BoardColorChoices as BoardColorChoices
import Options.BoardStyle as BoardStyle
import Options.DauberChoices as DauberChoices
import Options.Theme exposing (Theme)
import Options.ThemeChoices as ThemeChoices


view :
    { model
        | boardColor : BoardStyle.Color
        , dauberColor : Dot.Color
        , selectedTheme : Theme
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
