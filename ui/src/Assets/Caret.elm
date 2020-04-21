module Assets.Caret exposing (svg)

import Html exposing (Html)
import Html.Attributes as Html
import Svg
import Svg.Attributes exposing (d, fill, height, viewBox, width)
import View.Theme as Theme exposing (Theme(..))



--<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
--<path d="M13.2292 7.49999L9.99583 10.7333L6.7625 7.49999C6.60681 7.34395 6.39543 7.25626 6.175 7.25626C5.95457 7.25626 5.74319 7.34395 5.5875 7.49999C5.2625 7.82499 5.2625 8.34999 5.5875 8.67499L9.4125 12.5C9.7375 12.825 10.2625 12.825 10.5875 12.5L14.4125 8.67499C14.7375 8.34999 14.7375 7.82499 14.4125 7.49999C14.0875 7.18333 13.5542 7.17499 13.2292 7.49999Z" fill="#545454"/>
--</svg>


svg : Theme -> Html msg
svg theme =
    Svg.svg
        [ Html.style "vertical-align" "middle"
        , width "30"
        , height "30"
        , viewBox "0 0 20 20"
        , fill "none"
        ]
        [ Svg.path
            [ d "M13.2292 7.49999L9.99583 10.7333L6.7625 7.49999C6.60681 7.34395 6.39543 7.25626 6.175 7.25626C5.95457 7.25626 5.74319 7.34395 5.5875 7.49999C5.2625 7.82499 5.2625 8.34999 5.5875 8.67499L9.4125 12.5C9.7375 12.825 10.2625 12.825 10.5875 12.5L14.4125 8.67499C14.7375 8.34999 14.7375 7.82499 14.4125 7.49999C14.0875 7.18333 13.5542 7.17499 13.2292 7.49999Z"
            , fill (fillColor theme)
            ]
            []
        ]


fillColor theme =
    case theme |> Theme.normalizedTheme of
        Dark ->
            "#E5E5E5"

        _ ->
            "#545454"
