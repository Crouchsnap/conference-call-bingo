module BoardStyle exposing (Color(..), hexColor)


type Color
    = OriginalRed
    | FadedBlue
    | LuckyPurple
    | GoofyGreen
    | FordBlue


hexColor color =
    case color of
        OriginalRed ->
            "#EB514D"

        FadedBlue ->
            "#97CBEB"

        LuckyPurple ->
            "#896DD6"

        GoofyGreen ->
            "#84D552"

        FordBlue ->
            "linear-gradient(180deg, #4CA9E3 0%, #0F2955 89.58%)"
