module Main exposing (..)

import Browser
import Html exposing (Html, div, text)


type Msg
    = NoOp


type alias Model =
    String


view model =
    { title = "BINGO!"
    , body =
        [ div []
            [ text model ]
        ]
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( "some string", Cmd.none )


update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
