declare var PRODUCTION: boolean;
if (PRODUCTION) require('./analytics/base.js').init()
import * as Elm from './Main.elm'
import * as Opentype from 'opentype.js'
import * as BinPack from './util/bin-pack.js'
import * as saveAs from './util/FileSaver.js'
import * as JSZip from 'jszip'
import { Outcome, spaghetti } from './util/spaghetti'
import { done } from './util/resultDownload'

const app = Elm.Main.fullscreen()

app.ports.outcome.subscribe((data: Outcome) =>
  spaghetti(data, <HTMLCanvasElement>document.getElementById('canvas'), true)
    .then(app.ports.css_income.send)
)


app.ports.download.subscribe((data: Outcome) => {
  const canvas = <HTMLCanvasElement>document.getElementById('canvas')
  spaghetti(data, canvas, false)
    .then((mapping) => done(mapping, canvas))
})

interface FontItem {
  label: string,
  value: string,
  id: string,
}

const fontFilesFolder = (label: string, id: string) => (acc: FontItem[], [key, value]: [string, string]): FontItem[] => {
  return acc.concat({ label: `${label} (${key})`, value: value, id: `${id}-${key}` })
}

function fontFolder(acc: FontItem[], item: any, index: number): FontItem[] {
  return acc.concat(Object.entries(item.files).reduce(fontFilesFolder(item.family, index.toString(16)), []))
}
app.ports.font_list.send(require("../webfonts.json").items.reduce(fontFolder, []))





