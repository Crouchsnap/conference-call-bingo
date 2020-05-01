module Game.GameOptions exposing (view)

import Game.Timer as Timer
import Html exposing (Html, div)
import Msg exposing (Msg)
import Options.Theme exposing (Theme)
import Options.TopicChoices as TopicChoices
import Time exposing (Posix)
import UserSettings exposing (UserSettings)


view :
    { model
        | userSettings : UserSettings
        , systemTheme : Theme
        , class : String -> Html.Attribute Msg
        , startTime : Posix
        , time : Posix
    }
    -> String
    -> Html Msg
view model wrapperClass =
    div [ model.class wrapperClass ]
        [ TopicChoices.view model
        , Timer.view model "timer-container options-container bottom-item"
        ]
