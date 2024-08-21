module Api.Page exposing (Page, decode)

import Json.Decode as Decode
import Json.Decode.Extra as Decode
import Route.Path exposing (Path)


type alias Page =
    { title : String
    , route : Path
    }


decode : Decode.Decoder Page
decode =
    Decode.succeed Page
        |> Decode.andMap (Decode.field "title" Decode.string)
        |> Decode.andMap (Decode.field "route" Decode.string |> Decode.andThen decodeRoute)


decodeRoute : String -> Decode.Decoder Path
decodeRoute string =
    case string of
        "/" ->
            Decode.succeed Route.Path.Home_

        "/calculator" ->
            Decode.succeed Route.Path.Calculator

        "/fish" ->
            Decode.succeed Route.Path.Fish

        _ ->
            Decode.fail ("Unknown route: " ++ string)
