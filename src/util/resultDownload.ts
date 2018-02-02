import * as saveAs from './FileSaver.js'
import * as JSZip from 'jszip'



async function done(mapping: String, canvas: HTMLCanvasElement) {
  const zip: any = new JSZip()

  zip.file("mapping.txt", mapping);
  // const example = zip.folder("example");
  zip.file("font.png", canvas.toDataURL().replace("data:image/png;base64,", ""), { base64: true });

  const content = await zip.generateAsync({ type: "blob" })
  // see FileSaver.js
  saveAs(content, "bitmapfont.zip");
}
export { done }