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
import Requests
import Task
import Time exposing (Posix)
import Url exposing (Url)
import UserSettings exposing (UserSettings)
import Validate exposing (validate)
import View.BingoCard as BingoCard
import View.Feedback as Feedback exposing (Feedback, emptyFeedback, updateRating, updateSuggestion)
import View.FeedbackModal as FeedbackModal
import View.ViewportHelper exposing (defaultDevice, viewportToDevice)
import Win.Modal
import Win.Score as Score exposing (Score, emptyYourScore, updatePlayer)
import Win.TopScoresTable exposing (isFormValid)


type alias Model =
    { board : Board Msg
    , startTime : Posix
    , time : Posix
    , highScores : WebData (List Score)
    , submittedScoreResponse : WebData ()
    , url : Url
    , key : Key
    , score : Score
    , feedback : Feedback
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
    , showStartMultiplayerGameModal : Bool
    , multiplayerScores : List MultiplayerScore
    , currentSquaresChecked : Int
    , errors : List String
    , feedbackErrors : List String
    , betaMode : Bool
    , openFeedback : Bool
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
      , highScores = RemoteData.NotAsked
      , submittedScoreResponse = RemoteData.NotAsked
      , url = url
      , key = key
      , score = emptyYourScore
      , feedback = emptyFeedback
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
      , showStartMultiplayerGameModal = False
      , multiplayerScores = []
      , currentSquaresChecked = 1
      , errors = []
      , feedbackErrors = []
      , betaMode = isBeta url
      , openFeedback = False
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
                    , case model.startMultiplayerResponseBody of
                        RemoteData.Success startMultiplayerResponseBody ->
                            Ports.sendGaEvent (MultiplayerWin startMultiplayerResponseBody.id)

                        _ ->
                            Cmd.none
                    ]
                )

            else
                ( { model | board = updatedBoard, nextSeed = nextSeed, currentSquaresChecked = squaresChecked }, Cmd.batch [ multiplayerGameScoreEvent, gaEvent ] )

        GotCurrentTime time ->
            ( model |> reset time, Cmd.none )

        GotEndTime time ->
            ( { model | score = model.score |> Score.setScoreTime model.startTime time }
            , Ports.sendGaEvent (Winner model.startTime time)
            )

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
            if model.score |> isFormValid then
                ( model
                , Cmd.batch
                    [ Requests.submitScore model.url model.score
                    , Ports.sendGaEvent (SubmittedScore model.score)
                    ]
                )

            else
                model |> update NewGame

        SubmitFeedback ->
            case validate Feedback.feedbackValidator model.feedback of
                Ok _ ->
                    ( { model | openFeedback = False, feedbackErrors = [], feedback = emptyFeedback, ratingState = Rating.initialCustomState RatingStar.selected RatingStar.unselected }
                    , Requests.submitFeedback model.url model.feedback
                    )

                Err errors ->
                    ( { model | feedbackErrors = errors }, Cmd.none )

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
            ( if model.score.score == 0 then
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
            , Cmd.batch
                [ Ports.openMultiplayerScoresPort model.url gameId
                , Ports.sendGaEvent (MultiplayerJoin gameId)
                ]
            )

        MultiplayerScoreUpdated _ ->
            ( model, Cmd.none )

        StartMultiplayerGame ->
            case validate Score.scoreValidator model.score of
                Ok _ ->
                    ( { model | errors = [], showStartMultiplayerGameModal = False }, Requests.startMultiplayerGame model.url model.score.player model.currentSquaresChecked )

                Err errors ->
                    ( { model | errors = errors }, Cmd.none )

        JoinMultiplayerGame ->
            case validate Score.scoreValidator model.score of
                Ok _ ->
                    let
                        url =
                            model.url
                    in
                    ( { model | errors = [] }
                    , Cmd.batch
                        [ Requests.joinMultiplayerGame model.url (model.url.fragment |> Maybe.withDefault "") model.score.player model.currentSquaresChecked
                        , Navigation.pushUrl model.key (Url.toString { url | fragment = Nothing })
                        ]
                    )

                Err errors ->
                    ( { model | errors = errors }, Cmd.none )

        StartMultiplayerGameModal ->
            ( { model | showStartMultiplayerGameModal = True }, Cmd.none )

        CancelJoinMultiplayerGame ->
            let
                url =
                    model.url
            in
            ( { model | showStartMultiplayerGameModal = False }, Navigation.pushUrl model.key (Url.toString { url | fragment = Nothing }) )

        MultiplayerScores value ->
            let
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
                    ]

              else
                Cmd.none
            )

        Copy id ->
            ( model, Ports.copy id )

        FeedbackModal show ->
            ( { model | openFeedback = show }, Cmd.none )

        LeaveMultiplayerGame ->
            case model.startMultiplayerResponseBody of
                RemoteData.Success startMultiplayerResponseBody ->
                    let
                        ( updatedModel, updatedCmd ) =
                            update NewGame model
                    in
                    ( updatedModel
                    , Cmd.batch
                        [ Requests.leaveMultiplayerGame model.url startMultiplayerResponseBody
                        , updatedCmd
                        , Ports.sendGaEvent (MultiplayerLeave startMultiplayerResponseBody.id)
                        ]
                    )

                _ ->
                    ( model, Cmd.none )

        LeftGameResponse _ ->
            ( model, Cmd.none )


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
        , score = emptyYourScore
        , ratingState = model.ratingState |> Rating.set 0
        , submittedScoreResponse = RemoteData.NotAsked
        , modalVisibility = Modal.hidden
        , startMultiplayerResponseBody = RemoteData.NotAsked
        , showStartMultiplayerGameModal = False
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
        , Multiplayer.JoinModal.view model JoinMultiplayerGame (model.url.fragment /= Nothing && model.startMultiplayerResponseBody == RemoteData.NotAsked)
        , Multiplayer.JoinModal.view model StartMultiplayerGame model.showStartMultiplayerGameModal
        , Multiplayer.WinModal.view model ((model.multiplayerScores |> List.any (\score -> score.score > 4)) || (model.startMultiplayerResponseBody /= RemoteData.NotAsked && Bingo.isWinner model.board))
        , FeedbackModal.view model model.openFeedback
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
