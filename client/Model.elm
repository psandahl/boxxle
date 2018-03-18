module Model exposing (Model, State(..))

import Game exposing (Game)
import Renderer exposing (Renderer)


type State
    = Initializing
    | Initialized
    | Error String


type alias Model =
    { state : State
    , renderer : Renderer
    , game : Maybe Game
    }
