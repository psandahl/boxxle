module Msg exposing (Msg(..))

import Mouse exposing (Position)
import WebGL.Texture exposing (Error, Texture)
import Window exposing (Size)


{- Messages sent to the Boxxle game -}


type
    Msg
    -- Mouse have been moved to a new position.
    = MousePosition Position
      -- Screen viewport is changed.
    | SetViewport Size
      -- Textures are received from the server.
    | SetTextures (Result Error (List Texture))
