module Main exposing (Model, init, main, update, view)

import Bingo exposing (randomBoard)
import Board exposing (Board)
import Browser
import Browser.Dom exposing (Viewport)
import Browser.Events
import Browser.Navigation as Navigation exposing (Key, load, pushUrl)
import Element exposing (Device, DeviceClass(..), classifyDevice)
import Html exposing (Html, a, br, button, div, h1, h2, input, label, text, textarea)
import Html.Attributes exposing (disabled, for, href, id, maxlength, minlength, name, target, title)
import Html.Events exposing (onClick, onInput)
import List.Extra
import Msg exposing (Msg(..))
import Random
import Rating
import RemoteData exposing (WebData)
import Requests exposing (errorToString)
import Score exposing (GameResult, Score, emptyGameResult)
import Square exposing (Square, toggleSquareInList)
import Style exposing (..)
import Task
import Time exposing (Posix)
import TimeFormatter
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
    , dotOffsets : List ( Int, Int )
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
      , dotOffsets = List.range 0 24 |> List.map (\_ -> ( 0, 0 ))
      }
    , Cmd.batch [ Task.perform GotCurrentTime Time.now, Task.perform GotViewportSize Browser.Dom.getViewport ]
    )


view : Model -> Browser.Document Msg
view model =
    { title = "BINGO!"
    , body =
        [ h1
            titleStyle
            [ text "CONFERENCE CALL BINGO!" ]
        , div
            subTitleStyle
            [ text "Powered by ", a [ target "_blank", href "https://www.fordlabs.com" ] [ text "FordLabs" ] ]
        , if model.device.class == Desktop || model.device.class == BigDesktop then
            div subTitleStyle [ text "Now better on mobile!" ]

          else
            div [] []
        ]
            ++ (if Bingo.isWinner model.board then
                    winningView model

                else
                    boardView model
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
                [ submitGame model
                , topScoreView model
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


topScoreView : Model -> Html Msg
topScoreView model =
    div topScoreContainerStyle
        [ div
            topScoreTableStyle
            ([ div
                topScoreHeaderStyle
                [ text "High Scores" ]
             , div
                topScoreColumnHeaderStyle
                [ text "Rank" ]
             , div
                topScoreColumnHeaderStyle
                [ text "Player" ]
             , div
                topScoreColumnHeaderStyle
                [ text "Time" ]
             ]
                ++ (case model.highScores of
                        RemoteData.Success scores ->
                            let
                                yourScore =
                                    Score.yourScore (TimeFormatter.timeDifference model.startTime model.endTime)

                                scoresWithYourRow =
                                    Score.insertYourScore yourScore scores

                                yourScoreTupe =
                                    scoresWithYourRow
                                        |> List.Extra.find (\( _, score ) -> score == yourScore)
                                        |> Maybe.withDefault ( -1, Score -1 "" )

                                yourRow =
                                    if (yourScoreTupe |> Tuple.first) > 9 then
                                        [ yourScoreTupe ]

                                    else
                                        []

                                rows =
                                    List.append (scoresWithYourRow |> List.take 10) yourRow
                                        |> List.map (scoreRow yourScore)
                                        |> List.concat
                            in
                            rows

                        _ ->
                            []
                   )
            )
        , newGameButton
        ]


scoreRow : Score -> ( Int, Score ) -> List (Html Msg)
scoreRow yourScore ( rank, score ) =
    let
        calculatedFormat =
            if score == yourScore then
                yourScoreRowStyle

            else
                scoreRowStyle
    in
    [ div
        calculatedFormat
        [ text (String.fromInt (rank + 1)) ]
    , div
        calculatedFormat
        [ text score.player ]
    , div
        calculatedFormat
        [ text (TimeFormatter.winingTime score.score) ]
    ]


newGameButton =
    button (newButtonStyle ++ [ onClick NewGame ]) [ text "Play Again" ]


submitGame model =
    div
        submitGameStyle
        (case model.submittedScoreResponse of
            RemoteData.NotAsked ->
                [ div
                    submitScoreFormStyle
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
                            (playerInputStyle
                                ++ [ name "player"
                                   , title "Enter 2 to 4 Characters"
                                   , minlength 2
                                   , maxlength 4
                                   , onInput Player
                                   ]
                            )
                            []
                        ]
                    , label [ for "suggestion" ] [ text "What Square would you like to add?", br [] [], text "Or any other feedback?" ]
                    , div []
                        [ textarea
                            (suggestionInputStyle
                                ++ [ name "suggestion"
                                   , title "Enter a suggestion (max 100 characters)"
                                   , maxlength 100
                                   , onInput Suggestion
                                   ]
                            )
                            []
                        ]
                    , div []
                        [ let
                            disable =
                                not (isFormValid model.formData)
                          in
                          button
                            (submitScoreButtonStyle disable
                                ++ [ disabled disable
                                   , onClick SubmitGame
                                   ]
                            )
                            [ text "Submit Your Score" ]
                        ]
                    ]
                ]

            RemoteData.Success _ ->
                [ div
                    submittedMessageStyle
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
    let
        first12 =
            List.take 12 model.dotOffsets

        last12 =
            List.drop 12 model.dotOffsets

        withCenter =
            first12 ++ [ ( 0, 0 ) ] ++ last12

        squaresAndOffsets =
            List.map2 (\square offsets -> ( square, offsets )) model.board withCenter
    in
    [ div
        (boardTableStyle
            model.device
        )
        (List.map
            (\( square, offset ) ->
                div
                    squareContainerStyle
                    [ div
                        (squareStyle square ++ [ onClick (ToggleCheck square) ])
                        [ text square.text ]
                    ]
            )
            squaresAndOffsets
        )
    ]


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
                Cmd.batch [ Task.perform GotEndTime Time.now, Requests.getHighScores model.url ]

              else
                Cmd.none
            )

        GotCurrentTime time ->
            let
                ( board, next ) =
                    Time.posixToMillis time |> randomBoard

                ( offsets, nextNext ) =
                    randomOffset next
            in
            ( { model
                | board = board
                , nextSeed = nextNext
                , startTime = time
                , endTime = Time.millisToPosix 0
                , formData = emptyGameResult
                , ratingState = Rating.initialState
                , submittedScoreResponse = RemoteData.NotAsked
                , dotOffsets = offsets
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

        GotViewportSize viewport ->
            ( { model | device = viewportToDevice viewport }, Cmd.none )

        WindowResized width height ->
            ( { model | device = classifyDevice { height = height, width = width } }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


randomOffset : Random.Seed -> ( List ( Int, Int ), Random.Seed )
randomOffset seed =
    let
        generator =
            Random.int -25 25

        ( xs, nextForY ) =
            Random.step (Random.list 48 generator) seed

        ( ys, next ) =
            Random.step (Random.list 48 generator) nextForY

        offsets =
            List.map2 Tuple.pair xs ys
    in
    ( offsets, next )


main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.batch [ Browser.Events.onResize WindowResized ]
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
