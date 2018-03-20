module Graphics.Renderer
    exposing
        ( Renderer
        , getMouseRay
        , init
        , setViewport
        , viewScene
        )

import Debug
import Graphics.Box as Box exposing (Box)
import Html exposing (Html)
import Html.Attributes as Attr
import Math.Matrix4 as Linear exposing (Mat4)
import Math.Vector3 exposing (Vec3, normalize, vec3)
import Mouse exposing (Position)
import Msg exposing (Msg)
import WebGL as GL
import Window exposing (Size)


{- Renderer record. Holding information for rendering. -}


type alias Renderer =
    { viewport : Size
    , perspectiveMatrix : Mat4
    , invertedPerspectiveMatrix : Mat4
    , viewMatrix : Mat4
    , invertedViewMatrix : Mat4
    }



{- Initialize a renderer with a default viewport and a camera located at origo. -}


init : Renderer
init =
    let
        persp =
            perspectiveFromViewport defaultViewport

        view =
            Linear.makeLookAt (vec3 0 0 0)
                (vec3 0 -1 -1)
                (vec3 0 1 0)
    in
    { viewport = defaultViewport
    , perspectiveMatrix = persp
    , invertedPerspectiveMatrix = invertOrCrash persp
    , viewMatrix = view
    , invertedViewMatrix = invertOrCrash view
    }



{- Set a new viewport and recalculate the perspecitive matrix. -}


setViewport : Size -> Renderer -> Renderer
setViewport size renderer =
    let
        persp =
            perspectiveFromViewport size
    in
    { renderer
        | viewport = size
        , perspectiveMatrix = persp
        , invertedPerspectiveMatrix = invertOrCrash persp
    }



{- View a scene of Boxes. -}


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
            )
            boxes



{- Get a ray from eye position - center of screen - pointing in the direction
   of the mouse cursor, and using the perspective information to get depth.
-}


getMouseRay : Position -> Renderer -> Vec3
getMouseRay position renderer =
    let
        ndc =
            normalizedDeviceCoordinates position renderer.viewport

        eye =
            eyeCoordinates ndc renderer.invertedPerspectiveMatrix

        world =
            worldCoordinates eye renderer.invertedViewMatrix
    in
    normalize world


normalizedDeviceCoordinates : Position -> Size -> ( Float, Float )
normalizedDeviceCoordinates position viewport =
    ( ((2 * toFloat position.x) / toFloat viewport.width) - 1
    , 1 - ((2 * toFloat position.y) / toFloat viewport.height)
    )


eyeCoordinates : ( Float, Float ) -> Mat4 -> Vec3
eyeCoordinates ( ndcX, ndcY ) invertedPerspectiveMatrix =
    let
        vec =
            vec3 ndcX ndcY 1
    in
    Linear.transform invertedPerspectiveMatrix vec


worldCoordinates : Vec3 -> Mat4 -> Vec3
worldCoordinates vec invertedViewMatrix =
    Linear.transform invertedViewMatrix vec


invertOrCrash : Mat4 -> Mat4
invertOrCrash matrix =
    case Linear.inverse matrix of
        Just invMatrix ->
            invMatrix

        Nothing ->
            Debug.crash "Cannot invert matrix"


defaultViewport : Size
defaultViewport =
    Size 800 600


fov : Float
fov =
    45


perspectiveFromViewport : Size -> Linear.Mat4
perspectiveFromViewport viewport =
    Linear.makePerspective fov (toFloat viewport.width / toFloat viewport.height) 0.1 100
