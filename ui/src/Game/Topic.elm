module Game.Topic exposing (Topic(..), architect, av, coronaviri, encodeTopic, fordCredit, fordisms, generic, itfcg, kanye, toString, toggleTopic, topicDecoder, vehicleDevelopment)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import List.Extra


type Topic
    = Generic
    | Fordism
    | Credit
    | Coronavirus
    | AV
    | VehicleDevelopemnt
    | Kanye
    | Center
    | ITFCG
    | Architect


generic : List String
generic =
    [ "\"Mute your phone please\""
    , "\"WAT??\""
    , "5 seconds awkward silence"
    , "Sound of telephone ringing"
    , "(sigh)"
    , "\"Ok, let's get started\""
    , "(coughing)"
    , "Child or animal noise"
    , "People talking at the same time"
    , "\"This was shared ahead of time\""
    , "Echo noise or feedback"
    , "Sound of someone typing"
    , "\"Can you repeat that?\""
    , "\"Can you share that by email?\""
    , "Background talking"
    , "\"...technical difficulties\""
    , "5th \"Thank you\""
    , "\"Time is just about up\""
    , "Powerpoint malfunction"
    , "\"I was on mute\""
    , "\"Can you see my screen?\""
    , "Unintended interruption"
    , "\"__, can you comment?\""
    , "\"I need to step out\""
    , "\"Can you share?\""
    , "\"You're not sharing\""
    , "Any acronym"
    , "Roundtable intros"
    , "5 or more Webex beeps"
    , "Pet or child on webcam"
    , "University logo on webcam"
    , "\"What team are you from?\""
    , "\"double mute\""
    , "\"I'll send out the deck\""
    , "(eating sounds)"
    , "\"Bingo!\""
    , "\"I think ____ stepped away\""
    , "\"Can you hear me?\""
    , "(breathing directly into the microphone)"
    , "\"That's a great question...(deflection)\""
    , "Two people with the same first name present"
    , "\"Let's give everyone a few minutes to join\""
    , "Meeting started late"
    , "\"That’s it\""
    , "\"Any questions?\""
    , "\"Post in the chat\""
    , "\"Good Morning\\ Afternoon\\ Evening\""
    ]


fordisms : List String
fordisms =
    [ "\"VIN number\""
    , "\"MVP\""
    , "Reference to people as resources"
    , "Any vehicle program number"
    , "\"Go further\""
    , "\"LL_ approval needed\""
    , "Any _aaS acronym"
    , "A well known acronym repurposed by Ford"
    , "Now, near, far"
    , "\"I'll send a note\""
    , "First name reference to an exec you don't know"
    , "Five or more people named for Disciples present"
    , "The only mens' shirts visible are white or blue"
    , "\"The business\""
    , "Older GSR waxes on about anything pre-2012"
    , "\"Can you go back to ___?\""
    , "\"If we can move on...\""
    , "\"Let's take that off line\""
    , "\"I can't see what's on the screen\""
    , "Driving noises"
    ]


coronaviri : List String
coronaviri =
    [ "\"TP\""
    , "\"corona\""
    , "\"virus\""
    , "\"hand sanitizer\""
    , "\"wash your hands\""
    , "\"sick\""
    , "\"does ___ store have supplies?\""
    , "\"death rate\""
    , "\"recovery rate\""
    , "\"work from home\""
    , "\"face mask\""
    , "\"social distancing\""
    , "\"wait until we're back in the office\""
    , "\"stay-at-home order\""
    , "\"contact tracing\""
    , "\"test rate\""
    , "\"essential workers\""
    , "\"reopen\""
    , "\"In these uncertain times\""
    , "\"Now more then ever\""
    , "\"The new normal\""
    ]


av : List String
av =
    [ "\"lidar\""
    , "\"GEO fenced\""
    , "\"level 4\""
    , "\"level 5\""
    , "\"take overs\""
    , "\"future state\""
    , "\"radar\""
    , "\"sonar\""
    , "\"telemetry\""
    , "\"disengage- ments\""
    , "\"ride hailing\""
    ]


vehicleDevelopment : List String
vehicleDevelopment =
    [ "\"TLA (Three Letter Acronym)\""
    , "\"LL_ isn't in their TDR/EMM\""
    , "\"can we meet without LL_?\""
    , "\"Prefile\""
    , "Problem with OneNote"
    , "Admin Assistant stalls"
    , "Multiple people dictating to one person"
    , "\"IRL Spellcheck\""
    , "\"Trying to locate part in TeamCenter\""
    , "\"TeamCenter is slow today\""
    , "TeamCenter search returns nothing"
    , "search returns everything but what you want"
    , "\"Working Level\""
    , "presenter checks emails on screen"
    , "\"Is there a CRIPS?\""
    , "\"WERS\""
    , "\"FEDE\""
    , "Speaker interchanges rule/ requirement/ test"
    , "Any reference to 2008/Great Recession"
    , "\"sister program is exception to ___\""
    , "\"Rivian\""
    , "\"Roush\""
    , "\"Up to MPG\""
    , "\"Can you cut a section?\""
    , "\"Can you turn on __?\""
    , "speaker's unspoken contempt for a supplier"
    , "Agenda ignored"
    ]


kanye : List String
kanye =
    [ "\"Burn that excel spread sheet\""
    , "\"2024\""
    , "\"We came into a broken world. And we're the cleanup crew\""
    , "\"I love sleep; it's my favorite\""
    , "\"Perhaps I should have been more like water today\""
    , "\"I still think I am the greatest\""
    , "\"Keep squares out yo circle\""
    , "\"I'd like to meet with Tim Cook. I got some ideas\""
    , "\"The thought police want to suppress freedom of thought\""
    , "\"Let's be like water\""
    , "\"If I got any cooler I would freeze to death\""
    , "\"I wish I had a friend like me\""
    , "\"I'm a creative genius\""
    , "\"My greatest pain in life is that I will never be able to see myself perform live\""
    , "\"Fur pillows are hard to actually sleep on\""
    , "\"Distraction is the enemy of vision\""
    , "\"I feel calm but energized\""
    , "\"Everything you do in life stems from either fear or love\""
    , "\"I leave my emojis bart Simpson color\""
    , "\"The world is our office\""
    , "\"You can't look at a glass half full or empty if it's overflowing\""
    , "\"Tweeting is legal and also therapeutic\""
    , "\"All you have to be is yourself\""
    , "\"I'll do a hundred reps of controversy for a 6 pack of truth\""
    ]


itfcg : List String
itfcg =
    [ "\"Co-Leads\""
    , "\"Thanks everyone for joining\""
    , "\"Skip Level\""
    , "\"Interns\""
    , "\"New Hires\""
    , "\"Incoming FCGs\""
    , "\"On-Boarding\""
    , "\"Off-Boarding\""
    , "\"Carousel\""
    , "\"Volunteering\""
    , "\"Innovation\""
    , "\"Media\""
    , "\"Special Events\""
    , "\"Dev Comm\""
    , "\"Council\""
    , "\"MegaByte\""
    , "\"Advisors\""
    , "\"Hackathon\""
    , "\"Rotation\""
    , "\"Algorithm\""
    , "\"Building Champions\""
    , "\"Happy Hour\""
    , "\"FCGs\""
    , "\"One Ford FCGs\""
    , "\"Comms Meeting\""
    , "\"Carousel Solve\""
    , "\"Forward Into Ford\""
    ]


architect : List String
architect =
    [ "\"Best Practice\""
    , "\"According to the code\""
    , "\"Value Engineering (VE)\""
    , "\"Design intent\""
    , "\"Additional Service Request (ASR)\""
    , "\"FF&E\""
    , "\"OFCI\""
    , "\"The big idea\""
    , "\"The concept\""
    , "\"How do you support that?\""
    , "\"BIM 360\""
    , "\"Workplace of the future\""
    , "\"submittals\""
    , "\"plotting/printing the drawings\""
    , "\"it's in the model\""
    , "\"title block\""
    , "reference to column grids"
    , "reference to finishes"
    ]


fordCredit : List String
fordCredit =
    [ "\"fail\""
    , "You hear the gong"
    , "\"Retroquest\""
    , "\"companion app\""
    , "\"future state\""
    , "\"design\""
    , "\"demo\""
    , "\"lightning talk\""
    , "\"shout outs\""
    , "\"commercial\""
    , "\"consumer\""
    , "\"dealer\""
    , "\"platform\""
    , "\"experiential\""
    , "\"foundational\""
    ]


toggleTopic topic topics =
    topics
        |> (if not (List.member topic topics) then
                List.append [ topic ]

            else
                List.Extra.remove topic
           )


topicDecoder : Decoder Topic
topicDecoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "fordism" ->
                        Decode.succeed Fordism

                    "coronavirus" ->
                        Decode.succeed Coronavirus

                    "av" ->
                        Decode.succeed AV

                    "vehicleDevelopment" ->
                        Decode.succeed VehicleDevelopemnt

                    "kanye" ->
                        Decode.succeed Kanye

                    "ITFCG" ->
                        Decode.succeed ITFCG

                    "architect" ->
                        Decode.succeed Architect

                    "fordCredit" ->
                        Decode.succeed Credit

                    _ ->
                        Decode.succeed Generic
            )


encodeTopic : Topic -> Encode.Value
encodeTopic topic =
    topic |> toString |> Encode.string


toString : Topic -> String
toString topic =
    case topic of
        Generic ->
            "generic"

        Fordism ->
            "fordism"

        Credit ->
            "fordCredit"

        Coronavirus ->
            "coronavirus"

        AV ->
            "av"

        VehicleDevelopemnt ->
            "vehicleDevelopment"

        Kanye ->
            "kanye"

        Center ->
            "center"

        ITFCG ->
            "ITFCG"

        Architect ->
            "architect"
