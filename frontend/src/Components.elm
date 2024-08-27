module Components exposing
    ( body
    , commodityView
    , container
    , errorView
    , goldView
    , inputWithIconButton
    , loadingView
    , primaryIconButton
    , textInput
    , titleDiv
    )

import Api.Responses.Page
import Api.Responses.Wiki
import Css exposing (url)
import Html
import Html.Styled exposing (Html, a, button, div, img, input, label, li, option, select, span, text, textarea)
import Html.Styled.Attributes exposing (css, disabled, fromUnstyled, href, placeholder, readonly, rows, selected, src, type_, value)
import Html.Styled.Events exposing (onBlur, onClick, onInput)
import Icons
import Route.Path exposing (Path)
import Tailwind.Color
import Tailwind.Extra as Tw
import Tailwind.Theme as Tw
import Tailwind.Utilities as Tw


buttonStyle : List Css.Style
buttonStyle =
    [ Tw.items_center
    , Tw.justify_center
    , Tw.flex
    , Tw.transition
    , Tw.outline_none
    , Tw.border_0
    , Tw.rounded
    , Tw.p_2
    , Tw.cursor_pointer
    , Tw.text_sm
    ]


primaryButtonStyle : List Css.Style
primaryButtonStyle =
    buttonStyle
        ++ [ Tw.bg_color Tw.teal_800
           , Tw.text_color Tw.white
           , Tw.fill_color Tw.white
           , Css.hover [ Tw.bg_color Tw.teal_700 ]
           , Css.disabled
                [ Tw.bg_color Tw.blue_800
                , Tw.cursor_not_allowed
                ]
           ]


primaryButton : { label : String, onClick : msg } -> Html msg
primaryButton settings =
    button
        [ css primaryButtonStyle
        , onClick settings.onClick
        ]
        [ text settings.label ]


primaryIconButton : { icon : Html msg, onClick : msg, disabled : Bool } -> Html msg
primaryIconButton settings =
    button
        [ css primaryButtonStyle
        , onClick settings.onClick
        , disabled settings.disabled
        ]
        [ settings.icon ]


primaryIconLink : { icon : Html msg } -> Html msg
primaryIconLink settings =
    a [ fromUnstyled (Route.Path.href Route.Path.Search) ]
        [ div
            [ css primaryButtonStyle
            ]
            [ settings.icon ]
        ]


inputLabel : List Css.Style
inputLabel =
    [ Tw.flex_col
    , Tw.space_y_1
    , Tw.flex
    ]


baseInputStyle : List Css.Style
baseInputStyle =
    [ Tw.relative
    , Tw.border_2
    , Tw.border_solid
    , Tw.border_color Tw.gray_200
    , Tw.outline_none
    , Tw.rounded
    , Tw.p_2
    , Tw.text_sm
    , Tw.font_sans
    , Tw.resize_y
    , Css.focus [ Tw.border_color Tw.gray_400 ]
    ]


textInput : { label : String, onInput : String -> msg, value : String } -> Html msg
textInput settings =
    label [ css inputLabel ]
        [ div [] [ text settings.label ]
        , input
            [ placeholder settings.label
            , value settings.value
            , onInput settings.onInput
            , css baseInputStyle
            ]
            []
        ]


inputButtonStyle : List Css.Style
inputButtonStyle =
    primaryButtonStyle
        ++ [ Tw.absolute
           , Tw.top_0
           , Tw.right_0
           , Tw.bottom_0
           , Tw.items_center
           , Tw.flex
           , Tw.border_2
           , Tw.border_color Tw.transparent
           , Tw.box_border
           , Tw.h_full
           , Tw.px_2
           , Tw.bg_clip_padding
           ]


inputContainerStyle : List Css.Style
inputContainerStyle =
    [ Tw.relative
    , Tw.flex_col
    , Tw.flex
    , Tw.w_full
    ]


inputWithIconButton : { label : String, icon : Html msg, onInput : String -> msg, onClick : msg, value : String } -> Html msg
inputWithIconButton settings =
    label [ css inputLabel ]
        [ div [ css inputContainerStyle ]
            [ input
                [ placeholder settings.label
                , value settings.value
                , onInput settings.onInput
                , css baseInputStyle
                ]
                []
            , button [ css inputButtonStyle, onClick settings.onClick ] [ settings.icon ]
            ]
        ]


titleStyle : List Css.Style
titleStyle =
    [ Tw.text_2xl
    , Tw.font_bold
    , Tw.mb_2
    ]


titleDiv : String -> Html msg
titleDiv title =
    div [ css titleStyle ] [ text title ]


containerStyle : List Css.Style
containerStyle =
    [ Tw.flex_1
    , Tw.h_fit
    , Tw.w_full
    , Tw.max_w_6xl
    , Tw.rounded
    , Tw.border_1
    , Tw.border_solid
    , Tw.border_color Tw.emerald_700
    , Tw.flex
    ]


containerInnerStyle : List Css.Style
containerInnerStyle =
    [ Tw.bg_color Tw.teal_900
    , Tw.bg_opacity_75
    , Tw.box_border
    , Tw.h_full
    , Tw.flex_1
    , Tw.p_10
    , Css.property "backdrop-filter" "blur(8px)"
    , Tw.space_y_3

    -- , Css.property "border-radius" "0.2rem 0 0 0.15rem"
    , Tw.overflow_x_hidden
    , Tw.rounded_tl
    , Tw.rounded_bl
    ]


containerPopularStyle : List Css.Style
containerPopularStyle =
    [ Tw.bg_color Tw.teal_900
    , Tw.box_border
    , Tw.h_full
    , Tw.p_5
    , Tw.pt_10
    , Tw.w_64
    , Tw.space_y_3
    , Tw.rounded_tr
    , Tw.rounded_br
    ]


popularTitleStyle : List Css.Style
popularTitleStyle =
    [ Tw.font_bold
    , Tw.mb_2
    ]


popularView : Api.Responses.Page.Page -> Html msg
popularView page =
    a [ css aStyle, fromUnstyled (Route.Path.href page.route) ]
        [ div [ css listEntryStyle ] [ text page.title ]
        ]


linkStyle : List Css.Style
linkStyle =
    [ Tw.text_color Tw.amber_400
    , Tw.cursor_pointer
    , Tw.underline
    , Tw.text_center
    , Tw.transition_colors
    , Css.hover [ Tw.text_color Tw.amber_600 ]
    ]


link : { label : String, href : Path } -> Html msg
link settings =
    a [ css linkStyle, fromUnstyled (Route.Path.href settings.href) ] [ text settings.label ]


moreView : Api.Responses.Page.Page -> Html msg
moreView page =
    li [] [ link { label = page.title, href = page.route } ]


listEntryStyle : List Css.Style
listEntryStyle =
    [ Tw.text_color Tw.amber_400
    , Tw.font_semibold
    , Tw.p_2
    , Tw.w_full
    , Tw.box_border
    , Tw.cursor_pointer
    ]


aStyle : List Css.Style
aStyle =
    [ Tw.no_underline
    , Tw.block
    , Tw.transition_colors
    , Tw.bg_color Tw.teal_700
    , Css.nthOfType "even"
        [ Tw.bg_color Tw.teal_800
        ]
    , Css.hover [ Tw.bg_color Tw.teal_600 ]
    ]


chapterView : (Int -> msg) -> Api.Responses.Wiki.Chapter -> Html msg
chapterView msg chapter =
    a [ css aStyle, onClick (msg chapter.order) ]
        [ div [ css listEntryStyle ] [ text chapter.title ]
        ]


innerSideBarStyle : List Css.Style
innerSideBarStyle =
    [ Tw.flex_col
    , Tw.space_y_3
    , Tw.sticky
    , Tw.top_0
    ]


container : { content : List (Html msg), popular : List Api.Responses.Page.Page, chapters : List Api.Responses.Wiki.Chapter, jumpMsg : Int -> msg, more : List Api.Responses.Page.Page } -> Html msg
container settings =
    div [ css containerStyle ]
        [ div [ css containerInnerStyle ]
            (settings.content
                ++ [ case settings.more of
                        [] ->
                            text ""

                        _ ->
                            div []
                                (div [ css popularTitleStyle ] [ text "Siehe mehr" ]
                                    :: List.map moreView settings.more
                                )
                   ]
            )
        , div [ css containerPopularStyle ]
            [ div [ css innerSideBarStyle ]
                [ case settings.chapters of
                    [] ->
                        text ""

                    _ ->
                        div [] (div [ css popularTitleStyle ] [ text "Inhalt" ] :: List.map (chapterView settings.jumpMsg) settings.chapters)
                , case settings.popular of
                    [] ->
                        text ""

                    _ ->
                        div [] (div [ css popularTitleStyle ] [ text "Populär" ] :: List.map popularView settings.popular)
                ]
            ]
        ]


loadingStyle : List Css.Style
loadingStyle =
    [ Tw.items_center
    , Tw.space_x_1
    , Tw.justify_center
    , Tw.flex
    , Tw.w_full
    , Tw.fill_color Tw.white
    ]


loadingView : Html msg
loadingView =
    div [ css loadingStyle ]
        [ Icons.loading
        , div [] [ text "Lade..." ]
        ]


errorTextStyle : List Css.Style
errorTextStyle =
    [ Tw.font_bold
    , Tw.text_color Tw.red_500
    ]


errorView : String -> Html msg
errorView message =
    div [ css errorTextStyle ] [ text message ]


iconViewStyle : List Css.Style
iconViewStyle =
    [ Tw.inline_flex
    , Tw.items_center
    , Tw.space_x_1
    , Tw.w_fit
    , Tw.h_fit
    ]


iconStyle : String -> List Css.Style
iconStyle bgUrl =
    [ Css.backgroundImage (url bgUrl)
    , Tw.h_full
    , Tw.w_full
    , Tw.p_3
    , Tw.bg_cover
    , Tw.bg_center
    , Tw.bg_no_repeat
    , Tw.box_border
    ]


goldView : String -> Html msg
goldView value =
    div [ css iconViewStyle ] [ div [] [ text value ], img [ src "https://timeofjustice.eu/global/sea-of-thieves-gold.webp" ] [] ]


commodityView : String -> String -> Html msg
commodityView icon value =
    div [ css iconViewStyle ] [ div [] [ text value ], div [ css (iconStyle icon) ] [] ]


navBarStyle : List Css.Style
navBarStyle =
    [ Tw.sticky
    , Tw.top_0
    , Tw.z_10
    , Tw.items_center
    , Tw.justify_between
    , Tw.flex
    , Tw.p_4
    , Tw.bg_color Tw.emerald_700
    , Tw.font_bold
    ]


navBarTitleStyle : List Css.Style
navBarTitleStyle =
    [ Tw.space_x_1
    , Tw.items_center
    , Tw.flex
    ]


navBar : { titles : List String } -> Html msg
navBar settings =
    let
        titleSpans =
            List.map (\title -> div [ css navBarTitleStyle ] [ span [] [ text "/" ], span [] [ text title ] ]) settings.titles
    in
    div [ css navBarStyle ]
        [ div [ css navBarTitleStyle ]
            [ span [] [ text "Sea of Thieves" ]
            , div [ css navBarTitleStyle ] titleSpans
            ]
        , primaryIconLink { icon = Icons.search }
        ]


bodyStyle : String -> List Css.Style
bodyStyle bgUrl =
    [ Tw.absolute
    , Tw.inset_0
    , Tw.box_border
    , Tw.h_screen
    , Tw.font_sans
    , Tw.flex
    , Tw.flex_col
    , Tw.overflow_hidden
    , Tw.text_color Tw.white
    ]


innerStyle : List Css.Style
innerStyle =
    [ Tw.p_3
    , Tw.flex_1
    , Tw.h_auto
    , Tw.flex
    , Tw.flex_col
    , Tw.items_center
    , Tw.overflow_auto
    ]


backgroundImageStyle : String -> List Css.Style
backgroundImageStyle bgUrl =
    [ Css.backgroundImage (url bgUrl)
    , Tw.bg_color Tw.teal_900
    , Tw.bg_cover
    , Tw.bg_center
    , Tw.bg_no_repeat
    , Css.property "filter" "blur(2px)"
    , Tw.fixed
    , Tw.inset_0
    , Tw.box_border
    , Tw.h_full
    , Tw.w_full
    , Css.property "transform" "scale(1.1)"
    , Css.property "z-index" "-1"
    ]


body :
    { titles : List String
    , content : List (Html msg)
    , background : String
    }
    -> List (Html.Html msg)
body settings =
    [ Html.Styled.toUnstyled <|
        div [ css (bodyStyle settings.background) ]
            [ navBar { titles = settings.titles }
            , div [ css innerStyle ] (div [ css (backgroundImageStyle settings.background) ] [] :: settings.content)
            ]
    ]
