module Box exposing (Box, makeBox, makeMesh, toEntity)

import Debug
import Math.Matrix4 as Linear exposing (Mat4)
import Math.Vector2 exposing (Vec2, vec2)
import Math.Vector3 exposing (Vec3, vec3)
import WebGL as GL exposing (Entity, Mesh, Shader)
import WebGL.Settings as Settings
import WebGL.Settings.DepthTest as DepthTest
import WebGL.Texture exposing (Texture)


type alias Box =
    { mesh : Mesh Vertex
    , modelMatrix : Mat4
    }


type alias Vertex =
    { position : Vec3
    , normal : Vec3
    , tangent : Vec3
    , binormal : Vec3
    , texCoord : Vec2
    }


makeBox : Mesh Vertex -> Vec3 -> Box
makeBox mesh origin =
    { mesh = mesh, modelMatrix = Linear.makeTranslate origin }


makeMesh : Mesh Vertex
makeMesh =
    let
        vertices =
            Debug.log "Vertices=" <|
                List.concat <|
                    List.map (transformSide frontSide)
                        [ Linear.identity -- Front
                        , Linear.makeRotate halfPi <| vec3 0 1 0 -- Right
                        , Linear.makeRotate -halfPi <| vec3 0 1 0 -- Left
                        , Linear.makeRotate halfPi <| vec3 1 0 0 -- Bottom
                        , Linear.makeRotate -halfPi <| vec3 1 0 0 -- Top
                        , Linear.makeRotate pi <| vec3 1 0 0 -- Back
                        ]

        indices =
            List.concat <|
                List.map squareIndices [ 0, 4, 8, 12, 16, 20 ]
    in
    GL.indexedTriangles vertices indices


squareIndices : Int -> List ( Int, Int, Int )
squareIndices base =
    [ ( base, base + 1, base + 2 )
    , ( base, base + 2, base + 3 )
    ]


frontSide : List Vertex
frontSide =
    [ { position = vec3 0.5 0.5 0.5
      , normal = front
      , tangent = right
      , binormal = up
      , texCoord = vec2 1 1
      }
    , { position = vec3 -0.5 0.5 0.5
      , normal = front
      , tangent = right
      , binormal = up
      , texCoord = vec2 0 1
      }
    , { position = vec3 -0.5 -0.5 0.5
      , normal = front
      , tangent = right
      , binormal = up
      , texCoord = vec2 0 0
      }
    , { position = vec3 0.5 -0.5 0.5
      , normal = front
      , tangent = right
      , binormal = up
      , texCoord = vec2 1 0
      }
    ]


halfPi : Float
halfPi =
    pi * 0.5


transformSide : List Vertex -> Mat4 -> List Vertex
transformSide vertices mat =
    List.map (transformVertex mat) vertices


transformVertex : Mat4 -> Vertex -> Vertex
transformVertex mat vertex =
    { vertex
        | position = Linear.transform mat vertex.position
        , normal = Linear.transform mat vertex.normal
    }


toEntity : Mat4 -> Mat4 -> Texture -> Texture -> Box -> Entity
toEntity projectionMatrix viewMatrix texture bumpmap box =
    GL.entityWith
        [ DepthTest.default
        , Settings.cullFace Settings.back
        ]
        vertexShader
        fragmentShader
        box.mesh
        { projectionMatrix = projectionMatrix
        , viewMatrix = viewMatrix
        , modelMatrix = box.modelMatrix
        , dummyTexture = texture
        , bumpmapTexture = bumpmap
        }


front : Vec3
front =
    vec3 0 0 1


right : Vec3
right =
    vec3 1 0 0


up : Vec3
up =
    vec3 0 1 0


vertexShader :
    Shader Vertex
        { uniforms
            | projectionMatrix : Mat4
            , viewMatrix : Mat4
            , modelMatrix : Mat4
        }
        { vNormal : Vec3
        , vTangent : Vec3
        , vBinormal : Vec3
        , vTexCoord : Vec2
        }
vertexShader =
    [glsl|
        precision mediump float;

        attribute vec3 position;
        attribute vec3 normal;
        attribute vec3 tangent;
        attribute vec3 binormal;
        attribute vec2 texCoord;

        uniform mat4 projectionMatrix;
        uniform mat4 viewMatrix;
        uniform mat4 modelMatrix;

        varying vec3 vNormal;
        varying vec3 vTangent;
        varying vec3 vBinormal;
        varying vec2 vTexCoord;

        void main()
        {
            mat4 vpMatrix = viewMatrix * modelMatrix;
            vNormal = (vpMatrix * vec4(normal, 0.0)).xyz;
            vTangent = (vpMatrix * vec4(tangent, 0.0)).xyz;
            vBinormal = (vpMatrix * vec4(binormal, 0.0)).xyz;
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
            , bumpmapTexture : Texture
        }
        { vNormal : Vec3
        , vTangent : Vec3
        , vBinormal : Vec3
        , vTexCoord : Vec2
        }
fragmentShader =
    [glsl|
        precision mediump float;

        uniform mat4 viewMatrix;
        uniform sampler2D dummyTexture;
        uniform sampler2D bumpmapTexture;

        varying vec3 vNormal;
        varying vec3 vTangent;
        varying vec3 vBinormal;
        varying vec2 vTexCoord;

        vec3 lightDirection = normalize(vec3(1.0, -0.5, -1.0));
        vec3 lightColor = vec3(1.0);

        vec3 bumpedNormal();
        vec3 fragColor();
        vec3 ambientLight();
        vec3 diffuseLight(vec3 normal);

        void main()
        {
            vec3 normal = bumpedNormal();
            vec3 color = fragColor() * (ambientLight() + diffuseLight(normal));
            gl_FragColor = vec4(color, 1.0);
        }

        vec3 bumpedNormal()
        {
            vec3 normal = texture2D(bumpmapTexture, vTexCoord).rgb;
            normal = normal * 2.0 - vec3(1.0);

            mat3 tbn = mat3(normalize(vTangent), normalize(vBinormal), normalize(vNormal));
            return normalize(tbn * normal);
        }

        vec3 fragColor()
        {
            //return texture2D(dummyTexture, vTexCoord).rgb;
            return vec3(0.2, 0.0, 0.8);
        }

        vec3 ambientLight()
        {
            return lightColor * 0.6;
        }

        vec3 diffuseLight(vec3 normal)
        {
            lightDirection = normalize((viewMatrix * vec4(lightDirection, 0.0)).xyz);

            float diffuse = min(0.0, dot(normal, lightDirection));

            return lightColor * diffuse;
        }
    |]
