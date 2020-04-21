module Options.BoardStyle exposing (Color(..), className)


type Color
    = OriginalRed
    | FadedBlue
    | LuckyPurple
    | GoofyGreen
    | FordBlue


className color =
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
