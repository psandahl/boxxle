module Main exposing (main)

import Game.Model exposing (Model)
import Game.Orchestrator exposing (init, update, view)
import Html
import Msg exposing (Msg)


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
    Sub.none
