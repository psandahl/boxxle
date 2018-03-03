module Main exposing (main)

import Game.Model exposing (Model)
import Game.Update exposing (init, update)
import Game.View exposing (view)
import Html
import Msg exposing (Msg(..))
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
