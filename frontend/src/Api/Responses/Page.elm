module Api.Responses.Page exposing (Page, decode)

import Json.Decode as Decode
import Json.Decode.Extra as Decode
import Route.Path exposing (Path)


type alias Page =
    { title : String
    , route : Path
    }


type Route
    = RootRoute RootRouteDetails
    | SubRoute SubRouteDetails


type alias RootRouteDetails =
    { path : String
    }


type alias SubRouteDetails =
    { path : String
    , page : String
    }


decodeRootRoute : Decode.Decoder RootRouteDetails
decodeRootRoute =
    Decode.succeed RootRouteDetails
        |> Decode.andMap (Decode.field "path" Decode.string)


decodeSubRoute : Decode.Decoder SubRouteDetails
decodeSubRoute =
    Decode.succeed SubRouteDetails
        |> Decode.andMap (Decode.field "path" Decode.string)
        |> Decode.andMap (Decode.field "page" Decode.string)


decodeRoute : Decode.Decoder Route
decodeRoute =
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\moduleType ->
                case moduleType of
                    "root" ->
                        Decode.field "value" decodeRootRoute
                            |> Decode.map RootRoute

                    "sub" ->
                        Decode.field "value" decodeSubRoute
                            |> Decode.map SubRoute

                    _ ->
                        Decode.succeed (RootRoute { path = "/" })
            )


decode : Decode.Decoder Page
decode =
    Decode.succeed Page
        |> Decode.andMap (Decode.field "title" Decode.string)
        |> Decode.andMap (Decode.field "route" decodeRoute |> Decode.andThen parseRoute)


parseRoute : Route -> Decode.Decoder Path
parseRoute route =
    case route of
        RootRoute { path } ->
            case path of
                "/" ->
                    Decode.succeed Route.Path.Home_

                "/events/burning-blade/calculator" ->
                    Decode.succeed Route.Path.Events_BurningBlade_Calculator

                _ ->
                    Decode.succeed Route.Path.Home_

        SubRoute { path, page } ->
            case path of
                "/wiki" ->
                    Decode.succeed (Route.Path.Wiki_EntryName_ { entryName = page })

                "/events" ->
                    Decode.succeed (Route.Path.Events_EventName_ { eventName = page })

                _ ->
                    Decode.succeed Route.Path.Home_
