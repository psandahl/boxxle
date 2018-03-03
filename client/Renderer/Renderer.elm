module Renderer.Renderer exposing (init, scene, setViewport)

import Html exposing (Html)
import Msg exposing (Msg)
import Renderer.Model exposing (Model)
import Window exposing (Size)


init : Model
init =
    { viewport = defaultViewport }


setViewport : Model -> Size -> Model
setViewport model size =
    { model | viewport = size }


scene : Model -> Html Msg
scene model =
    Html.text <| "Viewport: " ++ toString model.viewport


defaultViewport : Size
defaultViewport =
    Size 800 600
