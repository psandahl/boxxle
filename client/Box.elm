module Box exposing (Box, makeBox, makeMesh, toEntity)

import Math.Matrix4 as Linear exposing (Mat4)
import Math.Vector2 exposing (Vec2, vec2)
import Math.Vector3 exposing (Vec3, vec3)
import WebGL as GL exposing (Entity, Mesh, Shader)
import WebGL.Settings as Settings
import WebGL.Texture exposing (Texture)


type alias Box =
    { mesh : Mesh Vertex
    , modelMatrix : Mat4
    }


type alias Vertex =
    { position : Vec3
    , normal : Vec3
    , texCoord : Vec2
    }


makeBox : Mesh Vertex -> Vec3 -> Box
makeBox mesh origin =
    { mesh = mesh, modelMatrix = Linear.makeTranslate origin }


makeMesh : Mesh Vertex
makeMesh =
    let
        vertices =
            [ -- Front side. First idx=0.
              { position = vec3 0.5 0.5 0.5
              , normal = front
              , texCoord = vec2 1 1
              }
            , { position = vec3 -0.5 0.5 0.5
              , normal = front
              , texCoord = vec2 0 1
              }
            , { position = vec3 -0.5 -0.5 0.5
              , normal = front
              , texCoord = vec2 0 0
              }
            , { position = vec3 0.5 -0.5 0.5
              , normal = front
              , texCoord = vec2 1 0
              }

            -- Right side. First idx=4.
            , { position = vec3 0.5 0.5 -0.5
              , normal = right
              , texCoord = vec2 1 1
              }
            , { position = vec3 0.5 0.5 0.5
              , normal = right
              , texCoord = vec2 0 1
              }
            , { position = vec3 0.5 -0.5 0.5
              , normal = right
              , texCoord = vec2 0 0
              }
            , { position = vec3 0.5 -0.5 -0.5
              , normal = right
              , texCoord = vec2 1 0
              }

            -- Left side. First idx=8.
            , { position = vec3 -0.5 0.5 0.5
              , normal = left
              , texCoord = vec2 1 1
              }
            , { position = vec3 -0.5 0.5 -0.5
              , normal = left
              , texCoord = vec2 0 1
              }
            , { position = vec3 -0.5 -0.5 -0.5
              , normal = left
              , texCoord = vec2 0 0
              }
            , { position = vec3 -0.5 -0.5 0.5
              , normal = left
              , texCoord = vec2 1 0
              }

            -- Back side. First idx=12.
            , { position = vec3 -0.5 0.5 -0.5
              , normal = back
              , texCoord = vec2 1 1
              }
            , { position = vec3 0.5 0.5 -0.5
              , normal = back
              , texCoord = vec2 0 1
              }
            , { position = vec3 0.5 -0.5 -0.5
              , normal = back
              , texCoord = vec2 0 0
              }
            , { position = vec3 -0.5 -0.5 -0.5
              , normal = back
              , texCoord = vec2 1 0
              }

            -- Bottom side. First idx=16.
            , { position = vec3 0.5 -0.5 0.5
              , normal = bottom
              , texCoord = vec2 1 1
              }
            , { position = vec3 -0.5 -0.5 0.5
              , normal = bottom
              , texCoord = vec2 0 1
              }
            , { position = vec3 -0.5 -0.5 -0.5
              , normal = bottom
              , texCoord = vec2 0 0
              }
            , { position = vec3 0.5 -0.5 -0.5
              , normal = bottom
              , texCoord = vec2 1 0
              }

            -- Top side. First idx=20.
            , { position = vec3 0.5 0.5 -0.5
              , normal = top
              , texCoord = vec2 1 1
              }
            , { position = vec3 -0.5 0.5 -0.5
              , normal = top
              , texCoord = vec2 0 1
              }
            , { position = vec3 -0.5 0.5 0.5
              , normal = top
              , texCoord = vec2 0 0
              }
            , { position = vec3 0.5 0.5 0.5
              , normal = top
              , texCoord = vec2 1 0
              }
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


toEntity : Mat4 -> Mat4 -> Texture -> Box -> Entity
toEntity projectionMatrix viewMatrix texture box =
    GL.entityWith
        [ Settings.cullFace Settings.back ]
        vertexShader
        fragmentShader
        box.mesh
        { projectionMatrix = projectionMatrix
        , viewMatrix = viewMatrix
        , modelMatrix = box.modelMatrix
        , dummyTexture = texture
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


vertexShader :
    Shader Vertex
        { uniforms
            | projectionMatrix : Mat4
            , viewMatrix : Mat4
            , modelMatrix : Mat4
        }
        { vNormal : Vec3, vTexCoord : Vec2 }
vertexShader =
    [glsl|
        precision mediump float;

        attribute vec3 position;
        attribute vec3 normal;
        attribute vec2 texCoord;

        uniform mat4 projectionMatrix;
        uniform mat4 viewMatrix;
        uniform mat4 modelMatrix;

        varying vec3 vNormal;
        varying vec2 vTexCoord;

        void main()
        {
            mat4 vpMatrix = viewMatrix * modelMatrix;
            vNormal = (vpMatrix * vec4(normal, 0.0)).xyz;

            vTexCoord = texCoord;

            mat4 mvpMatrix = projectionMatrix * vpMatrix;
            gl_Position = mvpMatrix * vec4(position, 1.0);
        }
    |]


fragmentShader :
    Shader {}
        { uniforms
            | viewMatrix : Mat4
            , dummyTexture : Texture
        }
        { vNormal : Vec3, vTexCoord : Vec2 }
fragmentShader =
    [glsl|
        precision mediump float;

        uniform mat4 viewMatrix;
        uniform sampler2D dummyTexture;

        varying vec3 vNormal;
        varying vec2 vTexCoord;

        vec3 lightDirection = normalize(vec3(1.0));
        vec3 lightColor = vec3(1.0);

        vec3 fragColor();
        vec3 ambientLight();
        vec3 diffuseLight();

        void main()
        {
            vec3 color = fragColor() * (ambientLight() + diffuseLight());
            gl_FragColor = vec4(color, 1.0);
        }

        vec3 fragColor()
        {
            return texture2D(dummyTexture, vTexCoord).rgb;
        }

        vec3 ambientLight()
        {
            return lightColor * 0.8;
        }

        vec3 diffuseLight()
        {
            vec3 normal = normalize(vNormal);
            lightDirection = normalize((viewMatrix * vec4(lightDirection, 0.0)).xyz);

            float diffuse = min(0.0, dot(normal, lightDirection));

            return lightColor * diffuse;
        }
    |]
