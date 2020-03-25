module Main exposing (Model, Msg(..), init, main, update, view)

import Bingo exposing (randomBoard)
import Board exposing (Board)
import Browser
import Browser.Navigation as Navigation exposing (Key, load, pushUrl)
import Html exposing (Html, a, br, button, div, h1, h2, h3, input, label, li, text, textarea)
import Html.Attributes exposing (disabled, for, href, id, maxlength, minlength, name, style, title)
import Html.Events exposing (onClick, onInput)
import Rating
import RemoteData exposing (WebData)
import Requests exposing (errorToString)
import Score exposing (GameResult, Score, emptyGameResult)
import Square exposing (Square, toggleSquareInList)
import Task
import Time exposing (Posix)
import TimeFormatter
import Url exposing (Url)


type Msg
    = GotCurrentTime Time.Posix
    | GotEndTime Time.Posix
    | ToggleCheck Square
    | NewGame
    | HighScoresResponse (WebData (List Score))
    | GameResponse (WebData ())
    | SubmitGame
    | RequestHighScores
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | Player String
    | Suggestion String
    | RatingMsg Rating.Msg
    | NoOp


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
    }


view model =
    { title = "BINGO!"
    , body =
        [ h1
            [ style "text-align" "center"
            , style "font-family" "sans-serif"
            ]
            [ text "CONFERENCE CALL BINGO!" ]
        , div
            [ style "font-size" "12"
            , style "text-align" "center"
            , style "font-family" "sans-serif"
            , style "padding-bottom" "8px"
            ]
            [ text "Powered by ", a [ href "https://www.fordlabs.com" ] [ text "FordLabs" ] ]
        ]
            ++ (if Bingo.isWinner model.board then
                    winningView model

                else
                    boardView model
               )
    }


winningView : Model -> List (Html Msg)
winningView model =
    winningScoreHeader model
        ++ [ div
                [ id "table"
                , style "display" "grid"
                , style "grid-template-columns" "repeat(2, 1fr)"
                , style "min-height" "25rem"
                ]
                [ submitGame model
                , topScoreView model
                ]
           ]


winningScoreHeader model =
    [ h1
        [ style "text-align" "center"
        , style "font-family" "sans-serif"
        ]
        [ text "🎉 Bingo! 🎉" ]
    , h2
        [ style "text-align" "center"
        , style "font-family" "sans-serif"
        ]
        [ text ("Your winning time: " ++ TimeFormatter.winingTimeDifference model.startTime model.endTime) ]
    ]


topScoreView model =
    div [ style "font-family" "sans-serif", style "justify-content" "left", style "position" "relative" ]
        [ div
            [ style "display" "grid"
            , style "grid-template-columns" "repeat(2, 7rem)"
            , style "margin-left" "1.5rem"
            ]
            ([ div
                [ style "text-align" "center"
                , style "grid-column" "span 2"
                , style "font-size" "1.5rem"
                , style "margin-bottom" ".8rem"
                ]
                [ text "High Scores" ]
             , div
                [ style "font-size" "1.5rem"
                , style "text-align" "center"
                , style "border" "1px solid"
                , style "padding" "3px"
                ]
                [ text "Player" ]
             , div
                [ style "font-size" "1.5rem"
                , style "text-align" "center"
                , style "border" "1px solid"
                , style "padding" "3px"
                ]
                [ text "Time" ]
             ]
                ++ (case model.highScores of
                        RemoteData.Success scores ->
                            scores
                                |> List.take 10
                                |> List.map scoreRow
                                |> List.concat

                        _ ->
                            []
                   )
            )
        , newGameButton
        ]


scoreRow score =
    [ div
        [ style "font-size" "1rem"
        , style "border" "1px solid"
        , style "padding" "3px"
        ]
        [ text score.player ]
    , div
        [ style "font-size" "1rem"
        , style "border" "1px solid"
        , style "padding" "3px"
        ]
        [ text (TimeFormatter.winingTime score.score) ]
    ]


newGameButton =
    button
        [ style "background-color" "#002F6CCC"
        , style "color" "white"
        , style "border" "none"
        , style "font-size" "18px"
        , style "border-radius" "5px"
        , style "cursor" "pointer"
        , style "padding" "20px"
        , style "position" "absolute"
        , style "bottom" "0"
        , style "left" "0"
        , style "margin-left" "4.5rem"
        , onClick NewGame
        ]
        [ text "Play Again" ]


submitGame model =
    div
        [ style "text-align" "center"
        , style "margin-right" "1.5rem"
        ]
        (case model.submittedScoreResponse of
            RemoteData.NotAsked ->
                [ div
                    [ style "justify-content" "right"
                    , style "display" "grid"
                    , style "grid-template-columns" "repeat(2, auto-fill)"
                    , style "grid-gap" "10px"
                    , style "text-align" "center"
                    , style "font-family" "sans-serif"
                    , style "font-size" "1.5rem"
                    , style "box-shadow" "inset 0 0 0 10px rgba(0, 255, 0, 0.5);"
                    ]
                    [ div [] [ text "Rate Your Experience" ]
                    , Html.map RatingMsg
                        (Rating.styleView
                            [ ( "color", "gold" )
                            , ( "font-size", "2.5rem" )
                            , ( "cursor", "pointer" )
                            ]
                            model.ratingState
                        )
                    , label [ for "player" ] [ text "Initials" ]
                    , div []
                        [ input
                            [ name "player"
                            , title "Enter 2 to 4 Characters"
                            , style "padding" "5px"
                            , style "border-radius" "5px"
                            , style "max-width" "7rem"
                            , style "font-family" "sans-serif"
                            , style "font-size" "1.2rem"
                            , style "text-align" "center"
                            , minlength 2
                            , maxlength 4
                            , onInput Player
                            ]
                            []
                        ]
                    , label [ for "suggestion" ] [ text "What Square would you like to add?", br [] [], text "Or any other feedback?" ]
                    , div []
                        [ textarea
                            [ name "suggestion"
                            , title "Enter a suggestion (max 100 characters)"
                            , style "padding" "5px"
                            , style "border-radius" "5px"
                            , style "max-width" "30rem"
                            , style "min-height" "10rem"
                            , style "font-family" "sans-serif"
                            , style "font-size" "1.2rem"
                            , maxlength 100
                            , onInput Suggestion
                            ]
                            []
                        ]
                    , div []
                        [ let
                            disable =
                                not (isFormValid model.formData)

                            backgroundColor =
                                if disable then
                                    "#002F6C99"

                                else
                                    "#002F6CCC"
                          in
                          button
                            [ style "background-color" backgroundColor
                            , style "color" "white"
                            , style "border" "none"
                            , style "font-size" "18px"
                            , style "border-radius" "5px"
                            , style "cursor" "pointer"
                            , style "padding" "20px"
                            , style "max-width" "10rem"
                            , disabled disable
                            , onClick SubmitGame
                            ]
                            [ text "Submit Your Score" ]
                        ]
                    ]
                ]

            RemoteData.Success _ ->
                [ div
                    [ style "font-family" "sans-serif"
                    , style "font-size" "1.5rem"
                    ]
                    [ text "😀Thanks for your feedback!😀" ]
                ]

            RemoteData.Failure error ->
                [ text ("Failed to submit " ++ errorToString error) ]

            RemoteData.Loading ->
                [ text "Submitting" ]
        )


isFormValid : GameResult -> Bool
isFormValid gameResult =
    let
        initialsLength =
            String.length gameResult.player
    in
    initialsLength > 1 && initialsLength < 5 && gameResult.rating > 0


boardView : Model -> List (Html Msg)
boardView model =
    [ div
        [ style "justify-content" "center"
        , style "padding-top" "5px"
        , style "display" "grid"
        , style "grid-template-columns" "repeat(5, 100px)"
        , style "grid-template-rows" "repeat(5, 100px)"
        , style "grid-gap" "10px"
        , style "font-family" "sans-serif"
        ]
        (List.map
            (\square ->
                div
                    [ style "display" "table"
                    , style "height" "100%"
                    , style "width" "100%"
                    ]
                    [ div
                        [ if square.checked then
                            style "background-color" "red"

                          else
                            style "background-color" "#002F6CCC"
                        , onClick (ToggleCheck square)
                        , style "color" "white"
                        , style "border-radius" "5px"
                        , style "cursor" "pointer"
                        , style "vertical-align" "middle"
                        , style "text-align" "center"
                        , style "display" "table-cell"
                        , style "padding" "5px"
                        ]
                        [ text square.text ]
                    ]
            )
            model.board
        )
    ]


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
      }
    , Task.perform GotCurrentTime Time.now
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleCheck squareToToggle ->
            let
                updatedBoard =
                    model.board |> toggleSquareInList squareToToggle
            in
            ( { model | board = updatedBoard }
            , if updatedBoard |> Bingo.isWinner then
                Cmd.batch [ Task.perform GotEndTime Time.now, Requests.getHighScores model.url HighScoresResponse ]

              else
                Cmd.none
            )

        GotCurrentTime time ->
            ( { model
                | board = Time.posixToMillis time |> randomBoard
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
            ( model, Requests.getHighScores model.url HighScoresResponse )

        SubmitGame ->
            let
                formData =
                    model.formData

                gameResultWithScore =
                    { formData | score = Time.posixToMillis model.endTime - Time.posixToMillis model.startTime }
            in
            ( { model | formData = formData }, Requests.submitScore model.url GameResponse gameResultWithScore )

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
            let
                formData =
                    model.formData
            in
            ( { model | formData = { formData | player = initials } }, Cmd.none )

        Suggestion suggestion ->
            let
                formData =
                    model.formData
            in
            ( { model | formData = { formData | suggestion = Just suggestion } }, Cmd.none )

        RatingMsg ratingMsg ->
            let
                newRatingState =
                    Rating.update ratingMsg model.ratingState

                formData =
                    model.formData
            in
            ( { model | ratingState = newRatingState, formData = { formData | rating = Rating.get newRatingState } }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
