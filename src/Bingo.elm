module Bingo exposing (..)


type alias Square =
    { value : String, checked : Bool }


falseSquare text =
    Square text False


type alias Board =
    List Square


allSquares =
    [ falseSquare "Mute your phone please"
    , falseSquare "5 seconds awkward silence"
    , falseSquare "People talking at the same time"
    , falseSquare "Sound of telephone ringing"
    , falseSquare "(sigh)"
    , falseSquare "Ok, let's get started"
    , falseSquare "(coughing)"
    , falseSquare "Child or animal noise"
    ]


board : Board
board =
    []
