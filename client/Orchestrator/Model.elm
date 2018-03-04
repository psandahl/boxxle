module Orchestrator.Model exposing (Model)

import Box exposing (Box)
import Renderer


type alias Model =
    { renderer : Renderer.Model
    , box : Box
    }
