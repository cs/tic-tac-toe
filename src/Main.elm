module Main exposing (main)

import Array
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
update msg ({ actingPlayer, board } as model) =
    case msg of
        RestartMsg ->
            ( { model | actingPlayer = X, board = Model.emptyBoard }, Cmd.none )

        MakeMoveMsg index ->
            case Array.get index board of
                Just Nothing ->
                    ( { model
                        | actingPlayer = Model.nextPlayer actingPlayer
                        , board = Array.set index (Just actingPlayer) board
                      }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )
