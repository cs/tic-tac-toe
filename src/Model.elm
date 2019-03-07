module Model exposing (Board, Model, Msg(..), Player(..), emptyBoard)

import Array exposing (Array)


type alias Model =
    { actingPlayer : Player
    , board : Board
    }


type Msg
    = RestartGameMsg


type Player
    = X
    | O


type alias Board =
    Array (Maybe Player)


emptyBoard : Board
emptyBoard =
    Array.initialize 9 (always Nothing)
