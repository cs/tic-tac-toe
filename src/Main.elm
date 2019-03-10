module Main exposing (main)

import Array
import Browser
import Browser.Navigation
import Html.Styled as H
import Json.Encode as Encode
import Model as Model exposing (Model, Msg(..), Player(..))
import Url exposing (Url)
import View exposing (view)


main : Program Encode.Value Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view =
            \model ->
                { title = "Tic-Tac-Toe written in Elm"
                , body = view model |> List.map H.toUnstyled
                }
        , onUrlRequest = UrlRequestMsg
        , onUrlChange = UrlChangeMsg
        }


init : Encode.Value -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { key = key, actingPlayer = X, board = Model.emptyBoard }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ actingPlayer, board } as model) =
    case msg of
        UrlRequestMsg urlRequest ->
            ( model
            , case urlRequest of
                Browser.Internal url ->
                    Browser.Navigation.pushUrl model.key (Url.toString url)

                Browser.External url ->
                    Browser.Navigation.load url
            )

        UrlChangeMsg url ->
            ( model, Cmd.none )

        RestartMsg ->
            ( { model | actingPlayer = X, board = Model.emptyBoard }, Cmd.none )

        MakeMoveMsg index ->
            if Array.get index board == Just Nothing && Model.detectWinner board == Nothing then
                ( { model
                    | actingPlayer = Model.nextPlayer actingPlayer
                    , board = Array.set index (Just actingPlayer) board
                  }
                , Cmd.none
                )

            else
                ( model, Cmd.none )
