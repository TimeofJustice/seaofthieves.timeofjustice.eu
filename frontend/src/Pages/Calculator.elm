module Pages.Calculator exposing (Model, Msg, page)

import Api.Requests.BurningBlade
import Api.WorldEvents.BurningBlade
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
page _ _ =
    Page.new
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


type alias Model =
    { rituals : Maybe Int
    , pageInfo : ResponseData Api.WorldEvents.BurningBlade.PageInfo
    }


init : () -> ( Model, Effect Msg )
init _ =
    ( { rituals = Nothing, pageInfo = Loading }
    , Effect.sendCmd (Api.Requests.BurningBlade.get { msg = ReceivedPageInfoResponse })
    )


type Msg
    = ChangeRituals String
    | ReceivedPageInfoResponse (Result Http.Error (Result Api.Requests.BurningBlade.Error Api.WorldEvents.BurningBlade.PageInfo))


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

        ReceivedPageInfoResponse result ->
            case result of
                Ok (Ok pageInfo) ->
                    ( { model | pageInfo = Success pageInfo }
                    , Effect.none
                    )

                Ok (Err error) ->
                    ( { model | pageInfo = Error (Api.Requests.BurningBlade.errorToString error) }
                    , Effect.none
                    )

                Err error ->
                    ( { model | pageInfo = Error (Http.Extra.errorToString error) }
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
            case model.pageInfo of
                Success pageInfo ->
                    pageView pageInfo model.rituals

                Error error ->
                    [ Components.errorView error ]

                _ ->
                    [ Components.loadingView ]
        , popular =
            case model.pageInfo of
                Success pageInfo ->
                    pageInfo.popular

                _ ->
                    [ { title = "Home", route = Route.Path.Home_ } ]
        }


pageView : Api.WorldEvents.BurningBlade.PageInfo -> Maybe Int -> List (Html Msg)
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
