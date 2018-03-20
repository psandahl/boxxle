module Game.BoxGrid exposing (BoxGrid, init, renderBoxes)

import Array exposing (Array)
import Game.Box
import Graphics.Box
import Math.Vector3 exposing (Vec3, add, sub, vec3)
import WebGL exposing (Mesh)
import WebGL.Texture exposing (Texture)


type alias BoxGrid =
    { boxes : Array Game.Box.Box
    }


init : Mesh Graphics.Box.Vertex -> Texture -> Texture -> BoxGrid
init mesh normalMap specularMap =
    { boxes =
        Array.initialize gridSize
            (\n ->
                let
                    row =
                        n // rows

                    col =
                        n % cols
                in
                Game.Box.init mesh normalMap specularMap <| gridPointAt row col
            )
    }


renderBoxes : BoxGrid -> List Graphics.Box.Box
renderBoxes boxGrid =
    Array.foldl (\box list -> box.box :: list) [] boxGrid.boxes


gridSize : Int
gridSize =
    rows * cols


rows : Int
rows =
    5


cols : Int
cols =
    5


gridPointAt : Int -> Int -> Vec3
gridPointAt row col =
    add gridStartPoint <| vec3 (spacing * toFloat col) 0 (spacing * toFloat row)


gridStartPoint : Vec3
gridStartPoint =
    sub gridMidPoint <| vec3 (spacing * 2) 0 (spacing * 2)


gridMidPoint : Vec3
gridMidPoint =
    vec3 0 -8 -8


spacing : Float
spacing =
    1.2
