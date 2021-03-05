module Game.Timer exposing (timer, title, view)

import Html exposing (div, text)
import Time exposing (Posix)
import Win.TimeFormatter as TimeFormatter


view model className =
    div [ model.class className ]
        [ div
            [ model.class "timer-wrapper" ]
            (if (model.time |> Time.posixToMillis) > 0 then
                [ title model.class
                , timer model
                ]

             else
                []
            )
        ]


timer { time, startTime, class } =
    div [ class "timer-time" ] [ text (TimeFormatter.formatDifference time (Time.millisToPosix 1615867200000)) ]


title class =
    div [ class "timer-title" ] [ text "Time Remaining:" ]
