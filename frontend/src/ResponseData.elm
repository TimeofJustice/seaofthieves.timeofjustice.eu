module ResponseData exposing (ResponseData(..))


type ResponseData a
    = Pending
    | Loading
    | Error String
    | Success a
