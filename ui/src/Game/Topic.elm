module Game.Topic exposing (Topic(..), encodeTopic, toString, toggleTopic, topicDecoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import List.Extra


type Topic
    = Generic
    | Fordism
    | Coronavirus
    | Center


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
