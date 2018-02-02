module Layout.Footer exposing (view)

import Application.Message exposing (Message(..))
import Html exposing (div, span, text)
import Html.Attributes exposing (attribute)
import Ui.Container exposing (columnCenter)
import Ui.Input


view { demo, fontSize, symbols } css =
    columnCenter []
        [ Html.node "style" [] [ text css ]
        , Html.map Demo (Ui.Input.render demo)
        , div []
            (String.split "" demo.value
                |> List.map (\s -> span [ attribute "data-letter" s ] [])
            )
        ]
