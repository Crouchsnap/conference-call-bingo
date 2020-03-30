module Dot exposing (Color(..), Dot, Offset, Shape, defaultDot, dot, hexColor, round, zeroOffset)

import Random
import RandomHelper exposing (randomOffset)


type Color
    = Blue
    | Keylime
    | Magenta
    | Ruby
    | Tangerine


type alias Offset =
    { x : Int, y : Int }


type alias Shape =
    { x : Int, y : Int }


type alias Dot =
    { offset : Offset
    , shape : Shape
    , color : Color
    }


zeroOffset =
    Offset 0 0


round =
    Shape 0 0


defaultDot =
    Dot zeroOffset round Blue


hexColor : Color -> String
hexColor color =
    case color of
        Blue ->
            "#095CFF66"

        Keylime ->
            "#79BA1066"

        Magenta ->
            "#FA00C366"

        Ruby ->
            "#D31336"

        Tangerine ->
            "#ED9E28"


dot : Random.Seed -> Color -> ( Dot, Random.Seed )
dot seed color =
    let
        ( offset, nextSeed ) =
            randomOffset seed 25
    in
    ( Dot offset round color, nextSeed )
