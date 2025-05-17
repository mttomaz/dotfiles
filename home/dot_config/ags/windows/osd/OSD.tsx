import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { timeout } from "astal/time"
import Variable from "astal/variable"
import Wp from "gi://AstalWp"
import Brightness from "@utils/brightness"
import { spotifyPlayer } from "@common/vars"


function OnScreenProgress({ visible }: { visible: Variable<boolean> }) {
  const brightness = Brightness.get_default()
  const speaker = Wp.get_default()!.get_default_speaker()

  const iconName = Variable("")
  const value = Variable(0)

  let count = 0
  function show(v: number, icon: string) {
    visible.set(true)
    value.set(v)
    iconName.set(icon)
    count++
    timeout(2000, () => {
      count--
      if (count === 0) visible.set(false)
    })
  }

  return (
    <box
      setup={(self) => {
        self.hook(brightness, "notify::screen", () =>
          show(brightness.screen, "display-brightness-symbolic"),
        )

        if (speaker) {
          self.hook(speaker, "notify::volume", () =>
            show(speaker.volume, speaker.volumeIcon),
          )
        }

        self.hook(spotifyPlayer, "notify::volume", () =>
          show(spotifyPlayer.volume, "spotify")
        )
      }}>
      <box vertical className="OSD">
        <icon icon={iconName()}/>
        <levelbar
          valign={Gtk.Align.CENTER}
          heightRequest={100}
          widthRequest={8}
          vertical
          inverted
          value={value()}
        />
        <label label={value(v => `${Math.floor(v * 100)}%`)} />
      </box>
    </box>
  )
}

export default function OSD(monitor: Gdk.Monitor) {
  const visible = Variable(false)

  return (
    <window
      gdkmonitor={monitor}
      className="OSD"
      namespace="osd"
      application={App}
      visible={visible()}
      layer={Astal.Layer.OVERLAY}
      anchor={Astal.WindowAnchor.RIGHT}
    >
      <eventbox onClick={() => visible.set(false)}>
        <OnScreenProgress visible={visible} />
      </eventbox>
    </window>
  )
}
