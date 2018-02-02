module Layout.Right exposing (view)

import Application.Message exposing (Message(..))
import Html exposing (div, h3, text)
import Html.Attributes exposing (style)
import Ui.Button
import Ui.Chooser
import Ui.Container exposing (column, row)
import Ui.NumberRange
import Ui.Textarea


view { template, templateСhooser, symbols, imageSize, imageWidth, imageHeight, button } =
    column
        [ style
            [ ( "width", "25%" )
            , ( "padding", "0 3% 0 3%" )
            ]
        ]
        [ h3 [] [ text "Output" ]
        , Html.map ImageSize (Ui.Chooser.view imageSize)
        , Html.map ImageWidth (Ui.NumberRange.view imageWidth)
        , Html.map ImageHeight (Ui.NumberRange.view imageHeight)
        , Html.map Symbols (Ui.Textarea.view symbols)
        , Html.map TemplateСhooser (Ui.Chooser.view templateСhooser)
        , Html.map Template (Ui.Textarea.view template)
        , Ui.Button.view Download button
        ]



-- imageWidth imageHeight
