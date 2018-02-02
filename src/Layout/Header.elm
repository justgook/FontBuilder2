module Layout.Header exposing (view)

import Html exposing (div, text)
import Ui.Container exposing (rowCenter)
import Ui.Header


view : Html.Html msg
view =
    Ui.Header.view
        [ Ui.Header.title
            { action = Nothing
            , target = "_self"
            , link = Nothing
            , text = "Font Builder"
            }
        ]
