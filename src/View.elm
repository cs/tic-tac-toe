module View exposing (view)

import Array
import Css as C
import Html.Styled as H
import Html.Styled.Attributes as A
import Html.Styled.Events as E
import Model as Model exposing (Board, Model, Msg(..), Player(..))


view : Model -> List (H.Html Msg)
view ({ actingPlayer, board } as model) =
    [ H.styled H.div
        [ C.displayFlex
        , C.flexDirection C.column
        , C.alignItems C.center
        , C.margin (C.px 16)
        ]
        []
        [ H.styled H.h1 [ C.fontSize (C.px 40) ] [] [ H.text "Tic-Tac-Toe" ]
        , renderBoard board
        , renderState model
        , if board /= Model.emptyBoard then
            renderRestartLink

          else
            H.text ""
        , H.styled H.hr [ C.width (C.px 150) ] [] []
        , H.styled H.div
            [ C.padding (C.px 16) ]
            []
            [ H.styled H.a
                [ C.fontSize (C.px 16)
                , C.color (C.hex "#4c6cff")
                , C.textDecoration C.none
                , C.hover [ C.textDecoration C.underline ]
                ]
                [ A.href "https://github.com/cs/tic-tac-toe" ]
                [ H.text "Get the Code on GitHub" ]
            ]
        ]
    ]


renderBoard : Board -> H.Html Msg
renderBoard board =
    H.styled H.div
        [ C.displayFlex
        , C.flexWrap C.wrap
        , C.width (C.px 330)
        , C.height (C.px 330)
        , C.boxSizing C.contentBox
        ]
        []
        (Array.toIndexedList board |> List.map renderBoardCell)


renderBoardCell : ( Int, Maybe Player ) -> H.Html Msg
renderBoardCell ( index, player ) =
    H.styled H.div
        [ C.displayFlex
        , C.alignItems C.center
        , C.justifyContent C.center
        , C.flex3 (C.num 0) (C.num 0) (C.px 100)
        , C.margin (C.px 5)
        , C.width (C.px 100)
        , C.height (C.px 100)
        , C.border3 (C.px 1) C.solid (C.hex "cccccc")
        , C.boxSizing C.borderBox
        , C.fontSize (C.px 80)
        , C.cursor C.pointer
        , C.backgroundColor (C.hex "ffffff")
        , C.hover [ C.backgroundColor (C.hex "eeeeee") ]
        ]
        [ E.onClick (MakeMoveMsg index) ]
        [ Maybe.map renderPlayerLabel player |> Maybe.withDefault (H.text "") ]


renderState : Model -> H.Html Msg
renderState { actingPlayer, board } =
    H.styled H.div
        [ C.margin (C.px 32), C.fontSize (C.px 32), C.textAlign C.center ]
        []
        (case Model.detectWinner board of
            Just player ->
                [ H.text "Congrats "
                , renderPlayerLabel player
                , H.text ","
                , H.br [] []
                , H.text "you have won!"
                ]

            Nothing ->
                [ H.text "Hey "
                , renderPlayerLabel actingPlayer
                , H.text ","
                , H.br [] []
                , H.text "it's your turn!"
                ]
        )


renderPlayerLabel : Player -> H.Html Msg
renderPlayerLabel player =
    let
        name =
            case player of
                X ->
                    "X"

                O ->
                    "O"

        color =
            case player of
                X ->
                    C.hex "ff0000"

                O ->
                    C.hex "0000ff"
    in
    H.styled H.strong [ C.color color, C.fontFamily C.monospace ] [] [ H.text name ]


renderRestartLink : H.Html Msg
renderRestartLink =
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
