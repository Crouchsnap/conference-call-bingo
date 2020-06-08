module Main exposing (Model, init, main, update, view)

import Assets.RatingStar as RatingStar
import Bootstrap.Modal as Modal
import Browser
import Browser.Dom exposing (Viewport)
import Browser.Events
import Browser.Navigation as Navigation exposing (Key, load, pushUrl)
import Element exposing (Device, DeviceClass(..), classifyDevice)
import Footer.Footer as Footer
import GA exposing (Event(..))
import Game.Bingo as Bingo exposing (longestRowCount, randomBoard)
import Game.Board exposing (Board)
import Game.GameOptions as GameOptions
import Game.Square exposing (Square, toggleSquareInList)
import Game.Topic exposing (Topic(..), toggleTopic)
import Header.MobilHeader as MobileHeader
import Html exposing (Html, div)
import Json.Decode
import List.Extra
import Msg exposing (Msg(..))
import Multiplayer.JoinModal
import Multiplayer.Multiplayer as Multiplayer exposing (GameUpdate(..), MultiplayerScore, StartMultiplayerResponseBody)
import Multiplayer.WinModal
import Options.Options as Options
import Options.Theme as Theme exposing (Theme(..))
import Ports
import Random
import Rating
import RemoteData exposing (WebData)
import Requests exposing (getHostFromLocation)
import Task
import Time exposing (Posix)
import Url exposing (Url)
import UserSettings exposing (UserSettings)
import View.BingoCard as BingoCard
import View.ViewportHelper exposing (defaultDevice, viewportToDevice)
import Win.Feedback exposing (Feedback, emptyFeedback, updateRating, updateSuggestion)
import Win.Modal
import Win.Score exposing (Score, emptyGameResult, updatePlayer)
import Win.TopScoresTable exposing (isFormValid)


type alias Model =
    { board : Board Msg
    , startTime : Posix
    , time : Posix
    , endTime : Posix
    , highScores : WebData (List Score)
    , submittedScoreResponse : WebData ()
    , url : Url
    , key : Key
    , score : Score
    , feedback : Feedback
    , feedbackSent : Bool
    , ratingState : Rating.State
    , device : Device
    , nextSeed : Random.Seed
    , systemTheme : Theme
    , class : String -> Html.Attribute Msg
    , showTopics : Bool
    , showOptions : Bool
    , userSettings : UserSettings
    , modalVisibility : Modal.Visibility
    , startMultiplayerResponseBody : WebData StartMultiplayerResponseBody
    , multiplayerScores : List MultiplayerScore
    , currentSquaresChecked : Int
    , betaMode : Bool
    }


type alias Flags =
    { dark : Json.Decode.Value
    , userSettings : Json.Decode.Value
    }


init : Flags -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        theme =
            Theme.systemThemeFromFlag flags.dark

        userSettings =
            UserSettings.decodeUserSettingsValue theme flags.userSettings
    in
    ( { board = []
      , startTime = Time.millisToPosix 0
      , time = Time.millisToPosix 0
      , endTime = Time.millisToPosix 0
      , highScores = RemoteData.NotAsked
      , submittedScoreResponse = RemoteData.NotAsked
      , url = url
      , key = key
      , score = emptyGameResult
      , feedback = emptyFeedback
      , feedbackSent = False
      , ratingState = Rating.initialCustomState RatingStar.selected RatingStar.unselected
      , device = defaultDevice
      , nextSeed = Random.initialSeed 0
      , systemTheme = theme
      , class = Theme.themedClass userSettings.selectedTheme
      , showTopics = False
      , showOptions = False
      , userSettings = userSettings
      , modalVisibility = Modal.hidden
      , startMultiplayerResponseBody = RemoteData.NotAsked
      , multiplayerScores = []
      , currentSquaresChecked = 1
      , betaMode = isBeta url
      }
    , Cmd.batch [ Task.perform GotCurrentTime Time.now, Task.perform GotViewportSize Browser.Dom.getViewport ]
    )


isBeta : Url -> Bool
isBeta { query } =
    case query of
        Just q ->
            q |> String.contains "beta"

        Nothing ->
            False


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleCheck squareToToggle ->
            let
                ( updatedBoard, nextSeed ) =
                    model.board |> toggleSquareInList model.nextSeed model.userSettings.dauberColor squareToToggle

                squaresChecked =
                    updatedBoard |> longestRowCount

                multiplayerGameScoreEvent =
                    case model.startMultiplayerResponseBody of
                        RemoteData.Success startMultiplayerResponseBody ->
                            if squaresChecked > model.currentSquaresChecked then
                                Requests.sendMultiplayerScore model.url Increment startMultiplayerResponseBody

                            else if squaresChecked < model.currentSquaresChecked then
                                Requests.sendMultiplayerScore model.url Decrement startMultiplayerResponseBody

                            else
                                Cmd.none

                        _ ->
                            Cmd.none

                url =
                    model.url

                gaEvent =
                    Ports.sendGaEvent
                        (SquareDaub
                            ((updatedBoard |> List.Extra.find (\square -> square.text == squareToToggle.text))
                                |> Maybe.withDefault squareToToggle
                            )
                        )
            in
            if updatedBoard |> Bingo.isWinner then
                ( { model
                    | board = updatedBoard
                    , nextSeed = nextSeed
                    , modalVisibility =
                        if model.startMultiplayerResponseBody == RemoteData.NotAsked then
                            Modal.shown

                        else
                            Modal.hidden
                    , currentSquaresChecked = squaresChecked
                  }
                , Cmd.batch
                    [ Task.perform GotEndTime Time.now
                    , Requests.getHighScores model.url
                    , multiplayerGameScoreEvent
                    , gaEvent
                    ]
                )

            else
                ( { model | board = updatedBoard, nextSeed = nextSeed, currentSquaresChecked = squaresChecked }, Cmd.batch [ multiplayerGameScoreEvent, gaEvent ] )

        GotCurrentTime time ->
            ( model |> reset time, Cmd.none )

        GotEndTime time ->
            ( { model | endTime = time }, Ports.sendGaEvent (Winner model.startTime time) )

        NewGame ->
            ( model, Task.perform GotCurrentTime Time.now )

        HighScoresResponse response ->
            ( { model | highScores = response }, Cmd.none )

        GameResponse response ->
            { model | submittedScoreResponse = response } |> update NewGame

        FeedbackResponse _ ->
            ( model, Cmd.none )

        RequestHighScores ->
            ( model, Requests.getHighScores model.url )

        SubmitGame ->
            let
                score =
                    model.score

                scoreWithTime =
                    { score | score = Time.posixToMillis model.endTime - Time.posixToMillis model.startTime }
            in
            if score |> isFormValid then
                ( { model | score = score }
                , Cmd.batch
                    [ Requests.submitScore model.url scoreWithTime
                    , Ports.sendGaEvent (SubmittedScore model.startTime model.endTime)
                    ]
                )

            else
                model |> update NewGame

        SubmitFeedback ->
            if model.feedback.rating > 0 then
                ( { model | feedbackSent = True }, Requests.submitFeedback model.url model.feedback )

            else
                ( model, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( { model | betaMode = isBeta url }, pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, load href )

        UrlChanged url ->
            ( { model | url = url, betaMode = isBeta url }, Cmd.none )

        Player initials ->
            ( { model | score = updatePlayer initials model.score }, Cmd.none )

        Suggestion suggestion ->
            ( { model | feedback = updateSuggestion (Just suggestion) model.feedback }, Cmd.none )

        RatingMsg ratingMsg ->
            let
                newRatingState =
                    Rating.update ratingMsg model.ratingState
            in
            ( { model | ratingState = newRatingState, feedback = updateRating (Rating.get newRatingState) model.feedback }, Cmd.none )

        GotViewportSize viewport ->
            ( { model | device = viewportToDevice viewport }, Cmd.none )

        WindowResized width height ->
            ( { model | device = classifyDevice { height = height, width = width } }, Cmd.none )

        TopicToggled topic ->
            let
                currentUserSettings =
                    model.userSettings

                updatedUserSettings =
                    { currentUserSettings | topics = toggleTopic topic model.userSettings.topics }
            in
            ( { model | userSettings = updatedUserSettings }
            , Cmd.batch
                [ Task.perform GotCurrentTime Time.now
                , Ports.saveUserSettings updatedUserSettings
                , Ports.sendGaEvent (TopicChange (updatedUserSettings.topics |> List.member topic) topic)
                ]
            )

        DauberSelected color ->
            let
                currentUserSettings =
                    model.userSettings

                updatedUserSettings =
                    { currentUserSettings | dauberColor = color }
            in
            ( { model | userSettings = updatedUserSettings }
            , Cmd.batch [ Ports.saveUserSettings updatedUserSettings, Ports.sendGaEvent (DauberColor color model.userSettings.selectedTheme) ]
            )

        BoardColorSelected color ->
            let
                currentUserSettings =
                    model.userSettings

                updatedUserSettings =
                    { currentUserSettings | boardColor = color }
            in
            ( { model | userSettings = updatedUserSettings }
            , Cmd.batch [ Ports.saveUserSettings updatedUserSettings, Ports.sendGaEvent (BoardColor color model.userSettings.selectedTheme) ]
            )

        UpdateTheme theme ->
            let
                currentUserSettings =
                    model.userSettings

                updatedUserSettings =
                    { currentUserSettings | selectedTheme = theme }
            in
            ( { model | userSettings = updatedUserSettings, class = Theme.themedClass theme }
            , Cmd.batch [ Ports.saveUserSettings updatedUserSettings, Ports.sendGaEvent (ThemeChange theme) ]
            )

        ToggleTopics ->
            ( { model | showTopics = not model.showTopics }, Cmd.none )

        ToggleOptions ->
            ( { model | showOptions = not model.showOptions }, Cmd.none )

        GAEvent event ->
            ( model, Ports.sendGaEvent event )

        Tick newTime ->
            ( if Time.posixToMillis model.endTime == 0 then
                { model | time = newTime }

              else
                model
            , Cmd.none
            )

        MultiplayerStartResponse response ->
            let
                gameId =
                    response |> RemoteData.withDefault { id = "fake", playerId = "player" } |> .id
            in
            ( { model | startMultiplayerResponseBody = response }
            , Ports.listenToMultiplayerScores (getHostFromLocation model.url ++ "/api/multiplayer/scores/" ++ gameId)
            )

        MultiplayerScoreUpdated _ ->
            ( model, Cmd.none )

        StartMultiplayerGame ->
            ( model, Requests.startMultiplayerGame model.url model.score.player model.currentSquaresChecked )

        JoinMultiplayerGame ->
            ( model, Requests.joinMultiplayerGame model.url (model.url.fragment |> Maybe.withDefault "") model.score.player model.currentSquaresChecked )

        MultiplayerScores value ->
            let
                url =
                    model.url

                multiplayerScores =
                    case value of
                        Ok scores ->
                            scores

                        _ ->
                            model.multiplayerScores
            in
            ( { model | multiplayerScores = multiplayerScores }
            , if multiplayerScores |> List.any (\score -> score.score == 5) then
                Cmd.batch
                    [ Ports.stopListeningToMultiplayerScores ()
                    , Navigation.pushUrl model.key (Url.toString { url | fragment = Nothing })
                    ]

              else
                Cmd.none
            )

        Copy id ->
            ( model, Ports.copy id )


reset time model =
    let
        seed =
            if model.nextSeed == Random.initialSeed 0 then
                Time.posixToMillis time |> Random.initialSeed

            else
                model.nextSeed

        ( board, next ) =
            seed |> randomBoard model.userSettings.topics
    in
    { model
        | board = board
        , nextSeed = next
        , startTime = time
        , endTime = Time.millisToPosix 0
        , score = emptyGameResult
        , ratingState = model.ratingState |> Rating.set 0
        , submittedScoreResponse = RemoteData.NotAsked
        , modalVisibility = Modal.hidden
        , startMultiplayerResponseBody = RemoteData.NotAsked
        , multiplayerScores = []
        , currentSquaresChecked = 1
    }


view : Model -> Browser.Document Msg
view model =
    { title = "BINGO! - Conference Call Bingo! | FordLabs"
    , body =
        [ div [ model.class "body" ]
            [ bodyView model, Footer.view model ]
        ]
    }


bodyView model =
    div [ model.class "body-container" ]
        [ MobileHeader.view model
        , GameOptions.view model "game-options-container"
        , BingoCard.view model
        , Options.view model "theme-options-container"
        , Win.Modal.view model
        , Multiplayer.JoinModal.view model (model.url.fragment /= Nothing && model.startMultiplayerResponseBody == RemoteData.NotAsked)
        , Multiplayer.WinModal.view model ((model.multiplayerScores |> List.any (\score -> score.score > 4)) || (model.startMultiplayerResponseBody /= RemoteData.NotAsked && Bingo.isWinner model.board))
        ]


main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions =
            \_ ->
                Sub.batch
                    [ Browser.Events.onResize WindowResized
                    , Time.every 1000 Tick
                    , Ports.multiplayerScoresListener (Multiplayer.decodeMultiplayerScoresToResult >> MultiplayerScores)
                    ]
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
