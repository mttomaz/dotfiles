import { bind } from "astal"
import { Gtk } from "astal/gtk3"
import { currentTime } from "@common/vars"

function DigitStack(index: number) {
  return (
    <stack
      transitionType={Gtk.StackTransitionType.SLIDE_DOWN}
      transitionDuration={500}
      visibleChildName={bind(currentTime).as(time => time?.[index] ?? "0")}
      className="DigitStack"
    >
      {Array.from({ length: 10 }, (_, i) => (
        <label name={i.toString()} label={i.toString()} />
      ))}
    </stack>
  )
}

export default function Time() {
  return (
    <box
      className="Time"
      halign={Gtk.Align.CENTER}
      valign={Gtk.Align.CENTER}
    >
      {DigitStack(0)}
      {DigitStack(1)}
      <label label=":"css="font-family: 'JetBrainsMono Nerd Font'" />
      {DigitStack(3)}
      {DigitStack(4)}
    </box>
  )
}
