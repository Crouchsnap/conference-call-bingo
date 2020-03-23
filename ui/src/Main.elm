module Main exposing (Model, Msg(..), init, main, update, view)

import Bingo exposing (randomBoard)
import Board exposing (Board)
import Browser
import Html exposing (Html, a, button, div, h1, text)
import Html.Attributes exposing (href, style)
import Html.Events exposing (onClick)
import Square exposing (Square, toggleSquareInList)
import Task
import Time


type Msg
    = GotCurrentTime Time.Posix
    | ToggleCheck Square
    | NewGame


type alias Model =
    Board


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
            ++ (if Bingo.isWinner model then
                    [ h1
                        [ style "text-align" "center"
                        , style "font-family" "sans-serif"
                        ]
                        [ text "Bingo!" ]
                    , div [ style "text-align" "center" ]
                        [ button
                            [ style "background-color" "#002F6CCC"
                            , style "color" "white"
                            , style "border" "none"
                            , style "font-size" "18px"
                            , style "border-radius" "5px"
                            , style "cursor" "pointer"
                            , style "padding" "20px"
                            , onClick NewGame
                            ]
                            [ text "Play Again" ]
                        ]
                    ]

                else
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
                            model
                        )
                    ]
               )
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( [], Task.perform GotCurrentTime Time.now )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleCheck squareToToggle ->
            ( model |> toggleSquareInList squareToToggle, Cmd.none )

        GotCurrentTime time ->
            ( Time.posixToMillis time |> randomBoard, Cmd.none )

        NewGame ->
            ( model, Task.perform GotCurrentTime Time.now )


main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
