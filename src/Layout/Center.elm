module Layout.Center exposing (view)

import Html exposing (canvas, div, text)
import Html.Attributes exposing (id, style)
import Ui.Container exposing (column)


view : Html.Html msg
view =
    column [ style [ ( "flex", "1" ) ] ]
        [ canvas
            [ id "canvas"
            , style
                [ ( "width", "100%" )
                , ( "background-color", "#DDD" )
                , ( "background-image", "linear-gradient(45deg, #F5F5F5 25%, transparent 25%, transparent 75%, #F5F5F5 75%, #F5F5F5),linear-gradient(45deg, #F5F5F5 25%, transparent 25%, transparent 75%, #F5F5F5 75%, #F5F5F5)" )
                , ( "background-position", "0 0, 9px 9px" )
                , ( "background-size", "18px 18px" )
                ]
            ]
            []
        ]
