module Orchestrator.View exposing (view)

import Debug
import Html exposing (Html)
import Msg exposing (Msg)
import Orchestrator.Model exposing (Model, State(..))
import Renderer


view : Model -> Html Msg
view model =
    case model.state of
        Initializing ->
            Html.text "Initializing ..."

        Initialized ->
            case model.renderer of
                Just renderer ->
                    Renderer.viewScene renderer [ model.box ]

                _ ->
                    Debug.crash "No renderer!"

        Error str ->
            Html.text <| "Error: " ++ str
