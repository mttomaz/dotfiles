import { showBar, showCrosshair, showLauncher, showLeftSidebar, showRightSidebar } from "@common/vars"
import { Variable } from "astal"

enum RevealerCommand {
  OPEN,
  CLOSE,
  TOGGLE
}

function handleRevealer(command: RevealerCommand, revealer: Variable<boolean>): string {
  switch (command) {
    case RevealerCommand.TOGGLE:
      revealer.set(!revealer.get())
      return `${revealer.get()}`
    default: return 'Unknown reveal command.'
  }
}


export default function requestHandler(request: string, res: (response: any) => void) {
  const args = request.split(':')

  switch (args[0]) {
    case 'bar':
      switch (args[1]) {
        case 'toggle': return res(handleRevealer(RevealerCommand.TOGGLE, showBar))
        default: return res('Unknown command for bar.')
      }
    case 'leftsidebar':
      switch (args[1]) {
        case 'toggle': return res(handleRevealer(RevealerCommand.TOGGLE, showLeftSidebar))
        default: return res('Unknown command for leftsidebar.')
      }
    case 'rightsidebar':
      switch (args[1]) {
        case 'toggle': return res(handleRevealer(RevealerCommand.TOGGLE, showRightSidebar))
        default: return res('Unknown command for rightsidebar.')
      }
    case 'launcher':
      switch (args[1]) {
        case 'toggle': return res(handleRevealer(RevealerCommand.TOGGLE, showLauncher))
        default: return res('Unknown command for launcher.')
      }
    case 'crosshair':
      switch (args[1]) {
        case 'toggle': return res(handleRevealer(RevealerCommand.TOGGLE, showCrosshair))
        default: return res('Unknown command for crosshair.')
      }
    default:
      return res('Unknown request.')
  }
}
