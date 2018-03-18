module Game exposing (Game, boxes, init)

import Box exposing (Box, Vertex)
import Math.Vector3 exposing (vec3)
import WebGL exposing (Mesh)
import WebGL.Texture exposing (Texture)


type alias Game =
    { boxMesh : Mesh Vertex
    , normalMap : Texture
    , specularMap : Texture
    , dummyBox : Box
    }


init : Mesh Vertex -> Texture -> Texture -> Game
init boxMesh normalMap specularMap =
    { boxMesh = boxMesh
    , normalMap = normalMap
    , specularMap = specularMap
    , dummyBox = Box.init boxMesh normalMap specularMap <| vec3 2 0 0
    }


boxes : Game -> List Box
boxes game =
    [ game.dummyBox ]
