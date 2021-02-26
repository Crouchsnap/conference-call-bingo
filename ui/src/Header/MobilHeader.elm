module Header.MobilHeader exposing (view)

import Assets.Info as Info
import Assets.Refresh as Refresh
import Assets.Star as Star
import Game.Timer as Timer
import Html exposing (button, div)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Options.OptionsPopup as OptionsPopup


view model =
    div [ model.class "mobile" ]
        [ div [ model.class "mobile-options-header" ]
            [ iconView model
            , Timer.view model "timer-container-mobile"
            , OptionsPopup.view model
            ]
        ]


iconView model =
    div [ model.class "topic-mobile-wrapper" ]
        [ button [ model.class "about-icon", onClick ShowAbout ]
            [ Info.view model.userSettings.selectedTheme ]
        , button [ model.class "refresh-icon", onClick AreYouSureReset ]
            [ Refresh.view model.userSettings.selectedTheme ]
        , button [ model.class "ratings-icon", onClick (FeedbackModal True) ]
            [ Star.view "32" ]
        ]
