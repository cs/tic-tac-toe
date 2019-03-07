module Model exposing (Board, Model, Msg(..), Player(..), emptyBoard, nextPlayer)

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

        Nothing
