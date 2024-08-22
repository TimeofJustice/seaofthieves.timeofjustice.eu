module Api.Responses.Wiki exposing (PageInfo, decode, WikiModule(..), CellType(..))

import Api.Responses.Page
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra as Decode


type alias PageInfo =
    { title : String
    , modules : List WikiModule
    , more : List Api.Responses.Page.Page
    }


type WikiModule
    = TextModule TextModuleContent
    | BlockModule BlockModuleContent
    | ImageModule ImageModuleContent
    | TableModule TableModuleContent


type alias TextModuleContent =
    { title : String, content : String }


type alias BlockModuleContent =
    { content : String }


type alias ImageModuleContent =
    { description : String, path : String }


type alias TableModuleContent =
    { title : String, headers : List String, rows : List (List CellType) }


decodeTextModuleContent : Decoder TextModuleContent
decodeTextModuleContent =
    Decode.succeed TextModuleContent
        |> Decode.andMap (Decode.field "title" Decode.string)
        |> Decode.andMap (Decode.field "content" Decode.string)


decodeBlockModuleContent : Decoder BlockModuleContent
decodeBlockModuleContent =
    Decode.succeed BlockModuleContent
        |> Decode.andMap (Decode.field "content" Decode.string)


decodeImageModuleContent : Decoder ImageModuleContent
decodeImageModuleContent =
    Decode.succeed ImageModuleContent
        |> Decode.andMap (Decode.field "description" Decode.string)
        |> Decode.andMap (Decode.field "path" Decode.string)


decodeTableModuleContent : Decoder TableModuleContent
decodeTableModuleContent =
    Decode.succeed TableModuleContent
        |> Decode.andMap (Decode.field "title" Decode.string)
        |> Decode.andMap (Decode.field "columns" (Decode.list Decode.string))
        |> Decode.andMap (Decode.field "rows" (Decode.list (Decode.list decodeCellType)))


type CellType
    = TextCell String
    | GoldCell Int


decodeWikiModule : Decoder WikiModule
decodeWikiModule =
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\moduleType ->
                case moduleType of
                    "text" ->
                        Decode.field "value" decodeTextModuleContent
                            |> Decode.map TextModule

                    "block" ->
                        Decode.field "value" decodeBlockModuleContent
                            |> Decode.map BlockModule

                    "image" ->
                        Decode.field "value" decodeImageModuleContent
                            |> Decode.map ImageModule

                    "table" ->
                        Decode.field "value" decodeTableModuleContent
                            |> Decode.map TableModule

                    _ ->
                        Decode.succeed (BlockModule { content = "Error with module" })
            )


decodeCellType : Decoder CellType
decodeCellType =
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\cellType ->
                case cellType of
                    "text" ->
                        Decode.field "value" Decode.string
                            |> Decode.map TextCell

                    "gold" ->
                        Decode.field "value" Decode.int
                            |> Decode.map GoldCell

                    _ ->
                        Decode.succeed (TextCell "Error with cell")
            )


decode : Decoder PageInfo
decode =
    Decode.succeed PageInfo
        |> Decode.andMap (Decode.field "title" Decode.string)
        |> Decode.andMap (Decode.field "modules" (Decode.list decodeWikiModule))
        |> Decode.andMap (Decode.field "more" (Decode.list Api.Responses.Page.decode))
