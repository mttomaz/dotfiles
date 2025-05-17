import { bind } from "astal"
import { Gtk } from "astal/gtk3"
import Variable from "astal/variable"
import Mpris from "gi://AstalMpris"


function lengthStr(length: number) {
  const min = Math.floor(length / 60)
  const sec = Math.floor(length % 60)
  const sec0 = sec < 10 ? "0" : ""
  return `${min}:${sec0}${sec}`
}

export default function MediaPlayer(player: Mpris.Player) {
  const showPosition = Variable<boolean>(false)

  const coverArt = bind(player, "coverArt").as(c =>
    `background-image: url('${c}')`)

  const playIcon = bind(player, "playbackStatus").as(s =>
    s === 0 ? "󰏤" : "󰐊")

  const position = bind(player, "position").as(p => player.length > 0
    ? p / player.length : 0)

  function ArtistTitle() {
    return <box vertical hexpand>
      <label
        className="Title"
        truncate
        maxWidthChars={35}
        halign={Gtk.Align.START}
        valign={Gtk.Align.START}
        label={bind(player, "metadata").as(() => `${player.title}`)} />
      <label
        className="Artist"
        vexpand
        halign={Gtk.Align.START}
        valign={Gtk.Align.START}
        label={bind(player, "metadata").as(() => {
          if (player.artist) return `${player.artist}`
          if (player.album) return `${player.album}`
          return ""
        })} />
    </box>
  }

  function Position() {
    return <revealer
      revealChild={bind(showPosition)}
      transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}>
      <box vertical className="position">
        <box>
          <label
            halign={Gtk.Align.START}
            visible={bind(player, "length").as(l => l > 0)}
            label={bind(player, "position").as(lengthStr)}
          />
          <label
            hexpand
            halign={Gtk.Align.START}
            visible={bind(player, "length").as(l => l > 0)}
            label={bind(player, "length").as(l => l > 0 ? ` - ${lengthStr(l)}` : " - 0:00")}
          />
        </box>
        <slider
          visible={bind(player, "length").as(l => l > 0)}
          onDragged={({ value }) => player.position = value * player.length}
          value={position}
        />
      </box>
    </revealer>
  }

  function Actions() {
    return <box
      className="Actions"
      homogeneous
      vertical>
      <button
        label="󰒮"
        onClicked={() => player.previous()}
      />
      <button
        label={playIcon}
        onClick={() => player.play_pause()}
      />
      <button
        label="󰒭"
        onClicked={() => player.next()}
      />
    </box>
  }

  return <eventbox
    onHover={() => showPosition.set(true)}
    onHoverLost={() => showPosition.set(false)}>
    <box className="MediaPlayer" >
      <box
        className="Cover"
        hexpand
        widthRequest={300}
        css={coverArt}>
        <box
          className="Description"
          vertical>
          <ArtistTitle />
          <Position />
        </box>
      </box>
      <Actions />
    </box>
  </eventbox>
}
