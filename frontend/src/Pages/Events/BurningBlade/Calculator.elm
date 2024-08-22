module Pages.Events.BurningBlade.Calculator exposing (Model, Msg, page)

import Api.Requests.BurningCalculator
import Api.Requests.Visit
import Api.Responses.BurningCalculator
import Api.Responses.Visit
import Auth
import Components
import Css
import Effect exposing (Effect)
import Html.Styled exposing (Html, div, img, table, tbody, td, text, th, thead, tr)
import Html.Styled.Attributes exposing (css, src)
import Http
import Http.Extra
import Page exposing (Page)
import ResponseData exposing (ResponseData(..))
import Route exposing (Route)
import Route.Path
import Shared
import Tailwind.Extra as Tw
import Tailwind.Theme as Tw
import Tailwind.Utilities as Tw
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page _ route =
    Page.new
        { init = \_ -> init route
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


type alias Model =
    { visitInfo : ResponseData Api.Responses.Visit.VisitInfo
    , rituals : Maybe Int
    , pageInfo : ResponseData Api.Responses.BurningCalculator.PageInfo
    }


init : Route () -> ( Model, Effect Msg )
init route =
    ( { visitInfo = Loading, rituals = Nothing, pageInfo = Loading }
    , Effect.batch
        [ Effect.sendCmd (Api.Requests.BurningCalculator.get { msg = ReceivedPageInfoResponse })
        , Effect.sendCmd (Api.Requests.Visit.get { path = route.path, msg = ReceivedVisitResponse })
        ]
    )


type Msg
    = ReceivedVisitResponse (Result Http.Error (Result Api.Requests.Visit.Error Api.Responses.Visit.VisitInfo))
    | ChangeRituals String
    | ReceivedPageInfoResponse (Result Http.Error (Result Api.Requests.BurningCalculator.Error Api.Responses.BurningCalculator.PageInfo))


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ReceivedVisitResponse result ->
            case result of
                Ok (Ok pageInfo) ->
                    ( { model | visitInfo = Success pageInfo }
                    , Effect.none
                    )

                Ok (Err error) ->
                    ( { model | visitInfo = Error (Api.Requests.Visit.errorToString error) }
                    , Effect.none
                    )

                Err error ->
                    ( { model | visitInfo = Error (Http.Extra.errorToString error) }
                    , Effect.none
                    )

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

        ReceivedPageInfoResponse result ->
            case result of
                Ok (Ok pageInfo) ->
                    ( { model | pageInfo = Success pageInfo }
                    , Effect.none
                    )

                Ok (Err error) ->
                    ( { model | pageInfo = Error (Api.Requests.BurningCalculator.errorToString error) }
                    , Effect.none
                    )

                Err error ->
                    ( { model | pageInfo = Error (Http.Extra.errorToString error) }
                    , Effect.none
                    )


view : Model -> View Msg
view model =
    { title = "BB-Calculator - SeaofThieves"
    , body =
        Components.body
            { titles = [ "Events", "Burning Blade", "Calculator" ]
            , content = [ bodyView model ]
            , background =
                case model.visitInfo of
                    Success visitInfo ->
                        visitInfo.backgroundUrl

                    _ ->
                        "https://timeofjustice.eu/global/background/sea-of-thieves-cannon-guild.jpg"
            }
    }


bodyView : Model -> Html Msg
bodyView model =
    Components.container
        { content =
            case model.pageInfo of
                Success pageInfo ->
                    pageView pageInfo model.rituals

                Error error ->
                    [ Components.errorView error ]

                _ ->
                    [ Components.loadingView ]
        , popular =
            case model.visitInfo of
                Success pageInfo ->
                    pageInfo.popular

                _ ->
                    [ { title = "Startseite", route = Route.Path.Home_ } ]
        , more =
            case model.pageInfo of
                Success pageInfo ->
                    pageInfo.more

                _ ->
                    []
        }


tableStyle : List Css.Style
tableStyle =
    [ Tw.w_full
    , Tw.border
    , Tw.border_collapse
    , Tw.p_3
    , Tw.bg_color Tw.teal_900
    , Tw.border_1
    , Tw.border_solid
    , Tw.border_color Tw.emerald_700
    ]


cellStyle : List Css.Style
cellStyle =
    [ Tw.p_3
    , Tw.border_1
    , Tw.border_solid
    , Tw.border_color Tw.emerald_700
    , Tw.text_center
    ]


innerCellStyle : List Css.Style
innerCellStyle =
    [ Tw.flex
    , Tw.flex_row
    , Tw.items_center
    , Tw.justify_center
    , Tw.space_x_1
    ]


pageView : Api.Responses.BurningCalculator.PageInfo -> Maybe Int -> List (Html Msg)
pageView pageInfo rituals =
    [ Components.titleDiv pageInfo.title
    , div [] [ text pageInfo.description ]
    , Components.textInput
        { label = "Anzahl der Rituale"
        , onInput = ChangeRituals
        , value =
            case rituals of
                Just amount ->
                    String.fromInt amount

                Nothing ->
                    ""
        }
    , table [ css tableStyle ]
        [ thead []
            [ tr []
                [ th [ css cellStyle ] [ text "Stufe I" ]
                , th [ css cellStyle ] [ text "Stufe II" ]
                , th [ css cellStyle ] [ text "Stufe III" ]
                , th [ css cellStyle ] [ text "Stufe IV" ]
                , th [ css cellStyle ] [ text "Stufe V" ]
                ]
            ]
        , tbody []
            [ tr []
                (List.map
                    goldView
                    [ calcGold rituals pageInfo.emissaryValues.grade1
                    , calcGold rituals pageInfo.emissaryValues.grade2
                    , calcGold rituals pageInfo.emissaryValues.grade3
                    , calcGold rituals pageInfo.emissaryValues.grade4
                    , calcGold rituals pageInfo.emissaryValues.grade5
                    ]
                )
            ]
        ]
    ]


goldView : Float -> Html msg
goldView gold =
    td [ css cellStyle ] [ div [ css innerCellStyle ] [ div [] [ text (String.fromFloat gold) ], Components.goldView ] ]


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
