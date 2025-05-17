import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { bind, Variable } from "astal"
import Calendar from "@widgets/Calendar/Calendar"
import Time from "@widgets/Time/Time"
import { getWeatherEmoji, getWeatherImage } from "@common/functions"
import { currentDay, weatherReport } from "@common/vars"


function TimeAndDate() {
  return (
    <box
      className="TimeAndDate"
      vertical
    >
      <Time />
      <label className="Today" label={currentDay().as(day => day.replace(/\^(\w)(\w*)/g, (_, first, rest) => first.toUpperCase() + rest.toLowerCase()))} />
    </box>
  )
}

function CalendarModule() {
  return (
    <box className="calendar" vertical>
      {new Calendar({ hexpand: true, vexpand: true })}
    </box>
  )
}

function getUpcomingHours(hourly: any[]) {
  const now = new Date()
  const currentHour = now.getHours()

  const parsedHourly = hourly.map(h => ({
    ...h,
    hour: Math.floor(Number(h.time) / 100),
  }))

  const startIdx = parsedHourly.findIndex(h => h.hour > currentHour)

  const slice = parsedHourly.slice(startIdx, startIdx + 5)
  return slice.length === 5 ? slice : [...slice, ...parsedHourly.slice(0, 5 - slice.length)]
}


function WeatherSidebar() {
  return bind(weatherReport).as((data) => {
    if (!data) return <box />

    const current = data.weather.current_condition[0]
    const upcoming = getUpcomingHours(data.weather.weather[0].hourly)
    const image = getWeatherImage(current.weatherDesc[0].value)

    return <box
      className="Weather"
      vertical>
      <box
        className="Image"
        css={`background-image: url('${SRC}/assets/weather/${image}')`}>
        <box
          className="Current">
          <box vertical halign={Gtk.Align.START}>
            <label
              className="Icon"
              xalign={0}
              yalign={0}
              vexpand
              label={getWeatherEmoji(current.weatherDesc[0].value)} />
            <label
              className="Description"
              xalign={0}
              label={current.weatherDesc[0].value} />
          </box>
          <box hexpand />
          <box vertical halign={Gtk.Align.END}>
            <box vertical>
              <label
                className="Temp"
                xalign={1}
                yalign={0}
                label={`${current.temp_C}°`} />
              <label
                className="FeelsLike"
                xalign={1}
                yalign={0}
                vexpand
                label={`Feels like: ${current.FeelsLikeC}°`} />
            </box>
            <box
              className="Info"
              vertical>
              <label className="Wind" xalign={1} label={`${current.windspeedKmph}km 💨`} />
              <label className="Humidity" xalign={1} label={`${current.humidity}% 💧`} />
              <label className="Precipitation" xalign={1} label={`${current.precipMM}mm ☔`} />
            </box>
          </box>
        </box>
      </box>
      <box
        className="HourlyForecast"
        homogeneous>
        {upcoming.map(h => (
          <box orientation={1} hexpand={true} className="HourlyItem" spacing={4}>
            <label label={`${h.hour.toString().padStart(2, "0")}:00`} className="Hour" />
            <label
              label={getWeatherEmoji(h.weatherDesc[0].value)}
              className="Icon"
              tooltipText={`${h.weatherDesc[0].value}, ☔: ${h.precipMM}mm`}
            />
            <label label={`${h.tempC}°`} className="SmallTemp" />
          </box>
        ))}
      </box>
    </box>
  })
}

export default function LeftSidebar(monitor: Gdk.Monitor, visible: Variable<boolean>) {
  const { LEFT, TOP } = Astal.WindowAnchor

  return <window
    className="LeftSidebar"
    namespace="leftsidebar"
    gdkmonitor={monitor}
    exclusivity={Astal.Exclusivity.EXCLUSIVE}
    application={App}
    layer={Astal.Layer.TOP}
    visible={visible()}
    anchor={TOP | LEFT}>
    <box
      hexpand
      vertical
      className="sidebar"
    >
      <TimeAndDate />
      <CalendarModule />
      <WeatherSidebar />
    </box>
  </window>
}
