module Game.Box exposing (Box, compareForIntersect, init)

import Game.AxisAlignedBoundingBox exposing (AxisAlignedBoundingBox, makeAabb)
import Graphics.Box
import Math.Vector3 exposing (Vec3, getX, getZ)
import WebGL exposing (Mesh)
import WebGL.Texture exposing (Texture)


type alias Box =
    { position : Vec3
    , box : Graphics.Box.Box
    , boundingBox : AxisAlignedBoundingBox
    }


init : Mesh Graphics.Box.Vertex -> Texture -> Texture -> Vec3 -> Box
init mesh normalMap specularMap position =
    { position = position
    , box = Graphics.Box.init mesh normalMap specularMap position
    , boundingBox = makeAabb position
    }


compareForIntersect : Box -> Box -> Order
compareForIntersect a b =
    if
        (getZ a.position > getZ b.position)
            && (abs (getX a.position) < abs (getX a.position))
    then
        GT
    else
        LT
