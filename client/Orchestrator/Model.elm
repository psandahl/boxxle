module Orchestrator.Model exposing (Model)

import Box exposing (Box)
import Renderer exposing (Renderer)


type alias Model =
    { renderer : Renderer
    , box : Box
    }
