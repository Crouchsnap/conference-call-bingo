module Game.Dot exposing (Color(..), Dot, Offset, Shape, class, colorDecoder, decoder, defaultDot, dot, encode, hexColor, round, toString, zeroOffset)

import Game.RandomHelper exposing (randomOffset, randomShape)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline
import Json.Encode as Encode
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
            "rgb(139, 188, 206)"

        Keylime ->
            "rgb(152, 210, 177)"

        Magenta ->
            "rgb(234, 207, 126)"

        Ruby ->
            "rgb(241, 172, 130)"

        Tangerine ->
            "rgb(218, 218, 219)"


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


colorDecoder : Decoder Color
colorDecoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "blue" ->
                        Decode.succeed Blue

                    "keylime" ->
                        Decode.succeed Keylime

                    "magenta" ->
                        Decode.succeed Magenta

                    "ruby" ->
                        Decode.succeed Ruby

                    "tangerine" ->
                        Decode.succeed Tangerine

                    _ ->
                        Decode.succeed Blue
            )


decoder : Decoder Dot
decoder =
    Decode.succeed Dot
        |> Json.Decode.Pipeline.optional "offset" decodeOffset { x = 0, y = 0 }
        |> Json.Decode.Pipeline.optional "shape" decodeShape (Shape 0 0 0 0)
        |> Json.Decode.Pipeline.optional "color" colorDecoder Blue


encode : Dot -> Encode.Value
encode value =
    Encode.object
        [ ( "offset", offsetEncoder <| value.offset )
        , ( "shape", shapeEncoder <| value.shape )
        , ( "color", Encode.string <| toString <| value.color )
        ]


shapeEncoder : Shape -> Encode.Value
shapeEncoder shape =
    Encode.object
        [ ( "topLeft", Encode.int <| shape.topLeft )
        , ( "topRight", Encode.int <| shape.topRight )
        , ( "bottomRight", Encode.int <| shape.bottomRight )
        , ( "bottomLeft", Encode.int <| shape.bottomLeft )
        ]


offsetEncoder : Offset -> Encode.Value
offsetEncoder offset =
    Encode.object
        [ ( "x", Encode.int <| offset.x )
        , ( "y", Encode.int <| offset.y )
        ]


decodeShape : Decoder Shape
decodeShape =
    Decode.succeed Shape
        |> Json.Decode.Pipeline.optional "topLeft" Decode.int 0
        |> Json.Decode.Pipeline.optional "topRight" Decode.int 0
        |> Json.Decode.Pipeline.optional "bottomRight" Decode.int 0
        |> Json.Decode.Pipeline.optional "bottomLeft" Decode.int 0


decodeOffset : Decoder Offset
decodeOffset =
    Decode.succeed Offset
        |> Json.Decode.Pipeline.optional "x" Decode.int 0
        |> Json.Decode.Pipeline.optional "y" Decode.int 0
