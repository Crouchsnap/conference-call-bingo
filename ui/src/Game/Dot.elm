module Game.Dot exposing (Color(..), Dot, Offset, Shape, class, defaultDot, dot, hexColor, round, toString, zeroOffset)

import Game.RandomHelper exposing (randomOffset, randomShape)
import Random


type Color
    = Blue
    | Keylime
    | Magenta
    | Ruby
    | Tangerine


type alias Offset =
    { x : Int, y : Int }


type alias Shape =
    { topLeft : Int, topRight : Int, bottomRight : Int, bottomLeft : Int }


type alias Dot =
    { offset : Offset
    , shape : Shape
    , color : Color
    }


zeroOffset =
    Offset 0 0


round =
    Shape 50 50 50 50


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
            "#D3133666"

        Tangerine ->
            "#ED9E2866"


class : Color -> String
class color =
    case color of
        Blue ->
            "blue-dauber"

        Keylime ->
            "keylime-dauber"

        Magenta ->
            "magenta-dauber"

        Ruby ->
            "ruby-dauber"

        Tangerine ->
            "tangerine-dauber"


toString : Color -> String
toString color =
    case color of
        Blue ->
            "blue"

        Keylime ->
            "keylime"

        Magenta ->
            "magenta"

        Ruby ->
            "ruby"

        Tangerine ->
            "tangerine"


dot : Random.Seed -> Color -> ( Dot, Random.Seed )
dot seed color =
    let
        ( offset, nextForShape ) =
            randomOffset seed 25

        ( shape, nextSeed ) =
            randomShape nextForShape 3
    in
    ( Dot offset shape color, nextSeed )
