module Http.Extra exposing (errorToString, withError)

import Api.Response
import Http exposing (Error(..), Response(..))
import Json.Decode as Decode exposing (Decoder)


withError :
    (String -> Maybe error)
    -> Decoder success
    -> Http.Response String
    -> Result Http.Error (Result error success)
withError decodeError decodeSuccess response =
    case response of
        BadUrl_ string ->
            Err (BadUrl string)

        Timeout_ ->
            Err Timeout

        NetworkError_ ->
            Err NetworkError

        BadStatus_ metadata body ->
            case Decode.decodeString (Decode.field "status" Decode.string) body of
                Err _ ->
                    Err (BadStatus metadata.statusCode)

                Ok errorResponse ->
                    case decodeError errorResponse of
                        Nothing ->
                            Err (BadStatus metadata.statusCode)

                        Just requestError ->
                            Ok (Err requestError)

        GoodStatus_ _ body ->
            case Decode.decodeString (Api.Response.decode decodeSuccess) body of
                Err _ ->
                    Err (BadBody body)

                Ok responseData ->
                    Ok (Ok responseData.data)


errorToString : Http.Error -> String
errorToString error =
    case error of
        BadUrl url ->
            "Es gab ein Problem mit der eingegebenen Adresse: " ++ url

        Timeout ->
            "Die Anfrage hat zu lange gedauert. Bitte versuche es später erneut."

        NetworkError ->
            "Es gibt ein Problem mit deiner Internetverbindung. Bitte überprüfe deine Verbindung und versuche es erneut."

        BadStatus statusCode ->
            "Der Server hat einen Fehler gemeldet (Statuscode: " ++ String.fromInt statusCode ++ "). Bitte versuche es später erneut."

        BadBody _ ->
            "Der Server hat eine ungültige Antwort gesendet. Bitte versuche es später erneut."
