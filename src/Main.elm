module Main exposing (..)

import Application.Message exposing (Message(..))
import Application.Port as Port
import Application.Templates
import Color
import Ext.Color exposing (hsvToRgb)
import Html exposing (button, div, program, text)
import Layout.Main exposing (view)
import Layout.Update
import Set
import Ui.Chooser
import Ui.ColorPicker
import Ui.NumberRange
import Ui.Textarea


main =
    program
        { init = ( { ui = Layout.Update.init, css = "" }, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions model =
    Sub.batch
        [ Ui.Chooser.onChange TemplateСhooserChange model.ui.templateСhooser
        , Port.font_list FontList
        , Port.css_income CSSincome
        , Ui.Chooser.onChange (\_ -> UpdateResult) model.ui.fontСhooser
        , Ui.NumberRange.onChange (\_ -> UpdateResult) model.ui.fontSize
        , Ui.ColorPicker.onChange (\_ -> UpdateResult) model.ui.colorPicker
        , Ui.Textarea.onChange (\_ -> UpdateResult) model.ui.symbols
        ]


update msg ({ ui } as model) =
    let
        ( newModel, cmd ) =
            case msg of
                Download ->
                    ( model, Port.download (outcome model.ui) )

                CSSincome newCss ->
                    ( { model | css = newCss }, Cmd.none )

                UpdateResult ->
                    model ! [ Port.outcome (outcome model.ui) ]

                FontList list ->
                    let
                        ( fontСhooser, cmd ) =
                            Ui.Chooser.items list ui.fontСhooser
                                |> Ui.Chooser.selectFirst

                        newModel =
                            { model | ui = { ui | fontСhooser = fontСhooser } }
                    in
                    newModel ! [ Port.outcome (outcome newModel.ui), Cmd.map FontСhooser cmd ]

                TemplateСhooserChange data ->
                    case Set.toList data of
                        result :: [] ->
                            let
                                _ =
                                    Debug.log "LIST" data

                                newModel =
                                    { model | ui = { ui | template = Ui.Textarea.setValue result ui.template |> Tuple.first } }
                            in
                            newModel ! [ Port.outcome (outcome newModel.ui) ]

                        _ ->
                            ( model, Cmd.none )

                _ ->
                    ( model, Cmd.none )
    in
    Layout.Update.update msg newModel
        |> Tuple.mapSecond (\c -> Cmd.batch [ c, cmd ])


outcome ui =
    { template = ui.template.value
    , font = Set.toList ui.fontСhooser.selected |> List.head |> Maybe.withDefault ""
    , fontSize = round ui.fontSize.value
    , fontColor = hsvToRgb ui.colorPicker.colorPanel.value |> Color.toRgb
    , glyphs = ui.symbols.value
    , cssTemplate = Application.Templates.css
    }
