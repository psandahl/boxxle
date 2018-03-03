module Game.View exposing (view)

import Game.Model exposing (Model)
import Html exposing (Html)
import Msg exposing (Msg)
import Renderer.Renderer as Renderer


view : Model -> Html Msg
view model =
    Renderer.viewScene model.renderer
