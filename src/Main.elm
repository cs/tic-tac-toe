module Main exposing (main)

import Array exposing (Array)
import Browser
import Html as H
import Json.Encode as Encode


type Player
    = X
    | O


type alias Board =
    Array (Maybe Player)


type alias Model =
    { actingPlayer : Player
    , board : Board
    }


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
    let
        emptyBoard =
            Array.initialize 9 (always Nothing)
    in
    ( { actingPlayer = X, board = emptyBoard }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> List (H.Html Msg)
view { actingPlayer } =
    [ "Hey ", playerToString actingPlayer, ", it's your turn!" ]
        |> List.map H.text


playerToString : Player -> String
playerToString player =
    case player of
        X ->
            "X"

        O ->
            "O"
