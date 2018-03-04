module Box exposing (Box, makeBox, makeMesh, toEntity)

import Math.Matrix4 as Linear exposing (Mat4)
import Math.Vector3 exposing (Vec3, vec3)
import WebGL as GL exposing (Entity, Mesh, Shader)
import WebGL.Settings as Settings


type alias Box =
    { mesh : Mesh Vertex
    , modelMatrix : Mat4
    }


type alias Vertex =
    { position : Vec3
    , normal : Vec3
    }


makeBox : Mesh Vertex -> Vec3 -> Box
makeBox mesh origin =
    { mesh = mesh, modelMatrix = Linear.makeTranslate origin }


makeMesh : Mesh Vertex
makeMesh =
    let
        vertices =
            [ -- Front side. First idx=0.
              { position = vec3 0.5 0.5 0.5, normal = front }
            , { position = vec3 -0.5 0.5 0.5, normal = front }
            , { position = vec3 -0.5 -0.5 0.5, normal = front }
            , { position = vec3 0.5 -0.5 0.5, normal = front }

            -- Right side. First idx=4.
            , { position = vec3 0.5 0.5 -0.5, normal = right }
            , { position = vec3 0.5 0.5 0.5, normal = right }
            , { position = vec3 0.5 -0.5 0.5, normal = right }
            , { position = vec3 0.5 -0.5 -0.5, normal = right }

            -- Left side. First idx=8.
            , { position = vec3 -0.5 0.5 0.5, normal = left }
            , { position = vec3 -0.5 0.5 -0.5, normal = left }
            , { position = vec3 -0.5 -0.5 -0.5, normal = left }
            , { position = vec3 -0.5 -0.5 0.5, normal = left }

            -- Back side. First idx=12.
            , { position = vec3 -0.5 0.5 -0.5, normal = back }
            , { position = vec3 0.5 0.5 -0.5, normal = back }
            , { position = vec3 0.5 -0.5 -0.5, normal = back }
            , { position = vec3 -0.5 -0.5 -0.5, normal = back }

            -- Bottom side. First idx=16.
            , { position = vec3 0.5 -0.5 0.5, normal = bottom }
            , { position = vec3 -0.5 -0.5 0.5, normal = bottom }
            , { position = vec3 -0.5 -0.5 -0.5, normal = bottom }
            , { position = vec3 0.5 -0.5 -0.5, normal = bottom }

            -- Top side. First idx=20.
            , { position = vec3 0.5 0.5 -0.5, normal = top }
            , { position = vec3 -0.5 0.5 -0.5, normal = top }
            , { position = vec3 -0.5 0.5 0.5, normal = top }
            , { position = vec3 0.5 0.5 0.5, normal = top }
            ]

        indices =
            [ -- Front size.
              ( 0, 1, 2 )
            , ( 0, 2, 3 )

            -- Right side.
            , ( 4, 5, 6 )
            , ( 4, 6, 7 )

            -- Left side.
            , ( 8, 9, 10 )
            , ( 8, 10, 11 )

            -- Back side.
            , ( 12, 13, 14 )
            , ( 12, 14, 15 )

            -- Bottom side.
            , ( 16, 17, 18 )
            , ( 16, 18, 19 )

            -- Top side.
            , ( 20, 21, 22 )
            , ( 20, 22, 23 )
            ]
    in
    GL.indexedTriangles vertices indices


toEntity : Mat4 -> Mat4 -> Box -> Entity
toEntity projectionMatrix viewMatrix box =
    GL.entityWith
        [ Settings.cullFace Settings.back ]
        vertexShader
        fragmentShader
        box.mesh
        { mvpMatrix = Linear.mul projectionMatrix <| Linear.mul viewMatrix box.modelMatrix
        }


front : Vec3
front =
    vec3 0 0 1


right : Vec3
right =
    vec3 1 0 0


left : Vec3
left =
    vec3 -1 0 0


back : Vec3
back =
    vec3 0 0 -1


bottom : Vec3
bottom =
    vec3 0 -1 0


top : Vec3
top =
    vec3 0 1 0


vertexShader : Shader Vertex { uniforms | mvpMatrix : Mat4 } {}
vertexShader =
    [glsl|
        attribute vec3 position;
        attribute vec3 normal;

        uniform mat4 mvpMatrix;

        void main()
        {
            gl_Position = mvpMatrix * vec4(position, 1.0);
        }
    |]


fragmentShader : Shader {} uniforms {}
fragmentShader =
    [glsl|
        precision mediump float;

        void main()
        {
            gl_FragColor = vec4(0.0, 0.0, 1.0, 1.0);
        }
    |]
