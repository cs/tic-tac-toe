module Model exposing
    ( Board
    , Model
    , Msg(..)
    , Player(..)
    , detectWinner
    , emptyBoard
    , nextPlayer
    )

import Array exposing (Array)


type alias Model =
    { actingPlayer : Player
    , board : Board
    }


type Msg
    = RestartMsg
    | MakeMoveMsg Int


type Player
    = X
    | O


nextPlayer : Player -> Player
nextPlayer player =
    case player of
        X ->
            O

        O ->
            X


type alias Board =
    Array (Maybe Player)


emptyBoard : Board
emptyBoard =
    Array.initialize 9 (always Nothing)


detectWinner : Board -> Maybe Player
detectWinner board =
    let
        horizontals =
            [ [ 0, 1, 2 ], [ 3, 4, 5 ], [ 6, 7, 8 ] ]

        verticals =
            [ [ 0, 3, 6 ], [ 1, 4, 7 ], [ 2, 5, 8 ] ]

        diagonals =
            [ [ 0, 4, 8 ], [ 2, 4, 6 ] ]
    in
    (horizontals ++ verticals ++ diagonals)
        |> List.map (List.filterMap (\index -> Array.get index board))
        |> List.map (List.filterMap identity)
        |> List.filter (\cells -> List.all ((==) X) cells || List.all ((==) O) cells)
        |> List.filter (\cells -> List.length cells == 3)
        |> List.filterMap List.head
        |> List.head
