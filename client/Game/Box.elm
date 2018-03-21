module Game.Box exposing (Box, init)

import Game.AxisAlignedBoundingBox exposing (AxisAlignedBoundingBox, makeAabb)
import Graphics.Box
import Math.Vector3 exposing (Vec3)
import WebGL exposing (Mesh)
import WebGL.Texture exposing (Texture)


type alias Box =
    { box : Graphics.Box.Box
    , boundingBox : AxisAlignedBoundingBox
    }


init : Mesh Graphics.Box.Vertex -> Texture -> Texture -> Vec3 -> Box
init mesh normalMap specularMap position =
    { box = Graphics.Box.init mesh normalMap specularMap position
    , boundingBox = makeAabb position
    }
