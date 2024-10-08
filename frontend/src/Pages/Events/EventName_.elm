module Pages.Events.EventName_ exposing (Model, Msg, page)

import Effect exposing (Effect)
import Route exposing (Route)
import Html
import Page exposing (Page)
import Shared
import View exposing (View)


page : Shared.Model -> Route { eventName : String } -> Page Model Msg
page shared route =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- INIT


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init () =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Pages.Events.EventName_"
    , body = [ Html.text "/events/:eventName" ]
    }
