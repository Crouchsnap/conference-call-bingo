module GA exposing (Event(..), encodeGaEvent)

import Game.Dot as Dot
import Game.Square exposing (Square)
import Game.Topic as Topic exposing (Topic)
import Json.Encode as Encode
import Msg exposing (Msg)
import Options.BoardStyle as BoardStyle
import Options.Theme as Theme exposing (Theme(..))
import Time exposing (Posix)
import Win.TimeFormatter as TimeFormatter


type Event
    = DauberColor Dot.Color Theme
    | BoardColor BoardStyle.Color Theme
    | ThemeChange Theme
    | TopicChange Bool Topic
    | SquareDaub (Square Msg)
    | Winner Posix Posix
    | SubmittedScore Posix Posix


encodeGaEvent : Event -> Encode.Value
encodeGaEvent event =
    let
        ( eventType, eventCategory ) =
            event |> toString
    in
    Encode.object
        [ ( "eventType", Encode.string <| eventType )
        , ( "eventCategory", Encode.string <| eventCategory )
        ]


toString : Event -> ( String, String )
toString event =
    case event of
        DauberColor color theme ->
            let
                dark =
                    if (theme |> Theme.normalizedTheme) == Dark then
                        "-dark"

                    else
                        ""
            in
            ( "dauber-color", (color |> Dot.toString) ++ dark )

        BoardColor color theme ->
            let
                dark =
                    if (theme |> Theme.normalizedTheme) == Dark then
                        "-dark"

                    else
                        ""
            in
            ( "board-color", (color |> BoardStyle.toString) ++ dark )

        ThemeChange theme ->
            ( "theme", theme |> Theme.toString )

        TopicChange added topic ->
            let
                prefix =
                    if added then
                        "add-"

                    else
                        "remove-"
            in
            ( prefix ++ "topic", topic |> Topic.toString )

        SquareDaub square ->
            let
                daubCount =
                    square.dots |> List.length
            in
            if daubCount > 0 then
                ( "square", square.text ++ "||" ++ (daubCount |> String.fromInt) )

            else
                ( "square-clear", square.text )

        Winner startTime endTime ->
            ( "winner", TimeFormatter.winingTimeDifference startTime endTime )

        SubmittedScore startTime endTime ->
            ( "submittedScore", TimeFormatter.winingTimeDifference startTime endTime )
