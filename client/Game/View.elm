module Game.View exposing (view)

import Game.Model exposing (Model)
import Html exposing (Html)
import Msg exposing (Msg)


view : Model -> Html Msg
view model =
    Html.text "Hello"
