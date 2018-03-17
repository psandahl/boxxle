module Model exposing (Model, State(..))

import Box exposing (Box)
import Renderer exposing (Renderer)


type State
    = Initializing
    | Initialized
    | Error String


type alias Model =
    { state : State
    , renderer : Maybe Renderer
    , box : Box
    }
