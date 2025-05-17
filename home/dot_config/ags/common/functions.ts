export function getWeatherEmoji(desc: string): string {
  desc = desc.toLowerCase()

  if (desc.includes("sunny") || desc.includes("clear")) return "☀️"
  if (desc.includes("partly")) return "⛅"
  if (desc.includes("cloudy") || desc.includes("overcast")) return "☁️"
  if (desc.includes("rain") || desc.includes("drizzle")) return "🌧️"
  if (desc.includes("thunder")) return "⛈️"
  if (desc.includes("snow")) return "❄️"
  if (desc.includes("fog") || desc.includes("mist")) return "🌫️"

  return "🌈" // fallback
}

export function getWeatherImage(desc: string): string {
  desc = desc.toLowerCase()

  if (desc.includes("sunny") || desc.includes("clear")) return "clear.png"
  if (desc.includes("partly")) return "partly_cloudy.png"
  if (desc.includes("cloudy") || desc.includes("overcast")) return "cloudy.png"
  if (desc.includes("light")) return "light_rain.png" // inclui tbm o light drizzle
  if (desc.includes("rain") || desc.includes("drizzle")) return "rain.png"
  if (desc.includes("thunder")) return "storm.png"
  // if (desc.includes("snow")) return "❄️"
  if (desc.includes("fog") || desc.includes("mist")) return "fog.png"

  return "other.png"
}

export function getWifiIcon(icon) {
  if (icon.includes("offline")) return "󰤮"
  if (icon.includes("no-route")) return "󰤭"
  if (icon.includes("connected")) return "󰤫"
  if (icon.includes("signal-none")) return "󰤯"
  if (icon.includes("signal-weak")) return "󰤟"
  if (icon.includes("signal-ok")) return "󰤢"
  if (icon.includes("signal-good")) return "󰤥"
  if (icon.includes("encrypted")) return "󰤪"
  return "󰤨"
}

export function escapeMarkup(text: string): string {
  return text.replace(/&/g, "&amp;");
}
