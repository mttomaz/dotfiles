import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { Variable, bind } from "astal"
import Battery from "gi://AstalBattery"
import Bluetooth from "gi://AstalBluetooth"
import Hyprland from "gi://AstalHyprland"
import Mpris from "gi://AstalMpris"
import Network from "gi://AstalNetwork"
import Tray from "gi://AstalTray"
import Time from "@widgets/Time/Time"
import { getWeatherEmoji } from "@common/functions"
import { memoryUsage, notificationsLength, showLeftSidebar, showRightSidebar, weatherReport } from "@common/vars"

function SysTray() {
  const tray = Tray.get_default()

  return <box className="SysTray">
    {bind(tray, "items").as(items => items.map(item => (
      <menubutton
        tooltipMarkup={bind(item, "tooltipMarkup")}
        usePopover={false}
        actionGroup={bind(item, "actionGroup").as(ag => ["dbusmenu", ag])}
        menuModel={bind(item, "menuModel")}>
        <icon gicon={bind(item, "gicon")} />
      </menubutton>
    )))}
  </box>
}

function NetworkModule() {
  const network = Network.get_default()
  const networkTypes = { "1": "wired", "2": "wifi" }

  return bind(network, "primary").as(p => {
    const dev = network[networkTypes[p]]
    if (dev) {
      return <icon
        className="Network"
        icon={bind(dev, "iconName")} />
    }
    return <box />
  })
}

function BluetoothModule() {
  const bluetooth = Bluetooth.get_default()

  return <revealer
    transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}
    revealChild={bind(bluetooth, "is_connected")}>
    <label className="Bluetooth" label="󰂱" />
  </revealer>
}

function BatteryLevel() {
  const bat = Battery.get_default()

  return <box className="Battery"
    visible={bind(bat, "isPresent")}>
    <label label={bind(bat, "percentage").as(p => `${Math.floor(p * 100)}%`)} />
    <icon icon={bind(bat, "batteryIconName")} />
  </box>
}

function getTitle(player: Mpris.Player): string {
  return player.artist
    ? `${player.artist}: ${player.title}`
    : player.album
      ? `${player.album}: ${player.title}`
      : `${player.title}`
}

function Media() {
  const mpris = Mpris.get_default()

  return bind(mpris, "players").as(ps => ps[0] ? (
    <button className="Media"
      onClick={() => ps[0].play_pause()}>
      <label
        className={bind(ps[0], "playbackStatus").as(s => s > 0 ? "paused" : "playing")}
        truncate
        maxWidthChars={80}
        label={bind(ps[0], "metadata").as(() => getTitle(ps[0]))} />
    </button>
  ) : (<box />))
}

function Workspaces() {
  const hypr = Hyprland.get_default()

  return <box className="Workspaces">
    {bind(hypr, "workspaces").as(wss => wss
      .filter(ws => !(ws.id >= -99 && ws.id <= -2)) // filter out special workspaces
      .sort((a, b) => a.id - b.id)
      .map(ws => (
        <button
          className={bind(hypr, "focusedWorkspace").as(fw =>
            ws === fw ? "focused" : "")}
          onClicked={() => ws.focus()}>
          {ws.id}
        </button>
      ))
    )}
  </box>
}

function Weather() {
  const visible = Variable<boolean>(false)
  return <revealer
    transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
    revealChild={visible()}>
    {bind(weatherReport).as((data) => {
      if (data) {
        const condition = data.weather.current_condition[0]
        const temp = condition.temp_C
        const emoji = getWeatherEmoji(condition.weatherDesc[0].value)
        visible.set(true)
        return <label className="Weather" label={`${temp}°C ${emoji}`} />
      }
      return <box />
    })}
  </revealer>
}

function NotificationBell() {
  return <revealer
    transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}
    revealChild={bind(notificationsLength).as(l => l > 0)}>
    <label className="NotificationBell" label="󱅫" />
  </revealer>
}

function Memory() {
  return <label
    className="Memory"
    onDestroy={() => memoryUsage.drop()}
    label={memoryUsage()}
  />
}

export default function Bar(monitor: Gdk.Monitor, visible: Variable<boolean>) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  return <window
    className="Bar"
    namespace="bar"
    gdkmonitor={monitor}
    exclusivity={Astal.Exclusivity.EXCLUSIVE}
    application={App}
    visible={visible()}
    layer={Astal.Layer.TOP}
    anchor={TOP | LEFT | RIGHT}>
    <centerbox>
      <box
        hexpand
        halign={Gtk.Align.START}
        css="margin-left: 4px">
        <button
          className="TimeAndWeather"
          onClicked={() => showLeftSidebar.set(!showLeftSidebar.get())}
        >
          <box>
            <Time />
            <Weather />
          </box>
        </button>
        <Workspaces />
      </box>
      <Media />
      <box
        hexpand
        halign={Gtk.Align.END}
        css="margin-right: 4px">
        <SysTray />
        <button
          className="TimeAndWeather"
          onClicked={() => showRightSidebar.set(!showRightSidebar.get())}
        >
          <box>
            <BatteryLevel />
            <NetworkModule />
            <BluetoothModule />
            <NotificationBell />
            <Memory />
          </box>
        </button>
      </box>
    </centerbox>
  </window>
}
