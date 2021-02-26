module Win.TimeFormatter exposing (formatDifference, timeDifference, winingTime, winingTimeDifference)

import Time exposing (Month(..), Posix, Zone)


timeDifference : Posix -> Posix -> Int
timeDifference startTime endTime =
    Time.posixToMillis endTime - Time.posixToMillis startTime


winingTimeDifference : Zone -> Posix -> String
winingTimeDifference zone endTime =
    winingTime zone endTime


formatDifference : Posix -> Posix -> String
formatDifference startTime endTime =
    let
        diff =
            timeDifference startTime endTime
    in
    if diff > 0 then
        diff |> timerTime

    else
        "00:00:00"


winingTime : Zone -> Posix -> String
winingTime zone millis =
    (Time.toMonth zone millis |> toDanishMonth)
        ++ " "
        ++ (Time.toDay zone millis |> String.fromInt)
        ++ ", "
        ++ (Time.toHour zone millis |> String.fromInt)
        ++ ":"
        ++ (Time.toMinute zone millis |> String.fromInt)


toDanishMonth : Month -> String
toDanishMonth month =
    case month of
        Jan ->
            "January"

        Feb ->
            "February"

        Mar ->
            "March"

        Apr ->
            "April"

        May ->
            "May"

        Jun ->
            "June"

        Jul ->
            "July"

        Aug ->
            "August"

        Sep ->
            "September"

        Oct ->
            "October"

        Nov ->
            "November"

        Dec ->
            "December"


timerTime : Int -> String
timerTime millis =
    let
        days =
            daysFormat millis
    in
    if String.length days > 0 then
        days

    else
        timerHours millis
            ++ timerMinsFormat millis
            ++ timerSecsFormat millis


type Units
    = Millis
    | Seconds
    | Minutes
    | Hours
    | Days


unitsToConst : Units -> Float
unitsToConst unit =
    case unit of
        Millis ->
            1

        Seconds ->
            1000

        Minutes ->
            60 * 1000

        Hours ->
            60 * 60 * 1000

        Days ->
            24 * 60 * 60 * 1000


parse : Units -> Int -> Int
parse unit millis =
    floor (toFloat millis / unitsToConst unit)


addLeadingZeroIfHigherMagnitude : Int -> String -> String
addLeadingZeroIfHigherMagnitude contingentValue value =
    if String.length value == 1 && contingentValue > 0 then
        "0" ++ value

    else
        value


addLeadingZero : Int -> String
addLeadingZero value =
    let
        valueAsString =
            String.fromInt value
    in
    if String.length valueAsString == 1 then
        "0" ++ valueAsString

    else
        valueAsString


millisFormat : Int -> String
millisFormat millis =
    let
        millisStr =
            millis |> parse Millis |> modBy 1000 |> String.fromInt
    in
    "."
        ++ (case String.length millisStr of
                1 ->
                    "00" ++ millisStr

                2 ->
                    "0" ++ millisStr

                _ ->
                    millisStr
           )


secsFormat : Int -> String
secsFormat millis =
    let
        secs =
            millis |> parse Seconds |> modBy 60
    in
    secs
        |> String.fromInt
        |> addLeadingZeroIfHigherMagnitude (millis |> parse Minutes)


timerSecsFormat : Int -> String
timerSecsFormat millis =
    millis
        |> parse Seconds
        |> modBy 60
        |> addLeadingZero


minsFormat : Int -> String
minsFormat millis =
    let
        mins =
            millis |> parse Minutes
    in
    if mins > 0 then
        (mins
            |> modBy 60
            |> String.fromInt
            |> addLeadingZeroIfHigherMagnitude (millis |> parse Hours)
        )
            ++ ":"

    else
        ""


timerMinsFormat : Int -> String
timerMinsFormat millis =
    (millis
        |> parse Minutes
        |> modBy 60
        |> addLeadingZero
    )
        ++ ":"


hoursFormat : Int -> String
hoursFormat millis =
    let
        hours =
            millis |> parse Hours
    in
    if hours > 0 then
        String.fromInt (hours |> modBy 24) ++ ":"

    else
        ""


daysFormat : Int -> String
daysFormat millis =
    let
        days =
            millis |> parse Days
    in
    if days > 0 then
        String.fromInt days ++ " Days "

    else
        ""


timerHours : Int -> String
timerHours millis =
    (millis
        |> parse Hours
        |> modBy 24
        |> addLeadingZero
    )
        ++ ":"
