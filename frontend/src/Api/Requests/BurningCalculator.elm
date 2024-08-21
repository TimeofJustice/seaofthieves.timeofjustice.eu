module Api.Requests.BurningCalculator exposing (Error, errorToString, get)

import Api.Responses.BurningCalculator exposing (PageInfo)
import Env
import Http
import Http.Extra as Http
import Json.Decode as Decode


get : { msg : Result Http.Error (Result Error PageInfo) -> msg } -> Cmd msg
get { msg } =
    Http.request
        { method = "GET"
        , headers = []
        , url = Env.baseUrl ++ "/events/burning-blade"
        , body = Http.emptyBody
        , expect = Http.expectStringResponse msg (Http.withError parseError Api.Responses.BurningCalculator.decode)
        , timeout = Just 5000
        , tracker = Nothing
        }


type Error
    = NotFound
    | MissingParamters


parseError : String -> Maybe Error
parseError errorCode =
    if errorCode == "not_found" then
        Just NotFound

    else if errorCode == "missing_parameters" then
        Just MissingParamters

    else
        Nothing


errorToString : Error -> String
errorToString error =
    case error of
        NotFound ->
            "The requested event was not found."

        MissingParamters ->
            "The request was missing required parameters."
