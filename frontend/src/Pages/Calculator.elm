module Pages.Calculator exposing (Model, Msg, page)

import Auth
import Components
import Effect exposing (Effect)
import Html.Styled exposing (Html, div, table, tbody, td, text, th, thead, tr)
import Html.Styled.Attributes exposing (css)
import Http
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared
import Tailwind.Utilities as Tw
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page _ _ =
    Page.new
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


type alias Model =
    { rituals : Maybe Int
    }


init : () -> ( Model, Effect Msg )
init _ =
    ( { rituals = Nothing }
    , Effect.none
    )


type Msg
    = ChangeRituals String


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ChangeRituals rituals ->
            let
                maybeRituals =
                    if String.isEmpty rituals then
                        Nothing

                    else
                        case String.toInt rituals of
                            Just value ->
                                Just value

                            Nothing ->
                                model.rituals
            in
            ( { model | rituals = maybeRituals }
            , Effect.none
            )


view : Model -> View Msg
view model =
    { title = "Calculator - SeaofThieves"
    , body =
        Components.body
            { titles = [ "Burning Blade" ]
            , content = [ bodyView model ]
            , background = "https://timeofjustice.eu/global/background/sea-of-thieves-sinking-the-burning-blade.webp"
            }
    }


bodyView : Model -> Html Msg
bodyView model =
    Components.container
        { content =
            [ Components.titleDiv "Burning Blade"
            , Components.textInput
                { label = "Anzahl der Rituale"
                , onInput = ChangeRituals
                , value =
                    case model.rituals of
                        Just rituals ->
                            String.fromInt rituals

                        Nothing ->
                            ""
                }
            , table [ css [ Tw.p_3 ] ]
                [ thead []
                    [ tr []
                        [ th [] [ text "Stufe I" ]
                        , th [] [ text "Stufe II" ]
                        , th [] [ text "Stufe III" ]
                        , th [] [ text "Stufe IV" ]
                        , th [] [ text "Stufe V" ]
                        ]
                    ]
                , tbody []
                    [ tr []
                        [ td [ css [ Tw.p_3 ] ] [ text (String.fromFloat (calcGold model.rituals 1.0) ++ " Gold") ]
                        , td [ css [ Tw.p_3 ] ] [ text (String.fromFloat (calcGold model.rituals 1.33) ++ " Gold") ]
                        , td [ css [ Tw.p_3 ] ] [ text (String.fromFloat (calcGold model.rituals 1.67) ++ " Gold") ]
                        , td [ css [ Tw.p_3 ] ] [ text (String.fromFloat (calcGold model.rituals 2) ++ " Gold") ]
                        , td [ css [ Tw.p_3 ] ] [ text (String.fromFloat (calcGold model.rituals 2.5) ++ " Gold") ]
                        ]
                    ]
                ]
            ]
        , popular = [ "Test" ]
        }


calcGold : Maybe Int -> Float -> Float
calcGold maybeRituals multiplier =
    let
        rituals =
            case maybeRituals of
                Just value ->
                    value

                Nothing ->
                    0

        gold =
            if rituals < 1 then
                14000

            else
                26000 * rituals
    in
    toFloat gold * multiplier
