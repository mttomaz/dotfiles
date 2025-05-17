import { GObject } from "astal"
import { astalify, ConstructProps, Gtk } from "astal/gtk3"

export default class Calendar extends astalify(Gtk.Calendar) {
  static {
    GObject.registerClass(this)
  }
  constructor(
    props: ConstructProps<Gtk.Calendar, Gtk.Calendar.ConstructorProps>,
  ) {
    super(props as any)
  }
}
