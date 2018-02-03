import * as Handlebars from 'handlebars'
import * as Opentype from 'opentype.js'
import * as BinPack from './bin-pack.js'
import * as saveAs from './FileSaver.js'
import * as JSZip from 'jszip'

// declare module 'handlebars/dist/handlebars' {
//   export = Handlebars;
// }

export interface Outcome {
  template: string,
  font: string,
  fontSize: number,
  fontColor: { red: number, green: number, blue: number, alpha: number },
  glyphs: string,
  cssTemplate: string,
}

Handlebars.registerHelper("math", function (lvalue: any, operator: any, rvalue: any, options: any): any {
  lvalue = parseFloat(lvalue);
  rvalue = parseFloat(rvalue);
  const returner: any = {
    "+": lvalue + rvalue,
    "-": lvalue - rvalue,
    "*": lvalue * rvalue,
    "/": lvalue / rvalue,
    "%": lvalue % rvalue
  }
  return returner[operator];
});

Handlebars.registerHelper('compare', function (v1: string, operator: string, v2: string) {
  switch (operator) {
    case '==':
      return (v1 == v2);
    case '!=':
      return (v1 != v2);
    case '===':
      return (v1 === v2);
    case '<':
      return (v1 < v2);
    case '<=':
      return (v1 <= v2);
    case '>':
      return (v1 > v2);
    case '>=':
      return (v1 >= v2);
    case '&&':
      return !!(v1 && v2);
    case '||':
      return !!(v1 || v2);
    default:
      return false;
  }

});

const spaghetti = (data: Outcome, canvas: HTMLCanvasElement, css: boolean) => {
  return new Promise<string>((resolve, reject) => {
    if (data && data.font) {
      const spacing = 2
      Opentype.load(data.font, (err, font) => {
        if (err) {
          return reject('Could not load font: ' + err);
        } else {
          const returnTemplate = !css
            ? Handlebars.compile(data.template, { noEscape: true })
            : Handlebars.compile(data.cssTemplate, { noEscape: true })
          const ctx: CanvasRenderingContext2D = canvas.getContext('2d')
          const glyphs =
            data.glyphs
              .replace(/\s+/g, '')
              .split('')
              .filter((v, i, a) => a.indexOf(v) === i)
              .reduce((acc: Opentype.Glyph[], char) => {
                const a = font.charToGlyph(char)
                if (a.getMetrics().xMax && a.unicode)
                  acc.push(a)
                return acc
              }
              , [])
          const ratio = data.fontSize / font.unitsPerEm
          console.time("pack in");
          const packResult = pack(glyphs, spacing, font.unitsPerEm / data.fontSize, true)
          console.timeEnd("pack in");
          canvas.height = packResult.height * ratio;
          canvas.width = packResult.width * ratio;
          packResult.items.forEach(({ datum, x, y, height, width }: any) => {
            const path = datum.getPath((x - datum.leftSideBearing) * ratio,
              (y + datum.yMax) * ratio,
              data.fontSize)
            const { red, green, blue, alpha } = data.fontColor

            path.fill = `rgba(${red}, ${green}, ${blue}, ${alpha})`
            path.draw(ctx)
          });
          // console.log(font)
          const dataForTemplate = {
            ...data,
            ascender: font.ascender,
            descender: font.descender,
            unitsPerEm: font.unitsPerEm,
            base64: canvas.toDataURL(),
            glyphs: glyphsParser(ratio, spacing, packResult.items),
          }
          resolve(returnTemplate(dataForTemplate))
        }
      });
    } else { reject("no font selected") }
  })
}



function pack(glyphs: Opentype.Glyph[], spacing: number, unitsPerPixel: number, pot: boolean, width?: number, height?: number) {
  const _spacing = spacing * unitsPerPixel
  const binPack = BinPack()
  const getWidth = (d: any) => d.xMax - d.xMin + _spacing
  const getHeight = (d: any) => d.yMax - d.yMin + _spacing
  binPack.rectWidth(getWidth)
  binPack.rectHeight(getHeight)
  glyphs.sort(function (a, b) {
    return Math.max(getWidth(b), getHeight(b)) - Math.max(getWidth(a), getHeight(a));
  })
  if (pot) {
    return _packPOTIncremental(binPack, glyphs, 2 * unitsPerPixel, 2 * unitsPerPixel, unitsPerPixel)
  } else {
    console.log("implement non-pot packing")
  }
}

function _packPOTIncremental(binPack: any, glyphs: Opentype.Glyph[], width: number, height: number, unitsPerPixel: number): any {
  binPack.binWidth(width)
  binPack.binHeight(height)
  binPack.addAll(glyphs)
  if (binPack.unpositioned.length && width < 16384 * unitsPerPixel) {
    return _packPOTIncremental(binPack, glyphs, width * 2, height * 2, unitsPerPixel)
  } else {
    return { items: binPack.positioned, width, height }
  }
}


function glyphsParser(ratio: number, spacing: number, glyphs: { width: number, height: number, x: number, y: number, datum: any }[]): any[] {
  return glyphs.map((g) => ({
    char: String.fromCharCode(g.datum.unicode),
    height: precisionRound(g.height * ratio - spacing + 0.5, 0),
    width: precisionRound(g.width * ratio - spacing + 0.5, 0),
    x: precisionRound(g.x * ratio, 0),
    y: precisionRound(g.y * ratio, 0),
    yOffset: precisionRound(g.datum.yMin * ratio, 0),
    advanceWidth: precisionRound(g.datum.advanceWidth * ratio, 0),
    leftSideBearing: precisionRound(g.datum.leftSideBearing * ratio, 0) || 0,
    rightSideBearing: precisionRound(g.datum.rightSideBearing * ratio, 0) || 0
  }))
}


function precisionRound(number: number, precision: number) {
  var factor = Math.pow(10, precision);
  return Math.round(number * factor) / factor;
}

export { spaghetti }