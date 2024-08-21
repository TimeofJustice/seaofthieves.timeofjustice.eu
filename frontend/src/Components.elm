module Components exposing (body, container, textInput)

import Css exposing (url)
import Html
import Html.Styled exposing (Html, a, button, div, img, input, label, option, select, span, text, textarea)
import Html.Styled.Attributes exposing (css, disabled, fromUnstyled, placeholder, readonly, rows, selected, src, type_, value)
import Html.Styled.Events exposing (onBlur, onClick, onInput)
import Route.Path exposing (Path)
import Tailwind.Color
import Tailwind.Extra as Tw
import Tailwind.Theme as Tw
import Tailwind.Utilities as Tw


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


containerStyle : List Css.Style
containerStyle =
    [ Tw.bg_color Tw.teal_900
    , Tw.bg_opacity_75
    , Tw.backdrop_blur_3xl
    , Tw.flex_1
    , Tw.h_auto
    , Tw.p_10
    , Tw.w_full
    , Tw.max_w_6xl
    , Tw.rounded
    , Tw.border_1
    , Tw.border_solid
    , Tw.border_color Tw.emerald_700
    ]


container : List (Html msg) -> Html msg
container content =
    div [ css containerStyle ] content


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
    , Tw.overflow_auto
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
    ]


backgroundImageStyle : String -> List Css.Style
backgroundImageStyle bgUrl =
    [ Css.backgroundImage (url bgUrl)
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
