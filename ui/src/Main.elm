module Main exposing (Model, init, main, update, view)

import Browser
import Browser.Dom exposing (Viewport)
import Browser.Events
import Browser.Navigation as Navigation exposing (Key, load, pushUrl)
import Element exposing (Device, DeviceClass(..), classifyDevice)
import Footer.Footer as Footer
import GA exposing (Event(..))
import Game.Bingo as Bingo exposing (randomBoard)
import Game.Board exposing (Board)
import Game.Dot as Dot
import Game.Square exposing (Square, genericSquare, toggleSquareInList)
import Game.Topic exposing (Topic(..), toggleTopic)
import Header.MobilHeader as MobileHeader
import Html exposing (Html, div)
import Json.Decode
import List.Extra
import Msg exposing (Msg(..))
import Options.Options as Options
import Options.Theme as Theme exposing (Theme(..))
import Options.TopicChoices as TopicChoices
import Ports
import Random
import Rating
import RemoteData exposing (WebData)
import Requests
import Task
import Time exposing (Posix)
import Url exposing (Url)
import UserSettings exposing (UserSettings)
import View.Board as Board
import View.ViewportHelper exposing (defaultDevice, viewportToDevice)
import Win.Score exposing (GameResult, Score, emptyGameResult, updatePlayer, updateRating, updateSuggestion)


type alias Model =
    { board : Board Msg
    , startTime : Posix
    , endTime : Posix
    , highScores : WebData (List Score)
    , submittedScoreResponse : WebData ()
    , url : Url
    , key : Key
    , gameResult : GameResult
    , ratingState : Rating.State
    , device : Device
    , nextSeed : Random.Seed
    , systemTheme : Theme
    , class : String -> Html.Attribute Msg
    , showTopics : Bool
    , showOptions : Bool
    , userSettings : UserSettings
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
      , endTime = Time.millisToPosix 0
      , highScores = RemoteData.NotAsked
      , submittedScoreResponse = RemoteData.NotAsked
      , url = url
      , key = key
      , gameResult = emptyGameResult
      , ratingState = Rating.initialState
      , device = defaultDevice
      , nextSeed = Random.initialSeed 0
      , systemTheme = theme
      , class = Theme.themedClass userSettings.selectedTheme
      , showTopics = False
      , showOptions = False
      , userSettings = userSettings
      }
    , Cmd.batch [ Task.perform GotCurrentTime Time.now, Task.perform GotViewportSize Browser.Dom.getViewport ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleCheck squareToToggle ->
            let
                ( updatedBoard, nextSeed ) =
                    model.board |> toggleSquareInList model.nextSeed model.userSettings.dauberColor squareToToggle

                gaEvent =
                    Ports.sendGaEvent
                        (SquareDaub
                            ((updatedBoard |> List.Extra.find (\square -> square.text == squareToToggle.text))
                                |> Maybe.withDefault squareToToggle
                            )
                        )
            in
            ( { model | board = updatedBoard, nextSeed = nextSeed }
            , if updatedBoard |> Bingo.isWinner then
                Cmd.batch [ Task.perform GotEndTime Time.now, Requests.getHighScores model.url, gaEvent ]

              else
                gaEvent
            )

        GotCurrentTime time ->
            let
                seed =
                    if model.nextSeed == Random.initialSeed 0 then
                        Time.posixToMillis time |> Random.initialSeed

                    else
                        model.nextSeed

                ( board, next ) =
                    seed |> randomBoard model.userSettings.topics
            in
            ( { model
                | board = board
                , nextSeed = next
                , startTime = time
                , endTime = Time.millisToPosix 0
                , gameResult = emptyGameResult
                , ratingState = Rating.initialState
                , submittedScoreResponse = RemoteData.NotAsked
              }
            , Cmd.none
            )

        GotEndTime time ->
            ( { model | endTime = time }, Cmd.none )

        NewGame ->
            ( model, Task.perform GotCurrentTime Time.now )

        HighScoresResponse response ->
            ( { model | highScores = response }, Cmd.none )

        GameResponse response ->
            { model | submittedScoreResponse = response } |> update NewGame

        RequestHighScores ->
            ( model, Requests.getHighScores model.url )

        SubmitGame ->
            let
                gameResult =
                    model.gameResult

                gameResultWithScore =
                    { gameResult | score = Time.posixToMillis model.endTime - Time.posixToMillis model.startTime }
            in
            ( { model | gameResult = gameResult }, Requests.submitScore model.url gameResultWithScore )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, load href )

        UrlChanged url ->
            ( { model | url = url }, Cmd.none )

        Player initials ->
            ( { model | gameResult = updatePlayer initials model.gameResult }, Cmd.none )

        Suggestion suggestion ->
            ( { model | gameResult = updateSuggestion (Just suggestion) model.gameResult }, Cmd.none )

        RatingMsg ratingMsg ->
            let
                newRatingState =
                    Rating.update ratingMsg model.ratingState
            in
            ( { model | ratingState = newRatingState, gameResult = updateRating (Rating.get newRatingState) model.gameResult }, Cmd.none )

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


view : Model -> Browser.Document Msg
view model =
    { title = "BINGO!"
    , body =
        [ div [ model.class "body" ]
            [ bodyView model, Footer.view model ]
        ]
    }


bodyView model =
    let
        gameFinished =
            Bingo.isWinner model.board
    in
    div [ model.class "body-container" ]
        [ MobileHeader.view model
        , TopicChoices.view model "topic-wrapper" (not gameFinished)
        , Board.view model gameFinished
        , Options.view model "game-options-container" (not gameFinished)
        ]


main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.batch [ Browser.Events.onResize WindowResized ]
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
