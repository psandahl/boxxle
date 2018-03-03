module Renderer.Model exposing (Model)

import Math.Matrix4 exposing (Mat4)
import Window exposing (Size)


type alias Model =
    { viewport : Size
    , perspectiveMatrix : Mat4
    , viewMatrix : Mat4
    }
