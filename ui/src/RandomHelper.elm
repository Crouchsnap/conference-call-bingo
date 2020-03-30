module RandomHelper exposing (randomOffset)

import Random


randomOffset : Random.Seed -> Int -> ( { x : Int, y : Int }, Random.Seed )
randomOffset seed range =
    let
        generator =
            Random.int -range range

        ( x, nextForY ) =
            Random.step generator seed

        ( y, next ) =
            Random.step generator nextForY
    in
    ( { x = x, y = y }, next )
