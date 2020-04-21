module View.ViewportHelper exposing (defaultDevice, viewportToDevice)

import Browser.Dom exposing (Viewport)
import Element exposing (Device, DeviceClass(..), Orientation(..), classifyDevice)


viewportToDevice : Viewport -> Device
viewportToDevice viewport =
    { width = viewport.viewport.width |> round, height = viewport.viewport.height |> round } |> classifyDevice


defaultDevice : Device
defaultDevice =
    { class = Desktop, orientation = Portrait }
