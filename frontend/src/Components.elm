module Components exposing (body)

import Css
import Html
import Html.Styled exposing (Html, a, button, div, input, label, option, select, span, text, textarea)
import Html.Styled.Attributes exposing (css, disabled, fromUnstyled, placeholder, readonly, rows, selected, type_, value)
import Html.Styled.Events exposing (onBlur, onClick, onInput)
import Route.Path exposing (Path)
import Tailwind.Color
import Tailwind.Theme as Tw
import Tailwind.Utilities as Tw


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
