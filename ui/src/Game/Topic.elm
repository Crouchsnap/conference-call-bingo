module Game.Topic exposing (Topic(..), av, coronaviri, encodeTopic, fordisms, generic, toString, toggleTopic, topicDecoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import List.Extra


type Topic
    = Generic
    | Fordism
    | Coronavirus
    | AV
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
    , "\"Let's give everyone a few minutes to join\""
    , "Meeting started late"
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
    , "\"The business\""
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

        Coronavirus ->
            "coronavirus"

        AV ->
            "av"

        Center ->
            "center"
