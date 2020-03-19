module Bingo exposing (..)


type alias Square =
    { value : String, checked : Bool }


type alias Board =
    List Square


falseSquare : String -> Square
falseSquare text =
    Square text False


allSquares : List Square
allSquares =
    List.map falseSquare
        [ "\"Mute your phone please\""
        , "\"Is ___ on the call?\""
        , "5 seconds awkward silence"
        , "People talking at the same time"
        , "Sound of telephone ringing"
        , "(sigh)"
        , "\"Ok, let's get started\""
        , "(coughing)"
        , "Child or animal noise"
        , "\"This was shared ahead of time\""
        , "Echo noise or feedback"
        , "Sound of someone typing"
        , "\"Can you repeat that?\""
        , "\"Can you share that by email?\""
        , "Sound of background conversation"
        , "\"...technical difficulties\""
        , "5th \"Thank you\""
        , "\"Time is just about up\""
        , "Powerpoint malfunction"
        , "\"I was on mute\""
        , "\"Can you see my screen?\""
        , "Unintended interruption"
        , "\"___ can you comment?\""
        , "\"I need to step out...\""
        ]


board : Board
board =
    []
