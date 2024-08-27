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
        Block.Paragraph content inlines ->
            [ BaseHtml.div [] (List.map customHtmlInline inlines) ]

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

            else if String.startsWith "!g" value then
                Html.Styled.toUnstyled <| Components.commodityView "https://timeofjustice.eu/global/icons/sea-of-thieves-trade-route-gemstones.png" (String.replace "!g" "" value)

            else if String.startsWith "!m" value then
                Html.Styled.toUnstyled <| Components.commodityView "https://timeofjustice.eu/global/icons/sea-of-thieves-trade-route-minerals.png" (String.replace "!m" "" value)

            else if String.startsWith "!si" value then
                Html.Styled.toUnstyled <| Components.commodityView "https://timeofjustice.eu/global/icons/sea-of-thieves-trade-route-silk.png" (String.replace "!si" "" value)

            else if String.startsWith "!sp" value then
                Html.Styled.toUnstyled <| Components.commodityView "https://timeofjustice.eu/global/icons/sea-of-thieves-trade-route-spices.png" (String.replace "!sp" "" value)

            else if String.startsWith "!st" value then
                Html.Styled.toUnstyled <| Components.commodityView "https://timeofjustice.eu/global/icons/sea-of-thieves-trade-route-stone.png" (String.replace "!st" "" value)

            else if String.startsWith "!su" value then
                Html.Styled.toUnstyled <| Components.commodityView "https://timeofjustice.eu/global/icons/sea-of-thieves-trade-route-sugar.png" (String.replace "!su" "" value)

            else if String.startsWith "!t" value then
                Html.Styled.toUnstyled <| Components.commodityView "https://timeofjustice.eu/global/icons/sea-of-thieves-trade-route-tea.png" (String.replace "!t" "" value)

            else
                Inline.defaultHtml (Just customHtmlInline) inline

        Link url title inlines ->
            Html.Styled.toUnstyled <|
                Components.inlineLink
                    { inline =
                        case title of
                            Just t ->
                                text t

                            Nothing ->
                                fromUnstyled <| BaseHtml.span [] (List.map customHtmlInline inlines)
                    , href = url
                    }

        _ ->
            Inline.defaultHtml (Just customHtmlInline) inline
