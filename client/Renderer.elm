module Renderer exposing (Renderer, init, setViewport, viewScene)

import Box exposing (Box)
import Html exposing (Html)
import Html.Attributes as Attr
import Math.Matrix4 as Linear exposing (Mat4)
import Math.Vector3 as Linear exposing (Vec3)
import Msg exposing (Msg)
import WebGL as GL
import WebGL.Texture exposing (Texture)
import Window exposing (Size)


type alias Renderer =
    { viewport : Size
    , perspectiveMatrix : Mat4
    , viewMatrix : Mat4
    , normalMap : Texture
    , specularMap : Texture
    }


init : Texture -> Texture -> Renderer
init normalMap specularMap =
    { viewport = defaultViewport
    , perspectiveMatrix = perspectiveFromViewport defaultViewport
    , viewMatrix =
        Linear.makeLookAt (Linear.vec3 0 4 4)
            (Linear.vec3 0 0 0)
            (Linear.vec3 0 1 0)
    , normalMap = normalMap
    , specularMap = specularMap
    }


setViewport : Size -> Renderer -> Renderer
setViewport size renderer =
    { renderer
        | viewport = size
        , perspectiveMatrix = perspectiveFromViewport size
    }


viewScene : Renderer -> List Box -> Html Msg
viewScene renderer boxes =
    GL.toHtmlWith
        [ GL.antialias
        , GL.depth 1
        , GL.alpha False
        , GL.clearColor 0 0 0 1
        ]
        [ Attr.height renderer.viewport.height
        , Attr.width renderer.viewport.width
        ]
    <|
        List.map
            (Box.toEntity renderer.perspectiveMatrix
                renderer.viewMatrix
                renderer.normalMap
                renderer.specularMap
            )
            boxes


defaultViewport : Size
defaultViewport =
    Size 800 600


fov : Float
fov =
    45


perspectiveFromViewport : Size -> Linear.Mat4
perspectiveFromViewport viewport =
    Linear.makePerspective fov (toFloat viewport.width / toFloat viewport.height) 0.1 100
