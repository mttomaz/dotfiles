import { App, Astal, Gdk } from "astal/gtk3"
import { Variable } from "astal"

export default function Crosshair(monitor: Gdk.Monitor, visible: Variable<boolean>) {
  return <window
    className="Crosshair"
    namespace="crosshair"
    gdkmonitor={monitor}
    visible={visible()}
    layer={Astal.Layer.OVERLAY}
    application={App}
    exclusivity={Astal.Exclusivity.IGNORE}
    keymode={Astal.Keymode.NONE}
    canFocus={false}
    acceptFocus={false}
  >
    <box
      className="Dot"
    />
  </window>
}
