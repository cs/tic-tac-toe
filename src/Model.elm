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


type alias Board =
    Array (Maybe Player)


emptyBoard : Board
emptyBoard =
    Array.initialize 9 (always Nothing)


nextPlayer : Player -> Player
nextPlayer player =
    case player of
        X ->
            O

        O ->
            X
