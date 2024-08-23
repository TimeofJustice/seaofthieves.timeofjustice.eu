module Markdown.Extra exposing (fromString)

import Components
import Css
import Html as BaseHtml
import Html.Styled exposing (Html, div, fromUnstyled, img, table, tbody, td, text, th, thead, tr)
import Html.Styled.Attributes exposing (css, id, src)
import Markdown
import Markdown.Block as Block exposing (Block)
import Markdown.Inline as Inline exposing (Inline(..))


fromString : List (Html.Styled.Attribute msg) -> String -> Html msg
fromString attr string =
    string
        |> Block.parse Nothing
        |> List.map customHtmlBlock
        |> List.concat
        |> List.map fromUnstyled
        |> div attr


customHtmlBlock : Block b i -> List (BaseHtml.Html msg)
customHtmlBlock block =
    case block of
        _ ->
            Block.defaultHtml
                (Just customHtmlBlock)
                (Just customHtmlInline)
                block


customHtmlInline : Inline i -> BaseHtml.Html msg
customHtmlInline inline =
    case inline of
        CodeInline value ->
            if String.startsWith "$" value then
                Html.Styled.toUnstyled <| Components.goldView (String.replace "$" "" value)

            else
                Inline.defaultHtml (Just customHtmlInline) inline

        _ ->
            Inline.defaultHtml (Just customHtmlInline) inline
