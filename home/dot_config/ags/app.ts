#!/usr/bin/gjs -m
import { compileScss } from "@common/cssHotReload"
import { doNotDisturb, showBar, showCrosshair, showLauncher, showLeftSidebar, showRightSidebar } from "@common/vars"
import Bar from "@windows/bar/Bar"
import Crosshair from "@windows/crosshair/Crosshair"
import Launcher from "@windows/launcher/Launcher"
import LeftSidebar from "@windows/left_sidebar/LeftSidebar"
import NotificationPopups from "@windows/notification_popups/NotificationPopups"
import OSD from "@windows/osd/OSD"
import RightSidebar from "@windows/right_sidebar/RightSidebar"
import { App, Gdk } from "astal/gtk3"
import requestHandler from "./requestHandler"

function getTargetMonitor(monitors: Array<Gdk.Monitor>) {
  const notebookModel = "0x9051"
  const pcModel = "24G2W1G4"

  const notebookMonitor = monitors.find(m => m.model === notebookModel)
  const pcMonitor = monitors.find(m => m.model === pcModel)

  return notebookMonitor || pcMonitor || monitors[0]
}

App.start({
  css: compileScss(),
  requestHandler: requestHandler,
  main() {
    const monitors = App.get_monitors()

    const targetMonitor = getTargetMonitor(monitors)

    Bar(targetMonitor, showBar)
    LeftSidebar(targetMonitor, showLeftSidebar)
    RightSidebar(targetMonitor, showRightSidebar)
    Crosshair(targetMonitor, showCrosshair)
    OSD(targetMonitor)
    NotificationPopups(targetMonitor, doNotDisturb)
    Launcher(targetMonitor, showLauncher)

    print(`\nAstal Windows applied on monitor: ${targetMonitor.model}`)
  },
})
