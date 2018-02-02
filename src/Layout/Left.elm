module Layout.Left exposing (view)

import Application.Message exposing (Message(..))
import Html exposing (div, h3, text)
import Html.Attributes exposing (style)
import Ui.Chooser
import Ui.ColorPicker
import Ui.Container exposing (column)
import Ui.NumberRange


view { fontСhooser, colorPicker, fontSize } =
    column
        [ style
            [ ( "min-width", "25%" )
            , ( "padding", "0 3% 0 3%" )
            ]
        ]
        [ h3 [] [ text "Input" ]
        , Html.map FontСhooser (Ui.Chooser.view fontСhooser)
        , Html.map FontSize (Ui.NumberRange.view fontSize)
        , Html.map ColorPicker (Ui.ColorPicker.render colorPicker)
        ]
