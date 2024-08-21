module Pages.Home_ exposing (Model, Msg, page)

import Api.Requests.BurningCalculator
import Api.Requests.Visit
import Api.Responses.BurningCalculator
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
    {}


init : Route () -> ( Model, Effect Msg )
init route =
    ( {}
    , Effect.sendCmd
        (Api.Requests.Visit.get
            { path = route.path
            , msg = NoOp
            }
        )
    )


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Effect.none
            )


view : Model -> View Msg
view model =
    { title = "Home - SeaofThieves"
    , body =
        Components.body
            { titles = [ "Home" ]
            , content = [ bodyView model ]
            , background = "https://timeofjustice.eu/global/background/sea-of-thieves-cannon-guild.jpg"
            }
    }


bodyView : Model -> Html Msg
bodyView model =
    Components.container
        { content = [ Components.titleDiv "Sea of Thieves Wiki" ]
        , popular = [ { title = "Burning Blade (Calculator)", route = Route.Path.Events_BurningBlade_Calculator } ]
        , more = []
        }
