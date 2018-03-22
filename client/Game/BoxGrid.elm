module Game.BoxGrid exposing (BoxGrid, init, intersect, renderBoxes)

import Array exposing (Array)
import Game.AxisAlignedBoundingBox as Aabb
import Game.Box
import Graphics.Box
import Math.Vector3 exposing (Vec3, add, getX, getZ, sub, vec3)
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


intersect : Vec3 -> BoxGrid -> Maybe Int
intersect ray boxGrid =
    case intersectBoxes 0 [] ray boxGrid of
        [] ->
            Nothing

        [ index ] ->
            Just index

        indices ->
            selectMostLikelyBox indices boxGrid


intersectBoxes : Int -> List Int -> Vec3 -> BoxGrid -> List Int
intersectBoxes index indices ray boxGrid =
    case Array.get index boxGrid.boxes of
        Just box ->
            if Aabb.intersect ray box.boundingBox then
                intersectBoxes (index + 1) (index :: indices) ray boxGrid
            else
                intersectBoxes (index + 1) indices ray boxGrid

        Nothing ->
            indices


selectMostLikelyBox : List Int -> BoxGrid -> Maybe Int
selectMostLikelyBox indices boxGrid =
    List.head <| List.sortWith (compareForIntersect boxGrid.boxes) indices


compareForIntersect : Array Game.Box.Box -> Int -> Int -> Order
compareForIntersect boxes i1 i2 =
    let
        b1 =
            Array.get i1 boxes

        b2 =
            Array.get i2 boxes
    in
    case ( b1, b2 ) of
        ( Just box1, Just box2 ) ->
            Game.Box.compareForIntersect box1 box2

        _ ->
            GT


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
