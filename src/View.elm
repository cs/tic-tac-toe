module View exposing (view)

import Array
import Css as C
import Html.Styled as H
import Html.Styled.Events as E
import Model as Model exposing (Board, Model, Msg(..), Player(..))


view : Model -> List (H.Html Msg)
view { actingPlayer, board } =
    let
        viewIf predicate content =
            if predicate then
                content

            else
                H.text ""
    in
    [ H.styled H.div
        [ C.displayFlex
        , C.flexDirection C.column
        , C.alignItems C.center
        , C.margin (C.px 16)
        ]
        []
        [ H.styled H.h1 [ C.fontSize (C.px 40) ] [] [ H.text "Tic Tac Toe" ]
        , renderBoard board
        , renderActingPlayer actingPlayer
        , viewIf (board /= Model.emptyBoard) renderRestartButton
        ]
    ]


renderBoard : Board -> H.Html Msg
renderBoard board =
    let
        renderBoardCell ( index, player ) =
            H.styled H.div
                [ C.displayFlex
                , C.alignItems C.center
                , C.justifyContent C.center
                , C.flex3 (C.num 0) (C.num 0) (C.px 100)
                , C.margin (C.px 5)
                , C.width (C.px 100)
                , C.height (C.px 100)
                , C.border3 (C.px 1) C.solid (C.hex "999999")
                , C.boxSizing C.borderBox
                , C.fontSize (C.px 80)
                , C.fontWeight C.bold
                , C.fontFamily C.monospace
                , C.color (Maybe.map playerToColor player |> Maybe.withDefault (C.hex "000000"))
                , C.backgroundColor (C.hex "ffffff")
                , C.hover [ C.backgroundColor (C.hex "eeeeee") ]
                ]
                [ E.onClick (MakeMoveMsg index) ]
                [ Maybe.map playerToString player
                    |> Maybe.withDefault ""
                    |> H.text
                ]
    in
    H.styled H.div
        [ C.displayFlex
        , C.flexWrap C.wrap
        , C.width (C.px 330)
        , C.height (C.px 330)
        , C.boxSizing C.contentBox
        ]
        []
        (Array.toIndexedList board |> List.map renderBoardCell)


renderActingPlayer : Player -> H.Html Msg
renderActingPlayer player =
    H.styled H.div
        [ C.margin (C.px 16), C.fontSize (C.px 32) ]
        []
        [ H.text "Hey "
        , H.styled H.strong
            [ C.color (playerToColor player) ]
            []
            [ H.text <| playerToString player ]
        , H.text ", it's your turn!"
        ]


renderRestartButton : H.Html Msg
renderRestartButton =
    H.styled H.div
        [ C.margin (C.px 16) ]
        []
        [ H.styled H.a
            [ C.fontSize (C.px 24)
            , C.color (C.hex "#4c6cff")
            , C.hover [ C.textDecoration C.underline ]
            ]
            [ E.onClick RestartMsg ]
            [ H.text "Restart Game" ]
        ]


playerToString : Player -> String
playerToString player =
    case player of
        X ->
            "X"

        O ->
            "O"


playerToColor : Player -> C.Color
playerToColor player =
    case player of
        X ->
            C.hex "ff0000"

        O ->
            C.hex "0000ff"
