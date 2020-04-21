module Options.Theme exposing (Theme(..), normalizedTheme, systemTheme, themedClass)

import Html exposing (Attribute)
import Html.Attributes exposing (class)


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
