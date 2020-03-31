module Theme exposing (SelectedTheme, Theme(..), systemTheme)


type Theme
    = Light
    | Dark
    | System Theme


type alias SelectedTheme =
    { system : Theme
    , selected : Theme
    }


systemTheme : Bool -> Theme
systemTheme dark =
    case dark of
        True ->
            System Dark

        False ->
            System Light


theme : Theme -> Theme
theme selected =
    case selected of
        System system ->
            system

        _ ->
            selected
