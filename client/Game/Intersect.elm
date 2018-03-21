module Game.Intersect exposing (AxisAlignedBoundingBox, intersect, makeAabb)

import Math.Vector3 exposing (Vec3, getX, getY, getZ, vec3)


type alias AxisAlignedBoundingBox =
    { minPoints : Vec3
    , maxPoints : Vec3
    }



{- Make two simplifications. 1. Box is always cube. 2. Side is one long. -}


makeAabb : Vec3 -> AxisAlignedBoundingBox
makeAabb position =
    { minPoints = vec3 (getX position - 0.5) (getY position - 0.5) (getZ position - 0.5)
    , maxPoints = vec3 (getX position + 0.5) (getY position + 0.5) (getZ position + 0.5)
    }



{- The ray origin is always at origo. -}


intersect : Vec3 -> AxisAlignedBoundingBox -> Bool
intersect ray aabb =
    let
        t1 =
            pointX aabb.minPoints ray

        t2 =
            pointX aabb.maxPoints ray

        t3 =
            pointY aabb.minPoints ray

        t4 =
            pointY aabb.maxPoints ray

        t5 =
            pointZ aabb.minPoints ray

        t6 =
            pointZ aabb.maxPoints ray

        largestMin =
            max (max (min t1 t2) (min t3 t4)) (min t5 t6)

        smallestMax =
            min (min (max t1 t2) (max t3 t4)) (max t5 t6)
    in
    if smallestMax < 0 then
        False
    else if largestMin > smallestMax then
        False
    else
        True


safeDivide : Float -> Float -> Float
safeDivide x y =
    let
        value =
            x / y
    in
    if isInfinite value then
        x / epsilon
    else
        value


epsilon : Float
epsilon =
    2.220446049250313e-16


pointX : Vec3 -> Vec3 -> Float
pointX position ray =
    safeDivide (getX position) (getX ray)


pointY : Vec3 -> Vec3 -> Float
pointY position ray =
    safeDivide (getY position) (getY ray)


pointZ : Vec3 -> Vec3 -> Float
pointZ position ray =
    safeDivide (getZ position) (getZ ray)
