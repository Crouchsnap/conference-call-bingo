module Options.TopicChoices exposing (view)

import Game.Topic exposing (Topic(..))
import Html exposing (Html, div, input, label, text)
import Html.Attributes exposing (checked, disabled, for, name, style, type_)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Multiplayer.Multiplayer exposing (StartMultiplayerResponseBody)
import RemoteData exposing (WebData)
import UserSettings exposing (UserSettings)


view :
    { model | class : String -> Html.Attribute Msg, userSettings : UserSettings, startMultiplayerResponseBody : WebData StartMultiplayerResponseBody }
    -> Html Msg
    -> Html Msg
view { class, userSettings, startMultiplayerResponseBody } title =
    let
        multiplayerInProgress =
            case startMultiplayerResponseBody of
                RemoteData.Success _ ->
                    True

                _ ->
                    False
    in
    div [ class "", style "margin" "1rem 0 2rem" ]
        ([ title ]
            ++ topicToggles class multiplayerInProgress userSettings.topics
        )


topicToggles class multiplayerInProgress selectedTopics =
    allTopicsAndLabels
        |> filterIfMultiplayerGame multiplayerInProgress selectedTopics
        |> List.map (\( topic, label ) -> topicToggle class multiplayerInProgress selectedTopics topic label)


filterIfMultiplayerGame : Bool -> List Topic -> List ( Topic, String ) -> List ( Topic, String )
filterIfMultiplayerGame multiplayerInProgress selectedTopics topics =
    if multiplayerInProgress then
        topics
            |> List.filter (\( topic, _ ) -> selectedTopics |> List.member topic)

    else
        topics


allTopicsAndLabels : List ( Topic, String )
allTopicsAndLabels =
    [ ( Architect, "Architecture/Engineering" )
    , ( AV, "Autonomous Vehicle" )
    , ( Fordism, "Fordisms" )
    , ( Credit, "Ford Credit" )
    , ( ITFCG, "IT-FCG" )
    , ( Kanye, "Kanye" )
    , ( VehicleDevelopemnt, "Product Development" )
    ]


topicToggle : (String -> Html.Attribute Msg) -> Bool -> List Topic -> Topic -> String -> Html Msg
topicToggle class multiplayerInProgress selectedTopics topic topicLabel =
    div
        ([ style "display" "flex" ]
            ++ (if multiplayerInProgress then
                    []

                else
                    [ onClick (TopicToggled topic) ]
               )
        )
        [ div [ class "topic-container" ]
            [ input [ name topicLabel, checked (selectedTopics |> List.member topic), disabled multiplayerInProgress, type_ "checkbox" ] []
            , div [ class (classNames topic multiplayerInProgress selectedTopics) ] []
            ]
        , label
            [ for topicLabel
            , class "label"
            ]
            [ text topicLabel ]
        ]


classNames : Topic -> Bool -> List Topic -> String
classNames topic disabled topics =
    let
        baseClass =
            "checkmark "

        checkedClass =
            if topics |> List.member topic then
                "checkmark-checked "

            else
                ""

        disabledClass =
            if disabled then
                "checkmark-disabled "

            else
                ""
    in
    baseClass ++ checkedClass ++ disabledClass
