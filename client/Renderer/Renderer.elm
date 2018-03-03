module Renderer.Renderer exposing (init, setViewport, viewScene)

import Html exposing (Html)
import Html.Attributes as Attr
import Msg exposing (Msg)
import Renderer.Model exposing (Model)
import WebGL as GL
import Window exposing (Size)


init : Model
init =
    { viewport = defaultViewport }


setViewport : Model -> Size -> Model
setViewport model size =
    { model | viewport = size }


viewScene : Model -> Html Msg
viewScene model =
    GL.toHtmlWith
        [ GL.antialias
        , GL.depth 1
        , GL.clearColor 0 0 1 0
        ]
        [ Attr.height model.viewport.height
        , Attr.width model.viewport.width
        ]
        []


defaultViewport : Size
defaultViewport =
    Size 800 600
