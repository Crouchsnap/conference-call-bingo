module Main exposing (..)

import Bingo exposing (Board, Square, randomBoard, toggleSquareInList)
import Browser
import Html exposing (Html, div, text)
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
        [ div [ style "display" "grid", style "grid-template-columns" "repeat(5, 100px)", style "grid-template-rows" "repeat(5, 100px)" ]
            (List.map
                (\square ->
                    div
                        [ if square.checked then
                            style "color" "red"

                          else
                            style "color" "black"
                        , onClick (ToggleCheck square)
                        ]
                        [ text square.text ]
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
