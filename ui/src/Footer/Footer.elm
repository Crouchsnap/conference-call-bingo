module Footer.Footer exposing (view)

import Assets.FordLabsLogo as FordLabsLogo
import GA exposing (Event(..))
import Html exposing (Html, a, div, text)
import Html.Attributes exposing (href, target)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Options.Theme exposing (Theme(..))
import Ports
import UserSettings exposing (UserSettings)


view :
    { model
        | userSettings : UserSettings
        , class : String -> Html.Attribute Msg
    }
    -> Html Msg
view { class, userSettings } =
    div []
        [ githubLink class
        , labsLink class userSettings.selectedTheme
        ]


githubLink class =
    div
        [ class "footer-container" ]
        [ text "Want to contribute? Check out our "
        , a
            [ class "anchor"
            , href "https://github.com/Crouchsnap/conference-call-bingo"
            , target "_blank"
            , onClick (GAEvent (LinkClickedEvent "Github!"))
            ]
            [ text "Github!" ]
        ]


labsLink class theme =
    div [ class "fordLabs-footer" ]
        [ a
            [ class "anchor"
            , href "https://www.fordlabs.com"
            , target "_blank"
            , onClick (GAEvent (LinkClickedEvent "FordLabs"))
            ]
            [ text "Powered by"
            , FordLabsLogo.view theme
            , text "FordLabs"
            ]
        ]
