module Media exposing (..)


viewportToMedia viewport =
    defaultMedia


type Device
    = Phone
    | Desktop
    | Tablet


type Orientation
    = Portrait
    | Landscape


type alias Media =
    { device : Device, orientation : Orientation }


defaultMedia =
    { device = Desktop, orientation = Portrait }
