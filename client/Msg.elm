module Msg exposing (Msg(..))

import WebGL.Texture exposing (Error, Texture)
import Window exposing (Size)


{- Messages sent to the Boxxle game -}


type
    Msg
    -- Screen viewport is changed.
    = SetViewport Size
      -- Textures are received from the server.
    | SetTextures (Result Error (List Texture))
