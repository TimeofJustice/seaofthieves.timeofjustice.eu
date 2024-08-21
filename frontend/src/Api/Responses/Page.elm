module Api.Responses.Page exposing (Page, decode)

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

        "/events/burning-blade/calculator" ->
            Decode.succeed Route.Path.Events_BurningBlade_Calculator

        "/wiki" ->
            Decode.succeed (Route.Path.Wiki_EntryName_ { entryName = "" })

        "/events/burning-blade" ->
            Decode.succeed (Route.Path.Events_EventName_ { eventName = "burning-blade" })

        _ ->
            Decode.succeed Route.Path.Home_
