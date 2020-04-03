module Game.RandomHelper exposing (randomOffset, randomShape)

import Random


randomOffset : Random.Seed -> Int -> ( { x : Int, y : Int }, Random.Seed )
randomOffset seed range =
    let
        generator =
            Random.int (-50 - range) (-50 + range)

        ( x, nextForY ) =
            Random.step generator seed

        ( y, next ) =
            Random.step generator nextForY
    in
    ( { x = x, y = y }, next )


randomShape : Random.Seed -> Int -> ( { topLeft : Int, topRight : Int, bottomRight : Int, bottomLeft : Int }, Random.Seed )
randomShape seed range =
    let
        generator =
            Random.int (50 - range) (50 + range)

        ( topLeft, nextForTopRight ) =
            Random.step generator seed

        ( topRight, nextForBottomRight ) =
            Random.step generator nextForTopRight

        ( bottomRight, nextForBottomLeft ) =
            Random.step generator nextForBottomRight

        ( bottomLeft, next ) =
            Random.step generator nextForBottomLeft
    in
    ( { topLeft = topLeft, topRight = topRight, bottomRight = bottomRight, bottomLeft = bottomLeft }, next )
