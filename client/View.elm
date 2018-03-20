module View exposing (view)

import Debug
import Game
import Graphics.Renderer as Renderer
import Html exposing (Html)
import Model exposing (Model, State(..))
import Msg exposing (Msg)


view : Model -> Html Msg
view model =
    case model.state of
        Initializing ->
            Html.text "Initializing ..."

        Initialized ->
            case model.game of
                Just game ->
                    Renderer.viewScene model.renderer <| Game.boxes game

                _ ->
                    Debug.crash "No game although Initialized state"

        Error str ->
            Html.text <| "Error: " ++ str
