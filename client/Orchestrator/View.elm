module Orchestrator.View exposing (view)

import Html exposing (Html)
import Msg exposing (Msg)
import Orchestrator.Model exposing (Model)
import Renderer


view : Model -> Html Msg
view model =
    Renderer.viewScene model.renderer
