module Game.Orchestrator exposing (init, update, view)

import Game.Model exposing (Model(..))
import Html exposing (Html)
import Msg exposing (Msg)


init : ( Model, Cmd Msg )
init =
    ( Model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Html.text "Hello"
