module Game.BoxGrid exposing (BoxGrid, init, renderBoxes)

import Array exposing (Array)
import Game.Box
import Graphics.Box
import Math.Vector3 exposing (vec3)
import WebGL exposing (Mesh)
import WebGL.Texture exposing (Texture)


type alias BoxGrid =
    { boxes : Array Game.Box.Box
    }


init : Mesh Graphics.Box.Vertex -> Texture -> Texture -> BoxGrid
init mesh normalMap specularMap =
    { boxes =
        Array.initialize 1
            (\_ ->
                Game.Box.init mesh normalMap specularMap <| vec3 4 -4 -4
            )
    }


renderBoxes : BoxGrid -> List Graphics.Box.Box
renderBoxes boxGrid =
    Array.foldl (\box list -> box.box :: list) [] boxGrid.boxes
