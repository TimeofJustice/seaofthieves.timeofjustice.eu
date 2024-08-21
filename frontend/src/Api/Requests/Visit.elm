module Api.Requests.Visit exposing (Error, errorToString, get)

import Api.Responses.Visit exposing (VisitInfo)
import Env
import Http
import Http.Extra as Http
import Json.Decode as Decode
import Route.Path


get : { path : Route.Path.Path, msg : Result Http.Error (Result Error VisitInfo) -> msg } -> Cmd msg
get { path, msg } =
    Http.request
        { method = "GET"
        , headers = []
        , url = Env.baseUrl ++ "/visit?path=" ++ Route.Path.toString path
        , body = Http.emptyBody
        , expect = Http.expectStringResponse msg (Http.withError parseError Api.Responses.Visit.decode)
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
