module View.Options exposing (gameStyleSelectorView)

import Game.Options.BoardColorView as BoardColorView
import Game.Options.DauberView as DauberView
import Html exposing (div)
import View.ThemeView as ThemeView


gameStyleSelectorView model className show =
    div [ model.class className ]
        ([ ThemeView.themeView model ]
            ++ (if show then
                    [ BoardColorView.boardColorView model, DauberView.dauberView model ]

                else
                    []
               )
        )
