module Options.TopicChoices exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Msg exposing (Msg(..))


view :
    { model | class : String -> Html.Attribute Msg }
    -> Html Msg
    -> Html Msg
view { class } title =
    div [ class "", style "margin" "1rem 0 2rem" ]
        [ title ]
