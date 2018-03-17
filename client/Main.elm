module Main exposing (main)

import Html
import Model exposing (Model)
import Msg exposing (Msg(..))
import Update exposing (init, update)
import View exposing (view)
import Window


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Window.resizes SetViewport
