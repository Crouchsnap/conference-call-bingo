module Footer.Footer exposing (view)

import Assets.FordLabsLogo as FordLabsLogo
import Html exposing (Html, a, div, text)
import Html.Attributes exposing (href, target)
import Msg exposing (Msg)
import Options.Theme exposing (Theme(..))


view :
    { model
        | selectedTheme : Theme
        , class : String -> Html.Attribute Msg
    }
    -> Html Msg
view { class, selectedTheme } =
    div []
        [ githubLink class
        , labsLink class selectedTheme
        ]


githubLink class =
    div
        [ class "footer-container" ]
        [ text "Want to contribute? Check out our "
        , a
            [ class "anchor"
            , href "https://github.com/Crouchsnap/conference-call-bingo"
            , target "_blank"
            ]
            [ text "Github!" ]
        ]


labsLink class theme =
    div [ class "fordLabs-footer" ]
        [ a
            [ class "anchor"
            , href "https://www.fordlabs.com"
            , target "_blank"
            ]
            [ text "Powered by"
            , FordLabsLogo.view theme
            , text "FordLabs"
            ]
        ]
