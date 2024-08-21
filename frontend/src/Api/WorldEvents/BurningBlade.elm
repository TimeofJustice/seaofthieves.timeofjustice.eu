module Api.WorldEvents.BurningBlade exposing (PageInfo, decode)

import Api.Page
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra as Decode


type alias PageInfo =
    { title : String
    , description : String
    , baseValue : Int
    , ritualValue : Int
    , emissaryValues : EmissaryValues
    , popular : List Api.Page.Page
    }


type alias EmissaryValues =
    { grade1 : Float
    , grade2 : Float
    , grade3 : Float
    , grade4 : Float
    , grade5 : Float
    }


decodeEmissaryValues : Decoder EmissaryValues
decodeEmissaryValues =
    Decode.succeed EmissaryValues
        |> Decode.andMap (Decode.field "grade1" Decode.float)
        |> Decode.andMap (Decode.field "grade2" Decode.float)
        |> Decode.andMap (Decode.field "grade3" Decode.float)
        |> Decode.andMap (Decode.field "grade4" Decode.float)
        |> Decode.andMap (Decode.field "grade5" Decode.float)


decode : Decoder PageInfo
decode =
    Decode.succeed PageInfo
        |> Decode.andMap (Decode.field "title" Decode.string)
        |> Decode.andMap (Decode.field "description" Decode.string)
        |> Decode.andMap (Decode.field "baseValue" Decode.int)
        |> Decode.andMap (Decode.field "ritualValue" Decode.int)
        |> Decode.andMap (Decode.field "emissaryValues" decodeEmissaryValues)
        |> Decode.andMap (Decode.field "popular" (Decode.list Api.Page.decode))
