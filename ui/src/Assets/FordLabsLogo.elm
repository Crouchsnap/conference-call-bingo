module Assets.FordLabsLogo exposing (view)

import Html exposing (Html)
import Html.Attributes as Html
import Options.Theme as Theme exposing (Theme(..))
import Svg
import Svg.Attributes exposing (cx, cy, d, fill, height, r, viewBox, width)


view : Theme -> Html msg
view theme =
    let
        ( circleColor, textColor ) =
            colors theme
    in
    Svg.svg
        [ Html.style "vertical-align" "middle"
        , Html.style "margin" "0 .25rem"
        , width "20"
        , height "20"
        , viewBox "0 0 20 20"
        , fill "none"
        ]
        [ Svg.circle [ cx "10", cy "10", r "10", fill circleColor ] []
        , Svg.path [ d "M9 6H7L4 13H6L9 6Z", fill textColor ] []
        , Svg.path [ d "M14 6H11L10 8H13L14 6Z", fill textColor ] []
        , Svg.path [ d "M13 9H10L9 11H12L13 9Z", fill textColor ] []
        , Svg.path [ d "M17 11H14L13 13H16L17 11Z", fill textColor ] []
        ]


colors theme =
    case theme |> Theme.normalizedTheme of
        Dark ->
            ( "#F2F2F2", "rgb(67, 65, 66)" )

        _ ->
            ( "rgb(67, 65, 66)", "white" )
