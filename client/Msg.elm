module Msg exposing (Msg(..))

import WebGL.Texture exposing (Error, Texture)
import Window exposing (Size)


type Msg
    = SetViewport Size
    | SetTextures (Result Error (List Texture))
