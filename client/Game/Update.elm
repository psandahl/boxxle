module Game.Update exposing (init, update)

import Game.Model exposing (Model)
import Msg exposing (Msg)
import Renderer.Renderer as Renderer


init : ( Model, Cmd Msg )
init =
    ( { renderer = Renderer.init }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
