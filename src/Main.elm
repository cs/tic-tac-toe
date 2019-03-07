module Main exposing (main)

import Browser
import Html.Styled as H
import Json.Encode as Encode
import Model as Model exposing (Model, Msg(..), Player(..))
import View exposing (view)


main : Program Encode.Value Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view =
            \model ->
                { title = "Tic Tac Toe"
                , body = view model |> List.map H.toUnstyled
                }
        }


init : Encode.Value -> ( Model, Cmd Msg )
init flags =
    ( { actingPlayer = X, board = Model.emptyBoard }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RestartGameMsg ->
            ( { actingPlayer = X, board = Model.emptyBoard }, Cmd.none )
