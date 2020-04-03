module Footer.Footer exposing (footerView)

import Footer.FordLabsLogo as FordLabsLogo
import Html exposing (Html, a, div, text)
import Html.Attributes exposing (href, target)
import Msg exposing (Msg)
import View.Theme as Theme exposing (Theme(..))


footerView :
    { model
        | selectedTheme : Theme
        , class : String -> Html.Attribute Msg
    }
    -> Html Msg
footerView { class, selectedTheme } =
    let
        ( fordLabsCircleColor, fordLabsLogoColor ) =
            case selectedTheme |> Theme.normalizedTheme of
                Dark ->
                    ( "#F2F2F2", "#545454" )

                _ ->
                    ( "#545454", "white" )
    in
    div []
        [ div
            [ class "footer-container" ]
            [ text "Want to contribute? Check out our "
            , a
                [ class "anchor"
                , href "https://github.com/Crouchsnap/conference-call-bingo"
                , target "_blank"
                ]
                [ text "Github!" ]
            ]
        , div [ class "fordLabs-footer" ]
            [ a
                [ class "anchor"
                , href "https://www.fordlabs.com"
                , target "_blank"
                ]
                [ text "Powered by"
                , FordLabsLogo.svg fordLabsCircleColor fordLabsLogoColor
                , text "FordLabs"
                ]
            ]
        ]
