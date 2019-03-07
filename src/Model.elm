module Model exposing (Board, Model, Player(..), emptyBoard, playerToString)

import Array exposing (Array)


type alias Model =
    { actingPlayer : Player
    , board : Board
    }


type Player
    = X
    | O


playerToString : Player -> String
playerToString player =
    case player of
        X ->
            "X"

        O ->
            "O"


type alias Board =
    Array (Maybe Player)


emptyBoard : Board
emptyBoard =
    Array.initialize 9 (always Nothing)
