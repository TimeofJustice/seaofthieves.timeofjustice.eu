module Key exposing (onEnter)

import Browser.Events
import Json.Decode as Decode


onEnter : msg -> Sub msg
onEnter msg =
    let
        decoder =
            let
                decodeKey string =
                    case string of
                        "Enter" ->
                            Decode.succeed msg

                        _ ->
                            Decode.fail ("Unknown key: " ++ string)
            in
            Decode.field "key" Decode.string
                |> Decode.andThen decodeKey
    in
    Browser.Events.onKeyDown decoder
