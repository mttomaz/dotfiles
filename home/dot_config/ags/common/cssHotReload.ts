import { App } from 'astal/gtk3'
import { exec, monitorFile } from 'astal'

const TMP = "/tmp"

export function compileScss(): string {
  try {
    exec(`sass ${SRC}/style.scss ${TMP}/style.css`)
    App.apply_css('/tmp/style.css')
    return `${TMP}/style.scss`
  } catch(err) {
    printerr('Error compiling scss files.', err)
    return ''
  }
}

// Hot Reload Scss
(function() {
  const scssFiles =
    exec(`find -L ${SRC} -iname '*.scss'`)
      .split('\n')

  // Compile scss files at startup
  compileScss()

  scssFiles
    .forEach(file =>
      monitorFile(file, compileScss)
    )
})()
