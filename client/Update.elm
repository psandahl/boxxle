module Update exposing (init, update)

import Debug
import Game
import Graphics.Box as Box
import Graphics.Renderer as Renderer
import Math.Vector3 exposing (vec3)
import Model exposing (Model, State(..))
import Msg exposing (Msg(..))
import Task
import WebGL.Texture as Texture
import Window


{- Initialize the main model. -}


init : ( Model, Cmd Msg )
init =
    ( { state = Initializing
      , renderer = Renderer.init
      , game = Nothing
      }
      -- Order a new viewport and load textures from server.
    , Cmd.batch [ Task.perform SetViewport Window.size, loadTextures ]
    )



{- Handle messages. -}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MousePosition position ->
            let
                ray =
                    Renderer.getMouseRay position model.renderer
            in
            ( { model
                | game = Maybe.map (Game.intersect ray) model.game
              }
            , Cmd.none
            )

        SetViewport size ->
            ( { model
                | renderer = Renderer.setViewport size model.renderer
              }
            , Cmd.none
            )

        SetTextures result ->
            case result of
                Ok [ normalMap, specularMap ] ->
                    ( { model
                        | state = Initialized
                        , game = Just <| Game.init Box.makeMesh normalMap specularMap
                      }
                    , Cmd.none
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
                [ "materials/normal-atlas.png"
                , "materials/specular-atlas.png"
                ]
