module Application.Message exposing (Message(..))

import Set exposing (Set)
import Ui.Chooser
import Ui.ColorPicker
import Ui.Input
import Ui.NumberRange
import Ui.Textarea


type Message
    = FontList (List Ui.Chooser.Item)
    | CSSincome String
    | FontСhooser Ui.Chooser.Msg
    | ImageSize Ui.Chooser.Msg
    | ImageWidth Ui.NumberRange.Msg
    | ImageHeight Ui.NumberRange.Msg
    | TemplateСhooser Ui.Chooser.Msg
    | Template Ui.Textarea.Msg
    | Symbols Ui.Textarea.Msg
    | FontSize Ui.NumberRange.Msg
    | ColorPicker Ui.ColorPicker.Msg
    | Demo Ui.Input.Msg
    | TemplateСhooserChange (Set String)
    | UpdateResult
    | Download
