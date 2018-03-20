module Graphics.Box
    exposing
        ( Box
        , Vertex
        , init
        , makeMesh
        , toEntity
        )

import Debug
import Math.Matrix4 as Linear exposing (Mat4)
import Math.Vector2 exposing (Vec2, vec2)
import Math.Vector3 exposing (Vec3, vec3)
import WebGL as GL exposing (Entity, Mesh, Shader)
import WebGL.Settings as Settings
import WebGL.Settings.DepthTest as DepthTest
import WebGL.Texture exposing (Texture)


{- Box record. -}


type alias Box =
    { mesh : Mesh Vertex
    , normalMap : Texture
    , specularMap : Texture
    , modelMatrix : Mat4
    }



{- Box vertex attributes. -}


type alias Vertex =
    { position : Vec3
    , normal : Vec3
    , tangent : Vec3
    , bitangent : Vec3
    , texCoord : Vec2
    }



{- Init a new box. -}


init : Mesh Vertex -> Texture -> Texture -> Vec3 -> Box
init mesh normalMap specularMap origin =
    { mesh = mesh
    , normalMap = normalMap
    , specularMap = specularMap
    , modelMatrix = Linear.makeTranslate origin
    }



{- Make a box mesh. -}


makeMesh : Mesh Vertex
makeMesh =
    let
        vertices =
            List.concat [ frontSide, backSide, rightSide, leftSide, bottomSide, topSide ]

        indices =
            List.concat <|
                List.map squareIndices [ 0, 4, 8, 12, 16, 20 ]
    in
    GL.indexedTriangles vertices indices



{- Generate indices for a square starting with the given vertex index. -}


squareIndices : Int -> List ( Int, Int, Int )
squareIndices base =
    [ ( base, base + 1, base + 2 )
    , ( base, base + 2, base + 3 )
    ]


frontSide : List Vertex
frontSide =
    transformSide (side horizontalTexture) Linear.identity


backSide : List Vertex
backSide =
    transformSide (side verticalTexture) <|
        Linear.makeRotate pi <|
            vec3 1 0 0


rightSide : List Vertex
rightSide =
    transformSide (side rightTexture) <|
        Linear.makeRotate halfPi <|
            vec3 0 1 0


leftSide : List Vertex
leftSide =
    transformSide (side leftTexture) <|
        Linear.makeRotate -halfPi <|
            vec3 0 1 0


bottomSide : List Vertex
bottomSide =
    transformSide (side switchTexture) <|
        Linear.makeRotate halfPi <|
            vec3 1 0 0


topSide : List Vertex
topSide =
    transformSide (side switchTexture) <|
        Linear.makeRotate -halfPi <|
            vec3 1 0 0



{- The template side is facing forward, i.e. point towards positive Z. -}


side : ( Vec2, Vec2, Vec2, Vec2 ) -> List Vertex
side ( ll, lr, ul, ur ) =
    [ { position = vec3 0.5 0.5 0.5
      , normal = front
      , tangent = right
      , bitangent = up
      , texCoord = ur
      }
    , { position = vec3 -0.5 0.5 0.5
      , normal = front
      , tangent = right
      , bitangent = up
      , texCoord = ul
      }
    , { position = vec3 -0.5 -0.5 0.5
      , normal = front
      , tangent = right
      , bitangent = up
      , texCoord = ll
      }
    , { position = vec3 0.5 -0.5 0.5
      , normal = front
      , tangent = right
      , bitangent = up
      , texCoord = lr
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


toEntity : Mat4 -> Mat4 -> Box -> Entity
toEntity projectionMatrix viewMatrix box =
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
        , normalMap = box.normalMap
        , specularMap = box.specularMap
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


blankTexture : ( Vec2, Vec2, Vec2, Vec2 )
blankTexture =
    ( vec2 0 0.75, vec2 0.5 0.75, vec2 0 1, vec2 0.5 1 )


horizontalTexture : ( Vec2, Vec2, Vec2, Vec2 )
horizontalTexture =
    ( vec2 0.5 0.75, vec2 1 0.75, vec2 0.5 1, vec2 1 1 )


leftTexture : ( Vec2, Vec2, Vec2, Vec2 )
leftTexture =
    ( vec2 0 0.5, vec2 0.5 0.5, vec2 0 0.75, vec2 0.5 0.75 )


rightTexture : ( Vec2, Vec2, Vec2, Vec2 )
rightTexture =
    ( vec2 0.5 0.5, vec2 1 0.5, vec2 0.5 0.75, vec2 1 0.75 )


switchTexture : ( Vec2, Vec2, Vec2, Vec2 )
switchTexture =
    ( vec2 0 0.25, vec2 0.5 0.25, vec2 0 0.5, vec2 0.5 0.5 )


verticalTexture : ( Vec2, Vec2, Vec2, Vec2 )
verticalTexture =
    ( vec2 0.5 0.25, vec2 1 0.25, vec2 0.5 0.5, vec2 1 0.5 )


vertexShader :
    Shader Vertex
        { uniforms
            | projectionMatrix : Mat4
            , viewMatrix : Mat4
            , modelMatrix : Mat4
        }
        { vPosition : Vec3
        , vNormal : Vec3
        , vTangent : Vec3
        , vBitangent : Vec3
        , vTexCoord : Vec2
        }
vertexShader =
    [glsl|
        precision mediump float;

        attribute vec3 position;
        attribute vec3 normal;
        attribute vec3 tangent;
        attribute vec3 bitangent;
        attribute vec2 texCoord;

        uniform mat4 projectionMatrix;
        uniform mat4 viewMatrix;
        uniform mat4 modelMatrix;

        varying vec3 vPosition;
        varying vec3 vNormal;
        varying vec3 vTangent;
        varying vec3 vBitangent;
        varying vec2 vTexCoord;

        void main()
        {
            mat4 mvMatrix = viewMatrix * modelMatrix;

            vPosition = (mvMatrix * vec4(position, 1.0)).xyz;
            vNormal = (mvMatrix * vec4(normal, 0.0)).xyz;
            vTangent = (mvMatrix * vec4(tangent, 0.0)).xyz;
            vBitangent = (mvMatrix * vec4(bitangent, 0.0)).xyz;
            vTexCoord = texCoord;

            mat4 mvpMatrix = projectionMatrix * mvMatrix;
            gl_Position = mvpMatrix * vec4(position, 1.0);
        }
    |]


fragmentShader :
    Shader {}
        { uniforms
            | viewMatrix : Mat4
            , normalMap : Texture
            , specularMap : Texture
        }
        { vPosition : Vec3
        , vNormal : Vec3
        , vTangent : Vec3
        , vBitangent : Vec3
        , vTexCoord : Vec2
        }
fragmentShader =
    [glsl|
        precision mediump float;

        uniform mat4 viewMatrix;
        uniform sampler2D normalMap;
        uniform sampler2D specularMap;

        varying vec3 vPosition;
        varying vec3 vNormal;
        varying vec3 vTangent;
        varying vec3 vBitangent;
        varying vec2 vTexCoord;

        // From right behind.
        vec3 light1 = normalize(vec3(1.0, -3.0, 1.0));
        // From left behind.
        vec3 light2 = normalize(vec3(-1.0, -3.0, 1.0));
        // From above and in front.
        vec3 light3 = normalize(vec3(0.0, 1.0, -1.0));
        // From back and below.
        vec3 light4 = normalize(vec3(0.0, -1.0, 1.0));

        vec3 lightColor = vec3(1.0);

        vec3 bumpedNormal();
        vec3 fragColor();
        vec3 ambientLight();
        vec3 diffuseLight(vec3 normal, vec3 transformedLightDir);
        vec3 specularLight(vec3 normal, vec3 transformedLightDir);

        void main()
        {
            vec3 normal = bumpedNormal();
            vec3 transformedLight1 = normalize((viewMatrix * vec4(light1, 0.0)).xyz);
            vec3 transformedLight2 = normalize((viewMatrix * vec4(light2, 0.0)).xyz);
            vec3 transformedLight3 = normalize((viewMatrix * vec4(light3, 0.0)).xyz);
            vec3 transformedLight4 = normalize((viewMatrix * vec4(light4, 0.0)).xyz);

            vec3 diffuse = diffuseLight(normal, transformedLight1) +
                diffuseLight(normal, transformedLight2) +
                    diffuseLight(normal, transformedLight3) +
                        diffuseLight(normal, transformedLight4);

            vec3 specular = specularLight(normal, transformedLight1) +
                specularLight(normal, transformedLight2) +
                    specularLight(normal, transformedLight3) +
                        specularLight(normal, transformedLight4);

            vec3 color = fragColor() *
                (ambientLight() + diffuse / 4.0 + specular / 4.0);

            gl_FragColor = vec4(color, 1.0);
        }

        vec3 bumpedNormal()
        {
            vec3 normal = texture2D(normalMap, vTexCoord).rgb;
            normal = normal * 2.0 - vec3(1.0);

            mat3 tbn = mat3(normalize(vTangent), normalize(vBitangent), normalize(vNormal));
            return normalize(tbn * normal);
        }

        vec3 fragColor()
        {
            return vec3(0.95, 0.95, 0.95);
        }

        vec3 ambientLight()
        {
            return lightColor * 0.3;
        }

        vec3 diffuseLight(vec3 normal, vec3 transformedLightDir)
        {
            float diffuse = max(0.0, dot(normal, transformedLightDir));

            return lightColor * diffuse;
        }

        vec3 specularLight(vec3 normal, vec3 transformedLightDir)
        {
            vec3 reflectDir = reflect(-transformedLightDir, normal);
            vec3 viewDir = normalize(vec3(0.0) - vPosition);
            float specular = pow(max(dot(viewDir, reflectDir), 0.0), 16.0);

            float shine = texture2D(specularMap, vTexCoord).r;

            return lightColor * specular * shine;
        }
    |]
