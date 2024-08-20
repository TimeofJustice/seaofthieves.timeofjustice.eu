module Components exposing (body, textInput)

import Css
import Html
import Html.Styled exposing (Html, a, button, div, input, label, option, select, span, text, textarea)
import Html.Styled.Attributes exposing (css, disabled, fromUnstyled, placeholder, readonly, rows, selected, type_, value)
import Html.Styled.Events exposing (onBlur, onClick, onInput)
import Route.Path exposing (Path)
import Tailwind.Color
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


navBarStyle : List Css.Style
navBarStyle =
    [ Tw.sticky
    , Tw.top_0
    , Tw.z_10
    , Tw.items_center
    , Tw.justify_between
    , Tw.flex
    , Tw.border_0
    , Tw.border_b_2
    , Tw.border_solid
    , Tw.border_color Tw.gray_200
    , Tw.p_3
    , Tw.bg_color Tw.white
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


bodyStyle : List Css.Style
bodyStyle =
    [ Tw.absolute
    , Tw.inset_0
    , Tw.box_border
    , Tw.h_screen
    , Tw.font_sans
    , Tw.flex
    , Tw.flex_col
    , Tw.overflow_auto
    ]


innerStyle : List Css.Style
innerStyle =
    [ Tw.p_3
    , Tw.flex_1
    , Tw.h_auto
    ]


body :
    { titles : List String
    , content : List (Html msg)
    }
    -> List (Html.Html msg)
body settings =
    [ Html.Styled.toUnstyled <|
        div [ css bodyStyle ]
            [ navBar { titles = settings.titles }
            , div [ css innerStyle ] settings.content
            ]
    ]
