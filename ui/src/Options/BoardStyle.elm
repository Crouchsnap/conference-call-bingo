module Options.BoardStyle exposing (Color(..), className, colorDecoder)

import Json.Decode as Decode exposing (Decoder)


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


colorDecoder : Decoder Color
colorDecoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "original-red" ->
                        Decode.succeed OriginalRed

                    "faded-blue" ->
                        Decode.succeed FadedBlue

                    "lucky-purple" ->
                        Decode.succeed LuckyPurple

                    "goofy-green" ->
                        Decode.succeed GoofyGreen

                    "ford-blue" ->
                        Decode.succeed FordBlue

                    _ ->
                        Decode.succeed OriginalRed
            )
