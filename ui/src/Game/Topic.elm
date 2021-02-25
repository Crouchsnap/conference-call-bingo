module Game.Topic exposing (Topic(..), centerText, encodeTopic, iwd, toString, toggleTopic, topicDecoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import List.Extra


type Topic
    = Iwd


centerText : String
centerText =
    "write a thank you note to a woman colleague"


iwd : List String
iwd =
    [ "count how any women are in the room in every meeting today"
    , "share an inspirational book, article, podcast, etc. created by a woman"
    , "strike up a conversation with a woman colleague you haven't had a chance to know"
    , "Acknowledge a woman with great leadership skills in a non-leadership position"
    , "donate time/money to an organization that supports women"
    , "call it out when a woman gets interrupted, make sure they get to speak"
    , "support a woman owned business"
    , "share an informative post for IWD on social media"
    , "ask a woman colleague what you could do to make the workplace more gender equal"
    , "celebrate women in film"
    , "support women authors"
    , "involve men and non-binary people in the conversation and celebration"
    , "advocate for gender equality in your workplace"
    , "Host or attend an online panel "
    , "Set up a (virtual) coffee date with a woman in your network"
    , "Acknowledge the awesome women in your life"
    , "celebrate women's achievements"
    , "challenge gender bias"
    , "launch a project or initiative"
    , "deliver female-focused activity"
    , "Submit your #ChooseToChallenge images"
    , "think about and commit to progressive actions"
    , "generate a list of tangible ideas and commitments that relate to behavior and expectation"
    , "Fundraise for a female-focused charity"
    , "Socialize your IWD Best Practice"
    , "Celebrate some amazing Indigenous women making change happen"
    , "Learn about Murdered and Missing Indigenous Women"
    , "Learn about Indigenous Women's Rights"
    , "Learn about impactful women"
    , "Re-think your immediate reaction to celeb gossip"
    , "Compile and play or share an IWD Spotify playlist"
    , "organize a women's suffrage white out event"
    , "quote a famous woman in a meeting"
    , "take a selfie wearing pearls and chucks"
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
                    "iwd" ->
                        Decode.succeed Iwd

                    _ ->
                        Decode.succeed Iwd
            )


encodeTopic : Topic -> Encode.Value
encodeTopic topic =
    topic |> toString |> Encode.string


toString : Topic -> String
toString topic =
    case topic of
        Iwd ->
            "iwd"
