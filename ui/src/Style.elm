module Style exposing
    ( bold
    , categoryButtonStyle
    , dotStyle
    , fontStyle
    , footerStyle
    , newButtonStyle
    , playerInputStyle
    , scoreRowStyle
    , squareContainerStyle
    , squareStyle
    , subTitleStyle
    , submitGameStyle
    , submitScoreButtonStyle
    , submitScoreFormStyle
    , submittedMessageStyle
    , suggestionInputStyle
    , titleStyle
    , topScoreColumnHeaderStyle
    , topScoreContainerStyle
    , topScoreHeaderStyle
    , topScoreTableStyle
    , winningScoreHeaderStyle
    , winningViewContainerStyle
    , yourScoreRowStyle
    )

import Dot exposing (Dot, Offset, Shape)
import Html
import Html.Attributes exposing (class, style)
import Msg exposing (Msg)
import Set


fontStyle =
    style "font-family" "Ubuntu, sans-serif"


borderRadius =
    style "border-radius" "5px"


largeFontSize =
    style "font-size" "1.5rem"


smallFontSize =
    style "font-size" ".8rem"


fontSize =
    style "font-size" "1.25rem"


bold =
    style "font-weight" "bold"


titleStyle : List (Html.Attribute Msg)
titleStyle =
    [ style "text-align" "center"
    , fontStyle
    ]


subTitleStyle : List (Html.Attribute Msg)
subTitleStyle =
    [ fontSize
    , style "text-align" "center"
    , fontStyle
    , style "padding-bottom" "8px"
    ]


footerStyle : List (Html.Attribute Msg)
footerStyle =
    [ style "font-size" "1rem"
    , style "text-align" "center"
    , fontStyle
    , bold
    , style "padding-top" "1rem"
    ]


winningViewContainerStyle =
    [ style "display" "grid"
    , style "grid-template-columns" "repeat(2, 1fr)"
    , style "min-height" "25rem"
    ]


winningScoreHeaderStyle : List (Html.Attribute Msg)
winningScoreHeaderStyle =
    titleStyle


topScoreContainerStyle =
    [ fontStyle
    , style "justify-content" "left"
    , style "position" "relative"
    ]


topScoreColumnHeaderStyle : List (Html.Attribute Msg)
topScoreColumnHeaderStyle =
    [ largeFontSize
    , style "text-align" "center"
    , style "border" "1px solid"
    , style "padding" "3px"
    ]


topScoreHeaderStyle : List (Html.Attribute Msg)
topScoreHeaderStyle =
    [ style "text-align" "center"
    , style "grid-column" "span 3"
    , largeFontSize
    , style "margin-bottom" ".8rem"
    ]


topScoreTableStyle : List (Html.Attribute Msg)
topScoreTableStyle =
    [ style "display" "grid"
    , style "grid-template-columns" "repeat(3, 7rem)"
    , style "margin-left" "1.5rem"
    ]


scoreRowStyle : List (Html.Attribute Msg)
scoreRowStyle =
    [ style "font-size" "1rem"
    , style "border" "1px solid"
    , style "padding" "3px"
    ]


yourScoreRowStyle : List (Html.Attribute Msg)
yourScoreRowStyle =
    scoreRowStyle
        ++ [ style "background-color" "#002F6CCC"
           , style "color" "white"
           ]


playerInputStyle =
    [ style "padding" "5px"
    , borderRadius
    , style "max-width" "7rem"
    , fontStyle
    , style "font-size" "1.2rem"
    , style "text-align" "center"
    ]


suggestionInputStyle =
    [ style "padding" "5px"
    , borderRadius
    , style "max-width" "30rem"
    , style "min-height" "10rem"
    , fontStyle
    , style "font-size" "1.2rem"
    ]


submitGameStyle =
    [ style "text-align" "center"
    , style "margin-right" "1.5rem"
    ]


newButtonStyle =
    [ style "background-color" "#002F6CCC"
    , style "color" "white"
    , style "border" "none"
    , style "font-size" "18px"
    , borderRadius
    , style "cursor" "pointer"
    , style "padding" "20px"
    , style "position" "absolute"
    , style "bottom" "0"
    , style "left" "0"
    , style "margin-left" "4.5rem"
    ]


categoryButtonStyle =
    [ style "background-color" "#002F6CCC"
    , style "color" "white"
    , style "border" "none"
    , style "font-size" "18px"
    , borderRadius
    , style "cursor" "pointer"
    , style "padding" "20px"
    , style "max-height" "1rem"
    , style "max-width" "12rem"
    , style "text-align" "center"
    , fontStyle
    ]


submitScoreFormStyle =
    [ style "justify-content" "right"
    , style "display" "grid"
    , style "grid-template-columns" "repeat(2, auto-fill)"
    , style "grid-gap" "10px"
    , style "text-align" "center"
    , fontStyle
    , largeFontSize
    , style "box-shadow" "inset 0 0 0 10px rgba(0, 255, 0, 0.5);"
    ]


submitScoreButtonStyle disable =
    let
        backgroundColor =
            if disable then
                "#002F6C99"

            else
                "#002F6CCC"
    in
    [ style "background-color" backgroundColor
    , style "color" "white"
    , style "border" "none"
    , style "font-size" "18px"
    , borderRadius
    , style "cursor" "pointer"
    , style "padding" "20px"
    , style "max-width" "10rem"
    ]


submittedMessageStyle =
    [ fontStyle
    , largeFontSize
    ]


squareContainerStyle =
    [ style "display" "table"
    , style "height" "100%"
    , style "width" "100%"
    ]


squareStyle index color =
    squareBorderStyle index
        ++ [ class (color ++ "-dauber-cursor")
           , style "vertical-align" "middle"
           , style "text-align" "center"
           , style "display" "table-cell"
           , style "padding" "5px"
           , style "position" "relative"
           , fontSize
           , bold
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
