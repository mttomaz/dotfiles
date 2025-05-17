import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { Variable, bind } from "astal"
import { exec, execAsync } from "astal/process"
import Bluetooth from "gi://AstalBluetooth"
import Mpris from "gi://AstalMpris"
import Network from "gi://AstalNetwork"
import Notifd from "gi://AstalNotifd"
import MediaPlayer from "@widgets/MediaPlayer/MediaPlayer"
import Notification from "@widgets/Notification/Notification"
import { getWifiIcon } from "@common/functions"
import { doNotDisturb, nightLightEnabled, notificationsLength, uptime } from "@common/vars"


function UserModule() {
  const userName = exec("whoami")
  const userImg = `${SRC}/assets/profile.png`

  return <box
    className="UserModule">
    <box className="UserImg" css={`background-image: url('${userImg}')`} />
    <box vertical valign={Gtk.Align.CENTER}>
      <label className="Username" label={userName} halign={Gtk.Align.START} />
      <label className="Uptime" label={uptime()} halign={Gtk.Align.START} />
    </box>
  </box>
}

function newSidebarButton(icon: string, name: string, status: string) {
  return (
    <box>
      <label className="Icon" label={icon} />
      <box
        className="Description"
        vertical
        valign={Gtk.Align.CENTER}>
        <label halign={Gtk.Align.START} label={name} />
        <label halign={Gtk.Align.START} label={status} />
      </box>
    </box>
  )
}

function WifiModule() {
  const network = Network.get_default()

  return (
    <box className="Wifi" halign={Gtk.Align.CENTER}>
      {bind(network, "wifi").as(wifi => <box>
        {bind(wifi, "enabled").as(enabled => {
          const icon = bind(wifi, "iconName").as(getWifiIcon)
          const name = enabled
            ? bind(wifi, "ssid").as(ssid => ssid || "Wifi")
            : "Wifi"
          const status = enabled ? "on" : "off"
          return (
            <button
              className={enabled ? "enabled" : "disabled"}
              onClicked={() => wifi.set_enabled(!enabled)}>
              {newSidebarButton(icon, name, status)}
            </button>
          )
        })}
      </box>
      )}
    </box>
  )
}

function BluetoothModule() {
  const bluetooth = Bluetooth.get_default()

  function getConnectedDevice(enabled: Boolean) {
    for (const device of bluetooth.get_devices()) {
      if (device.connected) {
        const name = device.name
        const status = bind(device, "batteryPercentage").as(p =>
          p > 0 ? `${Math.floor(p * 100)}%` : enabled ? "on" : "off")
        return { name, status }
      }
    }
    const name = "Bluetooth"
    const status = enabled ? "on" : "off"
    return { name, status }
  }

  return <box className="Bluetooth" halign={Gtk.Align.CENTER}>
    {bind(bluetooth, "isPowered").as(powered => (
      <button
        className={powered ? "enabled" : "disabled"}
        onClicked={() => exec("rfkill toggle bluetooth")}>
        {bind(bluetooth, "isConnected").as(conn => {
          const icon = conn ? "󰂱" : "󰂯"
          const { name, status } = getConnectedDevice(powered)
          return newSidebarButton(icon, name, status)
        })}
      </button>
    ))}
  </box>
}

function DoNotDisturbModule() {
  const icon = "󰍶"
  const name = "Do Not Disturb"
  return bind(doNotDisturb).as(dnd => {
    const status = dnd ? "on" : "off"
    return (
      <box
        className="doNotDisturb"
        halign={Gtk.Align.CENTER}>
        <button
          className={dnd ? "enabled" : "disabled"}
          onClicked={() => doNotDisturb.set(!dnd)}>
          {newSidebarButton(icon, name, status)}
        </button>
      </box>
    )
  })
}

function toggleNightLight() {
  if (nightLightEnabled.get()) {
    execAsync("pkill hyprsunset")
    nightLightEnabled.set(false)
  } else {
    execAsync("bash -c 'hyprsunset -t 5000 & disown'")
    nightLightEnabled.set(true)
  }
}

function NightLightModule() {
  const name = "Night Light"
  return bind(nightLightEnabled).as(enabled => {
    const icon = enabled ? "󱩌" : "󰌶"
    const status = enabled ? "on" : "off"
    return (
      <box
        className="nightLight"
        halign={Gtk.Align.CENTER}>
        <button
          className={enabled ? "enabled" : "disabled"}
          onClicked={toggleNightLight}>
          {newSidebarButton(icon, name, status)}
        </button>
      </box>
    )
  })
}

function NotificationList() {
  const notifd = Notifd.get_default()

  return <box className="NotificationList">
    {bind(notifd, "notifications").as(notifs => {
      const nLength = notifs.length
      notificationsLength.set(nLength)
      const boxHeight = nLength > 0 ? 400 : 300
      return <box vertical
        heightRequest={boxHeight}
        widthRequest={300}
      >
        <box>
          <label className="Title" label="Notifications" />
          <button
            className="dismissAll"
            halign={Gtk.Align.END}
            hexpand
            label="Clear All"
            onClicked={() => notifs.forEach(n => n.dismiss())}
          />
        </box>
        {nLength > 0 ? (
          <scrollable vexpand>
            <box vertical>
              {notifs.reverse().map(n => {
                return Notification({
                  notification: n,
                  setup: () => { },
                  onHoverLost: () => { }
                })
              })}
            </box>
          </scrollable>
        ) : (
          <box
            className="noNotifications"
            vexpand
            hexpand
            vertical
            valign={Gtk.Align.CENTER}
          >
            <label label="󱏬" className="Icon" />
            <label label="no notifications :(" />
          </box>
        )}
      </box>
    })}
  </box>
}

function actionButton(icon: string, className: string, exec: string | Array<string>) {
  return (
    <box className={className}>
      <button
        onClicked={() => execAsync(exec)}
        label={icon}
      />
    </box>
  )
}

function Actions() {
  return (
    <box className="sidebarActions">
      {actionButton("󰌾", "lock", "~/scripts/wayland/lock")}
      {actionButton("󰤄", "hibernate", "systemctl hibernate; ~/scripts/wayland/lock")}
      {actionButton("󰐥", "poweroff", "poweroff")}
    </box>
  )
}

function ScrollableMediaPlayers() {
  const mpris = Mpris.get_default()
  const currentPlayer = Variable(0)
  const playersLenght = Variable(0)

  return (
    <eventbox
      onScroll={(_, event) => {
        const delta_y = event.delta_y
        const current = currentPlayer.get()
        const max = playersLenght.get() - 1

        if (delta_y < 0) {
          if (current < max) currentPlayer.set(current + 1)
        } else {
          if (current > 0) currentPlayer.set(current - 1)
        }
      }}
    >
      {bind(mpris, "players").as(ps => {
        playersLenght.set(ps.length)
        if (ps.length > 0) return (
        <box vertical>
          <stack
            transitionType={Gtk.StackTransitionType.SLIDE_LEFT_RIGHT}
            transitionDuration={300}
            visibleChildName={bind(currentPlayer).as(current => ps[current].entry)}>
            {ps.map(player => {
              return <box name={player.entry}>
                {MediaPlayer(player)}
              </box>
            })}
          </stack>
          <box
            className="playersButtons"
            halign={Gtk.Align.CENTER}
            visible={ps.length > 1 ? true : false}
          >
            {ps.map(player => (
              <button
                className={bind(currentPlayer).as(current =>
                  ps[current].entry == player.entry
                    ? "enabled"
                    : "disabled"
                )}
                onClicked={() => currentPlayer.set(ps.indexOf(player))}>
                <icon icon={player.entry.replace(/zen/, "zen-browser")}/>
              </button>
            ))}
          </box>
        </box>)
        return <box/>
      })}
    </eventbox>
  )
}


export default function RightSidebar(monitor: Gdk.Monitor, visible: Variable<boolean>) {
  const { TOP, RIGHT } = Astal.WindowAnchor

  return <window
    className="RightSidebar"
    namespace="rightsidebar"
    gdkmonitor={monitor}
    exclusivity={Astal.Exclusivity.EXCLUSIVE}
    application={App}
    visible={visible()}
    layer={Astal.Layer.TOP}
    anchor={TOP | RIGHT}>
    <box
      vertical
      className="sidebar">
      <box>
        <UserModule />
        <box hexpand />
        <Actions />
      </box>
      <box>
        <WifiModule />
        <box widthRequest={8} />
        <BluetoothModule />
      </box>
      <box>
        <DoNotDisturbModule />
        <box widthRequest={8} />
        <NightLightModule />
      </box>
      <ScrollableMediaPlayers />
      <NotificationList />
    </box>
  </window>
}
