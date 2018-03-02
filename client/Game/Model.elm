module Game.Model exposing (Model)

import Renderer.Model as Renderer


type alias Model =
    { renderer : Renderer.Model }
