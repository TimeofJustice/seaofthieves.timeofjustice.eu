module Pages.Wiki.EntryName_ exposing (Model, Msg, page)

import Api.Requests.Visit
import Api.Requests.Wiki
import Api.Responses.Visit
import Api.Responses.Wiki exposing (CellType(..), WikiModule(..))
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


page : Shared.Model -> Route { entryName : String } -> Page Model Msg
page _ route =
    Page.new
        { init = \_ -> init route
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


type alias Model =
    { visitInfo : ResponseData Api.Responses.Visit.VisitInfo
    , pageInfo : ResponseData Api.Responses.Wiki.PageInfo
    }


init : Route { entryName : String } -> ( Model, Effect Msg )
init route =
    ( { visitInfo = Loading, pageInfo = Loading }
    , Effect.batch
        [ Effect.sendCmd (Api.Requests.Visit.get { path = route.path, msg = ReceivedVisitResponse })
        , Effect.sendCmd (Api.Requests.Wiki.get { entryName = route.params.entryName, msg = ReceivedPageInfoResponse })
        ]
    )


type Msg
    = ReceivedVisitResponse (Result Http.Error (Result Api.Requests.Visit.Error Api.Responses.Visit.VisitInfo))
    | ReceivedPageInfoResponse (Result Http.Error (Result Api.Requests.Wiki.Error Api.Responses.Wiki.PageInfo))


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

        ReceivedPageInfoResponse result ->
            case result of
                Ok (Ok pageInfo) ->
                    ( { model | pageInfo = Success pageInfo }
                    , Effect.none
                    )

                Ok (Err error) ->
                    ( { model | pageInfo = Error (Api.Requests.Wiki.errorToString error) }
                    , Effect.none
                    )

                Err error ->
                    ( { model | pageInfo = Error (Http.Extra.errorToString error) }
                    , Effect.none
                    )


view : Model -> View Msg
view model =
    { title = "Fish - SeaofThieves"
    , body =
        Components.body
            { titles = [ "Wiki", "Fish" ]
            , content = [ bodyView model ]
            , background = "https://timeofjustice.eu/global/background/sea-of-thieves-sinking-the-burning-blade.webp"
            }
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


moduleView : Api.Responses.Wiki.WikiModule -> Html Msg
moduleView module_ =
    case module_ of
        TextModule { title, content } ->
            div
                []
                [ Components.titleDiv title
                , div
                    []
                    [ text content ]
                ]

        BlockModule { content } ->
            div
                []
                [ text content ]

        ImageModule { description, path } ->
            div
                []
                [ img [ src path ] []
                , div
                    [ css [ Tw.text_sm ] ]
                    [ text description ]
                ]

        TableModule { title, headers, rows } ->
            div []
                [ Components.titleDiv title
                , table [ css tableStyle ]
                    [ thead []
                        [ tr []
                            (List.map
                                (\header ->
                                    th [ css cellStyle ] [ text header ]
                                )
                                headers
                            )
                        ]
                    , tbody []
                        (List.map
                            (\row ->
                                tr []
                                    (List.map
                                        (\cell ->
                                            td [ css cellStyle ]
                                                [ case cell of
                                                    TextCell content ->
                                                        text content

                                                    GoldCell amount ->
                                                        div [ css innerCellStyle ] [ div [] [ text (String.fromInt amount) ], Components.goldView ]
                                                ]
                                        )
                                        row
                                    )
                            )
                            rows
                        )
                    ]
                ]


bodyView : Model -> Html Msg
bodyView model =
    Components.container
        { content =
            case model.pageInfo of
                Success pageInfo ->
                    [ Components.titleDiv pageInfo.title ] ++ List.map moduleView pageInfo.modules

                Error error ->
                    [ Components.errorView error ]

                _ ->
                    [ Components.loadingView ]
        , popular =
            case model.visitInfo of
                Success pageInfo ->
                    pageInfo.popular

                _ ->
                    [ { title = "Home", route = Route.Path.Home_ } ]
        , more =
            []
        }
