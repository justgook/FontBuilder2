port module Application.Port exposing (..)

import Ui.Chooser


type alias Outcome =
    { template : String
    , font : String
    , fontSize : Int
    , fontColor : { red : Int, green : Int, blue : Int, alpha : Float }
    , glyphs : String
    , cssTemplate : String
    }


port outcome : Outcome -> Cmd msg


port css_outcome : String -> Cmd msg


port css_income : (String -> msg) -> Sub msg


port income : (String -> msg) -> Sub msg


port font_list : (List Ui.Chooser.Item -> msg) -> Sub msg


port download : Outcome -> Cmd msg
