module Footer.FordLabsLogo exposing (svg)

import Html.Attributes as Html
import Svg
import Svg.Attributes exposing (cx, cy, d, fill, height, r, viewBox, width)



--<svg
--               style="vertical-align:middle;" width="20" height="20" viewBox="0 0 20 20" fill="none"
--               xmlns="http://www.w3.org/2000/svg">
--           <circle cx="10" cy="10" r="10" fill="#002F6C"/>
--           <path d="M9 6H7L4 13H6L9 6Z" fill="white"/>
--           <path d="M14 6H11L10 8H13L14 6Z" fill="white"/>
--           <path d="M13 9H10L9 11H12L13 9Z" fill="white"/>
--           <path d="M17 11H14L13 13H16L17 11Z" fill="white"/>
--       </svg>


svg circleColor textColor =
    Svg.svg
        [ Html.style "vertical-align" "middle"
        , Html.style "margin" "0 .25rem"
        , width "20"
        , height "20"
        , viewBox "0 0 20 20"
        , fill "none"
        ]
        [ Svg.circle [ cx "10", cy "10", r "10", fill circleColor ] []
        , Svg.path [ d "M9 6H7L4 13H6L9 6Z", fill textColor ] []
        , Svg.path [ d "M14 6H11L10 8H13L14 6Z", fill textColor ] []
        , Svg.path [ d "M13 9H10L9 11H12L13 9Z", fill textColor ] []
        , Svg.path [ d "M17 11H14L13 13H16L17 11Z", fill textColor ] []
        ]
