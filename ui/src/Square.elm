module Square exposing (Square, allSquares, centerSquare, falseSquare, toggleSquare, toggleSquareInList)


type alias Square =
    { text : String, checked : Bool }


falseSquare : String -> Square
falseSquare text =
    Square text False


centerSquare : Square
centerSquare =
    Square "Free ⭐️ Space" True


allSquares : List Square
allSquares =
    [ falseSquare "\"Mute your phone please\""
    , falseSquare "5 seconds awkward silence"
    , falseSquare "Sound of telephone ringing"
    , falseSquare "(sigh)"
    , falseSquare "\"Ok, let's get started\""
    , falseSquare "(coughing)"
    , falseSquare "Child or animal noise"
    , falseSquare "People talking at the same time"
    , falseSquare "\"This was shared ahead of time\""
    , falseSquare "Echo noise or feedback"
    , falseSquare "Sound of someone typing"
    , falseSquare "\"Can you repeat that?\""
    , falseSquare "\"Can you share that by email?\""
    , falseSquare "Sound of background conversation"
    , falseSquare "\"...technical difficulties.\""
    , falseSquare "5th \"Thank you\""
    , falseSquare "\"Time is just about up\""
    , falseSquare "Powerpoint malfunction"
    , falseSquare "\"I was on mute\""
    , falseSquare "\"Can you see my screen?\""
    , falseSquare "Unintended interruption"
    , falseSquare "\"__, can you comment?\""
    , falseSquare "\"I need to step out\""
    , falseSquare "\"Go further\""
    , falseSquare "\"Can you share?\""
    , falseSquare "\"You're not sharing\""
    , falseSquare "Any acronym"
    , falseSquare "A well known acronym repurposed by Ford"
    , falseSquare "\"VIN number\""
    , falseSquare "\"MVP\""
    , falseSquare "Any vehicle program number"
    , falseSquare "Roundtable introductions"
    , falseSquare "5 or more Webex beeps"
    , falseSquare "Pet or child on webcam"
    , falseSquare "University logo on webcam"
    , falseSquare "\"LL_ approval needed\""
    , falseSquare "\"What team are you from?\""
    , falseSquare "\"double mute\""
    , falseSquare "Any _aaS acronym"
    , falseSquare "Reference to people as resources"
    , falseSquare "\"I'll send out the deck\""
    , falseSquare "\"Bingo!\""
    ]


toggleSquareInList : Square -> List Square -> List Square
toggleSquareInList squareToToggle squares =
    List.map
        (\square ->
            if square == squareToToggle then
                toggleSquare square

            else
                square
        )
        squares


toggleSquare : Square -> Square
toggleSquare square =
    { square | checked = not square.checked }
