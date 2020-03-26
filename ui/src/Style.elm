module Style exposing
    ( boardTableStyle
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

import Element exposing (Device, DeviceClass(..), Orientation(..))
import Html
import Html.Attributes exposing (style)
import Msg exposing (Msg)


fontStyle =
    style "font-family" "sans-serif"


borderRadius =
    style "border-radius" "5px"


largeFontSize =
    style "font-size" "1.5rem"


smallFontSize =
    style "font-size" ".8rem"


fontSize =
    style "font-size" "1rem"


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
    [ smallFontSize
    , style "text-align" "center"
    , fontStyle
    , style "padding-top" "4rem"
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


boardTableStyle : Device -> List (Html.Attribute Msg)
boardTableStyle { class, orientation } =
    let
        ( width, height, squareFontSize ) =
            case ( class, orientation ) of
                ( Phone, Portrait ) ->
                    ( "20%", "20%", largeFontSize )

                ( Phone, Landscape ) ->
                    ( "20%", "18%", fontSize )

                ( Desktop, Landscape ) ->
                    ( "8rem", "8rem", fontSize )

                _ ->
                    ( "10rem", "10rem", largeFontSize )
    in
    [ style "justify-content" "center"
    , style "padding-top" "5px"
    , style "display" "grid"
    , style "grid-template-columns" ("repeat(5, " ++ height ++ ")")
    , style "grid-template-rows" ("repeat(5, " ++ width ++ ")")
    , style "grid-gap" "10px"
    , squareFontSize
    , fontStyle
    ]


squareContainerStyle =
    [ style "display" "table"
    , style "height" "100%"
    , style "width" "100%"
    ]


squareStyle { checked } =
    List.append
        (if checked then
            [ style "background-color" "red" ]

         else
            [ style "background-color" "#002F6CCC" ]
        )
        [ style "color" "white"
        , borderRadius
        , style "cursor" "pointer"
        , style "vertical-align" "middle"
        , style "text-align" "center"
        , style "display" "table-cell"
        , style "padding" "5px"
        ]
