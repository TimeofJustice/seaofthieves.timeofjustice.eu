module Api.Responses.Wiki exposing (PageInfo, WikiModule(..), decode, Chapter)

import Api.Responses.Page
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra as Decode


type alias PageInfo =
    { title : String
    , modules : List WikiModule
    , chapters : List Chapter
    , more : List Api.Responses.Page.Page
    }


type alias Chapter =
    { title : String, order : Int }


decodeChapter : Decoder Chapter
decodeChapter =
    Decode.succeed Chapter
        |> Decode.andMap (Decode.field "title" Decode.string)
        |> Decode.andMap (Decode.field "order" Decode.int)


type WikiModule
    = TextModule TextModuleContent
    | BlockModule BlockModuleContent
    | ImageModule ImageModuleContent
    | TableModule TableModuleContent


type alias TextModuleContent =
    { title : String, content : String, order : Int }


type alias BlockModuleContent =
    { content : String, order : Int }


type alias ImageModuleContent =
    { description : String, path : String, order : Int }


type alias TableModuleContent =
    { title : String, headers : List String, rows : List (List String), order : Int }


decodeTextModuleContent : Decoder TextModuleContent
decodeTextModuleContent =
    Decode.succeed TextModuleContent
        |> Decode.andMap (Decode.field "title" Decode.string)
        |> Decode.andMap (Decode.field "content" Decode.string)
        |> Decode.andMap (Decode.field "order" Decode.int)


decodeBlockModuleContent : Decoder BlockModuleContent
decodeBlockModuleContent =
    Decode.succeed BlockModuleContent
        |> Decode.andMap (Decode.field "content" Decode.string)
        |> Decode.andMap (Decode.field "order" Decode.int)


decodeImageModuleContent : Decoder ImageModuleContent
decodeImageModuleContent =
    Decode.succeed ImageModuleContent
        |> Decode.andMap (Decode.field "description" Decode.string)
        |> Decode.andMap (Decode.field "path" Decode.string)
        |> Decode.andMap (Decode.field "order" Decode.int)


decodeTableModuleContent : Decoder TableModuleContent
decodeTableModuleContent =
    Decode.succeed TableModuleContent
        |> Decode.andMap (Decode.field "title" Decode.string)
        |> Decode.andMap (Decode.field "columns" (Decode.list Decode.string))
        |> Decode.andMap (Decode.field "rows" (Decode.list (Decode.list Decode.string)))
        |> Decode.andMap (Decode.field "order" Decode.int)


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
                        Decode.succeed (BlockModule { content = "Error with module", order = 0 })
            )


decode : Decoder PageInfo
decode =
    Decode.succeed PageInfo
        |> Decode.andMap (Decode.field "title" Decode.string)
        |> Decode.andMap (Decode.field "modules" (Decode.list decodeWikiModule))
        |> Decode.andMap (Decode.field "chapters" (Decode.list decodeChapter))
        |> Decode.andMap (Decode.field "more" (Decode.list Api.Responses.Page.decode))
