module Game exposing (Game, boxes, init, intersect)

import Debug
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



{- Intersect the mouse with entities in the game. -}


intersect : Vec3 -> Game -> Game
intersect ray game =
    let
        indices =
            Debug.log "Indices: " <| BoxGrid.intersect ray game.boxGrid
    in
    game
