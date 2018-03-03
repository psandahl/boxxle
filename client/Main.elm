module Main exposing (main)

import Html
import Msg exposing (Msg(..))
import Orchestrator.Model exposing (Model)
import Orchestrator.Update exposing (init, update)
import Orchestrator.View exposing (view)
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
