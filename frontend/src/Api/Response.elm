module Api.Response exposing (Response, decode)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra as Decode


type alias Response a =
    { status : String
    , data : a
    }


decode : Decoder a -> Decoder (Response a)
decode decoder =
    Decode.succeed Response
        |> Decode.andMap (Decode.field "status" Decode.string)
        |> Decode.andMap (Decode.field "data" decoder)
