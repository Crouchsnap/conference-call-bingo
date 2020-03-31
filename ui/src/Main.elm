module Main exposing (Model, init, main, update, view)

import Bingo exposing (randomBoard)
import Board exposing (Board)
import BoardColorView
import BoardStyle exposing (Color(..))
import Browser
import Browser.Dom exposing (Viewport)
import Browser.Events
import Browser.Navigation as Navigation exposing (Key, load, pushUrl)
import CategoryView
import DauberView
import Dot exposing (Color(..), Dot)
import Element exposing (Device, DeviceClass(..), classifyDevice)
import GameResultForm
import Html exposing (Html, a, br, button, div, h1, h2, input, label, text, textarea)
import Html.Attributes exposing (class, disabled, for, href, id, maxlength, minlength, name, style, target, title)
import Html.Events exposing (onClick, onInput)
import Msg exposing (Msg(..))
import Random
import Rating
import RemoteData exposing (WebData)
import Requests exposing (errorToString)
import Score exposing (GameResult, Score, emptyGameResult, updatePlayer, updateRating, updateSuggestion)
import Square exposing (Category(..), Square, toggleCategory, toggleSquareInList)
import Star
import Style exposing (..)
import Task
import Time exposing (Posix)
import TimeFormatter
import TopScoresView
import Url exposing (Url)
import ViewportHelper exposing (defaultDevice, viewportToDevice)


type alias Model =
    { board : Board
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
    }


init : () -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
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
            ( { model | submittedScoreResponse = response }, Cmd.none )

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

        CategoryToggled category _ ->
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


view : Model -> Browser.Document Msg
view model =
    { title = "BINGO!"
    , body =
        (if Bingo.isWinner model.board then
            winningView model

         else
            [ gameView model ]
        )
            ++ [ div
                    footerStyle
                    [ text "Want to contribute? Check out our ", a [ target "_blank", href "https://github.com/Crouchsnap/conference-call-bingo" ] [ text "Github!" ] ]
               ]
    }


winningView : Model -> List (Html Msg)
winningView model =
    winningScoreHeader model
        ++ [ div
                (winningViewContainerStyle ++ [ id "table" ])
                [ GameResultForm.submitGame model
                , TopScoresView.topScoreView model
                ]
           ]


winningScoreHeader : Model -> List (Html Msg)
winningScoreHeader { startTime, endTime } =
    [ h1
        winningScoreHeaderStyle
        [ text "🎉 Bingo! 🎉" ]
    , h2
        winningScoreHeaderStyle
        [ text ("Your winning time: " ++ TimeFormatter.winingTimeDifference startTime endTime) ]
    ]


gameView model =
    div
        [ style "display" "grid"
        , style "grid-template-columns" "auto 55.75rem auto"
        , style "padding" "1rem"
        ]
        [ CategoryView.categoryView, div [ style "justify-self" "center" ] (boardView model), gameStyleSelectorView model ]


gameStyleSelectorView model =
    div [ style "display" "flex", style "flex-direction" "column", style "max-width" "18rem" ]
        [ BoardColorView.boardColorView model, DauberView.dauberView model ]


boardView : Model -> List (Html Msg)
boardView model =
    let
        fordBlue =
            if model.boardColor == FordBlue then
                " fordBlueDark"

            else
                ""
    in
    [ div [ class ("bingoCard" ++ fordBlue), style "background" (model.boardColor |> BoardStyle.hexColor) ]
        [ div [ class "boardHeaderTopStyle" ] [ text "conference call" ]
        , div [ class "boardHeaderStyle" ]
            ([ "B", "I", "N", "G", "O" ]
                |> List.map
                    (\letter -> div [] [ text letter ])
            )
        , div
            [ class "boardTableStyle" ]
            (List.indexedMap
                (\index square ->
                    div
                        squareContainerStyle
                        [ div
                            (squareStyle index ++ [ onClick (ToggleCheck square), class "boardBorder" ])
                            ((if square.category == Center then
                                [ Star.star, div [ style "position" "relative", style "z-index" "10", style "text-transform" "uppercase" ] [ text square.text ] ]

                              else
                                [ text square.text ]
                             )
                                ++ (square.dots
                                        |> List.map (\dot -> dotDiv dot)
                                   )
                            )
                        ]
                )
                model.board
            )
        ]
    ]


dotDiv : Dot -> Html msg
dotDiv dot =
    div
        (dotStyle dot)
        []


main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.batch [ Browser.Events.onResize WindowResized ]
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
