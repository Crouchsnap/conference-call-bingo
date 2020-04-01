module BoardStyle exposing (Color(..), colorClass)


type Color
    = OriginalRed
    | FadedBlue
    | LuckyPurple
    | GoofyGreen
    | FordBlue


colorClass color =
    case color of
        OriginalRed ->
            "original-red"

        FadedBlue ->
            "faded-blue"

        LuckyPurple ->
            "lucky-purple"

        GoofyGreen ->
            "goofy-green"

        FordBlue ->
            "ford-blue"
