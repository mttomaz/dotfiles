import { GLib, Variable } from "astal"
import { execAsync } from "astal/process"
import Mpris from "gi://AstalMpris"

export const showBar = Variable<boolean>(true)
export const showLeftSidebar = Variable<boolean>(false)
export const showRightSidebar = Variable<boolean>(false)
export const showCrosshair = Variable<boolean>(false)
export const showLauncher = Variable<boolean>(false)
export const doNotDisturb = Variable<boolean>(false)
export const nightLightEnabled = Variable<boolean>(false)
export const notificationsLength = Variable<number>(0)
export const spotifyPlayer = Mpris.Player.new("spotify")

execAsync('pgrep -x hyprsunset')
  .then(() => nightLightEnabled.set(true))
  .catch(() => nightLightEnabled.set(false))

export const currentTime = Variable<string>("").poll(1000, () =>
  GLib.DateTime.new_now_local().format("%H:%M")!)

export const currentDay = Variable<string>("").poll(1000, () =>
  GLib.DateTime.new_now_local().format("^%A, %d de ^%B")!)

export const uptime = Variable("").poll(5 * 60 * 1000, async () => {
  const output = await execAsync("uptime -p")
  return output
    .replace(/ minutes| minute/, "m")
    .replace(/ hours| hour/, "h")
    .replace(/ days| day/, "d")
    .replace(/ weeks| week/, "w")
})

export const memoryUsage = Variable<string>("").poll(5 * 1000, async () => {
  const output = await execAsync(["sh", "-c", `free --mega | awk 'NR==2{print $3 " MB"}'`])
  return output
})

type WeatherData = {
  timestamp: string
  weather: any
};

export const weatherReport = Variable<WeatherData | null>(null).poll(20 * 60 * 1000, async () => {
  try {
    const result = await execAsync(`curl -s "wttr.in/Curitiba?format=j1"`)
    const weather = JSON.parse(result)
    const timestamp = currentTime.get()
    return { timestamp, weather }
  } catch (err) {
    console.error("Error fetching weather:", err)
    return null
  }
})
