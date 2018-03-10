module Orchestrator.Update exposing (init, update)

import Box
import Math.Vector3 exposing (vec3)
import Msg exposing (Msg(..))
import Orchestrator.Model exposing (Model, State(..))
import Renderer
import Task
import WebGL.Texture as Texture
import Window


init : ( Model, Cmd Msg )
init =
    ( { state = Initializing
      , renderer = Nothing
      , box = Box.makeBox Box.makeMesh <| vec3 0 0 0
      }
      -- Order the task of loading textures from the server.
    , loadTextures
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetViewport size ->
            ( { model
                | renderer = Maybe.map (Renderer.setViewport size) model.renderer
              }
            , Cmd.none
            )

        SetTextures result ->
            case result of
                Ok [ normalMap, specularMap ] ->
                    ( { model
                        | state = Initialized
                        , renderer = Just <| Renderer.init normalMap specularMap
                      }
                    , Task.perform SetViewport Window.size
                    )

                Ok _ ->
                    ( { model | state = Error "Unexpected number of textures from server" }, Cmd.none )

                _ ->
                    ( { model | state = Error "Communication error with server" }, Cmd.none )


loadTextures : Cmd Msg
loadTextures =
    Task.attempt SetTextures <|
        Task.sequence <|
            List.map Texture.load
                [ "materials/NormalMap.png", "materials/rockbump.jpg" ]
