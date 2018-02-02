module Layout.Main exposing (view)

import Html.Attributes exposing (style)
import Layout.Center as Center
import Layout.Footer as Footer
import Layout.Header as Header
import Layout.Left as Left
import Layout.Right as Right
import Ui.Container exposing (columnCenter, row)


view { ui, css } =
    columnCenter
        [ style [ ( "height", "100%" ) ] ]
        [ Header.view
        , Ui.Container.render { direction = "row", align = "space-between", compact = False }
            [ style [ ( "flex", "1" ) ] ]
            [ Left.view ui
            , Center.view
            , Right.view ui
            ]
        , Footer.view ui css
        ]
