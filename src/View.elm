module View exposing (view)

import Array
import Css as C
import Html.Styled as H
import Html.Styled.Events as E
import Model as Model exposing (Board, Model, Msg(..), Player(..))


view : Model -> List (H.Html Msg)
view { actingPlayer, board } =
    [ renderBoard board, renderActingPlayer actingPlayer, renderRestartButton ]


renderBoard : Board -> H.Html Msg
renderBoard board =
    let
        renderBoardCell ( index, maybePlayer ) =
            H.div [ E.onClick (MakeMoveMsg index) ]
                [ case maybePlayer of
                    Nothing ->
                        H.text "(empty)"

                    Just player ->
                        playerToString player |> H.text
                ]
    in
    H.styled H.div
        [ C.border3 (C.px 3) C.solid (C.hex "000000") ]
        []
        (Array.toIndexedList board |> List.map renderBoardCell)


renderActingPlayer : Player -> H.Html Msg
renderActingPlayer player =
    [ "Hey ", playerToString player, ", it's your turn!" ]
        |> List.map H.text
        |> H.styled H.div [ C.fontSize (C.px 32) ] []


renderRestartButton : H.Html Msg
renderRestartButton =
    H.button [ E.onClick RestartMsg ] [ H.text "Restart Game" ]


playerToString : Player -> String
playerToString player =
    case player of
        X ->
            "X"

        O ->
            "O"
