module Model exposing (Model, State(..))

import Game exposing (Game)
import Graphics.Renderer exposing (Renderer)


{- Game states -}


type State
    = Initializing
    | Initialized
    | Error String



{- Main model of the Boxxle game -}


type alias Model =
    { state : State
    , renderer : Renderer
    , game : Maybe Game
    }
