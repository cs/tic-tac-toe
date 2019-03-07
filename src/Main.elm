module Main exposing (main)

import Browser
import Html as H
import Json.Encode as Encode


type alias Model =
    {}


type Msg
    = NoOp


main : Program Encode.Value Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = \model -> { title = "Tic Tac Toe", body = view model }
        }


init : Encode.Value -> ( Model, Cmd Msg )
init flags =
    ( {}, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> List (H.Html Msg)
view model =
    []
