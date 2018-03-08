module Renderer exposing (Renderer, init, setTextures, setViewport, viewScene)

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
    , textures : List Texture
    }


init : Renderer
init =
    { viewport = defaultViewport
    , perspectiveMatrix = perspectiveFromViewport defaultViewport
    , viewMatrix =
        Linear.makeLookAt (Linear.vec3 -3 3 3)
            (Linear.vec3 0 0 0)
            (Linear.vec3 0 1 0)
    , textures = []
    }


setViewport : Renderer -> Size -> Renderer
setViewport renderer size =
    { renderer
        | viewport = size
        , perspectiveMatrix = perspectiveFromViewport size
    }


setTextures : Renderer -> List Texture -> Renderer
setTextures renderer textures =
    { renderer | textures = textures }


viewScene : Renderer -> List Box -> Html Msg
viewScene renderer boxes =
    GL.toHtmlWith
        [ GL.antialias
        , GL.depth 1
        , GL.alpha False
        , GL.clearColor 1 1 1 1
        ]
        [ Attr.height renderer.viewport.height
        , Attr.width renderer.viewport.width
        ]
    <|
        case renderer.textures of
            [ texture, bumpmap ] ->
                List.map (Box.toEntity renderer.perspectiveMatrix renderer.viewMatrix texture bumpmap) boxes

            _ ->
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
