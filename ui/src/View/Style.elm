module View.Style exposing
    ( dotStyle
    , squareStyle
    , suggestionInputStyle
    )

import Game.Dot as Dot exposing (Dot, Offset, Shape)
import Html exposing (Html)
import Html.Attributes exposing (style)
import Msg exposing (Msg)
import Set


borderRadius =
    style "border-radius" "5px"


fontSize =
    style "font-size" "1.25rem"


suggestionInputStyle =
    [ style "padding" "5px"
    , borderRadius
    , style "width" "25rem"
    , style "min-height" "4rem"
    , style "font-weight" "bold"
    , style "font-size" "1rem"
    ]


squareStyle : (String -> Html.Attribute Msg) -> Int -> String -> List (Html.Attribute Msg)
squareStyle class index color =
    squareBorderStyle index
        ++ [ class (color ++ "-dauber-cursor")
           , style "vertical-align" "middle"
           , style "text-align" "center"
           , style "display" "table-cell"
           , style "padding" "5px"
           , style "position" "relative"
           , fontSize
           , style "font-weight" "bold"
           ]


squareBorderStyle : Int -> List (Html.Attribute Msg)
squareBorderStyle index =
    if index == topLeftCorner then
        [ style "border-right" "2px solid #545454"
        , style "border-bottom" "2px solid #545454"
        ]

    else if index == topRightCorner then
        [ style "border-left" "2px solid #545454"
        , style "border-bottom" "2px solid #545454"
        ]

    else if index == leftBottomCorner then
        [ style "border-right" "2px solid #545454"
        , style "border-top" "2px solid #545454"
        ]

    else if index == rightBottomCorner then
        [ style "border-left" "2px solid #545454"
        , style "border-top" "2px solid #545454"
        ]

    else if topRow |> Set.member index then
        [ style "border-right" "2px solid #545454"
        , style "border-bottom" "2px solid #545454"
        , style "border-left" "2px solid #545454"
        ]

    else if leftColumn |> Set.member index then
        [ style "border-right" "2px solid #545454"
        , style "border-top" "2px solid #545454"
        , style "border-bottom" "2px solid #545454"
        ]

    else if rightColumn |> Set.member index then
        [ style "border-left" "2px solid #545454"
        , style "border-top" "2px solid #545454"
        , style "border-bottom" "2px solid #545454"
        ]

    else if bottomRow |> Set.member index then
        [ style "border-right" "2px solid #545454"
        , style "border-top" "2px solid #545454"
        , style "border-left" "2px solid #545454"
        ]

    else
        [ style "border" "2px solid #545454" ]


topLeftCorner =
    0


topRightCorner =
    4


leftBottomCorner =
    20


rightBottomCorner =
    24


topRow =
    Set.fromList [ 1, 2, 3 ]


leftColumn =
    Set.fromList [ 5, 10, 15 ]


rightColumn =
    Set.fromList [ 9, 14, 19 ]


bottomRow =
    Set.fromList [ 21, 22, 23 ]


dotStyle : Int -> Dot -> List (Html.Attribute msg)
dotStyle index { offset, shape, color } =
    [ style "height" "85%"
    , style "width" "85%"
    , style "display" "inline-block"
    , borderRadiusFromShape shape
    , style "background-color" (color |> Dot.hexColor)
    , style "position" "absolute"
    , style "top" "50%"
    , style "left" "50%"
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
