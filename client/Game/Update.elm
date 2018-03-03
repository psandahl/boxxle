module Game.Update exposing (init, update)

import Game.Model exposing (Model)
import Msg exposing (Msg(..))
import Renderer.Renderer as Renderer
import Task
import Window


init : ( Model, Cmd Msg )
init =
    ( { renderer = Renderer.init }, Task.perform SetViewport Window.size )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetViewport size ->
            ( { model | renderer = Renderer.setViewport model.renderer size }, Cmd.none )
