module Renderer exposing (Renderer, init, setTexture, setViewport, viewScene)

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
    , texture : Maybe Texture
    }


init : Renderer
init =
    { viewport = defaultViewport
    , perspectiveMatrix = perspectiveFromViewport defaultViewport
    , viewMatrix =
        Linear.makeLookAt (Linear.vec3 -4 10 10)
            (Linear.vec3 0 0 0)
            (Linear.vec3 0 1 0)
    , texture = Nothing
    }


setViewport : Renderer -> Size -> Renderer
setViewport renderer size =
    { renderer
        | viewport = size
        , perspectiveMatrix = perspectiveFromViewport size
    }


setTexture : Renderer -> Texture -> Renderer
setTexture renderer texture =
    { renderer | texture = Just texture }


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
        case renderer.texture of
            Just texture ->
                List.map (Box.toEntity renderer.perspectiveMatrix renderer.viewMatrix texture) boxes

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
