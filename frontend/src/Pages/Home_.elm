module Pages.Home_ exposing (Model, Msg, page)

import Api.Requests.Visit
import Api.Responses.Visit
import Auth
import Components
import Effect exposing (Effect)
import Html.Styled exposing (Html, div, table, tbody, td, text, th, thead, tr)
import Html.Styled.Attributes exposing (css)
import Http
import Http.Extra
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
    }


init : Route () -> ( Model, Effect Msg )
init route =
    ( { visitInfo = Loading }
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
    = ReceivedVisitResponse (Result Http.Error (Result Api.Requests.Visit.Error Api.Responses.Visit.VisitInfo))


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


view : Model -> View Msg
view model =
    { title = "Startseite - SeaofThieves"
    , body =
        Components.body
            { titles = [ "Startseite" ]
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
        { content = [ Components.titleDiv "Sea of Thieves Wiki" ]
        , popular =
            case model.visitInfo of
                Success pageInfo ->
                    pageInfo.popular

                _ ->
                    []
        , more = []
        }
