module Layout.Update exposing (init, update)

import Application.Message exposing (Message(..))
import Application.Templates
import Color
import Html exposing (button, div, program, text)
import Html.Events exposing (onClick)
import Layout.Main exposing (view)
import Ui
import Ui.Button
import Ui.Chooser
import Ui.ColorPicker
import Ui.Input
import Ui.Layout
import Ui.NumberRange
import Ui.Textarea


init =
    { fontСhooser =
        Ui.Chooser.init ()
            |> Ui.Chooser.placeholder "Select font .."
            |> Ui.Chooser.searchable True
            |> Ui.Chooser.closeOnSelect True
    , fontSize =
        Ui.NumberRange.init ()
            |> Ui.NumberRange.affix "px"
            |> Ui.NumberRange.round 0
            |> Ui.NumberRange.dragStep 1
            |> Ui.NumberRange.min 0
            |> Ui.NumberRange.setValue 70
            |> Tuple.first
    , colorPicker =
        Ui.ColorPicker.init ()
    , template =
        Ui.Textarea.init ()
            |> Ui.Textarea.placeholder "Handlebars Template..."
    , templateСhooser =
        Ui.Chooser.init ()
            |> Ui.Chooser.placeholder "Select Template.. "
            |> Ui.Chooser.closeOnSelect True
            |> Ui.Chooser.items Application.Templates.list
    , demo =
        Ui.Input.init ()
            |> Ui.Input.placeholder "Enter Your text for demo"
            |> Ui.Input.showClearIcon True
            |> Ui.Input.setValue "The quick brown fox jumps over the lazy dog"
            |> Tuple.first
    , imageSize =
        Ui.Chooser.init ()
            |> (\d -> { d | disabled = True })
            |> Ui.Chooser.placeholder "Image size.."
            |> Ui.Chooser.searchable True
            |> Ui.Chooser.closeOnSelect True
            |> Ui.Chooser.items
                [ { id = "1", value = "1", label = "POT (Power of 2)" }
                , { id = "2", value = "2", label = "Width Fixed" }
                , { id = "3", value = "3", label = "Height Fixed" }
                ]
            |> Ui.Chooser.selectFirst
            |> Tuple.first
    , imageWidth =
        Ui.NumberRange.init ()
            |> Ui.NumberRange.affix "px (width)"
            |> Ui.NumberRange.round 0
            |> Ui.NumberRange.dragStep 1
            |> Ui.NumberRange.min 0
            |> Ui.NumberRange.setValue 1024
            |> Tuple.first
            |> (\d -> { d | disabled = True })
    , imageHeight =
        Ui.NumberRange.init ()
            |> Ui.NumberRange.affix "px (height)"
            |> Ui.NumberRange.round 0
            |> Ui.NumberRange.dragStep 1
            |> Ui.NumberRange.min 0
            |> Ui.NumberRange.setValue 1024
            |> Tuple.first
            |> (\d -> { d | disabled = True })
    , button = Ui.Button.model "Download" "primary" "medium"
    , symbols =
        Ui.Textarea.init ()
            |> Ui.Textarea.placeholder "Symbols in font..."
            |> Ui.Textarea.setValue """ABCDEFGHIJKLMNOPQRSTUVWXYZ
abcdefghijklmnopqrstuvwxyz
0123456789:;<=>?@
!"#$%&'()*+,-./
[]^_`{|}~\x7F"""
            |> Tuple.first
    }


update msg_ ({ ui } as model) =
    case msg_ of
        ImageWidth msg ->
            let
                ( imageWidth, cmd ) =
                    Ui.NumberRange.update msg ui.imageWidth
            in
            ( { model
                | ui = { ui | imageWidth = imageWidth }
              }
            , Cmd.map ImageWidth cmd
            )

        ImageHeight msg ->
            let
                ( imageHeight, cmd ) =
                    Ui.NumberRange.update msg ui.imageHeight
            in
            ( { model
                | ui = { ui | imageHeight = imageHeight }
              }
            , Cmd.map ImageHeight cmd
            )

        ImageSize msg ->
            let
                ( imageSize, cmd ) =
                    Ui.Chooser.update msg ui.imageSize
            in
            ( { model
                | ui = { ui | imageSize = imageSize }
              }
            , Cmd.map ImageSize cmd
            )

        Template msg ->
            let
                ( template, cmd ) =
                    Ui.Textarea.update msg ui.template
            in
            ( { model
                | ui = { ui | template = template }
              }
            , Cmd.map Template cmd
            )

        Symbols msg ->
            let
                ( symbols, cmd ) =
                    Ui.Textarea.update msg ui.symbols
            in
            ( { model
                | ui = { ui | symbols = symbols }
              }
            , Cmd.map Symbols cmd
            )

        TemplateСhooser msg ->
            let
                ( templateСhooser, cmd ) =
                    Ui.Chooser.update msg ui.templateСhooser
            in
            ( { model
                | ui = { ui | templateСhooser = templateСhooser }
              }
            , Cmd.map TemplateСhooser cmd
            )

        ColorPicker msg ->
            let
                ( colorPicker, cmd ) =
                    Ui.ColorPicker.update msg ui.colorPicker
            in
            ( { model
                | ui = { ui | colorPicker = colorPicker }
              }
            , Cmd.map ColorPicker cmd
            )

        FontSize msg ->
            let
                ( fontSize, cmd ) =
                    Ui.NumberRange.update msg ui.fontSize
            in
            ( { model
                | ui = { ui | fontSize = fontSize }
              }
            , Cmd.map FontSize cmd
            )

        FontСhooser msg ->
            let
                ( fontСhooser, cmd ) =
                    Ui.Chooser.update msg ui.fontСhooser
            in
            ( { model
                | ui = { ui | fontСhooser = fontСhooser }
              }
            , Cmd.map FontСhooser cmd
            )

        Demo msg ->
            let
                ( demo, cmd ) =
                    Ui.Input.update msg ui.demo
            in
            ( { model
                | ui = { ui | demo = demo }
              }
            , Cmd.map Demo cmd
            )

        _ ->
            ( model, Cmd.none )
