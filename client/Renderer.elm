module Renderer exposing (Model, init, setTexture, setViewport, viewScene)

import Box exposing (Box)
import Html exposing (Html)
import Html.Attributes as Attr
import Math.Matrix4 as Linear exposing (Mat4)
import Math.Vector3 as Linear exposing (Vec3)
import Msg exposing (Msg)
import WebGL as GL
import WebGL.Texture exposing (Texture)
import Window exposing (Size)


type alias Model =
    { viewport : Size
    , perspectiveMatrix : Mat4
    , viewMatrix : Mat4
    , texture : Maybe Texture
    }


init : Model
init =
    { viewport = defaultViewport
    , perspectiveMatrix = perspectiveFromViewport defaultViewport
    , viewMatrix =
        Linear.makeLookAt (Linear.vec3 -4 10 10)
            (Linear.vec3 0 0 0)
            (Linear.vec3 0 1 0)
    , texture = Nothing
    }


setViewport : Model -> Size -> Model
setViewport model size =
    { model
        | viewport = size
        , perspectiveMatrix = perspectiveFromViewport size
    }


setTexture : Model -> Texture -> Model
setTexture model texture =
    { model | texture = Just texture }


viewScene : Model -> List Box -> Html Msg
viewScene model boxes =
    GL.toHtmlWith
        [ GL.antialias
        , GL.depth 1
        , GL.clearColor 0 0 0 0
        ]
        [ Attr.height model.viewport.height
        , Attr.width model.viewport.width
        ]
    <|
        case model.texture of
            Just texture ->
                List.map (Box.toEntity model.perspectiveMatrix model.viewMatrix texture) boxes

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
