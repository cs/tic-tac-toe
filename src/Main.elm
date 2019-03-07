module Main exposing (main)

import Array
import Browser
import Css as C
import Html.Styled as H
import Json.Encode as Encode
import Model as Model exposing (Board, Model, Player(..))


type Msg
    = NoOp


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
    ( model, Cmd.none )


view : Model -> List (H.Html Msg)
view { actingPlayer, board } =
    [ boardBox board, actingPlayerBox actingPlayer ]


boardBox : Board -> H.Html Msg
boardBox board =
    H.styled H.div
        [ C.border3 (C.px 3) C.solid (C.hex "000000") ]
        []
        (Array.map (\maybePlayer -> H.div [] [ maybePlayer |> Maybe.map Model.playerToString |> Maybe.withDefault "empty" |> H.text ]) board |> Array.toList)


actingPlayerBox : Player -> H.Html Msg
actingPlayerBox player =
    [ "Hey ", Model.playerToString player, ", it's your turn!" ]
        |> List.map H.text
        |> H.styled H.div [ C.fontSize (C.px 32) ] []
