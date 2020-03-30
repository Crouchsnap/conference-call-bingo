module RandomHelper exposing (randomOffset, randomOffsets)

import Random


randomOffsets : Random.Seed -> ( List ( Int, Int ), Random.Seed )
randomOffsets seed =
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
