module Game.Update exposing (init, update)

import Game.Model exposing (Model(..))
import Msg exposing (Msg)


init : ( Model, Cmd Msg )
init =
    ( Model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
