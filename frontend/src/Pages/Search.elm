module Pages.Search exposing (Model, Msg, page)

import Api.Requests.Search
import Api.Requests.Visit
import Api.Responses.Page
import Api.Responses.Search
import Api.Responses.Visit
import Auth
import Components
import Effect exposing (Effect)
import Html.Styled exposing (Html, div, table, tbody, td, text, th, thead, tr)
import Html.Styled.Attributes exposing (css)
import Http
import Http.Extra
import Icons
import Page exposing (Page)
import ResponseData exposing (ResponseData(..))
import Route exposing (Route)
import Route.Path
import Shared
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
    , searchQuery : String
    , searchInfo : ResponseData Api.Responses.Search.SearchInfo
    }


init : Route () -> ( Model, Effect Msg )
init route =
    ( { visitInfo = Loading, searchQuery = "", searchInfo = Pending }
    , Effect.batch
        [ Effect.sendCmd
            (Api.Requests.Visit.get
                { path = route.path
                , msg = ReceivedVisitResponse
                }
            )
        ]
    )


type Msg
    = NoOp
    | ReceivedVisitResponse (Result Http.Error (Result Api.Requests.Visit.Error Api.Responses.Visit.VisitInfo))
    | ChangeSearch String
    | Search
    | ReceivedSearchResponse (Result Http.Error (Result Api.Requests.Search.Error Api.Responses.Search.SearchInfo))


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Effect.none )

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

        ChangeSearch query ->
            ( { model | searchQuery = query }
            , Effect.none
            )

        Search ->
            ( { model | searchInfo = Loading }
            , Effect.sendCmd
                (Api.Requests.Search.get
                    { query = model.searchQuery
                    , msg = ReceivedSearchResponse
                    }
                )
            )

        ReceivedSearchResponse result ->
            case result of
                Ok (Ok searchInfo) ->
                    ( { model | searchInfo = Success searchInfo }
                    , Effect.none
                    )

                Ok (Err error) ->
                    ( { model | searchInfo = Error (Api.Requests.Search.errorToString error) }
                    , Effect.none
                    )

                Err error ->
                    ( { model | searchInfo = Error (Http.Extra.errorToString error) }
                    , Effect.none
                    )


view : Model -> View Msg
view model =
    { title = "Suche - SeaofThieves"
    , body =
        Components.body
            { titles = [ "Suche" ]
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
            [ Components.titleDiv "Suche"
            , Components.inputWithIconButton { label = "Suche", icon = Icons.search2, onInput = ChangeSearch, onClick = Search, value = model.searchQuery }
            , searchResults model.searchInfo
            ]
        , chapters = []
        , jumpMsg = \_ -> NoOp
        , popular =
            case model.visitInfo of
                Success pageInfo ->
                    pageInfo.popular

                _ ->
                    []
        , more = []
        }


searchResults : ResponseData Api.Responses.Search.SearchInfo -> Html Msg
searchResults searchInfo =
    div []
        (case searchInfo of
            Pending ->
                [ text "" ]

            Loading ->
                [ Components.loadingView ]

            Error error ->
                [ Components.errorView error ]

            Success { pages } ->
                List.map pageView pages
        )


pageView : Api.Responses.Page.Page -> Html Msg
pageView pageInfo =
    div []
        [ div [] [ text pageInfo.title ]
        ]
