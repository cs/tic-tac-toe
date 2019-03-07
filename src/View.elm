module View exposing (view)

import Array
import Css as C
import Html.Styled as H
import Html.Styled.Events as E
import Model as Model exposing (Board, Model, Msg(..), Player(..))


view : Model -> List (H.Html Msg)
view { actingPlayer, board } =
    [ boardBox board, actingPlayerBox actingPlayer, restartGameButton ]


boardBox : Board -> H.Html Msg
boardBox board =
    H.styled H.div
        [ C.border3 (C.px 3) C.solid (C.hex "000000") ]
        []
        (Array.map (\maybePlayer -> H.div [] [ maybePlayer |> Maybe.map playerToString |> Maybe.withDefault "empty" |> H.text ]) board |> Array.toList)


actingPlayerBox : Player -> H.Html Msg
actingPlayerBox player =
    [ "Hey ", playerToString player, ", it's your turn!" ]
        |> List.map H.text
        |> H.styled H.div [ C.fontSize (C.px 32) ] []


restartGameButton : H.Html Msg
restartGameButton =
    H.button [ E.onClick RestartGameMsg ] [ H.text "Restart Game" ]


playerToString : Player -> String
playerToString player =
    case player of
        X ->
            "X"

        O ->
            "O"
