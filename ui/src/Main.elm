module Main exposing (Model, init, main, update, view)

import Browser
import Browser.Dom exposing (Viewport)
import Browser.Events
import Browser.Navigation as Navigation exposing (Key, load, pushUrl)
import Element exposing (Device, DeviceClass(..), classifyDevice)
import Footer.Footer as Footer
import Game.Bingo as Bingo exposing (randomBoard)
import Game.Board exposing (Board)
import Game.Dot as Dot exposing (Color(..), Dot)
import Game.GameView as GameView
import Game.Options.BoardStyle as BoardStyle exposing (Color(..))
import Game.Options.CategoryView as CategoryView
import Game.Square exposing (Category(..), Square, toggleCategory, toggleSquareInList)
import Header.MobilHeader as MobileHeader
import Html exposing (Html, div, text)
import Html.Attributes exposing (href, style)
import Msg exposing (Msg(..))
import Random
import Rating
import RemoteData exposing (WebData)
import Requests
import Task
import Time exposing (Posix)
import Url exposing (Url)
import View.Options as Options
import View.Theme as Theme exposing (Theme(..))
import View.ViewportHelper exposing (defaultDevice, viewportToDevice)
import Win.Score exposing (GameResult, Score, emptyGameResult, updatePlayer, updateRating, updateSuggestion)
import Win.WinningView as WinningView


type alias Model =
    { board : Board Msg
    , startTime : Posix
    , endTime : Posix
    , highScores : WebData (List Score)
    , submittedScoreResponse : WebData ()
    , url : Url
    , key : Key
    , formData : GameResult
    , ratingState : Rating.State
    , device : Device
    , nextSeed : Random.Seed
    , categories : List Category
    , dauberColor : Dot.Color
    , boardColor : BoardStyle.Color
    , systemTheme : Theme
    , selectedTheme : Theme
    , class : String -> Html.Attribute Msg
    , showTopics : Bool
    , showOptions : Bool
    }


type alias Flags =
    { dark : Bool
    }


init : Flags -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        theme =
            Theme.systemTheme flags.dark
    in
    ( { board = []
      , startTime = Time.millisToPosix 0
      , endTime = Time.millisToPosix 0
      , highScores = RemoteData.NotAsked
      , submittedScoreResponse = RemoteData.NotAsked
      , url = url
      , key = key
      , formData = emptyGameResult
      , ratingState = Rating.initialState
      , device = defaultDevice
      , nextSeed = Random.initialSeed 0
      , categories = []
      , dauberColor = Blue
      , boardColor = OriginalRed
      , systemTheme = theme
      , selectedTheme = theme
      , class = Theme.themedClass theme
      , showTopics = False
      , showOptions = False
      }
    , Cmd.batch [ Task.perform GotCurrentTime Time.now, Task.perform GotViewportSize Browser.Dom.getViewport ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleCheck squareToToggle ->
            let
                ( updatedBoard, nextSeed ) =
                    model.board |> toggleSquareInList model.nextSeed model.dauberColor squareToToggle
            in
            ( { model | board = updatedBoard, nextSeed = nextSeed }
            , if updatedBoard |> Bingo.isWinner then
                Cmd.batch [ Task.perform GotEndTime Time.now, Requests.getHighScores model.url ]

              else
                Cmd.none
            )

        GotCurrentTime time ->
            let
                seed =
                    if model.nextSeed == Random.initialSeed 0 then
                        Time.posixToMillis time |> Random.initialSeed

                    else
                        model.nextSeed

                ( board, next ) =
                    seed |> randomBoard model.categories
            in
            ( { model
                | board = board
                , nextSeed = next
                , startTime = time
                , endTime = Time.millisToPosix 0
                , formData = emptyGameResult
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
                formData =
                    model.formData

                gameResultWithScore =
                    { formData | score = Time.posixToMillis model.endTime - Time.posixToMillis model.startTime }
            in
            ( { model | formData = formData }, Requests.submitScore model.url gameResultWithScore )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        Player initials ->
            ( { model | formData = updatePlayer initials model.formData }, Cmd.none )

        Suggestion suggestion ->
            ( { model | formData = updateSuggestion (Just suggestion) model.formData }, Cmd.none )

        RatingMsg ratingMsg ->
            let
                newRatingState =
                    Rating.update ratingMsg model.ratingState
            in
            ( { model | ratingState = newRatingState, formData = updateRating (Rating.get newRatingState) model.formData }, Cmd.none )

        GotViewportSize viewport ->
            ( { model | device = viewportToDevice viewport }, Cmd.none )

        WindowResized width height ->
            ( { model | device = classifyDevice { height = height, width = width } }, Cmd.none )

        CategoryToggled category ->
            ( { model
                | categories =
                    toggleCategory category
                        model.categories
              }
            , Task.perform GotCurrentTime Time.now
            )

        DauberSelected color ->
            ( { model | dauberColor = color }, Cmd.none )

        BoardColorSelected color ->
            ( { model | boardColor = color }, Cmd.none )

        UpdateTheme theme ->
            ( { model | selectedTheme = theme, class = Theme.themedClass theme }, Cmd.none )

        ToggleTopics ->
            ( { model | showTopics = not model.showTopics }, Cmd.none )

        ToggleOptions ->
            ( { model | showOptions = not model.showOptions }, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "BINGO!"
    , body =
        [ div
            [ model.class "body" ]
            [ bodyView model, Footer.footerView model ]
        ]
    }


bodyView model =
    let
        gameFinished =
            Bingo.isWinner model.board

        content =
            if gameFinished then
                WinningView.winningView

            else
                GameView.boardGridView
    in
    div
        [ model.class "body-container"
        ]
        [ MobileHeader.view model
        , CategoryView.categoryView model "categoryWrapper" (not gameFinished)
        , boardView model content
        , Options.view model "game-options-container" (not gameFinished)
        ]


boardView : Model -> (Model -> Html Msg) -> Html Msg
boardView model content =
    let
        { class } =
            model
    in
    div [ style "justify-self" "center" ]
        [ div [ class "bingoCard", class (model.boardColor |> BoardStyle.colorClass) ]
            [ div [ class "boardHeaderTopStyle" ] [ text "conference call" ]
            , div [ class "boardHeaderStyle" ]
                ([ "B", "I", "N", "G", "O" ]
                    |> List.map
                        (\letter -> div [] [ text letter ])
                )
            , content model
            ]
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
