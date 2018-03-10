module Orchestrator.Update exposing (init, update)

import Box
import Debug
import Math.Vector3 exposing (vec3)
import Msg exposing (Msg(..))
import Orchestrator.Model exposing (Model)
import Renderer
import Task
import WebGL.Texture as Texture
import Window


init : ( Model, Cmd Msg )
init =
    ( { renderer = Renderer.init
      , box = Box.makeBox Box.makeMesh <| vec3 0 0 0
      }
    , Task.perform SetViewport Window.size
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetViewport size ->
            ( { model
                | renderer = Renderer.setViewport model.renderer size
              }
            , loadTextures
            )

        SetTextures result ->
            case result of
                Ok [ texture, bumpmap ] ->
                    ( { model
                        | renderer = Renderer.setTextures model.renderer [ texture, bumpmap ]
                      }
                    , Cmd.none
                    )

                _ ->
                    Debug.crash "Boom"


loadTextures : Cmd Msg
loadTextures =
    Task.attempt SetTextures <|
        Task.sequence <|
            List.map Texture.load
                [ "materials/rock.jpg", "materials/NormalMap.png" ]
