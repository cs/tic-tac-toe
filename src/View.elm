module View exposing (view)

import Array
import Artwork
import Bool.Extra as Bool
import Css as C
import Css.Media as Media
import Html.Styled as H
import Html.Styled.Attributes as A
import Html.Styled.Events as E
import Model as Model exposing (Model, Msg(..), Player(..))
import Svg.Styled as Svg
import Svg.Styled.Attributes as SvgA


view : Model -> List (H.Html Msg)
view model =
    [ H.div
        [ A.css
            [ C.maxWidth (C.px 512)
            , C.margin2 C.zero C.auto
            , C.color (C.hex "#ffffff")
            , C.fontSize (C.px 16)
            ]
        ]
        [ viewHeader
        , viewMain model
        , viewAside model
        , viewSeparator
        , viewDescription
        , viewFooter
        ]
    ]


viewHeader : H.Html Msg
viewHeader =
    H.header
        [ A.css [ C.margin2 (C.px 32) (C.px 16), C.textAlign C.left ] ]
        [ H.h1
            [ A.css [ C.fontSize (C.px 32), C.lineHeight (C.num 1) ] ]
            [ H.text "Tic-Tac-Toe ", H.br [] [], H.small [] [ H.text "written in Elm" ] ]
        ]


viewMain : Model -> H.Html Msg
viewMain model =
    H.main_
        [ A.css
            [ C.displayFlex
            , C.flexWrap C.wrap
            , C.margin2 (C.px 32) C.zero
            , C.width (C.px 512)
            , C.maxWidth (C.pct 100)
            , C.height (C.px 512)
            , C.maxHeight (C.vw 100)
            ]
        ]
        (Array.toIndexedList model.board |> List.map viewCell)


viewCell : ( Int, Maybe Player ) -> H.Html Msg
viewCell ( index, player ) =
    H.div
        [ A.css
            [ C.boxSizing C.borderBox
            , C.width (C.pct 33.333)
            , C.height (C.pct 33.333)
            , C.padding (C.pct 2)
            , C.color (C.hex "#f36b15")
            ]
        , E.onClick (MakeMoveMsg index)
        ]
        [ H.div
            [ A.css
                [ C.displayFlex
                , C.alignItems C.center
                , C.justifyContent C.center
                , C.cursor C.pointer
                , C.width (C.pct 100)
                , C.height (C.pct 100)
                , C.borderRadius (C.pct 25)
                , C.backgroundColor (C.hex "#333333")
                , C.hover [ C.backgroundColor (C.hex "#444444") ]
                ]
            ]
            [ Maybe.map (viewPlayerIcon [ C.width (C.pct 70), C.height (C.pct 70) ]) player
                |> Maybe.withDefault (H.text "")
            ]
        ]


viewAside : Model -> H.Html Msg
viewAside { actingPlayer, board } =
    let
        iconStyle =
            [ C.display C.inline, C.height (C.px 18), C.color (C.hex "#f36b15") ]
    in
    H.aside
        [ A.css
            [ C.displayFlex
            , C.alignItems C.center
            , C.justifyContent C.spaceBetween
            , C.margin2 (C.px 32) (C.px 16)
            ]
        ]
        [ H.div [ A.css [ C.fontSize (C.px 24), C.lineHeight (C.px 32) ] ]
            (case Model.detectWinner board of
                Just player ->
                    [ H.text "Congrats "
                    , viewPlayerIcon iconStyle player
                    , H.text ", you have won!"
                    ]

                Nothing ->
                    [ H.text "Hey "
                    , viewPlayerIcon iconStyle actingPlayer
                    , H.text ", it's your turn!"
                    ]
            )
        , Bool.ifElse viewRestartButton (H.text "") (board /= Model.emptyBoard)
        ]


viewRestartButton : H.Html Msg
viewRestartButton =
    H.button
        [ A.css
            [ C.backgroundColor (C.hex "#f36b15")
            , C.color (C.hex "#ffffff")
            , C.borderWidth C.zero
            , C.padding2 (C.px 8) (C.px 16)
            , C.fontSize (C.px 16)
            , C.lineHeight (C.num 1)
            ]
        , E.onClick RestartMsg
        ]
        [ H.text "Restart" ]


viewSeparator : H.Html Msg
viewSeparator =
    H.div
        [ A.css [ C.margin2 (C.px 32) (C.px 16) ] ]
        [ H.hr [ A.css [ C.width (C.pct 50), C.borderColor (C.hex "#888888") ] ] [] ]


viewDescription : H.Html Msg
viewDescription =
    let
        styleLink =
            [ C.color (C.hex "#f36b15")
            , C.textDecoration C.none
            , C.hover [ C.textDecoration C.underline ]
            ]
    in
    H.aside
        [ A.css [ C.margin2 (C.px 32) (C.px 16), C.textAlign C.justify, C.lineHeight (C.px 20) ] ]
        [ H.p []
            [ H.text "This is a small demo of the "
            , H.a [ A.css styleLink, A.href "https://elm-lang.org", A.target "_blank" ]
                [ H.text "functional programming language Elm" ]
            , H.text """ for front-end development. Elm is a replacement for
                        regular JavaScript, offering some crucial advantages:"""
            ]
        , H.ol []
            [ H.li [] [ H.text """Greatly reduced surface area for bugs, due to
                                  being statically typed. Almost no more runtime
                                  errors and crashes.""" ]
            , H.li [] [ H.text """Clean and well-defined architecture, allowing
                                  complex web applications to scale well and to
                                  be refactored easily.""" ]
            , H.li [] [ H.text """Smaller page sizes and enhanced performance,
                                  due to being compiled to efficient low-level
                                  code and its use of a virtual DOM.""" ]
            ]
        , H.p [] [ H.text """Functional is currently becoming a trend in front-end
                             development. In the end, it's all about making
                             applications more reliable, driving down cost, and
                             speeding up development.""" ]
        , H.p []
            [ H.text "The code for this page is "
            , H.a
                [ A.css styleLink, A.href "https://github.com/cs/tic-tac-toe" ]
                [ H.text "available over on GitHub" ]
            , H.text ". Feel free to check it out if you are curious and don't hestitate "
            , H.a
                [ A.css styleLink, A.href "mailto:cs@bugfactory.io" ]
                [ H.text "to approach us if you have any questions" ]
            , H.text "."
            ]
        ]


viewFooter : H.Html Msg
viewFooter =
    H.footer
        [ A.css [ C.margin2 (C.px 32) (C.px 16), C.textAlign C.right ] ]
        [ H.a
            [ A.href "https://bugfactory.io", A.css [ C.color C.inherit ] ]
            [ Artwork.logoLarge (C.px 32) ]
        ]



-- Player Icons


viewPlayerIcon : List C.Style -> Player -> H.Html Msg
viewPlayerIcon styles player =
    case player of
        X ->
            iconX styles

        O ->
            iconO styles


iconX : List C.Style -> H.Html msg
iconX styles =
    let
        pathData =
            "M17.6777 0L0 17.6777L32.2393 49.917L0 82.1563L17.6777 99.834L49.917 67.5947L82.1562 99.8339L99.8339 82.1562L67.5947 49.917L99.8339 17.6777L82.1562 5.69224e-05L49.917 32.2393L17.6777 0Z"
    in
    Svg.svg [ SvgA.viewBox "0 0 100 100", SvgA.css styles ]
        [ Svg.path [ SvgA.fill "currentColor", SvgA.d pathData ] [] ]


iconO : List C.Style -> H.Html msg
iconO styles =
    let
        pathData =
            "M50 100C77.6142 100 100 77.6142 100 50C100 22.3858 77.6142 0 50 0C22.3858 0 0 22.3858 0 50C0 77.6142 22.3858 100 50 100ZM50 75C63.8071 75 75 63.8071 75 50C75 36.1929 63.8071 25 50 25C36.1929 25 25 36.1929 25 50C25 63.8071 36.1929 75 50 75Z"
    in
    Svg.svg [ SvgA.viewBox "0 0 100 100", SvgA.css styles ]
        [ Svg.path [ SvgA.fill "currentColor", SvgA.fillRule "evenodd", SvgA.d pathData ] [] ]
