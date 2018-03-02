module Renderer.Renderer exposing (init, scene)

import Debug
import Html exposing (Html)
import Msg exposing (Msg)
import Renderer.Model exposing (Model)
import Window exposing (Size)


init : Model
init =
    { viewport = defaultViewport }


scene : Model -> Html Msg
scene model =
    let
        d =
            Debug.log "Viewport: " model.viewport
    in
    Html.text "Foo"


defaultViewport : Size
defaultViewport =
    Size 800 600
