module Assets.Refresh exposing (view)

import Html exposing (Html)
import Options.Theme as Theme exposing (Theme(..))
import Svg exposing (Svg)
import Svg.Attributes exposing (class, clipRule, d, fill, fillRule, height, viewBox, width)


view : Theme -> Html msg
view theme =
    Svg.svg
        [ width "32"
        , height "32"
        , viewBox "0 0 16 16"
        , class "bi bi-arrow-counterclockwise"
        , fill (fillColor theme)
        ]
        [ Svg.path
            [ fillRule "evenodd"
            , d "M8 3a5 5 0 1 1-4.546 2.914.5.5 0 0 0-.908-.417A6 6 0 1 0 8 2v1z"
            ]
            []
        , Svg.path
            [ d "M8 4.466V.534a.25.25 0 0 0-.41-.192L5.23 2.308a.25.25 0 0 0 0 .384l2.36 1.966A.25.25 0 0 0 8 4.466z"
            ]
            []
        ]


fillColor theme =
    case theme |> Theme.normalizedTheme of
        Dark ->
            "rgb(218, 218, 219)"

        _ ->
            "rgb(67, 65, 66)"
