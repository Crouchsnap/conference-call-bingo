module View.Style exposing (dotStyle, squareStyle)

import Game.Dot as Dot exposing (Dot, Offset, Shape)
import Html exposing (Html)
import Html.Attributes exposing (style)
import Msg exposing (Msg)


squareStyle : (String -> Html.Attribute Msg) -> Int -> String -> List (Html.Attribute Msg)
squareStyle class index color =
    squareBorderStyle class index
        ++ [ class "square"
           , class (color ++ "-dauber-cursor")
           ]


squareBorderStyle : (String -> Html.Attribute Msg) -> Int -> List (Html.Attribute Msg)
squareBorderStyle class index =
    if index == rightBottomCorner then
        [ class "square-border-none" ]

    else if isRightColumn index then
        [ class "square-border-bottom" ]

    else if isBottomRow index then
        [ class "square-border-right" ]

    else
        [ class "square-border-right"
        , class "square-border-bottom"
        ]


isRightColumn index =
    modBy 5 (index + 1) == 0


isBottomRow index =
    index > 19


rightBottomCorner =
    24


dotStyle : (String -> Html.Attribute msg) -> Int -> Dot -> List (Html.Attribute msg)
dotStyle class index { offset, shape, color } =
    [ class "dot"
    , style "background-color" (color |> Dot.hexColor)
    , borderRadiusFromShape shape
    , transformOffset offset
    , style "z-index" ((index + 1) * 10 |> String.fromInt)
    ]


borderRadiusFromShape : Shape -> Html.Attribute msg
borderRadiusFromShape { topLeft, topRight, bottomRight, bottomLeft } =
    style "border-radius"
        (String.fromInt topLeft
            ++ "% "
            ++ String.fromInt topRight
            ++ "% "
            ++ String.fromInt bottomRight
            ++ "% "
            ++ String.fromInt bottomLeft
            ++ "%"
        )


transformOffset : Offset -> Html.Attribute msg
transformOffset { x, y } =
    style "transform" ("translate(" ++ String.fromInt x ++ "%," ++ String.fromInt y ++ "%)")
