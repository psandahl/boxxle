module Renderer.Renderer exposing (init, setViewport, viewScene)

import Html exposing (Html)
import Html.Attributes as Attr
import Math.Matrix4 as Linear
import Math.Vector3 as Linear
import Msg exposing (Msg)
import Renderer.Model exposing (Model)
import WebGL as GL
import Window exposing (Size)


init : Model
init =
    { viewport = defaultViewport
    , perspectiveMatrix = perspectiveFromViewport defaultViewport
    , viewMatrix =
        Linear.makeLookAt (Linear.vec3 0 10 10)
            (Linear.vec3 0 0 0)
            (Linear.vec3 0 1 0)
    }


setViewport : Model -> Size -> Model
setViewport model size =
    { model
        | viewport = size
        , perspectiveMatrix = perspectiveFromViewport size
    }


viewScene : Model -> Html Msg
viewScene model =
    GL.toHtmlWith
        [ GL.antialias
        , GL.depth 1
        , GL.clearColor 0 0 1 0
        ]
        [ Attr.height model.viewport.height
        , Attr.width model.viewport.width
        ]
        []


defaultViewport : Size
defaultViewport =
    Size 800 600


fov : Float
fov =
    45


perspectiveFromViewport : Size -> Linear.Mat4
perspectiveFromViewport viewport =
    Linear.makePerspective fov (toFloat viewport.width / toFloat viewport.height) 0.1 100
