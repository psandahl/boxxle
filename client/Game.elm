module Game exposing (Game, boxes, init)

import Game.BoxGrid as BoxGrid exposing (BoxGrid)
import Graphics.Box
import WebGL exposing (Mesh)
import WebGL.Texture exposing (Texture)


type alias Game =
    { boxMesh : Mesh Graphics.Box.Vertex
    , normalMap : Texture
    , specularMap : Texture
    , boxGrid : BoxGrid
    }


init : Mesh Graphics.Box.Vertex -> Texture -> Texture -> Game
init boxMesh normalMap specularMap =
    { boxMesh = boxMesh
    , normalMap = normalMap
    , specularMap = specularMap
    , boxGrid = BoxGrid.init boxMesh normalMap specularMap
    }


boxes : Game -> List Graphics.Box.Box
boxes game =
    BoxGrid.renderBoxes game.boxGrid
