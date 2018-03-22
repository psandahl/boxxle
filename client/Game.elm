module Game exposing (Game, boxes, init, mouseOver)

import Game.BoxGrid as BoxGrid exposing (BoxGrid)
import Graphics.Box
import Math.Vector3 exposing (Vec3)
import WebGL exposing (Mesh)
import WebGL.Texture exposing (Texture)


type alias Game =
    { boxMesh : Mesh Graphics.Box.Vertex
    , normalMap : Texture
    , specularMap : Texture
    , boxGrid : BoxGrid
    }



{- Initialize a new game. -}


init : Mesh Graphics.Box.Vertex -> Texture -> Texture -> Game
init boxMesh normalMap specularMap =
    { boxMesh = boxMesh
    , normalMap = normalMap
    , specularMap = specularMap
    , boxGrid = BoxGrid.init boxMesh normalMap specularMap
    }



{- Fetch boxes for rendering. -}


boxes : Game -> List Graphics.Box.Box
boxes game =
    BoxGrid.renderBoxes game.boxGrid



{- Handle intersect due to mouse move. -}


mouseOver : Vec3 -> Game -> Game
mouseOver ray game =
    { game | boxGrid = BoxGrid.mouseOver ray game.boxGrid }
