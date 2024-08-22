module Api.Responses.Visit exposing (VisitInfo, decode)

import Api.Responses.Page
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra as Decode


type alias VisitInfo =
    { popular : List Api.Responses.Page.Page
    , backgroundUrl : String
    }


decode : Decoder VisitInfo
decode =
    Decode.succeed VisitInfo
        |> Decode.andMap (Decode.field "popular" (Decode.list Api.Responses.Page.decode))
        |> Decode.andMap (Decode.field "background" Decode.string)
