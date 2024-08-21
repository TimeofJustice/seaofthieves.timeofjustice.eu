module Pages.Events.BurningBlade.Calculator exposing (Model, Msg, page)

import Api.Requests.BurningCalculator
import Api.Requests.Visit
import Api.Responses.BurningCalculator
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
            , background = "https://timeofjustice.eu/global/background/sea-of-thieves-sinking-the-burning-blade.webp"
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
                    [ { title = "Home", route = Route.Path.Home_ } ]
        , more =
            case model.pageInfo of
                Success pageInfo ->
                    pageInfo.more

                _ ->
                    []
        }


pageView : Api.Responses.BurningCalculator.PageInfo -> Maybe Int -> List (Html Msg)
pageView pageInfo rituals =
    [ Components.titleDiv pageInfo.title
    , Components.textInput
        { label = "Amount of Rituals"
        , onInput = ChangeRituals
        , value =
            case rituals of
                Just amount ->
                    String.fromInt amount

                Nothing ->
                    ""
        }
    , table [ css [ Tw.p_3 ] ]
        [ thead []
            [ tr []
                [ th [] [ text "Grade I" ]
                , th [] [ text "Grade II" ]
                , th [] [ text "Grade III" ]
                , th [] [ text "Grade IV" ]
                , th [] [ text "Grade V" ]
                ]
            ]
        , tbody []
            [ tr []
                [ td [ css [ Tw.p_3 ] ] [ text (String.fromFloat (calcGold rituals pageInfo.emissaryValues.grade1) ++ " Gold") ]
                , td [ css [ Tw.p_3 ] ] [ text (String.fromFloat (calcGold rituals pageInfo.emissaryValues.grade2) ++ " Gold") ]
                , td [ css [ Tw.p_3 ] ] [ text (String.fromFloat (calcGold rituals pageInfo.emissaryValues.grade3) ++ " Gold") ]
                , td [ css [ Tw.p_3 ] ] [ text (String.fromFloat (calcGold rituals pageInfo.emissaryValues.grade4) ++ " Gold") ]
                , td [ css [ Tw.p_3 ] ] [ text (String.fromFloat (calcGold rituals pageInfo.emissaryValues.grade5) ++ " Gold") ]
                ]
            ]
        ]
    ]


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
