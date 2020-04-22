module Options.Theme exposing (Theme(..), normalizedTheme, systemTheme, themeDecoder, themeEncoder, themedClass, toString)

import Html exposing (Attribute)
import Html.Attributes exposing (class)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode


type Theme
    = Light
    | Dark
    | System Theme


systemTheme : Bool -> Theme
systemTheme dark =
    case dark of
        True ->
            System Dark

        False ->
            System Light


normalizedTheme : Theme -> Theme
normalizedTheme selected =
    case selected of
        System system ->
            system

        _ ->
            selected


themedClass : Theme -> String -> Attribute msg
themedClass applyTheme className =
    case applyTheme |> normalizedTheme of
        Dark ->
            className
                |> String.split " "
                |> List.map (\name -> name ++ " " ++ name ++ "-dark")
                |> String.join " "
                |> class

        _ ->
            class className


toString : Theme -> String
toString theme =
    case theme of
        Dark ->
            "dark"

        Light ->
            "light"

        System _ ->
            "system"


themeEncoder : Theme -> Encode.Value
themeEncoder theme =
    Encode.string <| toString <| theme


themeDecoder : Theme -> Decoder Theme
themeDecoder system =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "light" ->
                        Decode.succeed Light

                    "dark" ->
                        Decode.succeed Dark

                    _ ->
                        Decode.succeed system
            )
