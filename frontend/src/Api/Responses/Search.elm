module Api.Responses.Search exposing (SearchInfo, decode)

import Api.Responses.Page
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra as Decode


type alias SearchInfo =
    { pages : List Api.Responses.Page.Page
    }


decode : Decoder SearchInfo
decode =
    Decode.succeed SearchInfo
        |> Decode.andMap (Decode.field "pages" (Decode.list Api.Responses.Page.decode))
