module Main exposing (..)

import Bingo exposing (Board, Square, randomBoard, toggleSquareInList)
import Browser
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Task
import Time


type Msg
    = GotCurrentTime Time.Posix
    | ToggleCheck Square


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
                    div [ style "display" "table" ]
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
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( [], Task.perform GotCurrentTime Time.now )


update msg model =
    case msg of
        ToggleCheck squareToToggle ->
            ( model
                |> toggleSquareInList squareToToggle
            , Cmd.none
            )

        GotCurrentTime time ->
            ( Time.posixToMillis time |> randomBoard, Cmd.none )


main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
