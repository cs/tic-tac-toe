module Main exposing (main)

import Browser
import Html as H
import Json.Encode as Encode
import Model as Model exposing (Model, Player(..))


type Msg
    = NoOp


main : Program Encode.Value Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = \model -> { title = "Tic Tac Toe", body = view model }
        }


init : Encode.Value -> ( Model, Cmd Msg )
init flags =
    ( { actingPlayer = X, board = Model.emptyBoard }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> List (H.Html Msg)
view { actingPlayer } =
    [ "Hey ", Model.playerToString actingPlayer, ", it's your turn!" ]
        |> List.map H.text
