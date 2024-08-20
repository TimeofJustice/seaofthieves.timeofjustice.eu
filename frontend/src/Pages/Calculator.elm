module Pages.Calculator exposing (page, Model, Msg)

import Auth
import Components
import Effect exposing (Effect)
import Html.Styled exposing (Html, div, text)
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
    {}


init : () -> ( Model, Effect Msg )
init _ =
    ( {}, Effect.none )


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Effect.none )


view : Model -> View Msg
view model =
    { title = "Login - CampusNotes"
    , body =
        Components.body
            { titles = [ "Login" ]
            , content = [ bodyView model ]
            }
    }


bodyView : Model -> Html Msg
bodyView model =
    div []
        [ div [ css [ Tw.flex, Tw.justify_center, Tw.items_center, Tw.h_full ] ]
            [ text "Home" ]
        ]
