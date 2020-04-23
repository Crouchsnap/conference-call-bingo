module Game.Topic exposing (Topic(..), coronaviri, encodeTopic, fordisms, generic, toString, toggleTopic, topicDecoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import List.Extra


type Topic
    = Generic
    | Fordism
    | Coronavirus
    | Center


generic : List String
generic =
    [ "\"Mute your phone please\""
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
    , "Reference to people as resources"
    , "\"I'll send out the deck\""
    , "(eating sounds)"
    , "\"Bingo!\""
    , "\"I think ____ stepped away\""
    , "\"Can you hear me?\""
    , "(breathing directly into the microphone)"
    , "\"That's a great question...(deflection)\""
    , "Two people with the same first name present"
    ]


fordisms : List String
fordisms =
    [ "\"VIN number\""
    , "\"MVP\""
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
    ]


coronaviri : List String
coronaviri =
    [ "TP"
    , "Corona"
    , "Virus"
    , "Hand Sanitizer"
    , "Wash your hands"
    , "Sick"
    , "\"does ___ store have supplies?\""
    , "Death rate"
    , "Recovery rate"
    , "Work from home"
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

                    _ ->
                        Decode.succeed Generic
            )


encodeTopic : Topic -> Encode.Value
encodeTopic topic =
    topic |> toString |> Encode.string


toString : Topic -> String
toString topic =
    case topic of
        Fordism ->
            "fordism"

        Coronavirus ->
            "coronavirus"

        _ ->
            ""
