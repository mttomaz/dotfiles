#!/usr/bin/gjs -m
var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __typeError = (msg) => {
  throw TypeError(msg);
};
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __decorateClass = (decorators, target, key, kind) => {
  var result = kind > 1 ? void 0 : kind ? __getOwnPropDesc(target, key) : target;
  for (var i = decorators.length - 1, decorator; i >= 0; i--)
    if (decorator = decorators[i])
      result = (kind ? decorator(target, key, result) : decorator(result)) || result;
  if (kind && result) __defProp(target, key, result);
  return result;
};
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);
var __accessCheck = (obj, member, msg) => member.has(obj) || __typeError("Cannot " + msg);
var __privateGet = (obj, member, getter) => (__accessCheck(obj, member, "read from private field"), getter ? getter.call(obj) : member.get(obj));
var __privateAdd = (obj, member, value) => member.has(obj) ? __typeError("Cannot add the same private member more than once") : member instanceof WeakSet ? member.add(obj) : member.set(obj, value);
var __privateSet = (obj, member, value, setter) => (__accessCheck(obj, member, "write to private field"), setter ? setter.call(obj, value) : member.set(obj, value), value);

// ../../../../usr/share/astal/gjs/gtk3/index.ts
import Astal7 from "gi://Astal?version=3.0";
import Gtk4 from "gi://Gtk?version=3.0";
import Gdk from "gi://Gdk?version=3.0";

// ../../../../usr/share/astal/gjs/variable.ts
import Astal3 from "gi://AstalIO";

// ../../../../usr/share/astal/gjs/binding.ts
var snakeify = (str) => str.replace(/([a-z])([A-Z])/g, "$1_$2").replaceAll("-", "_").toLowerCase();
var kebabify = (str) => str.replace(/([a-z])([A-Z])/g, "$1-$2").replaceAll("_", "-").toLowerCase();
var Binding = class _Binding {
  transformFn = (v) => v;
  #emitter;
  #prop;
  static bind(emitter, prop) {
    return new _Binding(emitter, prop);
  }
  constructor(emitter, prop) {
    this.#emitter = emitter;
    this.#prop = prop && kebabify(prop);
  }
  toString() {
    return `Binding<${this.#emitter}${this.#prop ? `, "${this.#prop}"` : ""}>`;
  }
  as(fn) {
    const bind2 = new _Binding(this.#emitter, this.#prop);
    bind2.transformFn = (v) => fn(this.transformFn(v));
    return bind2;
  }
  get() {
    if (typeof this.#emitter.get === "function")
      return this.transformFn(this.#emitter.get());
    if (typeof this.#prop === "string") {
      const getter = `get_${snakeify(this.#prop)}`;
      if (typeof this.#emitter[getter] === "function")
        return this.transformFn(this.#emitter[getter]());
      return this.transformFn(this.#emitter[this.#prop]);
    }
    throw Error("can not get value of binding");
  }
  subscribe(callback) {
    if (typeof this.#emitter.subscribe === "function") {
      return this.#emitter.subscribe(() => {
        callback(this.get());
      });
    } else if (typeof this.#emitter.connect === "function") {
      const signal = `notify::${this.#prop}`;
      const id = this.#emitter.connect(signal, () => {
        callback(this.get());
      });
      return () => {
        this.#emitter.disconnect(id);
      };
    }
    throw Error(`${this.#emitter} is not bindable`);
  }
};
var { bind } = Binding;
var binding_default = Binding;

// ../../../../usr/share/astal/gjs/time.ts
import Astal from "gi://AstalIO";
var Time = Astal.Time;
function interval(interval2, callback) {
  return Astal.Time.interval(interval2, () => void callback?.());
}
function timeout(timeout2, callback) {
  return Astal.Time.timeout(timeout2, () => void callback?.());
}

// ../../../../usr/share/astal/gjs/process.ts
import Astal2 from "gi://AstalIO";
var Process = Astal2.Process;
function subprocess(argsOrCmd, onOut = print, onErr = printerr) {
  const args = Array.isArray(argsOrCmd) || typeof argsOrCmd === "string";
  const { cmd, err, out } = {
    cmd: args ? argsOrCmd : argsOrCmd.cmd,
    err: args ? onErr : argsOrCmd.err || onErr,
    out: args ? onOut : argsOrCmd.out || onOut
  };
  const proc = Array.isArray(cmd) ? Astal2.Process.subprocessv(cmd) : Astal2.Process.subprocess(cmd);
  proc.connect("stdout", (_, stdout) => out(stdout));
  proc.connect("stderr", (_, stderr) => err(stderr));
  return proc;
}
function exec(cmd) {
  return Array.isArray(cmd) ? Astal2.Process.execv(cmd) : Astal2.Process.exec(cmd);
}
function execAsync(cmd) {
  return new Promise((resolve, reject) => {
    if (Array.isArray(cmd)) {
      Astal2.Process.exec_asyncv(cmd, (_, res) => {
        try {
          resolve(Astal2.Process.exec_asyncv_finish(res));
        } catch (error) {
          reject(error);
        }
      });
    } else {
      Astal2.Process.exec_async(cmd, (_, res) => {
        try {
          resolve(Astal2.Process.exec_finish(res));
        } catch (error) {
          reject(error);
        }
      });
    }
  });
}

// ../../../../usr/share/astal/gjs/variable.ts
var VariableWrapper = class extends Function {
  variable;
  errHandler = console.error;
  _value;
  _poll;
  _watch;
  pollInterval = 1e3;
  pollExec;
  pollTransform;
  pollFn;
  watchTransform;
  watchExec;
  constructor(init) {
    super();
    this._value = init;
    this.variable = new Astal3.VariableBase();
    this.variable.connect("dropped", () => {
      this.stopWatch();
      this.stopPoll();
    });
    this.variable.connect("error", (_, err) => this.errHandler?.(err));
    return new Proxy(this, {
      apply: (target, _, args) => target._call(args[0])
    });
  }
  _call(transform) {
    const b = binding_default.bind(this);
    return transform ? b.as(transform) : b;
  }
  toString() {
    return String(`Variable<${this.get()}>`);
  }
  get() {
    return this._value;
  }
  set(value) {
    if (value !== this._value) {
      this._value = value;
      this.variable.emit("changed");
    }
  }
  startPoll() {
    if (this._poll)
      return;
    if (this.pollFn) {
      this._poll = interval(this.pollInterval, () => {
        const v = this.pollFn(this.get());
        if (v instanceof Promise) {
          v.then((v2) => this.set(v2)).catch((err) => this.variable.emit("error", err));
        } else {
          this.set(v);
        }
      });
    } else if (this.pollExec) {
      this._poll = interval(this.pollInterval, () => {
        execAsync(this.pollExec).then((v) => this.set(this.pollTransform(v, this.get()))).catch((err) => this.variable.emit("error", err));
      });
    }
  }
  startWatch() {
    if (this._watch)
      return;
    this._watch = subprocess({
      cmd: this.watchExec,
      out: (out) => this.set(this.watchTransform(out, this.get())),
      err: (err) => this.variable.emit("error", err)
    });
  }
  stopPoll() {
    this._poll?.cancel();
    delete this._poll;
  }
  stopWatch() {
    this._watch?.kill();
    delete this._watch;
  }
  isPolling() {
    return !!this._poll;
  }
  isWatching() {
    return !!this._watch;
  }
  drop() {
    this.variable.emit("dropped");
  }
  onDropped(callback) {
    this.variable.connect("dropped", callback);
    return this;
  }
  onError(callback) {
    delete this.errHandler;
    this.variable.connect("error", (_, err) => callback(err));
    return this;
  }
  subscribe(callback) {
    const id = this.variable.connect("changed", () => {
      callback(this.get());
    });
    return () => this.variable.disconnect(id);
  }
  poll(interval2, exec2, transform = (out) => out) {
    this.stopPoll();
    this.pollInterval = interval2;
    this.pollTransform = transform;
    if (typeof exec2 === "function") {
      this.pollFn = exec2;
      delete this.pollExec;
    } else {
      this.pollExec = exec2;
      delete this.pollFn;
    }
    this.startPoll();
    return this;
  }
  watch(exec2, transform = (out) => out) {
    this.stopWatch();
    this.watchExec = exec2;
    this.watchTransform = transform;
    this.startWatch();
    return this;
  }
  observe(objs, sigOrFn, callback) {
    const f = typeof sigOrFn === "function" ? sigOrFn : callback ?? (() => this.get());
    const set = (obj, ...args) => this.set(f(obj, ...args));
    if (Array.isArray(objs)) {
      for (const obj of objs) {
        const [o, s] = obj;
        const id = o.connect(s, set);
        this.onDropped(() => o.disconnect(id));
      }
    } else {
      if (typeof sigOrFn === "string") {
        const id = objs.connect(sigOrFn, set);
        this.onDropped(() => objs.disconnect(id));
      }
    }
    return this;
  }
  static derive(deps, fn = (...args) => args) {
    const update = () => fn(...deps.map((d) => d.get()));
    const derived = new Variable(update());
    const unsubs = deps.map((dep) => dep.subscribe(() => derived.set(update())));
    derived.onDropped(() => unsubs.map((unsub) => unsub()));
    return derived;
  }
};
var Variable = new Proxy(VariableWrapper, {
  apply: (_t, _a, args) => new VariableWrapper(args[0])
});
var { derive } = Variable;
var variable_default = Variable;

// ../../../../usr/share/astal/gjs/_astal.ts
var noImplicitDestroy = Symbol("no no implicit destroy");
var setChildren = Symbol("children setter method");
function mergeBindings(array) {
  function getValues(...args) {
    let i = 0;
    return array.map(
      (value) => value instanceof binding_default ? args[i++] : value
    );
  }
  const bindings = array.filter((i) => i instanceof binding_default);
  if (bindings.length === 0)
    return array;
  if (bindings.length === 1)
    return bindings[0].as(getValues);
  return variable_default.derive(bindings, getValues)();
}
function setProp(obj, prop, value) {
  try {
    const setter = `set_${snakeify(prop)}`;
    if (typeof obj[setter] === "function")
      return obj[setter](value);
    return obj[prop] = value;
  } catch (error) {
    console.error(`could not set property "${prop}" on ${obj}:`, error);
  }
}
function hook(widget, object, signalOrCallback, callback) {
  if (typeof object.connect === "function" && callback) {
    const id = object.connect(signalOrCallback, (_, ...args) => {
      return callback(widget, ...args);
    });
    widget.connect("destroy", () => {
      object.disconnect(id);
    });
  } else if (typeof object.subscribe === "function" && typeof signalOrCallback === "function") {
    const unsub = object.subscribe((...args) => {
      signalOrCallback(widget, ...args);
    });
    widget.connect("destroy", unsub);
  }
}
function construct(widget, config) {
  let { setup, child, children = [], ...props } = config;
  if (children instanceof binding_default) {
    children = [children];
  }
  if (child) {
    children.unshift(child);
  }
  for (const [key, value] of Object.entries(props)) {
    if (value === void 0) {
      delete props[key];
    }
  }
  const bindings = Object.keys(props).reduce((acc, prop) => {
    if (props[prop] instanceof binding_default) {
      const binding = props[prop];
      delete props[prop];
      return [...acc, [prop, binding]];
    }
    return acc;
  }, []);
  const onHandlers = Object.keys(props).reduce((acc, key) => {
    if (key.startsWith("on")) {
      const sig = kebabify(key).split("-").slice(1).join("-");
      const handler = props[key];
      delete props[key];
      return [...acc, [sig, handler]];
    }
    return acc;
  }, []);
  const mergedChildren = mergeBindings(children.flat(Infinity));
  if (mergedChildren instanceof binding_default) {
    widget[setChildren](mergedChildren.get());
    widget.connect("destroy", mergedChildren.subscribe((v) => {
      widget[setChildren](v);
    }));
  } else {
    if (mergedChildren.length > 0) {
      widget[setChildren](mergedChildren);
    }
  }
  for (const [signal, callback] of onHandlers) {
    const sig = signal.startsWith("notify") ? signal.replace("-", "::") : signal;
    if (typeof callback === "function") {
      widget.connect(sig, callback);
    } else {
      widget.connect(sig, () => execAsync(callback).then(print).catch(console.error));
    }
  }
  for (const [prop, binding] of bindings) {
    if (prop === "child" || prop === "children") {
      widget.connect("destroy", binding.subscribe((v) => {
        widget[setChildren](v);
      }));
    }
    widget.connect("destroy", binding.subscribe((v) => {
      setProp(widget, prop, v);
    }));
    setProp(widget, prop, binding.get());
  }
  for (const [key, value] of Object.entries(props)) {
    if (value === void 0) {
      delete props[key];
    }
  }
  Object.assign(widget, props);
  setup?.(widget);
  return widget;
}
function isArrowFunction(func) {
  return !Object.hasOwn(func, "prototype");
}
function jsx(ctors2, ctor, { children, ...props }) {
  children ??= [];
  if (!Array.isArray(children))
    children = [children];
  children = children.filter(Boolean);
  if (children.length === 1)
    props.child = children[0];
  else if (children.length > 1)
    props.children = children;
  if (typeof ctor === "string") {
    if (isArrowFunction(ctors2[ctor]))
      return ctors2[ctor](props);
    return new ctors2[ctor](props);
  }
  if (isArrowFunction(ctor))
    return ctor(props);
  return new ctor(props);
}

// ../../../../usr/share/astal/gjs/gtk3/astalify.ts
import Astal4 from "gi://Astal?version=3.0";
import Gtk from "gi://Gtk?version=3.0";
import GObject from "gi://GObject";
function astalify(cls, clsName = cls.name) {
  class Widget extends cls {
    get css() {
      return Astal4.widget_get_css(this);
    }
    set css(css) {
      Astal4.widget_set_css(this, css);
    }
    get_css() {
      return this.css;
    }
    set_css(css) {
      this.css = css;
    }
    get className() {
      return Astal4.widget_get_class_names(this).join(" ");
    }
    set className(className) {
      Astal4.widget_set_class_names(this, className.split(/\s+/));
    }
    get_class_name() {
      return this.className;
    }
    set_class_name(className) {
      this.className = className;
    }
    get cursor() {
      return Astal4.widget_get_cursor(this);
    }
    set cursor(cursor) {
      Astal4.widget_set_cursor(this, cursor);
    }
    get_cursor() {
      return this.cursor;
    }
    set_cursor(cursor) {
      this.cursor = cursor;
    }
    get clickThrough() {
      return Astal4.widget_get_click_through(this);
    }
    set clickThrough(clickThrough) {
      Astal4.widget_set_click_through(this, clickThrough);
    }
    get_click_through() {
      return this.clickThrough;
    }
    set_click_through(clickThrough) {
      this.clickThrough = clickThrough;
    }
    get noImplicitDestroy() {
      return this[noImplicitDestroy];
    }
    set noImplicitDestroy(value) {
      this[noImplicitDestroy] = value;
    }
    set actionGroup([prefix, group]) {
      this.insert_action_group(prefix, group);
    }
    set_action_group(actionGroup) {
      this.actionGroup = actionGroup;
    }
    getChildren() {
      if (this instanceof Gtk.Bin) {
        return this.get_child() ? [this.get_child()] : [];
      } else if (this instanceof Gtk.Container) {
        return this.get_children();
      }
      return [];
    }
    setChildren(children) {
      children = children.flat(Infinity).map((ch) => ch instanceof Gtk.Widget ? ch : new Gtk.Label({ visible: true, label: String(ch) }));
      if (this instanceof Gtk.Container) {
        for (const ch of children)
          this.add(ch);
      } else {
        throw Error(`can not add children to ${this.constructor.name}`);
      }
    }
    [setChildren](children) {
      if (this instanceof Gtk.Container) {
        for (const ch of this.getChildren()) {
          this.remove(ch);
          if (!children.includes(ch) && !this.noImplicitDestroy)
            ch?.destroy();
        }
      }
      this.setChildren(children);
    }
    toggleClassName(cn, cond = true) {
      Astal4.widget_toggle_class_name(this, cn, cond);
    }
    hook(object, signalOrCallback, callback) {
      hook(this, object, signalOrCallback, callback);
      return this;
    }
    constructor(...params) {
      super();
      const props = params[0] || {};
      props.visible ??= true;
      construct(this, props);
    }
  }
  GObject.registerClass({
    GTypeName: `Astal_${clsName}`,
    Properties: {
      "class-name": GObject.ParamSpec.string(
        "class-name",
        "",
        "",
        GObject.ParamFlags.READWRITE,
        ""
      ),
      "css": GObject.ParamSpec.string(
        "css",
        "",
        "",
        GObject.ParamFlags.READWRITE,
        ""
      ),
      "cursor": GObject.ParamSpec.string(
        "cursor",
        "",
        "",
        GObject.ParamFlags.READWRITE,
        "default"
      ),
      "click-through": GObject.ParamSpec.boolean(
        "click-through",
        "",
        "",
        GObject.ParamFlags.READWRITE,
        false
      ),
      "no-implicit-destroy": GObject.ParamSpec.boolean(
        "no-implicit-destroy",
        "",
        "",
        GObject.ParamFlags.READWRITE,
        false
      )
    }
  }, Widget);
  return Widget;
}

// ../../../../usr/share/astal/gjs/gtk3/app.ts
import Gtk2 from "gi://Gtk?version=3.0";
import Astal5 from "gi://Astal?version=3.0";

// ../../../../usr/share/astal/gjs/overrides.ts
var snakeify2 = (str) => str.replace(/([a-z])([A-Z])/g, "$1_$2").replaceAll("-", "_").toLowerCase();
async function suppress(mod, patch2) {
  return mod.then((m) => patch2(m.default)).catch(() => void 0);
}
function patch(proto, prop) {
  Object.defineProperty(proto, prop, {
    get() {
      return this[`get_${snakeify2(prop)}`]();
    }
  });
}
await suppress(import("gi://AstalApps"), ({ Apps: Apps2, Application }) => {
  patch(Apps2.prototype, "list");
  patch(Application.prototype, "keywords");
  patch(Application.prototype, "categories");
});
await suppress(import("gi://AstalBattery"), ({ UPower }) => {
  patch(UPower.prototype, "devices");
});
await suppress(import("gi://AstalBluetooth"), ({ Adapter, Bluetooth: Bluetooth3, Device }) => {
  patch(Adapter.prototype, "uuids");
  patch(Bluetooth3.prototype, "adapters");
  patch(Bluetooth3.prototype, "devices");
  patch(Device.prototype, "uuids");
});
await suppress(import("gi://AstalHyprland"), ({ Hyprland: Hyprland2, Monitor, Workspace }) => {
  patch(Hyprland2.prototype, "binds");
  patch(Hyprland2.prototype, "monitors");
  patch(Hyprland2.prototype, "workspaces");
  patch(Hyprland2.prototype, "clients");
  patch(Monitor.prototype, "availableModes");
  patch(Monitor.prototype, "available_modes");
  patch(Workspace.prototype, "clients");
});
await suppress(import("gi://AstalMpris"), ({ Mpris: Mpris4, Player }) => {
  patch(Mpris4.prototype, "players");
  patch(Player.prototype, "supported_uri_schemes");
  patch(Player.prototype, "supportedUriSchemes");
  patch(Player.prototype, "supported_mime_types");
  patch(Player.prototype, "supportedMimeTypes");
  patch(Player.prototype, "comments");
});
await suppress(import("gi://AstalNetwork"), ({ Wifi }) => {
  patch(Wifi.prototype, "access_points");
  patch(Wifi.prototype, "accessPoints");
});
await suppress(import("gi://AstalNotifd"), ({ Notifd: Notifd4, Notification: Notification2 }) => {
  patch(Notifd4.prototype, "notifications");
  patch(Notification2.prototype, "actions");
});
await suppress(import("gi://AstalPowerProfiles"), ({ PowerProfiles }) => {
  patch(PowerProfiles.prototype, "actions");
});
await suppress(import("gi://AstalWp"), ({ Wp: Wp2, Audio, Video }) => {
  patch(Wp2.prototype, "endpoints");
  patch(Wp2.prototype, "devices");
  patch(Audio.prototype, "streams");
  patch(Audio.prototype, "recorders");
  patch(Audio.prototype, "microphones");
  patch(Audio.prototype, "speakers");
  patch(Audio.prototype, "devices");
  patch(Video.prototype, "streams");
  patch(Video.prototype, "recorders");
  patch(Video.prototype, "sinks");
  patch(Video.prototype, "sources");
  patch(Video.prototype, "devices");
});

// ../../../../usr/share/astal/gjs/_app.ts
import { setConsoleLogDomain } from "console";
import { exit, programArgs } from "system";
import IO from "gi://AstalIO";
import GObject2 from "gi://GObject";
function mkApp(App) {
  return new class AstalJS extends App {
    static {
      GObject2.registerClass({ GTypeName: "AstalJS" }, this);
    }
    eval(body) {
      return new Promise((res, rej) => {
        try {
          const fn = Function(`return (async function() {
                        ${body.includes(";") ? body : `return ${body};`}
                    })`);
          fn()().then(res).catch(rej);
        } catch (error) {
          rej(error);
        }
      });
    }
    requestHandler;
    vfunc_request(msg, conn) {
      if (typeof this.requestHandler === "function") {
        this.requestHandler(msg, (response) => {
          IO.write_sock(
            conn,
            String(response),
            (_, res) => IO.write_sock_finish(res)
          );
        });
      } else {
        super.vfunc_request(msg, conn);
      }
    }
    apply_css(style, reset = false) {
      super.apply_css(style, reset);
    }
    quit(code) {
      super.quit();
      exit(code ?? 0);
    }
    start({ requestHandler: requestHandler2, css, hold, main, client, icons, ...cfg } = {}) {
      const app = this;
      client ??= () => {
        print(`Astal instance "${app.instanceName}" already running`);
        exit(1);
      };
      Object.assign(this, cfg);
      setConsoleLogDomain(app.instanceName);
      this.requestHandler = requestHandler2;
      app.connect("activate", () => {
        main?.(...programArgs);
      });
      try {
        app.acquire_socket();
      } catch (error) {
        return client((msg) => IO.send_request(app.instanceName, msg), ...programArgs);
      }
      if (css)
        this.apply_css(css, false);
      if (icons)
        app.add_icons(icons);
      hold ??= true;
      if (hold)
        app.hold();
      app.runAsync([]);
    }
  }();
}

// ../../../../usr/share/astal/gjs/gtk3/app.ts
Gtk2.init(null);
var app_default = mkApp(Astal5.Application);

// ../../../../usr/share/astal/gjs/gtk3/widget.ts
import Astal6 from "gi://Astal?version=3.0";
import Gtk3 from "gi://Gtk?version=3.0";
import GObject3 from "gi://GObject";
function filter(children) {
  return children.flat(Infinity).map((ch) => ch instanceof Gtk3.Widget ? ch : new Gtk3.Label({ visible: true, label: String(ch) }));
}
Object.defineProperty(Astal6.Box.prototype, "children", {
  get() {
    return this.get_children();
  },
  set(v) {
    this.set_children(v);
  }
});
var Box = class extends astalify(Astal6.Box) {
  static {
    GObject3.registerClass({ GTypeName: "Box" }, this);
  }
  constructor(props, ...children) {
    super({ children, ...props });
  }
  setChildren(children) {
    this.set_children(filter(children));
  }
};
var Button = class extends astalify(Astal6.Button) {
  static {
    GObject3.registerClass({ GTypeName: "Button" }, this);
  }
  constructor(props, child) {
    super({ child, ...props });
  }
};
var CenterBox = class extends astalify(Astal6.CenterBox) {
  static {
    GObject3.registerClass({ GTypeName: "CenterBox" }, this);
  }
  constructor(props, ...children) {
    super({ children, ...props });
  }
  setChildren(children) {
    const ch = filter(children);
    this.startWidget = ch[0] || new Gtk3.Box();
    this.centerWidget = ch[1] || new Gtk3.Box();
    this.endWidget = ch[2] || new Gtk3.Box();
  }
};
var CircularProgress = class extends astalify(Astal6.CircularProgress) {
  static {
    GObject3.registerClass({ GTypeName: "CircularProgress" }, this);
  }
  constructor(props, child) {
    super({ child, ...props });
  }
};
var DrawingArea = class extends astalify(Gtk3.DrawingArea) {
  static {
    GObject3.registerClass({ GTypeName: "DrawingArea" }, this);
  }
  constructor(props) {
    super(props);
  }
};
var Entry = class extends astalify(Gtk3.Entry) {
  static {
    GObject3.registerClass({ GTypeName: "Entry" }, this);
  }
  constructor(props) {
    super(props);
  }
};
var EventBox = class extends astalify(Astal6.EventBox) {
  static {
    GObject3.registerClass({ GTypeName: "EventBox" }, this);
  }
  constructor(props, child) {
    super({ child, ...props });
  }
};
var Icon = class extends astalify(Astal6.Icon) {
  static {
    GObject3.registerClass({ GTypeName: "Icon" }, this);
  }
  constructor(props) {
    super(props);
  }
};
var Label = class extends astalify(Astal6.Label) {
  static {
    GObject3.registerClass({ GTypeName: "Label" }, this);
  }
  constructor(props) {
    super(props);
  }
  setChildren(children) {
    this.label = String(children);
  }
};
var LevelBar = class extends astalify(Astal6.LevelBar) {
  static {
    GObject3.registerClass({ GTypeName: "LevelBar" }, this);
  }
  constructor(props) {
    super(props);
  }
};
var MenuButton = class extends astalify(Gtk3.MenuButton) {
  static {
    GObject3.registerClass({ GTypeName: "MenuButton" }, this);
  }
  constructor(props, child) {
    super({ child, ...props });
  }
};
Object.defineProperty(Astal6.Overlay.prototype, "overlays", {
  get() {
    return this.get_overlays();
  },
  set(v) {
    this.set_overlays(v);
  }
});
var Overlay = class extends astalify(Astal6.Overlay) {
  static {
    GObject3.registerClass({ GTypeName: "Overlay" }, this);
  }
  constructor(props, ...children) {
    super({ children, ...props });
  }
  setChildren(children) {
    const [child, ...overlays] = filter(children);
    this.set_child(child);
    this.set_overlays(overlays);
  }
};
var Revealer = class extends astalify(Gtk3.Revealer) {
  static {
    GObject3.registerClass({ GTypeName: "Revealer" }, this);
  }
  constructor(props, child) {
    super({ child, ...props });
  }
};
var Scrollable = class extends astalify(Astal6.Scrollable) {
  static {
    GObject3.registerClass({ GTypeName: "Scrollable" }, this);
  }
  constructor(props, child) {
    super({ child, ...props });
  }
};
var Slider = class extends astalify(Astal6.Slider) {
  static {
    GObject3.registerClass({ GTypeName: "Slider" }, this);
  }
  constructor(props) {
    super(props);
  }
};
var Stack = class extends astalify(Astal6.Stack) {
  static {
    GObject3.registerClass({ GTypeName: "Stack" }, this);
  }
  constructor(props, ...children) {
    super({ children, ...props });
  }
  setChildren(children) {
    this.set_children(filter(children));
  }
};
var Switch = class extends astalify(Gtk3.Switch) {
  static {
    GObject3.registerClass({ GTypeName: "Switch" }, this);
  }
  constructor(props) {
    super(props);
  }
};
var Window = class extends astalify(Astal6.Window) {
  static {
    GObject3.registerClass({ GTypeName: "Window" }, this);
  }
  constructor(props, child) {
    super({ child, ...props });
  }
};

// ../../../../usr/share/astal/gjs/index.ts
import { default as default3 } from "gi://AstalIO?version=0.1";

// ../../../../usr/share/astal/gjs/file.ts
import Astal8 from "gi://AstalIO";
import Gio from "gi://Gio?version=2.0";
function readFileAsync(path) {
  return new Promise((resolve, reject) => {
    Astal8.read_file_async(path, (_, res) => {
      try {
        resolve(Astal8.read_file_finish(res) || "");
      } catch (error) {
        reject(error);
      }
    });
  });
}
function monitorFile(path, callback) {
  return Astal8.monitor_file(path, (file, event) => {
    callback(file, event);
  });
}

// ../../../../usr/share/astal/gjs/gobject.ts
import GObject4 from "gi://GObject";
import { default as default2 } from "gi://GLib?version=2.0";
var meta = Symbol("meta");
var priv = Symbol("priv");
var { ParamSpec, ParamFlags } = GObject4;
var kebabify2 = (str) => str.replace(/([a-z])([A-Z])/g, "$1-$2").replaceAll("_", "-").toLowerCase();
function register(options = {}) {
  return function(cls) {
    const t = options.Template;
    if (typeof t === "string" && !t.startsWith("resource://") && !t.startsWith("file://")) {
      options.Template = new TextEncoder().encode(t);
    }
    GObject4.registerClass({
      Signals: { ...cls[meta]?.Signals },
      Properties: { ...cls[meta]?.Properties },
      ...options
    }, cls);
    delete cls[meta];
  };
}
function property(declaration = Object) {
  return function(target, prop, desc) {
    target.constructor[meta] ??= {};
    target.constructor[meta].Properties ??= {};
    const name = kebabify2(prop);
    if (!desc) {
      Object.defineProperty(target, prop, {
        get() {
          return this[priv]?.[prop] ?? defaultValue(declaration);
        },
        set(v) {
          if (v !== this[prop]) {
            this[priv] ??= {};
            this[priv][prop] = v;
            this.notify(name);
          }
        }
      });
      Object.defineProperty(target, `set_${name.replace("-", "_")}`, {
        value(v) {
          this[prop] = v;
        }
      });
      Object.defineProperty(target, `get_${name.replace("-", "_")}`, {
        value() {
          return this[prop];
        }
      });
      target.constructor[meta].Properties[kebabify2(prop)] = pspec(name, ParamFlags.READWRITE, declaration);
    } else {
      let flags = 0;
      if (desc.get) flags |= ParamFlags.READABLE;
      if (desc.set) flags |= ParamFlags.WRITABLE;
      target.constructor[meta].Properties[kebabify2(prop)] = pspec(name, flags, declaration);
    }
  };
}
function pspec(name, flags, declaration) {
  if (declaration instanceof ParamSpec)
    return declaration;
  switch (declaration) {
    case String:
      return ParamSpec.string(name, "", "", flags, "");
    case Number:
      return ParamSpec.double(name, "", "", flags, -Number.MAX_VALUE, Number.MAX_VALUE, 0);
    case Boolean:
      return ParamSpec.boolean(name, "", "", flags, false);
    case Object:
      return ParamSpec.jsobject(name, "", "", flags);
    default:
      return ParamSpec.object(name, "", "", flags, declaration.$gtype);
  }
}
function defaultValue(declaration) {
  if (declaration instanceof ParamSpec)
    return declaration.get_default_value();
  switch (declaration) {
    case String:
      return "";
    case Number:
      return 0;
    case Boolean:
      return false;
    case Object:
    default:
      return null;
  }
}

// common/cssHotReload.ts
var TMP = "/tmp";
function compileScss() {
  try {
    exec(`sass ${"/home/broa/.config/ags"}/style.scss ${TMP}/style.css`);
    app_default.apply_css("/tmp/style.css");
    return `${TMP}/style.scss`;
  } catch (err) {
    printerr("Error compiling scss files.", err);
    return "";
  }
}
(function() {
  const scssFiles = exec(`find -L ${"/home/broa/.config/ags"} -iname '*.scss'`).split("\n");
  compileScss();
  scssFiles.forEach(
    (file) => monitorFile(file, compileScss)
  );
})();

// common/vars.ts
import Mpris from "gi://AstalMpris";
var showBar = Variable(true);
var showLeftSidebar = Variable(false);
var showRightSidebar = Variable(false);
var showCrosshair = Variable(false);
var showLauncher = Variable(false);
var doNotDisturb = Variable(false);
var nightLightEnabled = Variable(false);
var notificationsLength = Variable(0);
var sidebarPanel = Variable("main");
var spotifyPlayer = Mpris.Player.new("spotify");
execAsync("pgrep -x hyprsunset").then(() => nightLightEnabled.set(true)).catch(() => nightLightEnabled.set(false));
var currentTime = Variable("").poll(1e3, () => default2.DateTime.new_now_local().format("%H:%M"));
var currentDay = Variable("").poll(1e3, () => default2.DateTime.new_now_local().format("^%A, %d de ^%B"));
var uptime = Variable("").poll(5 * 60 * 1e3, async () => {
  const output = await execAsync("uptime -p");
  return output.replace(/ minutes| minute/, "m").replace(/ hours| hour/, "h").replace(/ days| day/, "d").replace(/ weeks| week/, "w");
});
var memoryUsage = Variable("").poll(5 * 1e3, async () => {
  const output = await execAsync(["sh", "-c", `free --mega | awk 'NR==2{print $3 " MB"}'`]);
  return output;
});
var weatherReport = Variable(null).poll(20 * 60 * 1e3, async () => {
  try {
    const result = await execAsync(`curl -s "wttr.in/Curitiba?format=j1"`);
    const weather = JSON.parse(result);
    const timestamp = currentTime.get();
    return { timestamp, weather };
  } catch (err) {
    console.error("Error fetching weather:", err);
    return null;
  }
});

// windows/bar/Bar.tsx
import Battery from "gi://AstalBattery";
import Bluetooth from "gi://AstalBluetooth";
import Hyprland from "gi://AstalHyprland";
import Mpris2 from "gi://AstalMpris";
import Network from "gi://AstalNetwork";
import Tray from "gi://AstalTray";

// ../../../../usr/share/astal/gjs/gtk3/jsx-runtime.ts
function jsx2(ctor, props) {
  return jsx(ctors, ctor, props);
}
var ctors = {
  box: Box,
  button: Button,
  centerbox: CenterBox,
  circularprogress: CircularProgress,
  drawingarea: DrawingArea,
  entry: Entry,
  eventbox: EventBox,
  // TODO: fixed
  // TODO: flowbox
  icon: Icon,
  label: Label,
  levelbar: LevelBar,
  // TODO: listbox
  menubutton: MenuButton,
  overlay: Overlay,
  revealer: Revealer,
  scrollable: Scrollable,
  slider: Slider,
  stack: Stack,
  switch: Switch,
  window: Window
};
var jsxs = jsx2;

// widgets/Time/Time.tsx
function DigitStack(index) {
  return /* @__PURE__ */ jsx2(
    "stack",
    {
      transitionType: Gtk4.StackTransitionType.SLIDE_DOWN,
      transitionDuration: 500,
      visibleChildName: bind(currentTime).as((time) => time?.[index] ?? "0"),
      className: "DigitStack",
      children: Array.from({ length: 10 }, (_, i) => /* @__PURE__ */ jsx2("label", { name: i.toString(), label: i.toString() }))
    }
  );
}
function Time2() {
  return /* @__PURE__ */ jsxs(
    "box",
    {
      className: "Time",
      halign: Gtk4.Align.CENTER,
      valign: Gtk4.Align.CENTER,
      children: [
        DigitStack(0),
        DigitStack(1),
        /* @__PURE__ */ jsx2("label", { label: ":", css: "font-family: 'JetBrainsMono Nerd Font'" }),
        DigitStack(3),
        DigitStack(4)
      ]
    }
  );
}

// common/functions.ts
var isIcon = (icon) => !!Astal7.Icon.lookup_icon(icon);
function getWeatherEmoji(desc) {
  desc = desc.toLowerCase();
  if (desc.includes("sunny") || desc.includes("clear")) return "\u2600\uFE0F";
  if (desc.includes("partly")) return "\u26C5";
  if (desc.includes("cloudy") || desc.includes("overcast")) return "\u2601\uFE0F";
  if (desc.includes("rain") || desc.includes("drizzle")) return "\u{1F327}\uFE0F";
  if (desc.includes("thunder")) return "\u26C8\uFE0F";
  if (desc.includes("snow")) return "\u2744\uFE0F";
  if (desc.includes("fog") || desc.includes("mist")) return "\u{1F32B}\uFE0F";
  return "\u{1F308}";
}
function getWeatherImage(desc) {
  desc = desc.toLowerCase();
  if (desc.includes("sunny") || desc.includes("clear")) return "clear.png";
  if (desc.includes("partly")) return "partly_cloudy.png";
  if (desc.includes("cloudy") || desc.includes("overcast")) return "cloudy.png";
  if (desc.includes("light")) return "light_rain.png";
  if (desc.includes("rain") || desc.includes("drizzle")) return "rain.png";
  if (desc.includes("thunder")) return "storm.png";
  if (desc.includes("fog") || desc.includes("mist")) return "fog.png";
  return "other.png";
}
function getWifiIcon(icon) {
  if (icon.includes("offline")) return "\u{F092E}";
  if (icon.includes("no-route")) return "\u{F092D}";
  if (icon.includes("connected")) return "\u{F092B}";
  if (icon.includes("signal-none")) return "\u{F092F}";
  if (icon.includes("signal-weak")) return "\u{F091F}";
  if (icon.includes("signal-ok")) return "\u{F0922}";
  if (icon.includes("signal-good")) return "\u{F0925}";
  if (icon.includes("encrypted")) return "\u{F092A}";
  return "\u{F0928}";
}

// windows/bar/Bar.tsx
function SysTray() {
  const tray = Tray.get_default();
  return /* @__PURE__ */ jsx2("box", { className: "SysTray", children: bind(tray, "items").as((items) => items.map((item) => /* @__PURE__ */ jsx2(
    "menubutton",
    {
      tooltipMarkup: bind(item, "tooltipMarkup"),
      usePopover: false,
      actionGroup: bind(item, "actionGroup").as((ag) => ["dbusmenu", ag]),
      menuModel: bind(item, "menuModel"),
      children: /* @__PURE__ */ jsx2("icon", { gicon: bind(item, "gicon") })
    }
  ))) });
}
function NetworkModule() {
  const network = Network.get_default();
  const networkTypes = { "1": "wired", "2": "wifi" };
  return bind(network, "primary").as((p) => {
    const dev = network[networkTypes[p]];
    if (dev) {
      return /* @__PURE__ */ jsx2(
        "icon",
        {
          className: "Network",
          icon: bind(dev, "iconName")
        }
      );
    }
    return /* @__PURE__ */ jsx2("box", {});
  });
}
function BluetoothModule() {
  const bluetooth = Bluetooth.get_default();
  return /* @__PURE__ */ jsx2(
    "revealer",
    {
      transitionType: Gtk4.RevealerTransitionType.SLIDE_LEFT,
      revealChild: bind(bluetooth, "is_connected"),
      children: /* @__PURE__ */ jsx2("label", { className: "Bluetooth", label: "\u{F00B1}" })
    }
  );
}
function BatteryLevel() {
  const bat = Battery.get_default();
  return /* @__PURE__ */ jsxs(
    "box",
    {
      className: "Battery",
      visible: bind(bat, "isPresent"),
      children: [
        /* @__PURE__ */ jsx2("label", { label: bind(bat, "percentage").as((p) => `${Math.floor(p * 100)}%`) }),
        /* @__PURE__ */ jsx2("icon", { icon: bind(bat, "batteryIconName") })
      ]
    }
  );
}
function getTitle(player) {
  return player.artist ? `${player.artist}: ${player.title}` : player.album ? `${player.album}: ${player.title}` : `${player.title}`;
}
function Media() {
  const mpris = Mpris2.get_default();
  return bind(mpris, "players").as((ps) => ps[0] ? /* @__PURE__ */ jsx2(
    "button",
    {
      className: "Media",
      onClick: () => ps[0].play_pause(),
      children: /* @__PURE__ */ jsx2(
        "label",
        {
          className: bind(ps[0], "playbackStatus").as((s) => s > 0 ? "paused" : "playing"),
          truncate: true,
          maxWidthChars: 80,
          label: bind(ps[0], "metadata").as(() => getTitle(ps[0]))
        }
      )
    }
  ) : /* @__PURE__ */ jsx2("box", {}));
}
function Workspaces() {
  const hypr = Hyprland.get_default();
  return /* @__PURE__ */ jsx2("box", { className: "Workspaces", children: bind(hypr, "workspaces").as(
    (wss) => wss.filter((ws) => !(ws.id >= -99 && ws.id <= -2)).sort((a, b) => a.id - b.id).map((ws) => /* @__PURE__ */ jsx2(
      "button",
      {
        className: bind(hypr, "focusedWorkspace").as((fw) => ws === fw ? "focused" : ""),
        onClicked: () => ws.focus(),
        children: ws.id
      }
    ))
  ) });
}
function Weather() {
  const visible = Variable(false);
  return /* @__PURE__ */ jsx2(
    "revealer",
    {
      transitionType: Gtk4.RevealerTransitionType.SLIDE_RIGHT,
      revealChild: visible(),
      children: bind(weatherReport).as((data) => {
        if (data) {
          const condition = data.weather.current_condition[0];
          const temp = condition.temp_C;
          const emoji = getWeatherEmoji(condition.weatherDesc[0].value);
          visible.set(true);
          return /* @__PURE__ */ jsx2("label", { className: "Weather", label: `${temp}\xB0C ${emoji}` });
        }
        return /* @__PURE__ */ jsx2("box", {});
      })
    }
  );
}
function NotificationBell() {
  return /* @__PURE__ */ jsx2(
    "revealer",
    {
      transitionType: Gtk4.RevealerTransitionType.SLIDE_LEFT,
      revealChild: bind(notificationsLength).as((l) => l > 1),
      children: /* @__PURE__ */ jsx2("label", { className: "NotificationBell", label: "\u{F116B}" })
    }
  );
}
function Memory() {
  return /* @__PURE__ */ jsx2(
    "label",
    {
      className: "Memory",
      onDestroy: () => memoryUsage.drop(),
      label: memoryUsage()
    }
  );
}
function Bar(monitor, visible) {
  const { TOP, LEFT, RIGHT } = Astal7.WindowAnchor;
  return /* @__PURE__ */ jsx2(
    "window",
    {
      className: "Bar",
      namespace: "bar",
      gdkmonitor: monitor,
      exclusivity: Astal7.Exclusivity.EXCLUSIVE,
      application: app_default,
      visible: visible(),
      layer: Astal7.Layer.TOP,
      anchor: TOP | LEFT | RIGHT,
      children: /* @__PURE__ */ jsxs("centerbox", { children: [
        /* @__PURE__ */ jsxs(
          "box",
          {
            hexpand: true,
            halign: Gtk4.Align.START,
            css: "margin-left: 4px",
            children: [
              /* @__PURE__ */ jsx2(
                "button",
                {
                  className: "TimeAndWeather",
                  onClicked: () => showLeftSidebar.set(!showLeftSidebar.get()),
                  children: /* @__PURE__ */ jsxs("box", { children: [
                    /* @__PURE__ */ jsx2(Time2, {}),
                    /* @__PURE__ */ jsx2(Weather, {})
                  ] })
                }
              ),
              /* @__PURE__ */ jsx2(Workspaces, {})
            ]
          }
        ),
        /* @__PURE__ */ jsx2(Media, {}),
        /* @__PURE__ */ jsxs(
          "box",
          {
            hexpand: true,
            halign: Gtk4.Align.END,
            css: "margin-right: 4px",
            children: [
              /* @__PURE__ */ jsx2(SysTray, {}),
              /* @__PURE__ */ jsx2(
                "button",
                {
                  className: "TimeAndWeather",
                  onClicked: () => showRightSidebar.set(!showRightSidebar.get()),
                  children: /* @__PURE__ */ jsxs("box", { children: [
                    /* @__PURE__ */ jsx2(BatteryLevel, {}),
                    /* @__PURE__ */ jsx2(NetworkModule, {}),
                    /* @__PURE__ */ jsx2(BluetoothModule, {}),
                    /* @__PURE__ */ jsx2(NotificationBell, {}),
                    /* @__PURE__ */ jsx2(Memory, {})
                  ] })
                }
              )
            ]
          }
        )
      ] })
    }
  );
}

// windows/crosshair/Crosshair.tsx
function Crosshair(monitor, visible) {
  return /* @__PURE__ */ jsx2(
    "window",
    {
      className: "Crosshair",
      namespace: "crosshair",
      gdkmonitor: monitor,
      visible: visible(),
      layer: Astal7.Layer.OVERLAY,
      application: app_default,
      exclusivity: Astal7.Exclusivity.IGNORE,
      keymode: Astal7.Keymode.NONE,
      canFocus: false,
      acceptFocus: false,
      children: /* @__PURE__ */ jsx2(
        "box",
        {
          className: "Dot"
        }
      )
    }
  );
}

// windows/launcher/Launcher.tsx
import Apps from "gi://AstalApps";
var MAX_ITEMS = 8;
function hide() {
  showLauncher.set(false);
}
function AppButton({ app }) {
  return /* @__PURE__ */ jsx2(
    "button",
    {
      className: "AppButton",
      onClicked: () => {
        hide();
        app.launch();
      },
      children: /* @__PURE__ */ jsxs("box", { children: [
        /* @__PURE__ */ jsx2("icon", { icon: app.iconName || "help-browser" }),
        /* @__PURE__ */ jsxs("box", { valign: Gtk4.Align.CENTER, vertical: true, children: [
          /* @__PURE__ */ jsx2(
            "label",
            {
              className: "name",
              truncate: true,
              xalign: 0,
              label: app.name
            }
          ),
          app.description && /* @__PURE__ */ jsx2(
            "label",
            {
              className: "description",
              wrap: true,
              xalign: 0,
              label: app.description
            }
          )
        ] })
      ] })
    }
  );
}
function Launcher(monitor, visible) {
  const apps = new Apps.Apps();
  const width = Variable(1e3);
  const text = Variable("");
  const list = text((text2) => apps.fuzzy_query(text2).slice(0, MAX_ITEMS));
  const onEnter = () => {
    apps.fuzzy_query(text.get())?.[0].launch();
    hide();
  };
  return /* @__PURE__ */ jsx2(
    "window",
    {
      name: "launcher",
      exclusivity: Astal7.Exclusivity.IGNORE,
      keymode: Astal7.Keymode.ON_DEMAND,
      application: app_default,
      gdkmonitor: monitor,
      visible: visible(),
      onShow: (self) => {
        text.set("");
        width.set(self.get_current_monitor().workarea.width);
      },
      onKeyPressEvent: function(_, event) {
        if (event.get_keyval()[1] === Gdk.KEY_Escape)
          hide();
      },
      children: /* @__PURE__ */ jsxs("box", { children: [
        /* @__PURE__ */ jsx2("eventbox", { widthRequest: width((w) => w / 2), expand: true, onClick: hide }),
        /* @__PURE__ */ jsxs("box", { hexpand: false, vertical: true, children: [
          /* @__PURE__ */ jsx2("eventbox", { heightRequest: 100, onClick: hide }),
          /* @__PURE__ */ jsxs("box", { widthRequest: 500, className: "Applauncher", vertical: true, children: [
            /* @__PURE__ */ jsx2(
              "entry",
              {
                placeholderText: "Search",
                text: text(),
                onChanged: (self) => {
                  if (self.text.startsWith(":e")) print("emoji");
                  return text.set(self.text);
                },
                onActivate: onEnter
              }
            ),
            /* @__PURE__ */ jsx2("box", { spacing: 6, vertical: true, children: list.as((list2) => list2.map((app) => /* @__PURE__ */ jsx2(AppButton, { app }))) }),
            /* @__PURE__ */ jsxs(
              "box",
              {
                halign: Gtk4.Align.CENTER,
                className: "not-found",
                vertical: true,
                visible: list.as((l) => l.length === 0),
                children: [
                  /* @__PURE__ */ jsx2("icon", { icon: "system-search-symbolic" }),
                  /* @__PURE__ */ jsx2("label", { label: "No match found" })
                ]
              }
            )
          ] }),
          /* @__PURE__ */ jsx2("eventbox", { expand: true, onClick: hide })
        ] }),
        /* @__PURE__ */ jsx2("eventbox", { widthRequest: width((w) => w / 2), expand: true, onClick: hide })
      ] })
    }
  );
}

// widgets/Calendar/Calendar.tsx
var Calendar = class extends astalify(Gtk4.Calendar) {
  static {
    GObject4.registerClass(this);
  }
  constructor(props) {
    super(props);
  }
};

// windows/left_sidebar/LeftSidebar.tsx
function TimeAndDate() {
  return /* @__PURE__ */ jsxs(
    "box",
    {
      className: "TimeAndDate",
      vertical: true,
      children: [
        /* @__PURE__ */ jsx2(Time2, {}),
        /* @__PURE__ */ jsx2("label", { className: "Today", label: currentDay().as((day) => day.replace(/\^(\w)(\w*)/g, (_, first, rest) => first.toUpperCase() + rest.toLowerCase())) })
      ]
    }
  );
}
function CalendarModule() {
  return /* @__PURE__ */ jsx2("box", { className: "calendar", vertical: true, children: new Calendar({ hexpand: true, vexpand: true }) });
}
function getUpcomingHours(hourly) {
  const now = /* @__PURE__ */ new Date();
  const currentHour = now.getHours();
  const parsedHourly = hourly.map((h) => ({
    ...h,
    hour: Math.floor(Number(h.time) / 100)
  }));
  const startIdx = parsedHourly.findIndex((h) => h.hour > currentHour);
  const slice = parsedHourly.slice(startIdx, startIdx + 5);
  return slice.length === 5 ? slice : [...slice, ...parsedHourly.slice(0, 5 - slice.length)];
}
function WeatherSidebar() {
  return bind(weatherReport).as((data) => {
    if (!data) return /* @__PURE__ */ jsx2("box", {});
    const current = data.weather.current_condition[0];
    const upcoming = getUpcomingHours(data.weather.weather[0].hourly);
    const image = getWeatherImage(current.weatherDesc[0].value);
    return /* @__PURE__ */ jsxs(
      "box",
      {
        className: "Weather",
        vertical: true,
        children: [
          /* @__PURE__ */ jsx2(
            "box",
            {
              className: "Image",
              css: `background-image: url('${"/home/broa/.config/ags"}/assets/weather/${image}')`,
              children: /* @__PURE__ */ jsxs(
                "box",
                {
                  className: "Current",
                  children: [
                    /* @__PURE__ */ jsxs("box", { vertical: true, halign: Gtk4.Align.START, children: [
                      /* @__PURE__ */ jsx2(
                        "label",
                        {
                          className: "Icon",
                          xalign: 0,
                          yalign: 0,
                          vexpand: true,
                          label: getWeatherEmoji(current.weatherDesc[0].value)
                        }
                      ),
                      /* @__PURE__ */ jsx2(
                        "label",
                        {
                          className: "Description",
                          xalign: 0,
                          label: current.weatherDesc[0].value
                        }
                      )
                    ] }),
                    /* @__PURE__ */ jsx2("box", { hexpand: true }),
                    /* @__PURE__ */ jsxs("box", { vertical: true, halign: Gtk4.Align.END, children: [
                      /* @__PURE__ */ jsxs("box", { vertical: true, children: [
                        /* @__PURE__ */ jsx2(
                          "label",
                          {
                            className: "Temp",
                            xalign: 1,
                            yalign: 0,
                            label: `${current.temp_C}\xB0`
                          }
                        ),
                        /* @__PURE__ */ jsx2(
                          "label",
                          {
                            className: "FeelsLike",
                            xalign: 1,
                            yalign: 0,
                            vexpand: true,
                            label: `Feels like: ${current.FeelsLikeC}\xB0`
                          }
                        )
                      ] }),
                      /* @__PURE__ */ jsxs(
                        "box",
                        {
                          className: "Info",
                          vertical: true,
                          children: [
                            /* @__PURE__ */ jsx2("label", { className: "Wind", xalign: 1, label: `${current.windspeedKmph}km \u{1F4A8}` }),
                            /* @__PURE__ */ jsx2("label", { className: "Humidity", xalign: 1, label: `${current.humidity}% \u{1F4A7}` }),
                            /* @__PURE__ */ jsx2("label", { className: "Precipitation", xalign: 1, label: `${current.precipMM}mm \u2614` })
                          ]
                        }
                      )
                    ] })
                  ]
                }
              )
            }
          ),
          /* @__PURE__ */ jsx2(
            "box",
            {
              className: "HourlyForecast",
              homogeneous: true,
              children: upcoming.map((h) => /* @__PURE__ */ jsxs("box", { orientation: 1, hexpand: true, className: "HourlyItem", spacing: 4, children: [
                /* @__PURE__ */ jsx2("label", { label: `${h.hour.toString().padStart(2, "0")}:00`, className: "Hour" }),
                /* @__PURE__ */ jsx2(
                  "label",
                  {
                    label: getWeatherEmoji(h.weatherDesc[0].value),
                    className: "Icon",
                    tooltipText: `${h.weatherDesc[0].value}, \u2614: ${h.precipMM}mm`
                  }
                ),
                /* @__PURE__ */ jsx2("label", { label: `${h.tempC}\xB0`, className: "SmallTemp" })
              ] }))
            }
          )
        ]
      }
    );
  });
}
function LeftSidebar(monitor, visible) {
  const { LEFT, TOP } = Astal7.WindowAnchor;
  return /* @__PURE__ */ jsx2(
    "window",
    {
      className: "LeftSidebar",
      namespace: "leftsidebar",
      gdkmonitor: monitor,
      exclusivity: Astal7.Exclusivity.EXCLUSIVE,
      application: app_default,
      layer: Astal7.Layer.TOP,
      visible: visible(),
      anchor: TOP | LEFT,
      children: /* @__PURE__ */ jsxs(
        "box",
        {
          hexpand: true,
          vertical: true,
          className: "sidebar",
          children: [
            /* @__PURE__ */ jsx2(TimeAndDate, {}),
            /* @__PURE__ */ jsx2(CalendarModule, {}),
            /* @__PURE__ */ jsx2(WeatherSidebar, {})
          ]
        }
      )
    }
  );
}

// windows/notification_popups/NotificationPopups.tsx
import Notifd2 from "gi://AstalNotifd";

// widgets/Notification/Notification.tsx
import Notifd from "gi://AstalNotifd";
var fileExists = (path) => default2.file_test(path, default2.FileTest.EXISTS);
var formatTime = (time, format = "%H:%M") => default2.DateTime.new_from_unix_local(time).format(format);
var urgency = (n) => {
  const { LOW, NORMAL, CRITICAL } = Notifd.Urgency;
  switch (n.urgency) {
    case LOW:
      return "low";
    case CRITICAL:
      return "critical";
    case NORMAL:
    default:
      return "normal";
  }
};
function Notification(props) {
  const { notification: n, onHoverLost, setup } = props;
  const { START, CENTER, END } = Gtk4.Align;
  return /* @__PURE__ */ jsx2(
    "eventbox",
    {
      hexpand: true,
      className: `Notification ${urgency(n)}`,
      setup,
      onHoverLost,
      children: /* @__PURE__ */ jsxs("box", { vertical: true, children: [
        /* @__PURE__ */ jsxs("box", { className: "header", children: [
          (n.appIcon || n.desktopEntry) && /* @__PURE__ */ jsx2(
            "icon",
            {
              className: "app-icon",
              visible: Boolean(n.appIcon || n.desktopEntry),
              icon: n.appIcon || n.desktopEntry
            }
          ),
          /* @__PURE__ */ jsx2(
            "label",
            {
              className: "app-name",
              halign: START,
              truncate: true,
              label: n.appName || "Unknown"
            }
          ),
          /* @__PURE__ */ jsx2(
            "label",
            {
              className: "time",
              hexpand: true,
              halign: END,
              label: formatTime(n.time)
            }
          ),
          /* @__PURE__ */ jsx2("button", { onClicked: () => n.dismiss(), children: /* @__PURE__ */ jsx2("icon", { icon: "window-close-symbolic" }) })
        ] }),
        /* @__PURE__ */ jsx2(Gtk4.Separator, { visible: true }),
        /* @__PURE__ */ jsxs("box", { className: "content", children: [
          n.image && fileExists(n.image) && /* @__PURE__ */ jsx2(
            "box",
            {
              valign: START,
              className: "image",
              css: `background-image: url('${n.image}')`
            }
          ),
          n.image && isIcon(n.image) && /* @__PURE__ */ jsx2(
            "box",
            {
              expand: false,
              valign: START,
              className: "icon-image",
              children: /* @__PURE__ */ jsx2("icon", { icon: n.image, expand: true, halign: CENTER, valign: CENTER })
            }
          ),
          /* @__PURE__ */ jsxs("box", { vertical: true, children: [
            /* @__PURE__ */ jsx2(
              "label",
              {
                className: "summary",
                halign: START,
                xalign: 0,
                label: n.summary,
                truncate: true
              }
            ),
            n.body && /* @__PURE__ */ jsx2(
              "label",
              {
                className: "body",
                wrap: true,
                useMarkup: false,
                halign: START,
                xalign: 0,
                label: n.body
              }
            )
          ] })
        ] }),
        n.get_actions().length > 0 && /* @__PURE__ */ jsx2("box", { className: "actions", children: n.get_actions().map(({ label, id }) => /* @__PURE__ */ jsx2(
          "button",
          {
            hexpand: true,
            onClicked: () => n.invoke(id),
            children: /* @__PURE__ */ jsx2("label", { label, halign: CENTER, hexpand: true })
          }
        )) })
      ] })
    }
  );
}

// windows/notification_popups/NotificationPopups.tsx
var TIMEOUT_DELAY = 5e3;
var NotifiationMap = class {
  // the underlying map to keep track of id widget pairs
  map = /* @__PURE__ */ new Map();
  // it makes sense to use a Variable under the hood and use its
  // reactivity implementation instead of keeping track of subscribers ourselves
  var = Variable([]);
  // notify subscribers to rerender when state changes
  notifiy() {
    this.var.set([...this.map.values()]);
  }
  constructor() {
    const notifd = Notifd2.get_default();
    notifd.connect("notified", (_, id) => {
      this.set(id, Notification({
        notification: notifd.get_notification(id),
        // once hovering over the notification is done
        // destroy the widget without calling notification.dismiss()
        // so that it acts as a "popup" and we can still display it
        // in a notification center like widget
        // but clicking on the close button will close it
        onHoverLost: () => this.delete(id),
        // notifd by default does not close notifications
        // until user input or the timeout specified by sender
        // which we set to ignore above
        setup: () => timeout(TIMEOUT_DELAY, () => {
          this.delete(id);
        })
      }));
    });
    notifd.connect("resolved", (_, id) => {
      this.delete(id);
    });
  }
  set(key, value) {
    this.map.get(key)?.destroy();
    this.map.set(key, value);
    this.notifiy();
  }
  delete(key) {
    this.map.get(key)?.destroy();
    this.map.delete(key);
    this.notifiy();
  }
  // needed by the Subscribable interface
  get() {
    return this.var.get();
  }
  // needed by the Subscribable interface
  subscribe(callback) {
    return this.var.subscribe(callback);
  }
};
function NotificationPopups(gdkmonitor, visible) {
  const { BOTTOM, RIGHT } = Astal7.WindowAnchor;
  const notifs = new NotifiationMap();
  return /* @__PURE__ */ jsx2(
    "window",
    {
      hexpand: true,
      className: "NotificationPopups",
      namespace: "notification",
      gdkmonitor,
      visible: bind(visible).as((v) => !v),
      exclusivity: Astal7.Exclusivity.IGNORE,
      application: app_default,
      layer: Astal7.Layer.OVERLAY,
      anchor: BOTTOM | RIGHT,
      children: /* @__PURE__ */ jsx2("box", { vertical: true, children: bind(notifs) })
    }
  );
}

// windows/osd/OSD.tsx
import Wp from "gi://AstalWp";

// utils/brightness.ts
var get = (args) => Number(exec(`brightnessctl ${args}`));
var screen = exec(`bash -c "ls -w1 /sys/class/backlight | head -1"`);
var _screenMax, _screen;
var Brightness = class extends GObject4.Object {
  constructor() {
    super();
    __privateAdd(this, _screenMax, get("max"));
    __privateAdd(this, _screen, get("get") / (get("max") || 1));
    monitorFile(`/sys/class/backlight/${screen}/brightness`, async (f) => {
      const v = await readFileAsync(f);
      __privateSet(this, _screen, Number(v) / __privateGet(this, _screenMax));
      this.notify("screen");
    });
  }
  static get_default() {
    if (!this.instance)
      this.instance = new Brightness();
    return this.instance;
  }
  get screen() {
    return __privateGet(this, _screen);
  }
  set screen(percent) {
    if (percent < 0)
      percent = 0;
    if (percent > 1)
      percent = 1;
    execAsync(`brightnessctl set ${Math.floor(percent * 100)}% -q`).then(() => {
      __privateSet(this, _screen, percent);
      this.notify("screen");
    });
  }
};
_screenMax = new WeakMap();
_screen = new WeakMap();
__publicField(Brightness, "instance");
__decorateClass([
  property(Number)
], Brightness.prototype, "screen", 1);
Brightness = __decorateClass([
  register({ GTypeName: "Brightness" })
], Brightness);

// windows/osd/OSD.tsx
function OnScreenProgress({ visible }) {
  const brightness = Brightness.get_default();
  const speaker = Wp.get_default().get_default_speaker();
  const iconName = variable_default("");
  const value = variable_default(0);
  let count = 0;
  function show(v, icon) {
    visible.set(true);
    value.set(v);
    iconName.set(icon);
    count++;
    timeout(2e3, () => {
      count--;
      if (count === 0) visible.set(false);
    });
  }
  return /* @__PURE__ */ jsx2(
    "box",
    {
      setup: (self) => {
        self.hook(
          brightness,
          "notify::screen",
          () => show(brightness.screen, "display-brightness-symbolic")
        );
        if (speaker) {
          self.hook(
            speaker,
            "notify::volume",
            () => show(speaker.volume, speaker.volumeIcon)
          );
        }
        self.hook(
          spotifyPlayer,
          "notify::volume",
          () => show(spotifyPlayer.volume, "spotify")
        );
      },
      children: /* @__PURE__ */ jsxs("box", { vertical: true, className: "OSD", children: [
        /* @__PURE__ */ jsx2("icon", { icon: iconName() }),
        /* @__PURE__ */ jsx2(
          "levelbar",
          {
            valign: Gtk4.Align.CENTER,
            heightRequest: 100,
            widthRequest: 8,
            vertical: true,
            inverted: true,
            value: value()
          }
        ),
        /* @__PURE__ */ jsx2("label", { label: value((v) => `${Math.floor(v * 100)}%`) })
      ] })
    }
  );
}
function OSD(monitor) {
  const visible = variable_default(false);
  return /* @__PURE__ */ jsx2(
    "window",
    {
      gdkmonitor: monitor,
      className: "OSD",
      namespace: "osd",
      application: app_default,
      visible: visible(),
      layer: Astal7.Layer.OVERLAY,
      anchor: Astal7.WindowAnchor.RIGHT,
      children: /* @__PURE__ */ jsx2("eventbox", { onClick: () => visible.set(false), children: /* @__PURE__ */ jsx2(OnScreenProgress, { visible }) })
    }
  );
}

// windows/right_sidebar/RightSidebar.tsx
import Bluetooth2 from "gi://AstalBluetooth";
import Mpris3 from "gi://AstalMpris";
import Network2 from "gi://AstalNetwork";
import Notifd3 from "gi://AstalNotifd";

// widgets/MediaPlayer/MediaPlayer.tsx
function lengthStr(length) {
  const min = Math.floor(length / 60);
  const sec = Math.floor(length % 60);
  const sec0 = sec < 10 ? "0" : "";
  return `${min}:${sec0}${sec}`;
}
function MediaPlayer(player) {
  const showPosition = variable_default(false);
  const coverArt = bind(player, "coverArt").as((c) => `background-image: url('${c}')`);
  const playIcon = bind(player, "playbackStatus").as((s) => s === 0 ? "\u{F03E4}" : "\u{F040A}");
  const position = bind(player, "position").as((p) => player.length > 0 ? p / player.length : 0);
  function ArtistTitle() {
    return /* @__PURE__ */ jsxs("box", { vertical: true, hexpand: true, children: [
      /* @__PURE__ */ jsx2(
        "label",
        {
          className: "Title",
          truncate: true,
          maxWidthChars: 35,
          halign: Gtk4.Align.START,
          valign: Gtk4.Align.START,
          label: bind(player, "metadata").as(() => `${player.title}`)
        }
      ),
      /* @__PURE__ */ jsx2(
        "label",
        {
          className: "Artist",
          vexpand: true,
          halign: Gtk4.Align.START,
          valign: Gtk4.Align.START,
          label: bind(player, "metadata").as(() => {
            if (player.artist) return `${player.artist}`;
            if (player.album) return `${player.album}`;
            return "";
          })
        }
      )
    ] });
  }
  function Position() {
    return /* @__PURE__ */ jsx2(
      "revealer",
      {
        revealChild: bind(showPosition),
        transitionType: Gtk4.RevealerTransitionType.SLIDE_DOWN,
        children: /* @__PURE__ */ jsxs("box", { vertical: true, className: "position", children: [
          /* @__PURE__ */ jsxs("box", { children: [
            /* @__PURE__ */ jsx2(
              "label",
              {
                halign: Gtk4.Align.START,
                visible: bind(player, "length").as((l) => l > 0),
                label: bind(player, "position").as(lengthStr)
              }
            ),
            /* @__PURE__ */ jsx2(
              "label",
              {
                hexpand: true,
                halign: Gtk4.Align.START,
                visible: bind(player, "length").as((l) => l > 0),
                label: bind(player, "length").as((l) => l > 0 ? ` - ${lengthStr(l)}` : " - 0:00")
              }
            )
          ] }),
          /* @__PURE__ */ jsx2(
            "slider",
            {
              visible: bind(player, "length").as((l) => l > 0),
              onDragged: ({ value }) => player.position = value * player.length,
              value: position
            }
          )
        ] })
      }
    );
  }
  function Actions() {
    return /* @__PURE__ */ jsxs(
      "box",
      {
        className: "Actions",
        homogeneous: true,
        vertical: true,
        children: [
          /* @__PURE__ */ jsx2(
            "button",
            {
              label: "\u{F04AE}",
              onClicked: () => player.previous()
            }
          ),
          /* @__PURE__ */ jsx2(
            "button",
            {
              label: playIcon,
              onClick: () => player.play_pause()
            }
          ),
          /* @__PURE__ */ jsx2(
            "button",
            {
              label: "\u{F04AD}",
              onClicked: () => player.next()
            }
          )
        ]
      }
    );
  }
  return /* @__PURE__ */ jsx2(
    "eventbox",
    {
      onHover: () => showPosition.set(true),
      onHoverLost: () => showPosition.set(false),
      children: /* @__PURE__ */ jsxs("box", { className: "MediaPlayer", children: [
        /* @__PURE__ */ jsx2(
          "box",
          {
            className: "Cover",
            hexpand: true,
            widthRequest: 300,
            css: coverArt,
            children: /* @__PURE__ */ jsxs(
              "box",
              {
                className: "Description",
                vertical: true,
                children: [
                  /* @__PURE__ */ jsx2(ArtistTitle, {}),
                  /* @__PURE__ */ jsx2(Position, {})
                ]
              }
            )
          }
        ),
        /* @__PURE__ */ jsx2(Actions, {})
      ] })
    }
  );
}

// windows/right_sidebar/RightSidebar.tsx
function UserModule() {
  const userName = exec("whoami");
  const userImg = `${"/home/broa/.config/ags"}/assets/profile.png`;
  return /* @__PURE__ */ jsxs(
    "box",
    {
      className: "UserModule",
      children: [
        /* @__PURE__ */ jsx2("box", { className: "UserImg", css: `background-image: url('${userImg}')` }),
        /* @__PURE__ */ jsxs("box", { vertical: true, valign: Gtk4.Align.CENTER, children: [
          /* @__PURE__ */ jsx2("label", { className: "Username", label: userName, halign: Gtk4.Align.START }),
          /* @__PURE__ */ jsx2("label", { className: "Uptime", label: uptime(), halign: Gtk4.Align.START })
        ] })
      ]
    }
  );
}
function sidebarButton(icon, name, status) {
  return /* @__PURE__ */ jsxs("box", { children: [
    /* @__PURE__ */ jsx2("label", { className: "Icon", label: icon }),
    /* @__PURE__ */ jsxs(
      "box",
      {
        className: "Description",
        vertical: true,
        valign: Gtk4.Align.CENTER,
        children: [
          /* @__PURE__ */ jsx2("label", { halign: Gtk4.Align.START, label: name }),
          /* @__PURE__ */ jsx2("label", { halign: Gtk4.Align.START, label: status })
        ]
      }
    )
  ] });
}
function WifiModule() {
  const network = Network2.get_default();
  return /* @__PURE__ */ jsx2("box", { className: "Wifi", halign: Gtk4.Align.CENTER, children: bind(network, "wifi").as(
    (wifi) => /* @__PURE__ */ jsx2("box", { children: bind(wifi, "enabled").as((enabled) => {
      const icon = bind(wifi, "iconName").as(getWifiIcon);
      const name = enabled ? bind(wifi, "ssid").as((ssid) => ssid || "Wifi") : "Wifi";
      const status = enabled ? "on" : "off";
      return /* @__PURE__ */ jsx2(
        "button",
        {
          className: enabled ? "enabled" : "disabled",
          onClicked: () => wifi.set_enabled(!enabled),
          children: sidebarButton(icon, name, status)
        }
      );
    }) })
  ) });
}
function BluetoothModule2() {
  const bluetooth = Bluetooth2.get_default();
  function getConnectedDevice(enabled) {
    for (const device of bluetooth.get_devices()) {
      if (device.connected) {
        const name2 = device.name;
        const status2 = bind(device, "batteryPercentage").as((p) => p > 0 ? `${Math.floor(p * 100)}%` : enabled ? "on" : "off");
        return { name: name2, status: status2 };
      }
    }
    const name = "Bluetooth";
    const status = enabled ? "on" : "off";
    return { name, status };
  }
  return /* @__PURE__ */ jsx2("box", { className: "Bluetooth", halign: Gtk4.Align.CENTER, children: bind(bluetooth, "isPowered").as((powered) => /* @__PURE__ */ jsx2(
    "button",
    {
      className: powered ? "enabled" : "disabled",
      onClicked: () => exec("rfkill toggle bluetooth"),
      children: bind(bluetooth, "isConnected").as((conn) => {
        const icon = conn ? "\u{F00B1}" : "\u{F00AF}";
        const { name, status } = getConnectedDevice(powered);
        return sidebarButton(icon, name, status);
      })
    }
  )) });
}
function DoNotDisturbModule() {
  const icon = "\u{F0376}";
  const name = "Do Not Disturb";
  return bind(doNotDisturb).as((dnd) => {
    const status = dnd ? "on" : "off";
    return /* @__PURE__ */ jsx2(
      "box",
      {
        className: "doNotDisturb",
        halign: Gtk4.Align.CENTER,
        children: /* @__PURE__ */ jsx2(
          "button",
          {
            className: dnd ? "enabled" : "disabled",
            onClicked: () => doNotDisturb.set(!dnd),
            children: sidebarButton(icon, name, status)
          }
        )
      }
    );
  });
}
function toggleNightLight() {
  if (nightLightEnabled.get()) {
    execAsync("pkill -x hyprsunset");
    nightLightEnabled.set(false);
  } else {
    execAsync("hyprsunset -t 5000");
    nightLightEnabled.set(true);
  }
}
function NightLightModule() {
  const name = "Night Light";
  return bind(nightLightEnabled).as((enabled) => {
    const icon = enabled ? "\u{F1A4C}" : "\u{F0336}";
    const status = enabled ? "on" : "off";
    return /* @__PURE__ */ jsx2(
      "box",
      {
        className: "nightLight",
        halign: Gtk4.Align.CENTER,
        children: /* @__PURE__ */ jsx2(
          "button",
          {
            className: enabled ? "enabled" : "disabled",
            onClicked: toggleNightLight,
            children: sidebarButton(icon, name, status)
          }
        )
      }
    );
  });
}
function NotificationList() {
  const notifd = Notifd3.get_default();
  return /* @__PURE__ */ jsx2("box", { className: "NotificationList", children: bind(notifd, "notifications").as((notifs) => {
    const nLength = notifs.length;
    notificationsLength.set(nLength);
    const boxHeight = nLength > 0 ? 400 : 300;
    return /* @__PURE__ */ jsxs(
      "box",
      {
        vertical: true,
        heightRequest: boxHeight,
        widthRequest: 300,
        children: [
          /* @__PURE__ */ jsxs("box", { children: [
            /* @__PURE__ */ jsx2("label", { className: "Title", label: "Notifications" }),
            /* @__PURE__ */ jsx2(
              "button",
              {
                className: "dismissAll",
                halign: Gtk4.Align.END,
                hexpand: true,
                label: "Clear All",
                onClicked: () => notifs.forEach((n) => n.dismiss())
              }
            )
          ] }),
          nLength > 0 ? /* @__PURE__ */ jsx2("scrollable", { vexpand: true, children: /* @__PURE__ */ jsx2("box", { vertical: true, children: notifs.reverse().map((n) => {
            return Notification({
              notification: n,
              setup: () => {
              },
              onHoverLost: () => {
              }
            });
          }) }) }) : /* @__PURE__ */ jsxs(
            "box",
            {
              className: "noNotifications",
              vexpand: true,
              hexpand: true,
              vertical: true,
              valign: Gtk4.Align.CENTER,
              children: [
                /* @__PURE__ */ jsx2("label", { label: "\u{F13EC}", className: "Icon" }),
                /* @__PURE__ */ jsx2("label", { label: "no notifications :(" })
              ]
            }
          )
        ]
      }
    );
  }) });
}
function ScrollableMediaPlayers() {
  const mpris = Mpris3.get_default();
  const currentPlayer = Variable(0);
  const playersLenght = Variable(0);
  return /* @__PURE__ */ jsx2(
    "eventbox",
    {
      onScroll: (_, event) => {
        const delta_y = event.delta_y;
        const current = currentPlayer.get();
        const max = playersLenght.get() - 1;
        if (delta_y < 0) {
          if (current < max) currentPlayer.set(current + 1);
        } else {
          if (current > 0) currentPlayer.set(current - 1);
        }
      },
      children: bind(mpris, "players").as((ps) => {
        playersLenght.set(ps.length);
        if (ps.length > 0) return /* @__PURE__ */ jsxs("box", { vertical: true, children: [
          /* @__PURE__ */ jsx2(
            "stack",
            {
              transitionType: Gtk4.StackTransitionType.SLIDE_LEFT_RIGHT,
              transitionDuration: 300,
              visibleChildName: bind(currentPlayer).as((current) => ps[current].entry),
              children: ps.map((player) => {
                return /* @__PURE__ */ jsx2("box", { name: player.entry, children: MediaPlayer(player) });
              })
            }
          ),
          /* @__PURE__ */ jsx2(
            "box",
            {
              className: "playersButtons",
              halign: Gtk4.Align.CENTER,
              visible: ps.length > 1 ? true : false,
              children: ps.map((player) => /* @__PURE__ */ jsx2(
                "button",
                {
                  className: bind(currentPlayer).as(
                    (current) => ps[current].entry == player.entry ? "enabled" : "disabled"
                  ),
                  onClicked: () => currentPlayer.set(ps.indexOf(player)),
                  children: /* @__PURE__ */ jsx2("icon", { icon: player.entry.replace(/zen/, "zen-browser") })
                }
              ))
            }
          )
        ] });
        return /* @__PURE__ */ jsx2("box", {});
      })
    }
  );
}
function SidebarBluetoothPanel() {
  const bluetooth = Bluetooth2.get_default();
  const adapter = bluetooth.adapter;
  function listItem(device) {
    if (device.name === null) return /* @__PURE__ */ jsx2("box", {});
    const visibleBinding = Variable.derive(
      [bind(device, "connected"), bind(device, "paired")],
      (connected, paired) => {
        return connected || paired;
      }
    );
    const battery = bind(device, "batteryPercentage").as((p) => p > 0 ? ` (${Math.floor(p * 100)}%)` : "");
    return /* @__PURE__ */ jsxs("box", { className: "Item", children: [
      /* @__PURE__ */ jsxs("box", { children: [
        /* @__PURE__ */ jsx2("icon", { icon: device.icon || "help-browser" }),
        /* @__PURE__ */ jsxs("box", { vertical: true, children: [
          /* @__PURE__ */ jsxs("box", { halign: Gtk4.Align.START, children: [
            /* @__PURE__ */ jsx2("label", { label: device.name, className: "Name" }),
            /* @__PURE__ */ jsx2("label", { label: battery, className: "Battery" })
          ] }),
          /* @__PURE__ */ jsx2(
            "label",
            {
              visible: visibleBinding(),
              className: "Status",
              halign: Gtk4.Align.START,
              label: bind(device, "connected").as((conn) => conn ? "Connected" : "Paired")
            }
          )
        ] })
      ] }),
      /* @__PURE__ */ jsx2("box", { hexpand: true }),
      /* @__PURE__ */ jsx2("box", { className: "Actions", children: /* @__PURE__ */ jsx2(
        "button",
        {
          label: "\u{F1616}",
          onClicked: () => {
            if (device.get_connected()) {
              device.disconnect_device((res) => console.log(res));
            } else {
              device.connect_device((res) => console.log(res));
            }
          }
        }
      ) })
    ] });
  }
  return /* @__PURE__ */ jsxs(
    "box",
    {
      name: "bluetooth",
      className: "SidebarBluetoothPanel",
      vertical: true,
      children: [
        /* @__PURE__ */ jsxs("box", { children: [
          /* @__PURE__ */ jsx2("label", { label: "Bluetooth", className: "Title" }),
          /* @__PURE__ */ jsx2("box", { hexpand: true }),
          /* @__PURE__ */ jsx2(
            "button",
            {
              className: "Discover",
              css: bind(adapter, "discovering").as(
                (disc) => disc ? "color: #7e9cd8;" : "color: #c8c093;"
              ),
              label: "\u{F04E6}",
              tooltipText: bind(adapter, "discovering").as((disc) => disc ? "Discovering" : "Discover"),
              onClicked: () => {
                if (adapter.get_discovering()) {
                  adapter.stop_discovery();
                } else {
                  adapter.start_discovery();
                }
              }
            }
          ),
          /* @__PURE__ */ jsx2(
            "switch",
            {
              active: bind(bluetooth, "isPowered"),
              onButtonPressEvent: () => execAsync("rfkill toggle bluetooth")
            }
          )
        ] }),
        /* @__PURE__ */ jsx2(
          "scrollable",
          {
            vexpand: true,
            className: "ItemList",
            children: /* @__PURE__ */ jsx2("box", { vertical: true, children: bind(bluetooth, "devices").as((devs) => devs.map((d) => listItem(d))) })
          }
        )
      ]
    }
  );
}
function SidebarWifiPanel() {
  const network = Network2.get_default();
  const wifi = network.wifi;
  function itemList(ap) {
    if (ap.ssid === null) return /* @__PURE__ */ jsx2("box", {});
    return /* @__PURE__ */ jsxs("box", { className: "Item", children: [
      /* @__PURE__ */ jsx2("label", { label: bind(ap, "iconName").as((i) => getWifiIcon(i)), className: "icon" }),
      /* @__PURE__ */ jsxs("box", { vertical: true, valign: Gtk4.Align.CENTER, children: [
        /* @__PURE__ */ jsx2("label", { label: ap.ssid, className: "ssid", halign: Gtk4.Align.START }),
        /* @__PURE__ */ jsx2(
          "label",
          {
            visible: bind(wifi, "activeAccessPoint").as((aap) => aap === ap),
            halign: Gtk4.Align.START,
            label: "Connected",
            className: "status"
          }
        )
      ] }),
      /* @__PURE__ */ jsx2("box", { hexpand: true }),
      /* @__PURE__ */ jsx2(
        "button",
        {
          label: "\u{F1616}",
          onClicked: () => execAsync(`nmcli device wifi connect ${ap.ssid}`)
        }
      )
    ] });
  }
  return /* @__PURE__ */ jsxs(
    "box",
    {
      name: "wifi",
      vertical: true,
      className: "SidebarWifiPanel",
      children: [
        /* @__PURE__ */ jsxs("box", { children: [
          /* @__PURE__ */ jsx2("label", { label: "Wifi", className: "Title" }),
          /* @__PURE__ */ jsx2("box", { hexpand: true }),
          /* @__PURE__ */ jsx2(
            "switch",
            {
              active: bind(wifi, "enabled"),
              onButtonPressEvent: () => wifi.set_enabled(!wifi.get_enabled())
            }
          )
        ] }),
        /* @__PURE__ */ jsx2(
          "scrollable",
          {
            vexpand: true,
            className: "ItemList",
            children: /* @__PURE__ */ jsx2("box", { vertical: true, children: bind(wifi, "access_points").as(
              (aps) => aps.sort((a, b) => b.strength - a.strength).map((ap) => itemList(ap))
            ) })
          }
        )
      ]
    }
  );
}
function SidebarMainPanel() {
  return /* @__PURE__ */ jsxs(
    "box",
    {
      name: "main",
      vertical: true,
      className: "SidebarMainPanel",
      children: [
        /* @__PURE__ */ jsxs("box", { children: [
          /* @__PURE__ */ jsx2(WifiModule, {}),
          /* @__PURE__ */ jsx2("box", { widthRequest: 8 }),
          /* @__PURE__ */ jsx2(BluetoothModule2, {})
        ] }),
        /* @__PURE__ */ jsxs("box", { children: [
          /* @__PURE__ */ jsx2(DoNotDisturbModule, {}),
          /* @__PURE__ */ jsx2("box", { widthRequest: 8 }),
          /* @__PURE__ */ jsx2(NightLightModule, {})
        ] }),
        /* @__PURE__ */ jsx2(ScrollableMediaPlayers, {}),
        /* @__PURE__ */ jsx2(NotificationList, {})
      ]
    }
  );
}
function SidebarPanels() {
  return /* @__PURE__ */ jsxs(
    "stack",
    {
      transitionType: Gtk4.StackTransitionType.SLIDE_LEFT_RIGHT,
      visibleChildName: bind(sidebarPanel).as((sp) => sp),
      children: [
        /* @__PURE__ */ jsx2(SidebarMainPanel, {}),
        /* @__PURE__ */ jsx2(SidebarBluetoothPanel, {}),
        /* @__PURE__ */ jsx2(SidebarWifiPanel, {})
      ]
    }
  );
}
function SidebarPanelsButtons() {
  const actions = ["main", "bluetooth", "wifi"];
  return /* @__PURE__ */ jsx2("centerbox", { className: "SidebarPanelsButtons", children: actions.map(
    (action) => /* @__PURE__ */ jsx2(
      "button",
      {
        hexpand: true,
        label: action,
        className: bind(sidebarPanel).as((sp) => sp === action ? "enabled" : "disabled"),
        onClicked: () => sidebarPanel.set(action)
      }
    )
  ) });
}
function RightSidebar(monitor, visible) {
  const { TOP, RIGHT } = Astal7.WindowAnchor;
  return /* @__PURE__ */ jsx2(
    "window",
    {
      className: "RightSidebar",
      namespace: "rightsidebar",
      gdkmonitor: monitor,
      exclusivity: Astal7.Exclusivity.EXCLUSIVE,
      application: app_default,
      visible: visible(),
      layer: Astal7.Layer.TOP,
      anchor: TOP | RIGHT,
      children: /* @__PURE__ */ jsxs(
        "box",
        {
          vertical: true,
          className: "sidebar",
          children: [
            /* @__PURE__ */ jsxs("box", { children: [
              /* @__PURE__ */ jsx2(UserModule, {}),
              /* @__PURE__ */ jsx2(SidebarPanelsButtons, {})
            ] }),
            /* @__PURE__ */ jsx2(SidebarPanels, {})
          ]
        }
      )
    }
  );
}

// requestHandler.ts
function handleRevealer(command, revealer) {
  switch (command) {
    case 2 /* TOGGLE */:
      revealer.set(!revealer.get());
      return `${revealer.get()}`;
    default:
      return "Unknown reveal command.";
  }
}
function requestHandler(request, res) {
  const args = request.split(":");
  switch (args[0]) {
    case "bar":
      switch (args[1]) {
        case "toggle":
          return res(handleRevealer(2 /* TOGGLE */, showBar));
        default:
          return res("Unknown command for bar.");
      }
    case "leftsidebar":
      switch (args[1]) {
        case "toggle":
          return res(handleRevealer(2 /* TOGGLE */, showLeftSidebar));
        default:
          return res("Unknown command for leftsidebar.");
      }
    case "rightsidebar":
      switch (args[1]) {
        case "toggle":
          return res(handleRevealer(2 /* TOGGLE */, showRightSidebar));
        default:
          return res("Unknown command for rightsidebar.");
      }
    case "launcher":
      switch (args[1]) {
        case "toggle":
          return res(handleRevealer(2 /* TOGGLE */, showLauncher));
        default:
          return res("Unknown command for launcher.");
      }
    case "crosshair":
      switch (args[1]) {
        case "toggle":
          return res(handleRevealer(2 /* TOGGLE */, showCrosshair));
        default:
          return res("Unknown command for crosshair.");
      }
    default:
      return res("Unknown request.");
  }
}

// app.ts
function getTargetMonitor(monitors) {
  const notebookModel = "0x9051";
  const pcModel = "24G2W1G4";
  const notebookMonitor = monitors.find((m) => m.model === notebookModel);
  const pcMonitor = monitors.find((m) => m.model === pcModel);
  return notebookMonitor || pcMonitor || monitors[0];
}
app_default.start({
  css: compileScss(),
  requestHandler,
  main() {
    const monitors = app_default.get_monitors();
    const targetMonitor = getTargetMonitor(monitors);
    Bar(targetMonitor, showBar);
    LeftSidebar(targetMonitor, showLeftSidebar);
    RightSidebar(targetMonitor, showRightSidebar);
    Crosshair(targetMonitor, showCrosshair);
    OSD(targetMonitor);
    NotificationPopups(targetMonitor, doNotDisturb);
    Launcher(targetMonitor, showLauncher);
    print(`
Astal Windows applied on monitor: ${targetMonitor.model}`);
  }
});
//# sourceMappingURL=data:application/json;base64,ewogICJ2ZXJzaW9uIjogMywKICAic291cmNlcyI6IFsiLi4vLi4vLi4vLi4vdXNyL3NoYXJlL2FzdGFsL2dqcy9ndGszL2luZGV4LnRzIiwgIi4uLy4uLy4uLy4uL3Vzci9zaGFyZS9hc3RhbC9nanMvdmFyaWFibGUudHMiLCAiLi4vLi4vLi4vLi4vdXNyL3NoYXJlL2FzdGFsL2dqcy9iaW5kaW5nLnRzIiwgIi4uLy4uLy4uLy4uL3Vzci9zaGFyZS9hc3RhbC9nanMvdGltZS50cyIsICIuLi8uLi8uLi8uLi91c3Ivc2hhcmUvYXN0YWwvZ2pzL3Byb2Nlc3MudHMiLCAiLi4vLi4vLi4vLi4vdXNyL3NoYXJlL2FzdGFsL2dqcy9fYXN0YWwudHMiLCAiLi4vLi4vLi4vLi4vdXNyL3NoYXJlL2FzdGFsL2dqcy9ndGszL2FzdGFsaWZ5LnRzIiwgIi4uLy4uLy4uLy4uL3Vzci9zaGFyZS9hc3RhbC9nanMvZ3RrMy9hcHAudHMiLCAiLi4vLi4vLi4vLi4vdXNyL3NoYXJlL2FzdGFsL2dqcy9vdmVycmlkZXMudHMiLCAiLi4vLi4vLi4vLi4vdXNyL3NoYXJlL2FzdGFsL2dqcy9fYXBwLnRzIiwgIi4uLy4uLy4uLy4uL3Vzci9zaGFyZS9hc3RhbC9nanMvZ3RrMy93aWRnZXQudHMiLCAiLi4vLi4vLi4vLi4vdXNyL3NoYXJlL2FzdGFsL2dqcy9pbmRleC50cyIsICIuLi8uLi8uLi8uLi91c3Ivc2hhcmUvYXN0YWwvZ2pzL2ZpbGUudHMiLCAiLi4vLi4vLi4vLi4vdXNyL3NoYXJlL2FzdGFsL2dqcy9nb2JqZWN0LnRzIiwgImNvbW1vbi9jc3NIb3RSZWxvYWQudHMiLCAiY29tbW9uL3ZhcnMudHMiLCAid2luZG93cy9iYXIvQmFyLnRzeCIsICIuLi8uLi8uLi8uLi91c3Ivc2hhcmUvYXN0YWwvZ2pzL2d0azMvanN4LXJ1bnRpbWUudHMiLCAid2lkZ2V0cy9UaW1lL1RpbWUudHN4IiwgImNvbW1vbi9mdW5jdGlvbnMudHMiLCAid2luZG93cy9jcm9zc2hhaXIvQ3Jvc3NoYWlyLnRzeCIsICJ3aW5kb3dzL2xhdW5jaGVyL0xhdW5jaGVyLnRzeCIsICJ3aWRnZXRzL0NhbGVuZGFyL0NhbGVuZGFyLnRzeCIsICJ3aW5kb3dzL2xlZnRfc2lkZWJhci9MZWZ0U2lkZWJhci50c3giLCAid2luZG93cy9ub3RpZmljYXRpb25fcG9wdXBzL05vdGlmaWNhdGlvblBvcHVwcy50c3giLCAid2lkZ2V0cy9Ob3RpZmljYXRpb24vTm90aWZpY2F0aW9uLnRzeCIsICJ3aW5kb3dzL29zZC9PU0QudHN4IiwgInV0aWxzL2JyaWdodG5lc3MudHMiLCAid2luZG93cy9yaWdodF9zaWRlYmFyL1JpZ2h0U2lkZWJhci50c3giLCAid2lkZ2V0cy9NZWRpYVBsYXllci9NZWRpYVBsYXllci50c3giLCAicmVxdWVzdEhhbmRsZXIudHMiLCAiYXBwLnRzIl0sCiAgInNvdXJjZXNDb250ZW50IjogWyJpbXBvcnQgQXN0YWwgZnJvbSBcImdpOi8vQXN0YWw/dmVyc2lvbj0zLjBcIlxuaW1wb3J0IEd0ayBmcm9tIFwiZ2k6Ly9HdGs/dmVyc2lvbj0zLjBcIlxuaW1wb3J0IEdkayBmcm9tIFwiZ2k6Ly9HZGs/dmVyc2lvbj0zLjBcIlxuaW1wb3J0IGFzdGFsaWZ5LCB7IHR5cGUgQ29uc3RydWN0UHJvcHMsIHR5cGUgQmluZGFibGVQcm9wcyB9IGZyb20gXCIuL2FzdGFsaWZ5LmpzXCJcblxuZXhwb3J0IHsgQXN0YWwsIEd0aywgR2RrIH1cbmV4cG9ydCB7IGRlZmF1bHQgYXMgQXBwIH0gZnJvbSBcIi4vYXBwLmpzXCJcbmV4cG9ydCB7IGFzdGFsaWZ5LCBDb25zdHJ1Y3RQcm9wcywgQmluZGFibGVQcm9wcyB9XG5leHBvcnQgKiBhcyBXaWRnZXQgZnJvbSBcIi4vd2lkZ2V0LmpzXCJcbmV4cG9ydCB7IGhvb2sgfSBmcm9tIFwiLi4vX2FzdGFsXCJcbiIsICJpbXBvcnQgQXN0YWwgZnJvbSBcImdpOi8vQXN0YWxJT1wiXG5pbXBvcnQgQmluZGluZywgeyB0eXBlIENvbm5lY3RhYmxlLCB0eXBlIFN1YnNjcmliYWJsZSB9IGZyb20gXCIuL2JpbmRpbmcuanNcIlxuaW1wb3J0IHsgaW50ZXJ2YWwgfSBmcm9tIFwiLi90aW1lLmpzXCJcbmltcG9ydCB7IGV4ZWNBc3luYywgc3VicHJvY2VzcyB9IGZyb20gXCIuL3Byb2Nlc3MuanNcIlxuXG5jbGFzcyBWYXJpYWJsZVdyYXBwZXI8VD4gZXh0ZW5kcyBGdW5jdGlvbiB7XG4gICAgcHJpdmF0ZSB2YXJpYWJsZSE6IEFzdGFsLlZhcmlhYmxlQmFzZVxuICAgIHByaXZhdGUgZXJySGFuZGxlcj8gPSBjb25zb2xlLmVycm9yXG5cbiAgICBwcml2YXRlIF92YWx1ZTogVFxuICAgIHByaXZhdGUgX3BvbGw/OiBBc3RhbC5UaW1lXG4gICAgcHJpdmF0ZSBfd2F0Y2g/OiBBc3RhbC5Qcm9jZXNzXG5cbiAgICBwcml2YXRlIHBvbGxJbnRlcnZhbCA9IDEwMDBcbiAgICBwcml2YXRlIHBvbGxFeGVjPzogc3RyaW5nW10gfCBzdHJpbmdcbiAgICBwcml2YXRlIHBvbGxUcmFuc2Zvcm0/OiAoc3Rkb3V0OiBzdHJpbmcsIHByZXY6IFQpID0+IFRcbiAgICBwcml2YXRlIHBvbGxGbj86IChwcmV2OiBUKSA9PiBUIHwgUHJvbWlzZTxUPlxuXG4gICAgcHJpdmF0ZSB3YXRjaFRyYW5zZm9ybT86IChzdGRvdXQ6IHN0cmluZywgcHJldjogVCkgPT4gVFxuICAgIHByaXZhdGUgd2F0Y2hFeGVjPzogc3RyaW5nW10gfCBzdHJpbmdcblxuICAgIGNvbnN0cnVjdG9yKGluaXQ6IFQpIHtcbiAgICAgICAgc3VwZXIoKVxuICAgICAgICB0aGlzLl92YWx1ZSA9IGluaXRcbiAgICAgICAgdGhpcy52YXJpYWJsZSA9IG5ldyBBc3RhbC5WYXJpYWJsZUJhc2UoKVxuICAgICAgICB0aGlzLnZhcmlhYmxlLmNvbm5lY3QoXCJkcm9wcGVkXCIsICgpID0+IHtcbiAgICAgICAgICAgIHRoaXMuc3RvcFdhdGNoKClcbiAgICAgICAgICAgIHRoaXMuc3RvcFBvbGwoKVxuICAgICAgICB9KVxuICAgICAgICB0aGlzLnZhcmlhYmxlLmNvbm5lY3QoXCJlcnJvclwiLCAoXywgZXJyKSA9PiB0aGlzLmVyckhhbmRsZXI/LihlcnIpKVxuICAgICAgICByZXR1cm4gbmV3IFByb3h5KHRoaXMsIHtcbiAgICAgICAgICAgIGFwcGx5OiAodGFyZ2V0LCBfLCBhcmdzKSA9PiB0YXJnZXQuX2NhbGwoYXJnc1swXSksXG4gICAgICAgIH0pXG4gICAgfVxuXG4gICAgcHJpdmF0ZSBfY2FsbDxSID0gVD4odHJhbnNmb3JtPzogKHZhbHVlOiBUKSA9PiBSKTogQmluZGluZzxSPiB7XG4gICAgICAgIGNvbnN0IGIgPSBCaW5kaW5nLmJpbmQodGhpcylcbiAgICAgICAgcmV0dXJuIHRyYW5zZm9ybSA/IGIuYXModHJhbnNmb3JtKSA6IGIgYXMgdW5rbm93biBhcyBCaW5kaW5nPFI+XG4gICAgfVxuXG4gICAgdG9TdHJpbmcoKSB7XG4gICAgICAgIHJldHVybiBTdHJpbmcoYFZhcmlhYmxlPCR7dGhpcy5nZXQoKX0+YClcbiAgICB9XG5cbiAgICBnZXQoKTogVCB7IHJldHVybiB0aGlzLl92YWx1ZSB9XG4gICAgc2V0KHZhbHVlOiBUKSB7XG4gICAgICAgIGlmICh2YWx1ZSAhPT0gdGhpcy5fdmFsdWUpIHtcbiAgICAgICAgICAgIHRoaXMuX3ZhbHVlID0gdmFsdWVcbiAgICAgICAgICAgIHRoaXMudmFyaWFibGUuZW1pdChcImNoYW5nZWRcIilcbiAgICAgICAgfVxuICAgIH1cblxuICAgIHN0YXJ0UG9sbCgpIHtcbiAgICAgICAgaWYgKHRoaXMuX3BvbGwpXG4gICAgICAgICAgICByZXR1cm5cblxuICAgICAgICBpZiAodGhpcy5wb2xsRm4pIHtcbiAgICAgICAgICAgIHRoaXMuX3BvbGwgPSBpbnRlcnZhbCh0aGlzLnBvbGxJbnRlcnZhbCwgKCkgPT4ge1xuICAgICAgICAgICAgICAgIGNvbnN0IHYgPSB0aGlzLnBvbGxGbiEodGhpcy5nZXQoKSlcbiAgICAgICAgICAgICAgICBpZiAodiBpbnN0YW5jZW9mIFByb21pc2UpIHtcbiAgICAgICAgICAgICAgICAgICAgdi50aGVuKHYgPT4gdGhpcy5zZXQodikpXG4gICAgICAgICAgICAgICAgICAgICAgICAuY2F0Y2goZXJyID0+IHRoaXMudmFyaWFibGUuZW1pdChcImVycm9yXCIsIGVycikpXG4gICAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICAgICAgdGhpcy5zZXQodilcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9KVxuICAgICAgICB9IGVsc2UgaWYgKHRoaXMucG9sbEV4ZWMpIHtcbiAgICAgICAgICAgIHRoaXMuX3BvbGwgPSBpbnRlcnZhbCh0aGlzLnBvbGxJbnRlcnZhbCwgKCkgPT4ge1xuICAgICAgICAgICAgICAgIGV4ZWNBc3luYyh0aGlzLnBvbGxFeGVjISlcbiAgICAgICAgICAgICAgICAgICAgLnRoZW4odiA9PiB0aGlzLnNldCh0aGlzLnBvbGxUcmFuc2Zvcm0hKHYsIHRoaXMuZ2V0KCkpKSlcbiAgICAgICAgICAgICAgICAgICAgLmNhdGNoKGVyciA9PiB0aGlzLnZhcmlhYmxlLmVtaXQoXCJlcnJvclwiLCBlcnIpKVxuICAgICAgICAgICAgfSlcbiAgICAgICAgfVxuICAgIH1cblxuICAgIHN0YXJ0V2F0Y2goKSB7XG4gICAgICAgIGlmICh0aGlzLl93YXRjaClcbiAgICAgICAgICAgIHJldHVyblxuXG4gICAgICAgIHRoaXMuX3dhdGNoID0gc3VicHJvY2Vzcyh7XG4gICAgICAgICAgICBjbWQ6IHRoaXMud2F0Y2hFeGVjISxcbiAgICAgICAgICAgIG91dDogb3V0ID0+IHRoaXMuc2V0KHRoaXMud2F0Y2hUcmFuc2Zvcm0hKG91dCwgdGhpcy5nZXQoKSkpLFxuICAgICAgICAgICAgZXJyOiBlcnIgPT4gdGhpcy52YXJpYWJsZS5lbWl0KFwiZXJyb3JcIiwgZXJyKSxcbiAgICAgICAgfSlcbiAgICB9XG5cbiAgICBzdG9wUG9sbCgpIHtcbiAgICAgICAgdGhpcy5fcG9sbD8uY2FuY2VsKClcbiAgICAgICAgZGVsZXRlIHRoaXMuX3BvbGxcbiAgICB9XG5cbiAgICBzdG9wV2F0Y2goKSB7XG4gICAgICAgIHRoaXMuX3dhdGNoPy5raWxsKClcbiAgICAgICAgZGVsZXRlIHRoaXMuX3dhdGNoXG4gICAgfVxuXG4gICAgaXNQb2xsaW5nKCkgeyByZXR1cm4gISF0aGlzLl9wb2xsIH1cbiAgICBpc1dhdGNoaW5nKCkgeyByZXR1cm4gISF0aGlzLl93YXRjaCB9XG5cbiAgICBkcm9wKCkge1xuICAgICAgICB0aGlzLnZhcmlhYmxlLmVtaXQoXCJkcm9wcGVkXCIpXG4gICAgfVxuXG4gICAgb25Ecm9wcGVkKGNhbGxiYWNrOiAoKSA9PiB2b2lkKSB7XG4gICAgICAgIHRoaXMudmFyaWFibGUuY29ubmVjdChcImRyb3BwZWRcIiwgY2FsbGJhY2spXG4gICAgICAgIHJldHVybiB0aGlzIGFzIHVua25vd24gYXMgVmFyaWFibGU8VD5cbiAgICB9XG5cbiAgICBvbkVycm9yKGNhbGxiYWNrOiAoZXJyOiBzdHJpbmcpID0+IHZvaWQpIHtcbiAgICAgICAgZGVsZXRlIHRoaXMuZXJySGFuZGxlclxuICAgICAgICB0aGlzLnZhcmlhYmxlLmNvbm5lY3QoXCJlcnJvclwiLCAoXywgZXJyKSA9PiBjYWxsYmFjayhlcnIpKVxuICAgICAgICByZXR1cm4gdGhpcyBhcyB1bmtub3duIGFzIFZhcmlhYmxlPFQ+XG4gICAgfVxuXG4gICAgc3Vic2NyaWJlKGNhbGxiYWNrOiAodmFsdWU6IFQpID0+IHZvaWQpIHtcbiAgICAgICAgY29uc3QgaWQgPSB0aGlzLnZhcmlhYmxlLmNvbm5lY3QoXCJjaGFuZ2VkXCIsICgpID0+IHtcbiAgICAgICAgICAgIGNhbGxiYWNrKHRoaXMuZ2V0KCkpXG4gICAgICAgIH0pXG4gICAgICAgIHJldHVybiAoKSA9PiB0aGlzLnZhcmlhYmxlLmRpc2Nvbm5lY3QoaWQpXG4gICAgfVxuXG4gICAgcG9sbChcbiAgICAgICAgaW50ZXJ2YWw6IG51bWJlcixcbiAgICAgICAgZXhlYzogc3RyaW5nIHwgc3RyaW5nW10sXG4gICAgICAgIHRyYW5zZm9ybT86IChzdGRvdXQ6IHN0cmluZywgcHJldjogVCkgPT4gVFxuICAgICk6IFZhcmlhYmxlPFQ+XG5cbiAgICBwb2xsKFxuICAgICAgICBpbnRlcnZhbDogbnVtYmVyLFxuICAgICAgICBjYWxsYmFjazogKHByZXY6IFQpID0+IFQgfCBQcm9taXNlPFQ+XG4gICAgKTogVmFyaWFibGU8VD5cblxuICAgIHBvbGwoXG4gICAgICAgIGludGVydmFsOiBudW1iZXIsXG4gICAgICAgIGV4ZWM6IHN0cmluZyB8IHN0cmluZ1tdIHwgKChwcmV2OiBUKSA9PiBUIHwgUHJvbWlzZTxUPiksXG4gICAgICAgIHRyYW5zZm9ybTogKHN0ZG91dDogc3RyaW5nLCBwcmV2OiBUKSA9PiBUID0gb3V0ID0+IG91dCBhcyBULFxuICAgICkge1xuICAgICAgICB0aGlzLnN0b3BQb2xsKClcbiAgICAgICAgdGhpcy5wb2xsSW50ZXJ2YWwgPSBpbnRlcnZhbFxuICAgICAgICB0aGlzLnBvbGxUcmFuc2Zvcm0gPSB0cmFuc2Zvcm1cbiAgICAgICAgaWYgKHR5cGVvZiBleGVjID09PSBcImZ1bmN0aW9uXCIpIHtcbiAgICAgICAgICAgIHRoaXMucG9sbEZuID0gZXhlY1xuICAgICAgICAgICAgZGVsZXRlIHRoaXMucG9sbEV4ZWNcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIHRoaXMucG9sbEV4ZWMgPSBleGVjXG4gICAgICAgICAgICBkZWxldGUgdGhpcy5wb2xsRm5cbiAgICAgICAgfVxuICAgICAgICB0aGlzLnN0YXJ0UG9sbCgpXG4gICAgICAgIHJldHVybiB0aGlzIGFzIHVua25vd24gYXMgVmFyaWFibGU8VD5cbiAgICB9XG5cbiAgICB3YXRjaChcbiAgICAgICAgZXhlYzogc3RyaW5nIHwgc3RyaW5nW10sXG4gICAgICAgIHRyYW5zZm9ybTogKHN0ZG91dDogc3RyaW5nLCBwcmV2OiBUKSA9PiBUID0gb3V0ID0+IG91dCBhcyBULFxuICAgICkge1xuICAgICAgICB0aGlzLnN0b3BXYXRjaCgpXG4gICAgICAgIHRoaXMud2F0Y2hFeGVjID0gZXhlY1xuICAgICAgICB0aGlzLndhdGNoVHJhbnNmb3JtID0gdHJhbnNmb3JtXG4gICAgICAgIHRoaXMuc3RhcnRXYXRjaCgpXG4gICAgICAgIHJldHVybiB0aGlzIGFzIHVua25vd24gYXMgVmFyaWFibGU8VD5cbiAgICB9XG5cbiAgICBvYnNlcnZlKFxuICAgICAgICBvYmpzOiBBcnJheTxbb2JqOiBDb25uZWN0YWJsZSwgc2lnbmFsOiBzdHJpbmddPixcbiAgICAgICAgY2FsbGJhY2s6ICguLi5hcmdzOiBhbnlbXSkgPT4gVCxcbiAgICApOiBWYXJpYWJsZTxUPlxuXG4gICAgb2JzZXJ2ZShcbiAgICAgICAgb2JqOiBDb25uZWN0YWJsZSxcbiAgICAgICAgc2lnbmFsOiBzdHJpbmcsXG4gICAgICAgIGNhbGxiYWNrOiAoLi4uYXJnczogYW55W10pID0+IFQsXG4gICAgKTogVmFyaWFibGU8VD5cblxuICAgIG9ic2VydmUoXG4gICAgICAgIG9ianM6IENvbm5lY3RhYmxlIHwgQXJyYXk8W29iajogQ29ubmVjdGFibGUsIHNpZ25hbDogc3RyaW5nXT4sXG4gICAgICAgIHNpZ09yRm46IHN0cmluZyB8ICgob2JqOiBDb25uZWN0YWJsZSwgLi4uYXJnczogYW55W10pID0+IFQpLFxuICAgICAgICBjYWxsYmFjaz86IChvYmo6IENvbm5lY3RhYmxlLCAuLi5hcmdzOiBhbnlbXSkgPT4gVCxcbiAgICApIHtcbiAgICAgICAgY29uc3QgZiA9IHR5cGVvZiBzaWdPckZuID09PSBcImZ1bmN0aW9uXCIgPyBzaWdPckZuIDogY2FsbGJhY2sgPz8gKCgpID0+IHRoaXMuZ2V0KCkpXG4gICAgICAgIGNvbnN0IHNldCA9IChvYmo6IENvbm5lY3RhYmxlLCAuLi5hcmdzOiBhbnlbXSkgPT4gdGhpcy5zZXQoZihvYmosIC4uLmFyZ3MpKVxuXG4gICAgICAgIGlmIChBcnJheS5pc0FycmF5KG9ianMpKSB7XG4gICAgICAgICAgICBmb3IgKGNvbnN0IG9iaiBvZiBvYmpzKSB7XG4gICAgICAgICAgICAgICAgY29uc3QgW28sIHNdID0gb2JqXG4gICAgICAgICAgICAgICAgY29uc3QgaWQgPSBvLmNvbm5lY3Qocywgc2V0KVxuICAgICAgICAgICAgICAgIHRoaXMub25Ecm9wcGVkKCgpID0+IG8uZGlzY29ubmVjdChpZCkpXG4gICAgICAgICAgICB9XG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICBpZiAodHlwZW9mIHNpZ09yRm4gPT09IFwic3RyaW5nXCIpIHtcbiAgICAgICAgICAgICAgICBjb25zdCBpZCA9IG9ianMuY29ubmVjdChzaWdPckZuLCBzZXQpXG4gICAgICAgICAgICAgICAgdGhpcy5vbkRyb3BwZWQoKCkgPT4gb2Jqcy5kaXNjb25uZWN0KGlkKSlcbiAgICAgICAgICAgIH1cbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiB0aGlzIGFzIHVua25vd24gYXMgVmFyaWFibGU8VD5cbiAgICB9XG5cbiAgICBzdGF0aWMgZGVyaXZlPFxuICAgICAgICBjb25zdCBEZXBzIGV4dGVuZHMgQXJyYXk8U3Vic2NyaWJhYmxlPGFueT4+LFxuICAgICAgICBBcmdzIGV4dGVuZHMge1xuICAgICAgICAgICAgW0sgaW4ga2V5b2YgRGVwc106IERlcHNbS10gZXh0ZW5kcyBTdWJzY3JpYmFibGU8aW5mZXIgVD4gPyBUIDogbmV2ZXJcbiAgICAgICAgfSxcbiAgICAgICAgViA9IEFyZ3MsXG4gICAgPihkZXBzOiBEZXBzLCBmbjogKC4uLmFyZ3M6IEFyZ3MpID0+IFYgPSAoLi4uYXJncykgPT4gYXJncyBhcyB1bmtub3duIGFzIFYpIHtcbiAgICAgICAgY29uc3QgdXBkYXRlID0gKCkgPT4gZm4oLi4uZGVwcy5tYXAoZCA9PiBkLmdldCgpKSBhcyBBcmdzKVxuICAgICAgICBjb25zdCBkZXJpdmVkID0gbmV3IFZhcmlhYmxlKHVwZGF0ZSgpKVxuICAgICAgICBjb25zdCB1bnN1YnMgPSBkZXBzLm1hcChkZXAgPT4gZGVwLnN1YnNjcmliZSgoKSA9PiBkZXJpdmVkLnNldCh1cGRhdGUoKSkpKVxuICAgICAgICBkZXJpdmVkLm9uRHJvcHBlZCgoKSA9PiB1bnN1YnMubWFwKHVuc3ViID0+IHVuc3ViKCkpKVxuICAgICAgICByZXR1cm4gZGVyaXZlZFxuICAgIH1cbn1cblxuZXhwb3J0IGludGVyZmFjZSBWYXJpYWJsZTxUPiBleHRlbmRzIE9taXQ8VmFyaWFibGVXcmFwcGVyPFQ+LCBcImJpbmRcIj4ge1xuICAgIDxSPih0cmFuc2Zvcm06ICh2YWx1ZTogVCkgPT4gUik6IEJpbmRpbmc8Uj5cbiAgICAoKTogQmluZGluZzxUPlxufVxuXG5leHBvcnQgY29uc3QgVmFyaWFibGUgPSBuZXcgUHJveHkoVmFyaWFibGVXcmFwcGVyIGFzIGFueSwge1xuICAgIGFwcGx5OiAoX3QsIF9hLCBhcmdzKSA9PiBuZXcgVmFyaWFibGVXcmFwcGVyKGFyZ3NbMF0pLFxufSkgYXMge1xuICAgIGRlcml2ZTogdHlwZW9mIFZhcmlhYmxlV3JhcHBlcltcImRlcml2ZVwiXVxuICAgIDxUPihpbml0OiBUKTogVmFyaWFibGU8VD5cbiAgICBuZXc8VD4oaW5pdDogVCk6IFZhcmlhYmxlPFQ+XG59XG5cbmV4cG9ydCBjb25zdCB7IGRlcml2ZSB9ID0gVmFyaWFibGVcbmV4cG9ydCBkZWZhdWx0IFZhcmlhYmxlXG4iLCAiZXhwb3J0IGNvbnN0IHNuYWtlaWZ5ID0gKHN0cjogc3RyaW5nKSA9PiBzdHJcbiAgICAucmVwbGFjZSgvKFthLXpdKShbQS1aXSkvZywgXCIkMV8kMlwiKVxuICAgIC5yZXBsYWNlQWxsKFwiLVwiLCBcIl9cIilcbiAgICAudG9Mb3dlckNhc2UoKVxuXG5leHBvcnQgY29uc3Qga2ViYWJpZnkgPSAoc3RyOiBzdHJpbmcpID0+IHN0clxuICAgIC5yZXBsYWNlKC8oW2Etel0pKFtBLVpdKS9nLCBcIiQxLSQyXCIpXG4gICAgLnJlcGxhY2VBbGwoXCJfXCIsIFwiLVwiKVxuICAgIC50b0xvd2VyQ2FzZSgpXG5cbmV4cG9ydCBpbnRlcmZhY2UgU3Vic2NyaWJhYmxlPFQgPSB1bmtub3duPiB7XG4gICAgc3Vic2NyaWJlKGNhbGxiYWNrOiAodmFsdWU6IFQpID0+IHZvaWQpOiAoKSA9PiB2b2lkXG4gICAgZ2V0KCk6IFRcbiAgICBba2V5OiBzdHJpbmddOiBhbnlcbn1cblxuZXhwb3J0IGludGVyZmFjZSBDb25uZWN0YWJsZSB7XG4gICAgY29ubmVjdChzaWduYWw6IHN0cmluZywgY2FsbGJhY2s6ICguLi5hcmdzOiBhbnlbXSkgPT4gdW5rbm93bik6IG51bWJlclxuICAgIGRpc2Nvbm5lY3QoaWQ6IG51bWJlcik6IHZvaWRcbiAgICBba2V5OiBzdHJpbmddOiBhbnlcbn1cblxuZXhwb3J0IGNsYXNzIEJpbmRpbmc8VmFsdWU+IHtcbiAgICBwcml2YXRlIHRyYW5zZm9ybUZuID0gKHY6IGFueSkgPT4gdlxuXG4gICAgI2VtaXR0ZXI6IFN1YnNjcmliYWJsZTxWYWx1ZT4gfCBDb25uZWN0YWJsZVxuICAgICNwcm9wPzogc3RyaW5nXG5cbiAgICBzdGF0aWMgYmluZDxcbiAgICAgICAgVCBleHRlbmRzIENvbm5lY3RhYmxlLFxuICAgICAgICBQIGV4dGVuZHMga2V5b2YgVCxcbiAgICA+KG9iamVjdDogVCwgcHJvcGVydHk6IFApOiBCaW5kaW5nPFRbUF0+XG5cbiAgICBzdGF0aWMgYmluZDxUPihvYmplY3Q6IFN1YnNjcmliYWJsZTxUPik6IEJpbmRpbmc8VD5cblxuICAgIHN0YXRpYyBiaW5kKGVtaXR0ZXI6IENvbm5lY3RhYmxlIHwgU3Vic2NyaWJhYmxlLCBwcm9wPzogc3RyaW5nKSB7XG4gICAgICAgIHJldHVybiBuZXcgQmluZGluZyhlbWl0dGVyLCBwcm9wKVxuICAgIH1cblxuICAgIHByaXZhdGUgY29uc3RydWN0b3IoZW1pdHRlcjogQ29ubmVjdGFibGUgfCBTdWJzY3JpYmFibGU8VmFsdWU+LCBwcm9wPzogc3RyaW5nKSB7XG4gICAgICAgIHRoaXMuI2VtaXR0ZXIgPSBlbWl0dGVyXG4gICAgICAgIHRoaXMuI3Byb3AgPSBwcm9wICYmIGtlYmFiaWZ5KHByb3ApXG4gICAgfVxuXG4gICAgdG9TdHJpbmcoKSB7XG4gICAgICAgIHJldHVybiBgQmluZGluZzwke3RoaXMuI2VtaXR0ZXJ9JHt0aGlzLiNwcm9wID8gYCwgXCIke3RoaXMuI3Byb3B9XCJgIDogXCJcIn0+YFxuICAgIH1cblxuICAgIGFzPFQ+KGZuOiAodjogVmFsdWUpID0+IFQpOiBCaW5kaW5nPFQ+IHtcbiAgICAgICAgY29uc3QgYmluZCA9IG5ldyBCaW5kaW5nKHRoaXMuI2VtaXR0ZXIsIHRoaXMuI3Byb3ApXG4gICAgICAgIGJpbmQudHJhbnNmb3JtRm4gPSAodjogVmFsdWUpID0+IGZuKHRoaXMudHJhbnNmb3JtRm4odikpXG4gICAgICAgIHJldHVybiBiaW5kIGFzIHVua25vd24gYXMgQmluZGluZzxUPlxuICAgIH1cblxuICAgIGdldCgpOiBWYWx1ZSB7XG4gICAgICAgIGlmICh0eXBlb2YgdGhpcy4jZW1pdHRlci5nZXQgPT09IFwiZnVuY3Rpb25cIilcbiAgICAgICAgICAgIHJldHVybiB0aGlzLnRyYW5zZm9ybUZuKHRoaXMuI2VtaXR0ZXIuZ2V0KCkpXG5cbiAgICAgICAgaWYgKHR5cGVvZiB0aGlzLiNwcm9wID09PSBcInN0cmluZ1wiKSB7XG4gICAgICAgICAgICBjb25zdCBnZXR0ZXIgPSBgZ2V0XyR7c25ha2VpZnkodGhpcy4jcHJvcCl9YFxuICAgICAgICAgICAgaWYgKHR5cGVvZiB0aGlzLiNlbWl0dGVyW2dldHRlcl0gPT09IFwiZnVuY3Rpb25cIilcbiAgICAgICAgICAgICAgICByZXR1cm4gdGhpcy50cmFuc2Zvcm1Gbih0aGlzLiNlbWl0dGVyW2dldHRlcl0oKSlcblxuICAgICAgICAgICAgcmV0dXJuIHRoaXMudHJhbnNmb3JtRm4odGhpcy4jZW1pdHRlclt0aGlzLiNwcm9wXSlcbiAgICAgICAgfVxuXG4gICAgICAgIHRocm93IEVycm9yKFwiY2FuIG5vdCBnZXQgdmFsdWUgb2YgYmluZGluZ1wiKVxuICAgIH1cblxuICAgIHN1YnNjcmliZShjYWxsYmFjazogKHZhbHVlOiBWYWx1ZSkgPT4gdm9pZCk6ICgpID0+IHZvaWQge1xuICAgICAgICBpZiAodHlwZW9mIHRoaXMuI2VtaXR0ZXIuc3Vic2NyaWJlID09PSBcImZ1bmN0aW9uXCIpIHtcbiAgICAgICAgICAgIHJldHVybiB0aGlzLiNlbWl0dGVyLnN1YnNjcmliZSgoKSA9PiB7XG4gICAgICAgICAgICAgICAgY2FsbGJhY2sodGhpcy5nZXQoKSlcbiAgICAgICAgICAgIH0pXG4gICAgICAgIH0gZWxzZSBpZiAodHlwZW9mIHRoaXMuI2VtaXR0ZXIuY29ubmVjdCA9PT0gXCJmdW5jdGlvblwiKSB7XG4gICAgICAgICAgICBjb25zdCBzaWduYWwgPSBgbm90aWZ5Ojoke3RoaXMuI3Byb3B9YFxuICAgICAgICAgICAgY29uc3QgaWQgPSB0aGlzLiNlbWl0dGVyLmNvbm5lY3Qoc2lnbmFsLCAoKSA9PiB7XG4gICAgICAgICAgICAgICAgY2FsbGJhY2sodGhpcy5nZXQoKSlcbiAgICAgICAgICAgIH0pXG4gICAgICAgICAgICByZXR1cm4gKCkgPT4ge1xuICAgICAgICAgICAgICAgICh0aGlzLiNlbWl0dGVyLmRpc2Nvbm5lY3QgYXMgQ29ubmVjdGFibGVbXCJkaXNjb25uZWN0XCJdKShpZClcbiAgICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgICB0aHJvdyBFcnJvcihgJHt0aGlzLiNlbWl0dGVyfSBpcyBub3QgYmluZGFibGVgKVxuICAgIH1cbn1cblxuZXhwb3J0IGNvbnN0IHsgYmluZCB9ID0gQmluZGluZ1xuZXhwb3J0IGRlZmF1bHQgQmluZGluZ1xuIiwgImltcG9ydCBBc3RhbCBmcm9tIFwiZ2k6Ly9Bc3RhbElPXCJcblxuZXhwb3J0IHR5cGUgVGltZSA9IEFzdGFsLlRpbWVcbmV4cG9ydCBjb25zdCBUaW1lID0gQXN0YWwuVGltZVxuXG5leHBvcnQgZnVuY3Rpb24gaW50ZXJ2YWwoaW50ZXJ2YWw6IG51bWJlciwgY2FsbGJhY2s/OiAoKSA9PiB2b2lkKSB7XG4gICAgcmV0dXJuIEFzdGFsLlRpbWUuaW50ZXJ2YWwoaW50ZXJ2YWwsICgpID0+IHZvaWQgY2FsbGJhY2s/LigpKVxufVxuXG5leHBvcnQgZnVuY3Rpb24gdGltZW91dCh0aW1lb3V0OiBudW1iZXIsIGNhbGxiYWNrPzogKCkgPT4gdm9pZCkge1xuICAgIHJldHVybiBBc3RhbC5UaW1lLnRpbWVvdXQodGltZW91dCwgKCkgPT4gdm9pZCBjYWxsYmFjaz8uKCkpXG59XG5cbmV4cG9ydCBmdW5jdGlvbiBpZGxlKGNhbGxiYWNrPzogKCkgPT4gdm9pZCkge1xuICAgIHJldHVybiBBc3RhbC5UaW1lLmlkbGUoKCkgPT4gdm9pZCBjYWxsYmFjaz8uKCkpXG59XG4iLCAiaW1wb3J0IEFzdGFsIGZyb20gXCJnaTovL0FzdGFsSU9cIlxuXG50eXBlIEFyZ3MgPSB7XG4gICAgY21kOiBzdHJpbmcgfCBzdHJpbmdbXVxuICAgIG91dD86IChzdGRvdXQ6IHN0cmluZykgPT4gdm9pZFxuICAgIGVycj86IChzdGRlcnI6IHN0cmluZykgPT4gdm9pZFxufVxuXG5leHBvcnQgdHlwZSBQcm9jZXNzID0gQXN0YWwuUHJvY2Vzc1xuZXhwb3J0IGNvbnN0IFByb2Nlc3MgPSBBc3RhbC5Qcm9jZXNzXG5cbmV4cG9ydCBmdW5jdGlvbiBzdWJwcm9jZXNzKGFyZ3M6IEFyZ3MpOiBBc3RhbC5Qcm9jZXNzXG5cbmV4cG9ydCBmdW5jdGlvbiBzdWJwcm9jZXNzKFxuICAgIGNtZDogc3RyaW5nIHwgc3RyaW5nW10sXG4gICAgb25PdXQ/OiAoc3Rkb3V0OiBzdHJpbmcpID0+IHZvaWQsXG4gICAgb25FcnI/OiAoc3RkZXJyOiBzdHJpbmcpID0+IHZvaWQsXG4pOiBBc3RhbC5Qcm9jZXNzXG5cbmV4cG9ydCBmdW5jdGlvbiBzdWJwcm9jZXNzKFxuICAgIGFyZ3NPckNtZDogQXJncyB8IHN0cmluZyB8IHN0cmluZ1tdLFxuICAgIG9uT3V0OiAoc3Rkb3V0OiBzdHJpbmcpID0+IHZvaWQgPSBwcmludCxcbiAgICBvbkVycjogKHN0ZGVycjogc3RyaW5nKSA9PiB2b2lkID0gcHJpbnRlcnIsXG4pIHtcbiAgICBjb25zdCBhcmdzID0gQXJyYXkuaXNBcnJheShhcmdzT3JDbWQpIHx8IHR5cGVvZiBhcmdzT3JDbWQgPT09IFwic3RyaW5nXCJcbiAgICBjb25zdCB7IGNtZCwgZXJyLCBvdXQgfSA9IHtcbiAgICAgICAgY21kOiBhcmdzID8gYXJnc09yQ21kIDogYXJnc09yQ21kLmNtZCxcbiAgICAgICAgZXJyOiBhcmdzID8gb25FcnIgOiBhcmdzT3JDbWQuZXJyIHx8IG9uRXJyLFxuICAgICAgICBvdXQ6IGFyZ3MgPyBvbk91dCA6IGFyZ3NPckNtZC5vdXQgfHwgb25PdXQsXG4gICAgfVxuXG4gICAgY29uc3QgcHJvYyA9IEFycmF5LmlzQXJyYXkoY21kKVxuICAgICAgICA/IEFzdGFsLlByb2Nlc3Muc3VicHJvY2Vzc3YoY21kKVxuICAgICAgICA6IEFzdGFsLlByb2Nlc3Muc3VicHJvY2VzcyhjbWQpXG5cbiAgICBwcm9jLmNvbm5lY3QoXCJzdGRvdXRcIiwgKF8sIHN0ZG91dDogc3RyaW5nKSA9PiBvdXQoc3Rkb3V0KSlcbiAgICBwcm9jLmNvbm5lY3QoXCJzdGRlcnJcIiwgKF8sIHN0ZGVycjogc3RyaW5nKSA9PiBlcnIoc3RkZXJyKSlcbiAgICByZXR1cm4gcHJvY1xufVxuXG4vKiogQHRocm93cyB7R0xpYi5FcnJvcn0gVGhyb3dzIHN0ZGVyciAqL1xuZXhwb3J0IGZ1bmN0aW9uIGV4ZWMoY21kOiBzdHJpbmcgfCBzdHJpbmdbXSkge1xuICAgIHJldHVybiBBcnJheS5pc0FycmF5KGNtZClcbiAgICAgICAgPyBBc3RhbC5Qcm9jZXNzLmV4ZWN2KGNtZClcbiAgICAgICAgOiBBc3RhbC5Qcm9jZXNzLmV4ZWMoY21kKVxufVxuXG5leHBvcnQgZnVuY3Rpb24gZXhlY0FzeW5jKGNtZDogc3RyaW5nIHwgc3RyaW5nW10pOiBQcm9taXNlPHN0cmluZz4ge1xuICAgIHJldHVybiBuZXcgUHJvbWlzZSgocmVzb2x2ZSwgcmVqZWN0KSA9PiB7XG4gICAgICAgIGlmIChBcnJheS5pc0FycmF5KGNtZCkpIHtcbiAgICAgICAgICAgIEFzdGFsLlByb2Nlc3MuZXhlY19hc3luY3YoY21kLCAoXywgcmVzKSA9PiB7XG4gICAgICAgICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgICAgICAgICAgcmVzb2x2ZShBc3RhbC5Qcm9jZXNzLmV4ZWNfYXN5bmN2X2ZpbmlzaChyZXMpKVxuICAgICAgICAgICAgICAgIH0gY2F0Y2ggKGVycm9yKSB7XG4gICAgICAgICAgICAgICAgICAgIHJlamVjdChlcnJvcilcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9KVxuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgQXN0YWwuUHJvY2Vzcy5leGVjX2FzeW5jKGNtZCwgKF8sIHJlcykgPT4ge1xuICAgICAgICAgICAgICAgIHRyeSB7XG4gICAgICAgICAgICAgICAgICAgIHJlc29sdmUoQXN0YWwuUHJvY2Vzcy5leGVjX2ZpbmlzaChyZXMpKVxuICAgICAgICAgICAgICAgIH0gY2F0Y2ggKGVycm9yKSB7XG4gICAgICAgICAgICAgICAgICAgIHJlamVjdChlcnJvcilcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9KVxuICAgICAgICB9XG4gICAgfSlcbn1cbiIsICJpbXBvcnQgVmFyaWFibGUgZnJvbSBcIi4vdmFyaWFibGUuanNcIlxuaW1wb3J0IHsgZXhlY0FzeW5jIH0gZnJvbSBcIi4vcHJvY2Vzcy5qc1wiXG5pbXBvcnQgQmluZGluZywgeyBDb25uZWN0YWJsZSwga2ViYWJpZnksIHNuYWtlaWZ5LCBTdWJzY3JpYmFibGUgfSBmcm9tIFwiLi9iaW5kaW5nLmpzXCJcblxuZXhwb3J0IGNvbnN0IG5vSW1wbGljaXREZXN0cm95ID0gU3ltYm9sKFwibm8gbm8gaW1wbGljaXQgZGVzdHJveVwiKVxuZXhwb3J0IGNvbnN0IHNldENoaWxkcmVuID0gU3ltYm9sKFwiY2hpbGRyZW4gc2V0dGVyIG1ldGhvZFwiKVxuXG5leHBvcnQgZnVuY3Rpb24gbWVyZ2VCaW5kaW5ncyhhcnJheTogYW55W10pIHtcbiAgICBmdW5jdGlvbiBnZXRWYWx1ZXMoLi4uYXJnczogYW55W10pIHtcbiAgICAgICAgbGV0IGkgPSAwXG4gICAgICAgIHJldHVybiBhcnJheS5tYXAodmFsdWUgPT4gdmFsdWUgaW5zdGFuY2VvZiBCaW5kaW5nXG4gICAgICAgICAgICA/IGFyZ3NbaSsrXVxuICAgICAgICAgICAgOiB2YWx1ZSxcbiAgICAgICAgKVxuICAgIH1cblxuICAgIGNvbnN0IGJpbmRpbmdzID0gYXJyYXkuZmlsdGVyKGkgPT4gaSBpbnN0YW5jZW9mIEJpbmRpbmcpXG5cbiAgICBpZiAoYmluZGluZ3MubGVuZ3RoID09PSAwKVxuICAgICAgICByZXR1cm4gYXJyYXlcblxuICAgIGlmIChiaW5kaW5ncy5sZW5ndGggPT09IDEpXG4gICAgICAgIHJldHVybiBiaW5kaW5nc1swXS5hcyhnZXRWYWx1ZXMpXG5cbiAgICByZXR1cm4gVmFyaWFibGUuZGVyaXZlKGJpbmRpbmdzLCBnZXRWYWx1ZXMpKClcbn1cblxuZXhwb3J0IGZ1bmN0aW9uIHNldFByb3Aob2JqOiBhbnksIHByb3A6IHN0cmluZywgdmFsdWU6IGFueSkge1xuICAgIHRyeSB7XG4gICAgICAgIGNvbnN0IHNldHRlciA9IGBzZXRfJHtzbmFrZWlmeShwcm9wKX1gXG4gICAgICAgIGlmICh0eXBlb2Ygb2JqW3NldHRlcl0gPT09IFwiZnVuY3Rpb25cIilcbiAgICAgICAgICAgIHJldHVybiBvYmpbc2V0dGVyXSh2YWx1ZSlcblxuICAgICAgICByZXR1cm4gKG9ialtwcm9wXSA9IHZhbHVlKVxuICAgIH0gY2F0Y2ggKGVycm9yKSB7XG4gICAgICAgIGNvbnNvbGUuZXJyb3IoYGNvdWxkIG5vdCBzZXQgcHJvcGVydHkgXCIke3Byb3B9XCIgb24gJHtvYmp9OmAsIGVycm9yKVxuICAgIH1cbn1cblxuZXhwb3J0IHR5cGUgQmluZGFibGVQcm9wczxUPiA9IHtcbiAgICBbSyBpbiBrZXlvZiBUXTogQmluZGluZzxUW0tdPiB8IFRbS107XG59XG5cbmV4cG9ydCBmdW5jdGlvbiBob29rPFdpZGdldCBleHRlbmRzIENvbm5lY3RhYmxlPihcbiAgICB3aWRnZXQ6IFdpZGdldCxcbiAgICBvYmplY3Q6IENvbm5lY3RhYmxlIHwgU3Vic2NyaWJhYmxlLFxuICAgIHNpZ25hbE9yQ2FsbGJhY2s6IHN0cmluZyB8ICgoc2VsZjogV2lkZ2V0LCAuLi5hcmdzOiBhbnlbXSkgPT4gdm9pZCksXG4gICAgY2FsbGJhY2s/OiAoc2VsZjogV2lkZ2V0LCAuLi5hcmdzOiBhbnlbXSkgPT4gdm9pZCxcbikge1xuICAgIGlmICh0eXBlb2Ygb2JqZWN0LmNvbm5lY3QgPT09IFwiZnVuY3Rpb25cIiAmJiBjYWxsYmFjaykge1xuICAgICAgICBjb25zdCBpZCA9IG9iamVjdC5jb25uZWN0KHNpZ25hbE9yQ2FsbGJhY2ssIChfOiBhbnksIC4uLmFyZ3M6IHVua25vd25bXSkgPT4ge1xuICAgICAgICAgICAgcmV0dXJuIGNhbGxiYWNrKHdpZGdldCwgLi4uYXJncylcbiAgICAgICAgfSlcbiAgICAgICAgd2lkZ2V0LmNvbm5lY3QoXCJkZXN0cm95XCIsICgpID0+IHtcbiAgICAgICAgICAgIChvYmplY3QuZGlzY29ubmVjdCBhcyBDb25uZWN0YWJsZVtcImRpc2Nvbm5lY3RcIl0pKGlkKVxuICAgICAgICB9KVxuICAgIH0gZWxzZSBpZiAodHlwZW9mIG9iamVjdC5zdWJzY3JpYmUgPT09IFwiZnVuY3Rpb25cIiAmJiB0eXBlb2Ygc2lnbmFsT3JDYWxsYmFjayA9PT0gXCJmdW5jdGlvblwiKSB7XG4gICAgICAgIGNvbnN0IHVuc3ViID0gb2JqZWN0LnN1YnNjcmliZSgoLi4uYXJnczogdW5rbm93bltdKSA9PiB7XG4gICAgICAgICAgICBzaWduYWxPckNhbGxiYWNrKHdpZGdldCwgLi4uYXJncylcbiAgICAgICAgfSlcbiAgICAgICAgd2lkZ2V0LmNvbm5lY3QoXCJkZXN0cm95XCIsIHVuc3ViKVxuICAgIH1cbn1cblxuZXhwb3J0IGZ1bmN0aW9uIGNvbnN0cnVjdDxXaWRnZXQgZXh0ZW5kcyBDb25uZWN0YWJsZSAmIHsgW3NldENoaWxkcmVuXTogKGNoaWxkcmVuOiBhbnlbXSkgPT4gdm9pZCB9Pih3aWRnZXQ6IFdpZGdldCwgY29uZmlnOiBhbnkpIHtcbiAgICAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgcHJlZmVyLWNvbnN0XG4gICAgbGV0IHsgc2V0dXAsIGNoaWxkLCBjaGlsZHJlbiA9IFtdLCAuLi5wcm9wcyB9ID0gY29uZmlnXG5cbiAgICBpZiAoY2hpbGRyZW4gaW5zdGFuY2VvZiBCaW5kaW5nKSB7XG4gICAgICAgIGNoaWxkcmVuID0gW2NoaWxkcmVuXVxuICAgIH1cblxuICAgIGlmIChjaGlsZCkge1xuICAgICAgICBjaGlsZHJlbi51bnNoaWZ0KGNoaWxkKVxuICAgIH1cblxuICAgIC8vIHJlbW92ZSB1bmRlZmluZWQgdmFsdWVzXG4gICAgZm9yIChjb25zdCBba2V5LCB2YWx1ZV0gb2YgT2JqZWN0LmVudHJpZXMocHJvcHMpKSB7XG4gICAgICAgIGlmICh2YWx1ZSA9PT0gdW5kZWZpbmVkKSB7XG4gICAgICAgICAgICBkZWxldGUgcHJvcHNba2V5XVxuICAgICAgICB9XG4gICAgfVxuXG4gICAgLy8gY29sbGVjdCBiaW5kaW5nc1xuICAgIGNvbnN0IGJpbmRpbmdzOiBBcnJheTxbc3RyaW5nLCBCaW5kaW5nPGFueT5dPiA9IE9iamVjdFxuICAgICAgICAua2V5cyhwcm9wcylcbiAgICAgICAgLnJlZHVjZSgoYWNjOiBhbnksIHByb3ApID0+IHtcbiAgICAgICAgICAgIGlmIChwcm9wc1twcm9wXSBpbnN0YW5jZW9mIEJpbmRpbmcpIHtcbiAgICAgICAgICAgICAgICBjb25zdCBiaW5kaW5nID0gcHJvcHNbcHJvcF1cbiAgICAgICAgICAgICAgICBkZWxldGUgcHJvcHNbcHJvcF1cbiAgICAgICAgICAgICAgICByZXR1cm4gWy4uLmFjYywgW3Byb3AsIGJpbmRpbmddXVxuICAgICAgICAgICAgfVxuICAgICAgICAgICAgcmV0dXJuIGFjY1xuICAgICAgICB9LCBbXSlcblxuICAgIC8vIGNvbGxlY3Qgc2lnbmFsIGhhbmRsZXJzXG4gICAgY29uc3Qgb25IYW5kbGVyczogQXJyYXk8W3N0cmluZywgc3RyaW5nIHwgKCgpID0+IHVua25vd24pXT4gPSBPYmplY3RcbiAgICAgICAgLmtleXMocHJvcHMpXG4gICAgICAgIC5yZWR1Y2UoKGFjYzogYW55LCBrZXkpID0+IHtcbiAgICAgICAgICAgIGlmIChrZXkuc3RhcnRzV2l0aChcIm9uXCIpKSB7XG4gICAgICAgICAgICAgICAgY29uc3Qgc2lnID0ga2ViYWJpZnkoa2V5KS5zcGxpdChcIi1cIikuc2xpY2UoMSkuam9pbihcIi1cIilcbiAgICAgICAgICAgICAgICBjb25zdCBoYW5kbGVyID0gcHJvcHNba2V5XVxuICAgICAgICAgICAgICAgIGRlbGV0ZSBwcm9wc1trZXldXG4gICAgICAgICAgICAgICAgcmV0dXJuIFsuLi5hY2MsIFtzaWcsIGhhbmRsZXJdXVxuICAgICAgICAgICAgfVxuICAgICAgICAgICAgcmV0dXJuIGFjY1xuICAgICAgICB9LCBbXSlcblxuICAgIC8vIHNldCBjaGlsZHJlblxuICAgIGNvbnN0IG1lcmdlZENoaWxkcmVuID0gbWVyZ2VCaW5kaW5ncyhjaGlsZHJlbi5mbGF0KEluZmluaXR5KSlcbiAgICBpZiAobWVyZ2VkQ2hpbGRyZW4gaW5zdGFuY2VvZiBCaW5kaW5nKSB7XG4gICAgICAgIHdpZGdldFtzZXRDaGlsZHJlbl0obWVyZ2VkQ2hpbGRyZW4uZ2V0KCkpXG4gICAgICAgIHdpZGdldC5jb25uZWN0KFwiZGVzdHJveVwiLCBtZXJnZWRDaGlsZHJlbi5zdWJzY3JpYmUoKHYpID0+IHtcbiAgICAgICAgICAgIHdpZGdldFtzZXRDaGlsZHJlbl0odilcbiAgICAgICAgfSkpXG4gICAgfSBlbHNlIHtcbiAgICAgICAgaWYgKG1lcmdlZENoaWxkcmVuLmxlbmd0aCA+IDApIHtcbiAgICAgICAgICAgIHdpZGdldFtzZXRDaGlsZHJlbl0obWVyZ2VkQ2hpbGRyZW4pXG4gICAgICAgIH1cbiAgICB9XG5cbiAgICAvLyBzZXR1cCBzaWduYWwgaGFuZGxlcnNcbiAgICBmb3IgKGNvbnN0IFtzaWduYWwsIGNhbGxiYWNrXSBvZiBvbkhhbmRsZXJzKSB7XG4gICAgICAgIGNvbnN0IHNpZyA9IHNpZ25hbC5zdGFydHNXaXRoKFwibm90aWZ5XCIpXG4gICAgICAgICAgICA/IHNpZ25hbC5yZXBsYWNlKFwiLVwiLCBcIjo6XCIpXG4gICAgICAgICAgICA6IHNpZ25hbFxuXG4gICAgICAgIGlmICh0eXBlb2YgY2FsbGJhY2sgPT09IFwiZnVuY3Rpb25cIikge1xuICAgICAgICAgICAgd2lkZ2V0LmNvbm5lY3Qoc2lnLCBjYWxsYmFjaylcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIHdpZGdldC5jb25uZWN0KHNpZywgKCkgPT4gZXhlY0FzeW5jKGNhbGxiYWNrKVxuICAgICAgICAgICAgICAgIC50aGVuKHByaW50KS5jYXRjaChjb25zb2xlLmVycm9yKSlcbiAgICAgICAgfVxuICAgIH1cblxuICAgIC8vIHNldHVwIGJpbmRpbmdzIGhhbmRsZXJzXG4gICAgZm9yIChjb25zdCBbcHJvcCwgYmluZGluZ10gb2YgYmluZGluZ3MpIHtcbiAgICAgICAgaWYgKHByb3AgPT09IFwiY2hpbGRcIiB8fCBwcm9wID09PSBcImNoaWxkcmVuXCIpIHtcbiAgICAgICAgICAgIHdpZGdldC5jb25uZWN0KFwiZGVzdHJveVwiLCBiaW5kaW5nLnN1YnNjcmliZSgodjogYW55KSA9PiB7XG4gICAgICAgICAgICAgICAgd2lkZ2V0W3NldENoaWxkcmVuXSh2KVxuICAgICAgICAgICAgfSkpXG4gICAgICAgIH1cbiAgICAgICAgd2lkZ2V0LmNvbm5lY3QoXCJkZXN0cm95XCIsIGJpbmRpbmcuc3Vic2NyaWJlKCh2OiBhbnkpID0+IHtcbiAgICAgICAgICAgIHNldFByb3Aod2lkZ2V0LCBwcm9wLCB2KVxuICAgICAgICB9KSlcbiAgICAgICAgc2V0UHJvcCh3aWRnZXQsIHByb3AsIGJpbmRpbmcuZ2V0KCkpXG4gICAgfVxuXG4gICAgLy8gZmlsdGVyIHVuZGVmaW5lZCB2YWx1ZXNcbiAgICBmb3IgKGNvbnN0IFtrZXksIHZhbHVlXSBvZiBPYmplY3QuZW50cmllcyhwcm9wcykpIHtcbiAgICAgICAgaWYgKHZhbHVlID09PSB1bmRlZmluZWQpIHtcbiAgICAgICAgICAgIGRlbGV0ZSBwcm9wc1trZXldXG4gICAgICAgIH1cbiAgICB9XG5cbiAgICBPYmplY3QuYXNzaWduKHdpZGdldCwgcHJvcHMpXG4gICAgc2V0dXA/Lih3aWRnZXQpXG4gICAgcmV0dXJuIHdpZGdldFxufVxuXG5mdW5jdGlvbiBpc0Fycm93RnVuY3Rpb24oZnVuYzogYW55KTogZnVuYyBpcyAoYXJnczogYW55KSA9PiBhbnkge1xuICAgIHJldHVybiAhT2JqZWN0Lmhhc093bihmdW5jLCBcInByb3RvdHlwZVwiKVxufVxuXG5leHBvcnQgZnVuY3Rpb24ganN4KFxuICAgIGN0b3JzOiBSZWNvcmQ8c3RyaW5nLCB7IG5ldyhwcm9wczogYW55KTogYW55IH0gfCAoKHByb3BzOiBhbnkpID0+IGFueSk+LFxuICAgIGN0b3I6IHN0cmluZyB8ICgocHJvcHM6IGFueSkgPT4gYW55KSB8IHsgbmV3KHByb3BzOiBhbnkpOiBhbnkgfSxcbiAgICB7IGNoaWxkcmVuLCAuLi5wcm9wcyB9OiBhbnksXG4pIHtcbiAgICBjaGlsZHJlbiA/Pz0gW11cblxuICAgIGlmICghQXJyYXkuaXNBcnJheShjaGlsZHJlbikpXG4gICAgICAgIGNoaWxkcmVuID0gW2NoaWxkcmVuXVxuXG4gICAgY2hpbGRyZW4gPSBjaGlsZHJlbi5maWx0ZXIoQm9vbGVhbilcblxuICAgIGlmIChjaGlsZHJlbi5sZW5ndGggPT09IDEpXG4gICAgICAgIHByb3BzLmNoaWxkID0gY2hpbGRyZW5bMF1cbiAgICBlbHNlIGlmIChjaGlsZHJlbi5sZW5ndGggPiAxKVxuICAgICAgICBwcm9wcy5jaGlsZHJlbiA9IGNoaWxkcmVuXG5cbiAgICBpZiAodHlwZW9mIGN0b3IgPT09IFwic3RyaW5nXCIpIHtcbiAgICAgICAgaWYgKGlzQXJyb3dGdW5jdGlvbihjdG9yc1tjdG9yXSkpXG4gICAgICAgICAgICByZXR1cm4gY3RvcnNbY3Rvcl0ocHJvcHMpXG5cbiAgICAgICAgcmV0dXJuIG5ldyBjdG9yc1tjdG9yXShwcm9wcylcbiAgICB9XG5cbiAgICBpZiAoaXNBcnJvd0Z1bmN0aW9uKGN0b3IpKVxuICAgICAgICByZXR1cm4gY3Rvcihwcm9wcylcblxuICAgIHJldHVybiBuZXcgY3Rvcihwcm9wcylcbn1cbiIsICJpbXBvcnQgeyBob29rLCBub0ltcGxpY2l0RGVzdHJveSwgc2V0Q2hpbGRyZW4sIG1lcmdlQmluZGluZ3MsIHR5cGUgQmluZGFibGVQcm9wcywgY29uc3RydWN0IH0gZnJvbSBcIi4uL19hc3RhbC5qc1wiXG5pbXBvcnQgQXN0YWwgZnJvbSBcImdpOi8vQXN0YWw/dmVyc2lvbj0zLjBcIlxuaW1wb3J0IEd0ayBmcm9tIFwiZ2k6Ly9HdGs/dmVyc2lvbj0zLjBcIlxuaW1wb3J0IEdkayBmcm9tIFwiZ2k6Ly9HZGs/dmVyc2lvbj0zLjBcIlxuaW1wb3J0IEdPYmplY3QgZnJvbSBcImdpOi8vR09iamVjdFwiXG5pbXBvcnQgR2lvIGZyb20gXCJnaTovL0dpbz92ZXJzaW9uPTIuMFwiXG5pbXBvcnQgQmluZGluZywgeyB0eXBlIENvbm5lY3RhYmxlLCB0eXBlIFN1YnNjcmliYWJsZSB9IGZyb20gXCIuLi9iaW5kaW5nLmpzXCJcblxuZXhwb3J0IHsgQmluZGFibGVQcm9wcywgbWVyZ2VCaW5kaW5ncyB9XG5cbmV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIGFzdGFsaWZ5PFxuICAgIEMgZXh0ZW5kcyB7IG5ldyguLi5hcmdzOiBhbnlbXSk6IEd0ay5XaWRnZXQgfSxcbj4oY2xzOiBDLCBjbHNOYW1lID0gY2xzLm5hbWUpIHtcbiAgICBjbGFzcyBXaWRnZXQgZXh0ZW5kcyBjbHMge1xuICAgICAgICBnZXQgY3NzKCk6IHN0cmluZyB7IHJldHVybiBBc3RhbC53aWRnZXRfZ2V0X2Nzcyh0aGlzKSB9XG4gICAgICAgIHNldCBjc3MoY3NzOiBzdHJpbmcpIHsgQXN0YWwud2lkZ2V0X3NldF9jc3ModGhpcywgY3NzKSB9XG4gICAgICAgIGdldF9jc3MoKTogc3RyaW5nIHsgcmV0dXJuIHRoaXMuY3NzIH1cbiAgICAgICAgc2V0X2Nzcyhjc3M6IHN0cmluZykgeyB0aGlzLmNzcyA9IGNzcyB9XG5cbiAgICAgICAgZ2V0IGNsYXNzTmFtZSgpOiBzdHJpbmcgeyByZXR1cm4gQXN0YWwud2lkZ2V0X2dldF9jbGFzc19uYW1lcyh0aGlzKS5qb2luKFwiIFwiKSB9XG4gICAgICAgIHNldCBjbGFzc05hbWUoY2xhc3NOYW1lOiBzdHJpbmcpIHsgQXN0YWwud2lkZ2V0X3NldF9jbGFzc19uYW1lcyh0aGlzLCBjbGFzc05hbWUuc3BsaXQoL1xccysvKSkgfVxuICAgICAgICBnZXRfY2xhc3NfbmFtZSgpOiBzdHJpbmcgeyByZXR1cm4gdGhpcy5jbGFzc05hbWUgfVxuICAgICAgICBzZXRfY2xhc3NfbmFtZShjbGFzc05hbWU6IHN0cmluZykgeyB0aGlzLmNsYXNzTmFtZSA9IGNsYXNzTmFtZSB9XG5cbiAgICAgICAgZ2V0IGN1cnNvcigpOiBDdXJzb3IgeyByZXR1cm4gQXN0YWwud2lkZ2V0X2dldF9jdXJzb3IodGhpcykgYXMgQ3Vyc29yIH1cbiAgICAgICAgc2V0IGN1cnNvcihjdXJzb3I6IEN1cnNvcikgeyBBc3RhbC53aWRnZXRfc2V0X2N1cnNvcih0aGlzLCBjdXJzb3IpIH1cbiAgICAgICAgZ2V0X2N1cnNvcigpOiBDdXJzb3IgeyByZXR1cm4gdGhpcy5jdXJzb3IgfVxuICAgICAgICBzZXRfY3Vyc29yKGN1cnNvcjogQ3Vyc29yKSB7IHRoaXMuY3Vyc29yID0gY3Vyc29yIH1cblxuICAgICAgICBnZXQgY2xpY2tUaHJvdWdoKCk6IGJvb2xlYW4geyByZXR1cm4gQXN0YWwud2lkZ2V0X2dldF9jbGlja190aHJvdWdoKHRoaXMpIH1cbiAgICAgICAgc2V0IGNsaWNrVGhyb3VnaChjbGlja1Rocm91Z2g6IGJvb2xlYW4pIHsgQXN0YWwud2lkZ2V0X3NldF9jbGlja190aHJvdWdoKHRoaXMsIGNsaWNrVGhyb3VnaCkgfVxuICAgICAgICBnZXRfY2xpY2tfdGhyb3VnaCgpOiBib29sZWFuIHsgcmV0dXJuIHRoaXMuY2xpY2tUaHJvdWdoIH1cbiAgICAgICAgc2V0X2NsaWNrX3Rocm91Z2goY2xpY2tUaHJvdWdoOiBib29sZWFuKSB7IHRoaXMuY2xpY2tUaHJvdWdoID0gY2xpY2tUaHJvdWdoIH1cblxuICAgICAgICBkZWNsYXJlIHByaXZhdGUgW25vSW1wbGljaXREZXN0cm95XTogYm9vbGVhblxuICAgICAgICBnZXQgbm9JbXBsaWNpdERlc3Ryb3koKTogYm9vbGVhbiB7IHJldHVybiB0aGlzW25vSW1wbGljaXREZXN0cm95XSB9XG4gICAgICAgIHNldCBub0ltcGxpY2l0RGVzdHJveSh2YWx1ZTogYm9vbGVhbikgeyB0aGlzW25vSW1wbGljaXREZXN0cm95XSA9IHZhbHVlIH1cblxuICAgICAgICBzZXQgYWN0aW9uR3JvdXAoW3ByZWZpeCwgZ3JvdXBdOiBBY3Rpb25Hcm91cCkgeyB0aGlzLmluc2VydF9hY3Rpb25fZ3JvdXAocHJlZml4LCBncm91cCkgfVxuICAgICAgICBzZXRfYWN0aW9uX2dyb3VwKGFjdGlvbkdyb3VwOiBBY3Rpb25Hcm91cCkgeyB0aGlzLmFjdGlvbkdyb3VwID0gYWN0aW9uR3JvdXAgfVxuXG4gICAgICAgIHByb3RlY3RlZCBnZXRDaGlsZHJlbigpOiBBcnJheTxHdGsuV2lkZ2V0PiB7XG4gICAgICAgICAgICBpZiAodGhpcyBpbnN0YW5jZW9mIEd0ay5CaW4pIHtcbiAgICAgICAgICAgICAgICByZXR1cm4gdGhpcy5nZXRfY2hpbGQoKSA/IFt0aGlzLmdldF9jaGlsZCgpIV0gOiBbXVxuICAgICAgICAgICAgfSBlbHNlIGlmICh0aGlzIGluc3RhbmNlb2YgR3RrLkNvbnRhaW5lcikge1xuICAgICAgICAgICAgICAgIHJldHVybiB0aGlzLmdldF9jaGlsZHJlbigpXG4gICAgICAgICAgICB9XG4gICAgICAgICAgICByZXR1cm4gW11cbiAgICAgICAgfVxuXG4gICAgICAgIHByb3RlY3RlZCBzZXRDaGlsZHJlbihjaGlsZHJlbjogYW55W10pIHtcbiAgICAgICAgICAgIGNoaWxkcmVuID0gY2hpbGRyZW4uZmxhdChJbmZpbml0eSkubWFwKGNoID0+IGNoIGluc3RhbmNlb2YgR3RrLldpZGdldFxuICAgICAgICAgICAgICAgID8gY2hcbiAgICAgICAgICAgICAgICA6IG5ldyBHdGsuTGFiZWwoeyB2aXNpYmxlOiB0cnVlLCBsYWJlbDogU3RyaW5nKGNoKSB9KSlcblxuICAgICAgICAgICAgaWYgKHRoaXMgaW5zdGFuY2VvZiBHdGsuQ29udGFpbmVyKSB7XG4gICAgICAgICAgICAgICAgZm9yIChjb25zdCBjaCBvZiBjaGlsZHJlbilcbiAgICAgICAgICAgICAgICAgICAgdGhpcy5hZGQoY2gpXG4gICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgIHRocm93IEVycm9yKGBjYW4gbm90IGFkZCBjaGlsZHJlbiB0byAke3RoaXMuY29uc3RydWN0b3IubmFtZX1gKVxuICAgICAgICAgICAgfVxuICAgICAgICB9XG5cbiAgICAgICAgW3NldENoaWxkcmVuXShjaGlsZHJlbjogYW55W10pIHtcbiAgICAgICAgICAgIC8vIHJlbW92ZVxuICAgICAgICAgICAgaWYgKHRoaXMgaW5zdGFuY2VvZiBHdGsuQ29udGFpbmVyKSB7XG4gICAgICAgICAgICAgICAgZm9yIChjb25zdCBjaCBvZiB0aGlzLmdldENoaWxkcmVuKCkpIHtcbiAgICAgICAgICAgICAgICAgICAgdGhpcy5yZW1vdmUoY2gpXG4gICAgICAgICAgICAgICAgICAgIGlmICghY2hpbGRyZW4uaW5jbHVkZXMoY2gpICYmICF0aGlzLm5vSW1wbGljaXREZXN0cm95KVxuICAgICAgICAgICAgICAgICAgICAgICAgY2g/LmRlc3Ryb3koKVxuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgLy8gYXBwZW5kXG4gICAgICAgICAgICB0aGlzLnNldENoaWxkcmVuKGNoaWxkcmVuKVxuICAgICAgICB9XG5cbiAgICAgICAgdG9nZ2xlQ2xhc3NOYW1lKGNuOiBzdHJpbmcsIGNvbmQgPSB0cnVlKSB7XG4gICAgICAgICAgICBBc3RhbC53aWRnZXRfdG9nZ2xlX2NsYXNzX25hbWUodGhpcywgY24sIGNvbmQpXG4gICAgICAgIH1cblxuICAgICAgICBob29rKFxuICAgICAgICAgICAgb2JqZWN0OiBDb25uZWN0YWJsZSxcbiAgICAgICAgICAgIHNpZ25hbDogc3RyaW5nLFxuICAgICAgICAgICAgY2FsbGJhY2s6IChzZWxmOiB0aGlzLCAuLi5hcmdzOiBhbnlbXSkgPT4gdm9pZCxcbiAgICAgICAgKTogdGhpc1xuICAgICAgICBob29rKFxuICAgICAgICAgICAgb2JqZWN0OiBTdWJzY3JpYmFibGUsXG4gICAgICAgICAgICBjYWxsYmFjazogKHNlbGY6IHRoaXMsIC4uLmFyZ3M6IGFueVtdKSA9PiB2b2lkLFxuICAgICAgICApOiB0aGlzXG4gICAgICAgIGhvb2soXG4gICAgICAgICAgICBvYmplY3Q6IENvbm5lY3RhYmxlIHwgU3Vic2NyaWJhYmxlLFxuICAgICAgICAgICAgc2lnbmFsT3JDYWxsYmFjazogc3RyaW5nIHwgKChzZWxmOiB0aGlzLCAuLi5hcmdzOiBhbnlbXSkgPT4gdm9pZCksXG4gICAgICAgICAgICBjYWxsYmFjaz86IChzZWxmOiB0aGlzLCAuLi5hcmdzOiBhbnlbXSkgPT4gdm9pZCxcbiAgICAgICAgKSB7XG4gICAgICAgICAgICBob29rKHRoaXMsIG9iamVjdCwgc2lnbmFsT3JDYWxsYmFjaywgY2FsbGJhY2spXG4gICAgICAgICAgICByZXR1cm4gdGhpc1xuICAgICAgICB9XG5cbiAgICAgICAgY29uc3RydWN0b3IoLi4ucGFyYW1zOiBhbnlbXSkge1xuICAgICAgICAgICAgc3VwZXIoKVxuICAgICAgICAgICAgY29uc3QgcHJvcHMgPSBwYXJhbXNbMF0gfHwge31cbiAgICAgICAgICAgIHByb3BzLnZpc2libGUgPz89IHRydWVcbiAgICAgICAgICAgIGNvbnN0cnVjdCh0aGlzLCBwcm9wcylcbiAgICAgICAgfVxuICAgIH1cblxuICAgIEdPYmplY3QucmVnaXN0ZXJDbGFzcyh7XG4gICAgICAgIEdUeXBlTmFtZTogYEFzdGFsXyR7Y2xzTmFtZX1gLFxuICAgICAgICBQcm9wZXJ0aWVzOiB7XG4gICAgICAgICAgICBcImNsYXNzLW5hbWVcIjogR09iamVjdC5QYXJhbVNwZWMuc3RyaW5nKFxuICAgICAgICAgICAgICAgIFwiY2xhc3MtbmFtZVwiLCBcIlwiLCBcIlwiLCBHT2JqZWN0LlBhcmFtRmxhZ3MuUkVBRFdSSVRFLCBcIlwiLFxuICAgICAgICAgICAgKSxcbiAgICAgICAgICAgIFwiY3NzXCI6IEdPYmplY3QuUGFyYW1TcGVjLnN0cmluZyhcbiAgICAgICAgICAgICAgICBcImNzc1wiLCBcIlwiLCBcIlwiLCBHT2JqZWN0LlBhcmFtRmxhZ3MuUkVBRFdSSVRFLCBcIlwiLFxuICAgICAgICAgICAgKSxcbiAgICAgICAgICAgIFwiY3Vyc29yXCI6IEdPYmplY3QuUGFyYW1TcGVjLnN0cmluZyhcbiAgICAgICAgICAgICAgICBcImN1cnNvclwiLCBcIlwiLCBcIlwiLCBHT2JqZWN0LlBhcmFtRmxhZ3MuUkVBRFdSSVRFLCBcImRlZmF1bHRcIixcbiAgICAgICAgICAgICksXG4gICAgICAgICAgICBcImNsaWNrLXRocm91Z2hcIjogR09iamVjdC5QYXJhbVNwZWMuYm9vbGVhbihcbiAgICAgICAgICAgICAgICBcImNsaWNrLXRocm91Z2hcIiwgXCJcIiwgXCJcIiwgR09iamVjdC5QYXJhbUZsYWdzLlJFQURXUklURSwgZmFsc2UsXG4gICAgICAgICAgICApLFxuICAgICAgICAgICAgXCJuby1pbXBsaWNpdC1kZXN0cm95XCI6IEdPYmplY3QuUGFyYW1TcGVjLmJvb2xlYW4oXG4gICAgICAgICAgICAgICAgXCJuby1pbXBsaWNpdC1kZXN0cm95XCIsIFwiXCIsIFwiXCIsIEdPYmplY3QuUGFyYW1GbGFncy5SRUFEV1JJVEUsIGZhbHNlLFxuICAgICAgICAgICAgKSxcbiAgICAgICAgfSxcbiAgICB9LCBXaWRnZXQpXG5cbiAgICByZXR1cm4gV2lkZ2V0XG59XG5cbnR5cGUgU2lnSGFuZGxlcjxcbiAgICBXIGV4dGVuZHMgSW5zdGFuY2VUeXBlPHR5cGVvZiBHdGsuV2lkZ2V0PixcbiAgICBBcmdzIGV4dGVuZHMgQXJyYXk8dW5rbm93bj4sXG4+ID0gKChzZWxmOiBXLCAuLi5hcmdzOiBBcmdzKSA9PiB1bmtub3duKSB8IHN0cmluZyB8IHN0cmluZ1tdXG5cbmV4cG9ydCB0eXBlIEJpbmRhYmxlQ2hpbGQgPSBHdGsuV2lkZ2V0IHwgQmluZGluZzxHdGsuV2lkZ2V0PlxuXG5leHBvcnQgdHlwZSBDb25zdHJ1Y3RQcm9wczxcbiAgICBTZWxmIGV4dGVuZHMgSW5zdGFuY2VUeXBlPHR5cGVvZiBHdGsuV2lkZ2V0PixcbiAgICBQcm9wcyBleHRlbmRzIEd0ay5XaWRnZXQuQ29uc3RydWN0b3JQcm9wcyxcbiAgICBTaWduYWxzIGV4dGVuZHMgUmVjb3JkPGBvbiR7c3RyaW5nfWAsIEFycmF5PHVua25vd24+PiA9IFJlY29yZDxgb24ke3N0cmluZ31gLCBhbnlbXT4sXG4+ID0gUGFydGlhbDx7XG4gICAgLy8gQHRzLWV4cGVjdC1lcnJvciBjYW4ndCBhc3NpZ24gdG8gdW5rbm93biwgYnV0IGl0IHdvcmtzIGFzIGV4cGVjdGVkIHRob3VnaFxuICAgIFtTIGluIGtleW9mIFNpZ25hbHNdOiBTaWdIYW5kbGVyPFNlbGYsIFNpZ25hbHNbU10+XG59PiAmIFBhcnRpYWw8e1xuICAgIFtLZXkgaW4gYG9uJHtzdHJpbmd9YF06IFNpZ0hhbmRsZXI8U2VsZiwgYW55W10+XG59PiAmIEJpbmRhYmxlUHJvcHM8UGFydGlhbDxQcm9wcyAmIHtcbiAgICBjbGFzc05hbWU/OiBzdHJpbmdcbiAgICBjc3M/OiBzdHJpbmdcbiAgICBjdXJzb3I/OiBzdHJpbmdcbiAgICBjbGlja1Rocm91Z2g/OiBib29sZWFuXG4gICAgYWN0aW9uR3JvdXA/OiBBY3Rpb25Hcm91cFxufT4+ICYgUGFydGlhbDx7XG4gICAgb25EZXN0cm95OiAoc2VsZjogU2VsZikgPT4gdW5rbm93blxuICAgIG9uRHJhdzogKHNlbGY6IFNlbGYpID0+IHVua25vd25cbiAgICBvbktleVByZXNzRXZlbnQ6IChzZWxmOiBTZWxmLCBldmVudDogR2RrLkV2ZW50KSA9PiB1bmtub3duXG4gICAgb25LZXlSZWxlYXNlRXZlbnQ6IChzZWxmOiBTZWxmLCBldmVudDogR2RrLkV2ZW50KSA9PiB1bmtub3duXG4gICAgb25CdXR0b25QcmVzc0V2ZW50OiAoc2VsZjogU2VsZiwgZXZlbnQ6IEdkay5FdmVudCkgPT4gdW5rbm93blxuICAgIG9uQnV0dG9uUmVsZWFzZUV2ZW50OiAoc2VsZjogU2VsZiwgZXZlbnQ6IEdkay5FdmVudCkgPT4gdW5rbm93blxuICAgIG9uUmVhbGl6ZTogKHNlbGY6IFNlbGYpID0+IHVua25vd25cbiAgICBzZXR1cDogKHNlbGY6IFNlbGYpID0+IHZvaWRcbn0+XG5cbnR5cGUgQ3Vyc29yID1cbiAgICB8IFwiZGVmYXVsdFwiXG4gICAgfCBcImhlbHBcIlxuICAgIHwgXCJwb2ludGVyXCJcbiAgICB8IFwiY29udGV4dC1tZW51XCJcbiAgICB8IFwicHJvZ3Jlc3NcIlxuICAgIHwgXCJ3YWl0XCJcbiAgICB8IFwiY2VsbFwiXG4gICAgfCBcImNyb3NzaGFpclwiXG4gICAgfCBcInRleHRcIlxuICAgIHwgXCJ2ZXJ0aWNhbC10ZXh0XCJcbiAgICB8IFwiYWxpYXNcIlxuICAgIHwgXCJjb3B5XCJcbiAgICB8IFwibm8tZHJvcFwiXG4gICAgfCBcIm1vdmVcIlxuICAgIHwgXCJub3QtYWxsb3dlZFwiXG4gICAgfCBcImdyYWJcIlxuICAgIHwgXCJncmFiYmluZ1wiXG4gICAgfCBcImFsbC1zY3JvbGxcIlxuICAgIHwgXCJjb2wtcmVzaXplXCJcbiAgICB8IFwicm93LXJlc2l6ZVwiXG4gICAgfCBcIm4tcmVzaXplXCJcbiAgICB8IFwiZS1yZXNpemVcIlxuICAgIHwgXCJzLXJlc2l6ZVwiXG4gICAgfCBcInctcmVzaXplXCJcbiAgICB8IFwibmUtcmVzaXplXCJcbiAgICB8IFwibnctcmVzaXplXCJcbiAgICB8IFwic3ctcmVzaXplXCJcbiAgICB8IFwic2UtcmVzaXplXCJcbiAgICB8IFwiZXctcmVzaXplXCJcbiAgICB8IFwibnMtcmVzaXplXCJcbiAgICB8IFwibmVzdy1yZXNpemVcIlxuICAgIHwgXCJud3NlLXJlc2l6ZVwiXG4gICAgfCBcInpvb20taW5cIlxuICAgIHwgXCJ6b29tLW91dFwiXG5cbnR5cGUgQWN0aW9uR3JvdXAgPSBbcHJlZml4OiBzdHJpbmcsIGFjdGlvbkdyb3VwOiBHaW8uQWN0aW9uR3JvdXBdXG4iLCAiaW1wb3J0IEd0ayBmcm9tIFwiZ2k6Ly9HdGs/dmVyc2lvbj0zLjBcIlxuaW1wb3J0IEFzdGFsIGZyb20gXCJnaTovL0FzdGFsP3ZlcnNpb249My4wXCJcbmltcG9ydCB7IG1rQXBwIH0gZnJvbSBcIi4uL19hcHBcIlxuXG5HdGsuaW5pdChudWxsKVxuXG5leHBvcnQgZGVmYXVsdCBta0FwcChBc3RhbC5BcHBsaWNhdGlvbilcbiIsICIvKipcbiAqIFdvcmthcm91bmQgZm9yIFwiQ2FuJ3QgY29udmVydCBub24tbnVsbCBwb2ludGVyIHRvIEpTIHZhbHVlIFwiXG4gKi9cblxuZXhwb3J0IHsgfVxuXG5jb25zdCBzbmFrZWlmeSA9IChzdHI6IHN0cmluZykgPT4gc3RyXG4gICAgLnJlcGxhY2UoLyhbYS16XSkoW0EtWl0pL2csIFwiJDFfJDJcIilcbiAgICAucmVwbGFjZUFsbChcIi1cIiwgXCJfXCIpXG4gICAgLnRvTG93ZXJDYXNlKClcblxuYXN5bmMgZnVuY3Rpb24gc3VwcHJlc3M8VD4obW9kOiBQcm9taXNlPHsgZGVmYXVsdDogVCB9PiwgcGF0Y2g6IChtOiBUKSA9PiB2b2lkKSB7XG4gICAgcmV0dXJuIG1vZC50aGVuKG0gPT4gcGF0Y2gobS5kZWZhdWx0KSkuY2F0Y2goKCkgPT4gdm9pZCAwKVxufVxuXG5mdW5jdGlvbiBwYXRjaDxQIGV4dGVuZHMgb2JqZWN0Pihwcm90bzogUCwgcHJvcDogRXh0cmFjdDxrZXlvZiBQLCBzdHJpbmc+KSB7XG4gICAgT2JqZWN0LmRlZmluZVByb3BlcnR5KHByb3RvLCBwcm9wLCB7XG4gICAgICAgIGdldCgpIHsgcmV0dXJuIHRoaXNbYGdldF8ke3NuYWtlaWZ5KHByb3ApfWBdKCkgfSxcbiAgICB9KVxufVxuXG5hd2FpdCBzdXBwcmVzcyhpbXBvcnQoXCJnaTovL0FzdGFsQXBwc1wiKSwgKHsgQXBwcywgQXBwbGljYXRpb24gfSkgPT4ge1xuICAgIHBhdGNoKEFwcHMucHJvdG90eXBlLCBcImxpc3RcIilcbiAgICBwYXRjaChBcHBsaWNhdGlvbi5wcm90b3R5cGUsIFwia2V5d29yZHNcIilcbiAgICBwYXRjaChBcHBsaWNhdGlvbi5wcm90b3R5cGUsIFwiY2F0ZWdvcmllc1wiKVxufSlcblxuYXdhaXQgc3VwcHJlc3MoaW1wb3J0KFwiZ2k6Ly9Bc3RhbEJhdHRlcnlcIiksICh7IFVQb3dlciB9KSA9PiB7XG4gICAgcGF0Y2goVVBvd2VyLnByb3RvdHlwZSwgXCJkZXZpY2VzXCIpXG59KVxuXG5hd2FpdCBzdXBwcmVzcyhpbXBvcnQoXCJnaTovL0FzdGFsQmx1ZXRvb3RoXCIpLCAoeyBBZGFwdGVyLCBCbHVldG9vdGgsIERldmljZSB9KSA9PiB7XG4gICAgcGF0Y2goQWRhcHRlci5wcm90b3R5cGUsIFwidXVpZHNcIilcbiAgICBwYXRjaChCbHVldG9vdGgucHJvdG90eXBlLCBcImFkYXB0ZXJzXCIpXG4gICAgcGF0Y2goQmx1ZXRvb3RoLnByb3RvdHlwZSwgXCJkZXZpY2VzXCIpXG4gICAgcGF0Y2goRGV2aWNlLnByb3RvdHlwZSwgXCJ1dWlkc1wiKVxufSlcblxuYXdhaXQgc3VwcHJlc3MoaW1wb3J0KFwiZ2k6Ly9Bc3RhbEh5cHJsYW5kXCIpLCAoeyBIeXBybGFuZCwgTW9uaXRvciwgV29ya3NwYWNlIH0pID0+IHtcbiAgICBwYXRjaChIeXBybGFuZC5wcm90b3R5cGUsIFwiYmluZHNcIilcbiAgICBwYXRjaChIeXBybGFuZC5wcm90b3R5cGUsIFwibW9uaXRvcnNcIilcbiAgICBwYXRjaChIeXBybGFuZC5wcm90b3R5cGUsIFwid29ya3NwYWNlc1wiKVxuICAgIHBhdGNoKEh5cHJsYW5kLnByb3RvdHlwZSwgXCJjbGllbnRzXCIpXG4gICAgcGF0Y2goTW9uaXRvci5wcm90b3R5cGUsIFwiYXZhaWxhYmxlTW9kZXNcIilcbiAgICBwYXRjaChNb25pdG9yLnByb3RvdHlwZSwgXCJhdmFpbGFibGVfbW9kZXNcIilcbiAgICBwYXRjaChXb3Jrc3BhY2UucHJvdG90eXBlLCBcImNsaWVudHNcIilcbn0pXG5cbmF3YWl0IHN1cHByZXNzKGltcG9ydChcImdpOi8vQXN0YWxNcHJpc1wiKSwgKHsgTXByaXMsIFBsYXllciB9KSA9PiB7XG4gICAgcGF0Y2goTXByaXMucHJvdG90eXBlLCBcInBsYXllcnNcIilcbiAgICBwYXRjaChQbGF5ZXIucHJvdG90eXBlLCBcInN1cHBvcnRlZF91cmlfc2NoZW1lc1wiKVxuICAgIHBhdGNoKFBsYXllci5wcm90b3R5cGUsIFwic3VwcG9ydGVkVXJpU2NoZW1lc1wiKVxuICAgIHBhdGNoKFBsYXllci5wcm90b3R5cGUsIFwic3VwcG9ydGVkX21pbWVfdHlwZXNcIilcbiAgICBwYXRjaChQbGF5ZXIucHJvdG90eXBlLCBcInN1cHBvcnRlZE1pbWVUeXBlc1wiKVxuICAgIHBhdGNoKFBsYXllci5wcm90b3R5cGUsIFwiY29tbWVudHNcIilcbn0pXG5cbmF3YWl0IHN1cHByZXNzKGltcG9ydChcImdpOi8vQXN0YWxOZXR3b3JrXCIpLCAoeyBXaWZpIH0pID0+IHtcbiAgICBwYXRjaChXaWZpLnByb3RvdHlwZSwgXCJhY2Nlc3NfcG9pbnRzXCIpXG4gICAgcGF0Y2goV2lmaS5wcm90b3R5cGUsIFwiYWNjZXNzUG9pbnRzXCIpXG59KVxuXG5hd2FpdCBzdXBwcmVzcyhpbXBvcnQoXCJnaTovL0FzdGFsTm90aWZkXCIpLCAoeyBOb3RpZmQsIE5vdGlmaWNhdGlvbiB9KSA9PiB7XG4gICAgcGF0Y2goTm90aWZkLnByb3RvdHlwZSwgXCJub3RpZmljYXRpb25zXCIpXG4gICAgcGF0Y2goTm90aWZpY2F0aW9uLnByb3RvdHlwZSwgXCJhY3Rpb25zXCIpXG59KVxuXG5hd2FpdCBzdXBwcmVzcyhpbXBvcnQoXCJnaTovL0FzdGFsUG93ZXJQcm9maWxlc1wiKSwgKHsgUG93ZXJQcm9maWxlcyB9KSA9PiB7XG4gICAgcGF0Y2goUG93ZXJQcm9maWxlcy5wcm90b3R5cGUsIFwiYWN0aW9uc1wiKVxufSlcblxuYXdhaXQgc3VwcHJlc3MoaW1wb3J0KFwiZ2k6Ly9Bc3RhbFdwXCIpLCAoeyBXcCwgQXVkaW8sIFZpZGVvIH0pID0+IHtcbiAgICBwYXRjaChXcC5wcm90b3R5cGUsIFwiZW5kcG9pbnRzXCIpXG4gICAgcGF0Y2goV3AucHJvdG90eXBlLCBcImRldmljZXNcIilcbiAgICBwYXRjaChBdWRpby5wcm90b3R5cGUsIFwic3RyZWFtc1wiKVxuICAgIHBhdGNoKEF1ZGlvLnByb3RvdHlwZSwgXCJyZWNvcmRlcnNcIilcbiAgICBwYXRjaChBdWRpby5wcm90b3R5cGUsIFwibWljcm9waG9uZXNcIilcbiAgICBwYXRjaChBdWRpby5wcm90b3R5cGUsIFwic3BlYWtlcnNcIilcbiAgICBwYXRjaChBdWRpby5wcm90b3R5cGUsIFwiZGV2aWNlc1wiKVxuICAgIHBhdGNoKFZpZGVvLnByb3RvdHlwZSwgXCJzdHJlYW1zXCIpXG4gICAgcGF0Y2goVmlkZW8ucHJvdG90eXBlLCBcInJlY29yZGVyc1wiKVxuICAgIHBhdGNoKFZpZGVvLnByb3RvdHlwZSwgXCJzaW5rc1wiKVxuICAgIHBhdGNoKFZpZGVvLnByb3RvdHlwZSwgXCJzb3VyY2VzXCIpXG4gICAgcGF0Y2goVmlkZW8ucHJvdG90eXBlLCBcImRldmljZXNcIilcbn0pXG4iLCAiaW1wb3J0IFwiLi9vdmVycmlkZXMuanNcIlxuaW1wb3J0IHsgc2V0Q29uc29sZUxvZ0RvbWFpbiB9IGZyb20gXCJjb25zb2xlXCJcbmltcG9ydCB7IGV4aXQsIHByb2dyYW1BcmdzIH0gZnJvbSBcInN5c3RlbVwiXG5pbXBvcnQgSU8gZnJvbSBcImdpOi8vQXN0YWxJT1wiXG5pbXBvcnQgR09iamVjdCBmcm9tIFwiZ2k6Ly9HT2JqZWN0XCJcbmltcG9ydCBHaW8gZnJvbSBcImdpOi8vR2lvP3ZlcnNpb249Mi4wXCJcbmltcG9ydCB0eXBlIEFzdGFsMyBmcm9tIFwiZ2k6Ly9Bc3RhbD92ZXJzaW9uPTMuMFwiXG5pbXBvcnQgdHlwZSBBc3RhbDQgZnJvbSBcImdpOi8vQXN0YWw/dmVyc2lvbj00LjBcIlxuXG50eXBlIENvbmZpZyA9IFBhcnRpYWw8e1xuICAgIGluc3RhbmNlTmFtZTogc3RyaW5nXG4gICAgY3NzOiBzdHJpbmdcbiAgICBpY29uczogc3RyaW5nXG4gICAgZ3RrVGhlbWU6IHN0cmluZ1xuICAgIGljb25UaGVtZTogc3RyaW5nXG4gICAgY3Vyc29yVGhlbWU6IHN0cmluZ1xuICAgIGhvbGQ6IGJvb2xlYW5cbiAgICByZXF1ZXN0SGFuZGxlcihyZXF1ZXN0OiBzdHJpbmcsIHJlczogKHJlc3BvbnNlOiBhbnkpID0+IHZvaWQpOiB2b2lkXG4gICAgbWFpbiguLi5hcmdzOiBzdHJpbmdbXSk6IHZvaWRcbiAgICBjbGllbnQobWVzc2FnZTogKG1zZzogc3RyaW5nKSA9PiBzdHJpbmcsIC4uLmFyZ3M6IHN0cmluZ1tdKTogdm9pZFxufT5cblxuaW50ZXJmYWNlIEFzdGFsM0pTIGV4dGVuZHMgQXN0YWwzLkFwcGxpY2F0aW9uIHtcbiAgICBldmFsKGJvZHk6IHN0cmluZyk6IFByb21pc2U8YW55PlxuICAgIHJlcXVlc3RIYW5kbGVyOiBDb25maWdbXCJyZXF1ZXN0SGFuZGxlclwiXVxuICAgIGFwcGx5X2NzcyhzdHlsZTogc3RyaW5nLCByZXNldD86IGJvb2xlYW4pOiB2b2lkXG4gICAgcXVpdChjb2RlPzogbnVtYmVyKTogdm9pZFxuICAgIHN0YXJ0KGNvbmZpZz86IENvbmZpZyk6IHZvaWRcbn1cblxuaW50ZXJmYWNlIEFzdGFsNEpTIGV4dGVuZHMgQXN0YWw0LkFwcGxpY2F0aW9uIHtcbiAgICBldmFsKGJvZHk6IHN0cmluZyk6IFByb21pc2U8YW55PlxuICAgIHJlcXVlc3RIYW5kbGVyPzogQ29uZmlnW1wicmVxdWVzdEhhbmRsZXJcIl1cbiAgICBhcHBseV9jc3Moc3R5bGU6IHN0cmluZywgcmVzZXQ/OiBib29sZWFuKTogdm9pZFxuICAgIHF1aXQoY29kZT86IG51bWJlcik6IHZvaWRcbiAgICBzdGFydChjb25maWc/OiBDb25maWcpOiB2b2lkXG59XG5cbnR5cGUgQXBwMyA9IHR5cGVvZiBBc3RhbDMuQXBwbGljYXRpb25cbnR5cGUgQXBwNCA9IHR5cGVvZiBBc3RhbDQuQXBwbGljYXRpb25cblxuZXhwb3J0IGZ1bmN0aW9uIG1rQXBwPEFwcCBleHRlbmRzIEFwcDM+KEFwcDogQXBwKTogQXN0YWwzSlNcbmV4cG9ydCBmdW5jdGlvbiBta0FwcDxBcHAgZXh0ZW5kcyBBcHA0PihBcHA6IEFwcCk6IEFzdGFsNEpTXG5cbmV4cG9ydCBmdW5jdGlvbiBta0FwcChBcHA6IEFwcDMgfCBBcHA0KSB7XG4gICAgcmV0dXJuIG5ldyAoY2xhc3MgQXN0YWxKUyBleHRlbmRzIEFwcCB7XG4gICAgICAgIHN0YXRpYyB7IEdPYmplY3QucmVnaXN0ZXJDbGFzcyh7IEdUeXBlTmFtZTogXCJBc3RhbEpTXCIgfSwgdGhpcyBhcyBhbnkpIH1cblxuICAgICAgICBldmFsKGJvZHk6IHN0cmluZyk6IFByb21pc2U8YW55PiB7XG4gICAgICAgICAgICByZXR1cm4gbmV3IFByb21pc2UoKHJlcywgcmVqKSA9PiB7XG4gICAgICAgICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgICAgICAgICAgY29uc3QgZm4gPSBGdW5jdGlvbihgcmV0dXJuIChhc3luYyBmdW5jdGlvbigpIHtcbiAgICAgICAgICAgICAgICAgICAgICAgICR7Ym9keS5pbmNsdWRlcyhcIjtcIikgPyBib2R5IDogYHJldHVybiAke2JvZHl9O2B9XG4gICAgICAgICAgICAgICAgICAgIH0pYClcbiAgICAgICAgICAgICAgICAgICAgZm4oKSgpLnRoZW4ocmVzKS5jYXRjaChyZWopXG4gICAgICAgICAgICAgICAgfSBjYXRjaCAoZXJyb3IpIHtcbiAgICAgICAgICAgICAgICAgICAgcmVqKGVycm9yKVxuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH0pXG4gICAgICAgIH1cblxuICAgICAgICByZXF1ZXN0SGFuZGxlcj86IENvbmZpZ1tcInJlcXVlc3RIYW5kbGVyXCJdXG5cbiAgICAgICAgdmZ1bmNfcmVxdWVzdChtc2c6IHN0cmluZywgY29ubjogR2lvLlNvY2tldENvbm5lY3Rpb24pOiB2b2lkIHtcbiAgICAgICAgICAgIGlmICh0eXBlb2YgdGhpcy5yZXF1ZXN0SGFuZGxlciA9PT0gXCJmdW5jdGlvblwiKSB7XG4gICAgICAgICAgICAgICAgdGhpcy5yZXF1ZXN0SGFuZGxlcihtc2csIChyZXNwb25zZSkgPT4ge1xuICAgICAgICAgICAgICAgICAgICBJTy53cml0ZV9zb2NrKGNvbm4sIFN0cmluZyhyZXNwb25zZSksIChfLCByZXMpID0+XG4gICAgICAgICAgICAgICAgICAgICAgICBJTy53cml0ZV9zb2NrX2ZpbmlzaChyZXMpLFxuICAgICAgICAgICAgICAgICAgICApXG4gICAgICAgICAgICAgICAgfSlcbiAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgc3VwZXIudmZ1bmNfcmVxdWVzdChtc2csIGNvbm4pXG4gICAgICAgICAgICB9XG4gICAgICAgIH1cblxuICAgICAgICBhcHBseV9jc3Moc3R5bGU6IHN0cmluZywgcmVzZXQgPSBmYWxzZSkge1xuICAgICAgICAgICAgc3VwZXIuYXBwbHlfY3NzKHN0eWxlLCByZXNldClcbiAgICAgICAgfVxuXG4gICAgICAgIHF1aXQoY29kZT86IG51bWJlcik6IHZvaWQge1xuICAgICAgICAgICAgc3VwZXIucXVpdCgpXG4gICAgICAgICAgICBleGl0KGNvZGUgPz8gMClcbiAgICAgICAgfVxuXG4gICAgICAgIHN0YXJ0KHsgcmVxdWVzdEhhbmRsZXIsIGNzcywgaG9sZCwgbWFpbiwgY2xpZW50LCBpY29ucywgLi4uY2ZnIH06IENvbmZpZyA9IHt9KSB7XG4gICAgICAgICAgICBjb25zdCBhcHAgPSB0aGlzIGFzIHVua25vd24gYXMgSW5zdGFuY2VUeXBlPEFwcDMgfCBBcHA0PlxuXG4gICAgICAgICAgICBjbGllbnQgPz89ICgpID0+IHtcbiAgICAgICAgICAgICAgICBwcmludChgQXN0YWwgaW5zdGFuY2UgXCIke2FwcC5pbnN0YW5jZU5hbWV9XCIgYWxyZWFkeSBydW5uaW5nYClcbiAgICAgICAgICAgICAgICBleGl0KDEpXG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIE9iamVjdC5hc3NpZ24odGhpcywgY2ZnKVxuICAgICAgICAgICAgc2V0Q29uc29sZUxvZ0RvbWFpbihhcHAuaW5zdGFuY2VOYW1lKVxuXG4gICAgICAgICAgICB0aGlzLnJlcXVlc3RIYW5kbGVyID0gcmVxdWVzdEhhbmRsZXJcbiAgICAgICAgICAgIGFwcC5jb25uZWN0KFwiYWN0aXZhdGVcIiwgKCkgPT4ge1xuICAgICAgICAgICAgICAgIG1haW4/LiguLi5wcm9ncmFtQXJncylcbiAgICAgICAgICAgIH0pXG5cbiAgICAgICAgICAgIHRyeSB7XG4gICAgICAgICAgICAgICAgYXBwLmFjcXVpcmVfc29ja2V0KClcbiAgICAgICAgICAgIH0gY2F0Y2ggKGVycm9yKSB7XG4gICAgICAgICAgICAgICAgcmV0dXJuIGNsaWVudChtc2cgPT4gSU8uc2VuZF9yZXF1ZXN0KGFwcC5pbnN0YW5jZU5hbWUsIG1zZykhLCAuLi5wcm9ncmFtQXJncylcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgaWYgKGNzcylcbiAgICAgICAgICAgICAgICB0aGlzLmFwcGx5X2Nzcyhjc3MsIGZhbHNlKVxuXG4gICAgICAgICAgICBpZiAoaWNvbnMpXG4gICAgICAgICAgICAgICAgYXBwLmFkZF9pY29ucyhpY29ucylcblxuICAgICAgICAgICAgaG9sZCA/Pz0gdHJ1ZVxuICAgICAgICAgICAgaWYgKGhvbGQpXG4gICAgICAgICAgICAgICAgYXBwLmhvbGQoKVxuXG4gICAgICAgICAgICBhcHAucnVuQXN5bmMoW10pXG4gICAgICAgIH1cbiAgICB9KVxufVxuIiwgIi8qIGVzbGludC1kaXNhYmxlIG1heC1sZW4gKi9cbmltcG9ydCBBc3RhbCBmcm9tIFwiZ2k6Ly9Bc3RhbD92ZXJzaW9uPTMuMFwiXG5pbXBvcnQgR3RrIGZyb20gXCJnaTovL0d0az92ZXJzaW9uPTMuMFwiXG5pbXBvcnQgR09iamVjdCBmcm9tIFwiZ2k6Ly9HT2JqZWN0XCJcbmltcG9ydCBhc3RhbGlmeSwgeyB0eXBlIENvbnN0cnVjdFByb3BzLCB0eXBlIEJpbmRhYmxlQ2hpbGQgfSBmcm9tIFwiLi9hc3RhbGlmeS5qc1wiXG5cbmZ1bmN0aW9uIGZpbHRlcihjaGlsZHJlbjogYW55W10pIHtcbiAgICByZXR1cm4gY2hpbGRyZW4uZmxhdChJbmZpbml0eSkubWFwKGNoID0+IGNoIGluc3RhbmNlb2YgR3RrLldpZGdldFxuICAgICAgICA/IGNoXG4gICAgICAgIDogbmV3IEd0ay5MYWJlbCh7IHZpc2libGU6IHRydWUsIGxhYmVsOiBTdHJpbmcoY2gpIH0pKVxufVxuXG4vLyBCb3hcbk9iamVjdC5kZWZpbmVQcm9wZXJ0eShBc3RhbC5Cb3gucHJvdG90eXBlLCBcImNoaWxkcmVuXCIsIHtcbiAgICBnZXQoKSB7IHJldHVybiB0aGlzLmdldF9jaGlsZHJlbigpIH0sXG4gICAgc2V0KHYpIHsgdGhpcy5zZXRfY2hpbGRyZW4odikgfSxcbn0pXG5cbmV4cG9ydCB0eXBlIEJveFByb3BzID0gQ29uc3RydWN0UHJvcHM8Qm94LCBBc3RhbC5Cb3guQ29uc3RydWN0b3JQcm9wcz5cbmV4cG9ydCBjbGFzcyBCb3ggZXh0ZW5kcyBhc3RhbGlmeShBc3RhbC5Cb3gpIHtcbiAgICBzdGF0aWMgeyBHT2JqZWN0LnJlZ2lzdGVyQ2xhc3MoeyBHVHlwZU5hbWU6IFwiQm94XCIgfSwgdGhpcykgfVxuICAgIGNvbnN0cnVjdG9yKHByb3BzPzogQm94UHJvcHMsIC4uLmNoaWxkcmVuOiBBcnJheTxCaW5kYWJsZUNoaWxkPikgeyBzdXBlcih7IGNoaWxkcmVuLCAuLi5wcm9wcyB9IGFzIGFueSkgfVxuICAgIHByb3RlY3RlZCBzZXRDaGlsZHJlbihjaGlsZHJlbjogYW55W10pOiB2b2lkIHsgdGhpcy5zZXRfY2hpbGRyZW4oZmlsdGVyKGNoaWxkcmVuKSkgfVxufVxuXG4vLyBCdXR0b25cbmV4cG9ydCB0eXBlIEJ1dHRvblByb3BzID0gQ29uc3RydWN0UHJvcHM8QnV0dG9uLCBBc3RhbC5CdXR0b24uQ29uc3RydWN0b3JQcm9wcywge1xuICAgIG9uQ2xpY2tlZDogW11cbiAgICBvbkNsaWNrOiBbZXZlbnQ6IEFzdGFsLkNsaWNrRXZlbnRdXG4gICAgb25DbGlja1JlbGVhc2U6IFtldmVudDogQXN0YWwuQ2xpY2tFdmVudF1cbiAgICBvbkhvdmVyOiBbZXZlbnQ6IEFzdGFsLkhvdmVyRXZlbnRdXG4gICAgb25Ib3Zlckxvc3Q6IFtldmVudDogQXN0YWwuSG92ZXJFdmVudF1cbiAgICBvblNjcm9sbDogW2V2ZW50OiBBc3RhbC5TY3JvbGxFdmVudF1cbn0+XG5leHBvcnQgY2xhc3MgQnV0dG9uIGV4dGVuZHMgYXN0YWxpZnkoQXN0YWwuQnV0dG9uKSB7XG4gICAgc3RhdGljIHsgR09iamVjdC5yZWdpc3RlckNsYXNzKHsgR1R5cGVOYW1lOiBcIkJ1dHRvblwiIH0sIHRoaXMpIH1cbiAgICBjb25zdHJ1Y3Rvcihwcm9wcz86IEJ1dHRvblByb3BzLCBjaGlsZD86IEJpbmRhYmxlQ2hpbGQpIHsgc3VwZXIoeyBjaGlsZCwgLi4ucHJvcHMgfSBhcyBhbnkpIH1cbn1cblxuLy8gQ2VudGVyQm94XG5leHBvcnQgdHlwZSBDZW50ZXJCb3hQcm9wcyA9IENvbnN0cnVjdFByb3BzPENlbnRlckJveCwgQXN0YWwuQ2VudGVyQm94LkNvbnN0cnVjdG9yUHJvcHM+XG5leHBvcnQgY2xhc3MgQ2VudGVyQm94IGV4dGVuZHMgYXN0YWxpZnkoQXN0YWwuQ2VudGVyQm94KSB7XG4gICAgc3RhdGljIHsgR09iamVjdC5yZWdpc3RlckNsYXNzKHsgR1R5cGVOYW1lOiBcIkNlbnRlckJveFwiIH0sIHRoaXMpIH1cbiAgICBjb25zdHJ1Y3Rvcihwcm9wcz86IENlbnRlckJveFByb3BzLCAuLi5jaGlsZHJlbjogQXJyYXk8QmluZGFibGVDaGlsZD4pIHsgc3VwZXIoeyBjaGlsZHJlbiwgLi4ucHJvcHMgfSBhcyBhbnkpIH1cbiAgICBwcm90ZWN0ZWQgc2V0Q2hpbGRyZW4oY2hpbGRyZW46IGFueVtdKTogdm9pZCB7XG4gICAgICAgIGNvbnN0IGNoID0gZmlsdGVyKGNoaWxkcmVuKVxuICAgICAgICB0aGlzLnN0YXJ0V2lkZ2V0ID0gY2hbMF0gfHwgbmV3IEd0ay5Cb3hcbiAgICAgICAgdGhpcy5jZW50ZXJXaWRnZXQgPSBjaFsxXSB8fCBuZXcgR3RrLkJveFxuICAgICAgICB0aGlzLmVuZFdpZGdldCA9IGNoWzJdIHx8IG5ldyBHdGsuQm94XG4gICAgfVxufVxuXG4vLyBDaXJjdWxhclByb2dyZXNzXG5leHBvcnQgdHlwZSBDaXJjdWxhclByb2dyZXNzUHJvcHMgPSBDb25zdHJ1Y3RQcm9wczxDaXJjdWxhclByb2dyZXNzLCBBc3RhbC5DaXJjdWxhclByb2dyZXNzLkNvbnN0cnVjdG9yUHJvcHM+XG5leHBvcnQgY2xhc3MgQ2lyY3VsYXJQcm9ncmVzcyBleHRlbmRzIGFzdGFsaWZ5KEFzdGFsLkNpcmN1bGFyUHJvZ3Jlc3MpIHtcbiAgICBzdGF0aWMgeyBHT2JqZWN0LnJlZ2lzdGVyQ2xhc3MoeyBHVHlwZU5hbWU6IFwiQ2lyY3VsYXJQcm9ncmVzc1wiIH0sIHRoaXMpIH1cbiAgICBjb25zdHJ1Y3Rvcihwcm9wcz86IENpcmN1bGFyUHJvZ3Jlc3NQcm9wcywgY2hpbGQ/OiBCaW5kYWJsZUNoaWxkKSB7IHN1cGVyKHsgY2hpbGQsIC4uLnByb3BzIH0gYXMgYW55KSB9XG59XG5cbi8vIERyYXdpbmdBcmVhXG5leHBvcnQgdHlwZSBEcmF3aW5nQXJlYVByb3BzID0gQ29uc3RydWN0UHJvcHM8RHJhd2luZ0FyZWEsIEd0ay5EcmF3aW5nQXJlYS5Db25zdHJ1Y3RvclByb3BzLCB7XG4gICAgb25EcmF3OiBbY3I6IGFueV0gLy8gVE9ETzogY2Fpcm8gdHlwZXNcbn0+XG5leHBvcnQgY2xhc3MgRHJhd2luZ0FyZWEgZXh0ZW5kcyBhc3RhbGlmeShHdGsuRHJhd2luZ0FyZWEpIHtcbiAgICBzdGF0aWMgeyBHT2JqZWN0LnJlZ2lzdGVyQ2xhc3MoeyBHVHlwZU5hbWU6IFwiRHJhd2luZ0FyZWFcIiB9LCB0aGlzKSB9XG4gICAgY29uc3RydWN0b3IocHJvcHM/OiBEcmF3aW5nQXJlYVByb3BzKSB7IHN1cGVyKHByb3BzIGFzIGFueSkgfVxufVxuXG4vLyBFbnRyeVxuZXhwb3J0IHR5cGUgRW50cnlQcm9wcyA9IENvbnN0cnVjdFByb3BzPEVudHJ5LCBHdGsuRW50cnkuQ29uc3RydWN0b3JQcm9wcywge1xuICAgIG9uQ2hhbmdlZDogW11cbiAgICBvbkFjdGl2YXRlOiBbXVxufT5cbmV4cG9ydCBjbGFzcyBFbnRyeSBleHRlbmRzIGFzdGFsaWZ5KEd0ay5FbnRyeSkge1xuICAgIHN0YXRpYyB7IEdPYmplY3QucmVnaXN0ZXJDbGFzcyh7IEdUeXBlTmFtZTogXCJFbnRyeVwiIH0sIHRoaXMpIH1cbiAgICBjb25zdHJ1Y3Rvcihwcm9wcz86IEVudHJ5UHJvcHMpIHsgc3VwZXIocHJvcHMgYXMgYW55KSB9XG59XG5cbi8vIEV2ZW50Qm94XG5leHBvcnQgdHlwZSBFdmVudEJveFByb3BzID0gQ29uc3RydWN0UHJvcHM8RXZlbnRCb3gsIEFzdGFsLkV2ZW50Qm94LkNvbnN0cnVjdG9yUHJvcHMsIHtcbiAgICBvbkNsaWNrOiBbZXZlbnQ6IEFzdGFsLkNsaWNrRXZlbnRdXG4gICAgb25DbGlja1JlbGVhc2U6IFtldmVudDogQXN0YWwuQ2xpY2tFdmVudF1cbiAgICBvbkhvdmVyOiBbZXZlbnQ6IEFzdGFsLkhvdmVyRXZlbnRdXG4gICAgb25Ib3Zlckxvc3Q6IFtldmVudDogQXN0YWwuSG92ZXJFdmVudF1cbiAgICBvblNjcm9sbDogW2V2ZW50OiBBc3RhbC5TY3JvbGxFdmVudF1cbn0+XG5leHBvcnQgY2xhc3MgRXZlbnRCb3ggZXh0ZW5kcyBhc3RhbGlmeShBc3RhbC5FdmVudEJveCkge1xuICAgIHN0YXRpYyB7IEdPYmplY3QucmVnaXN0ZXJDbGFzcyh7IEdUeXBlTmFtZTogXCJFdmVudEJveFwiIH0sIHRoaXMpIH1cbiAgICBjb25zdHJ1Y3Rvcihwcm9wcz86IEV2ZW50Qm94UHJvcHMsIGNoaWxkPzogQmluZGFibGVDaGlsZCkgeyBzdXBlcih7IGNoaWxkLCAuLi5wcm9wcyB9IGFzIGFueSkgfVxufVxuXG4vLyAvLyBUT0RPOiBGaXhlZFxuLy8gLy8gVE9ETzogRmxvd0JveFxuLy9cbi8vIEljb25cbmV4cG9ydCB0eXBlIEljb25Qcm9wcyA9IENvbnN0cnVjdFByb3BzPEljb24sIEFzdGFsLkljb24uQ29uc3RydWN0b3JQcm9wcz5cbmV4cG9ydCBjbGFzcyBJY29uIGV4dGVuZHMgYXN0YWxpZnkoQXN0YWwuSWNvbikge1xuICAgIHN0YXRpYyB7IEdPYmplY3QucmVnaXN0ZXJDbGFzcyh7IEdUeXBlTmFtZTogXCJJY29uXCIgfSwgdGhpcykgfVxuICAgIGNvbnN0cnVjdG9yKHByb3BzPzogSWNvblByb3BzKSB7IHN1cGVyKHByb3BzIGFzIGFueSkgfVxufVxuXG4vLyBMYWJlbFxuZXhwb3J0IHR5cGUgTGFiZWxQcm9wcyA9IENvbnN0cnVjdFByb3BzPExhYmVsLCBBc3RhbC5MYWJlbC5Db25zdHJ1Y3RvclByb3BzPlxuZXhwb3J0IGNsYXNzIExhYmVsIGV4dGVuZHMgYXN0YWxpZnkoQXN0YWwuTGFiZWwpIHtcbiAgICBzdGF0aWMgeyBHT2JqZWN0LnJlZ2lzdGVyQ2xhc3MoeyBHVHlwZU5hbWU6IFwiTGFiZWxcIiB9LCB0aGlzKSB9XG4gICAgY29uc3RydWN0b3IocHJvcHM/OiBMYWJlbFByb3BzKSB7IHN1cGVyKHByb3BzIGFzIGFueSkgfVxuICAgIHByb3RlY3RlZCBzZXRDaGlsZHJlbihjaGlsZHJlbjogYW55W10pOiB2b2lkIHsgdGhpcy5sYWJlbCA9IFN0cmluZyhjaGlsZHJlbikgfVxufVxuXG4vLyBMZXZlbEJhclxuZXhwb3J0IHR5cGUgTGV2ZWxCYXJQcm9wcyA9IENvbnN0cnVjdFByb3BzPExldmVsQmFyLCBBc3RhbC5MZXZlbEJhci5Db25zdHJ1Y3RvclByb3BzPlxuZXhwb3J0IGNsYXNzIExldmVsQmFyIGV4dGVuZHMgYXN0YWxpZnkoQXN0YWwuTGV2ZWxCYXIpIHtcbiAgICBzdGF0aWMgeyBHT2JqZWN0LnJlZ2lzdGVyQ2xhc3MoeyBHVHlwZU5hbWU6IFwiTGV2ZWxCYXJcIiB9LCB0aGlzKSB9XG4gICAgY29uc3RydWN0b3IocHJvcHM/OiBMZXZlbEJhclByb3BzKSB7IHN1cGVyKHByb3BzIGFzIGFueSkgfVxufVxuXG4vLyBUT0RPOiBMaXN0Qm94XG5cbi8vIE1lbnVCdXR0b25cbmV4cG9ydCB0eXBlIE1lbnVCdXR0b25Qcm9wcyA9IENvbnN0cnVjdFByb3BzPE1lbnVCdXR0b24sIEd0ay5NZW51QnV0dG9uLkNvbnN0cnVjdG9yUHJvcHM+XG5leHBvcnQgY2xhc3MgTWVudUJ1dHRvbiBleHRlbmRzIGFzdGFsaWZ5KEd0ay5NZW51QnV0dG9uKSB7XG4gICAgc3RhdGljIHsgR09iamVjdC5yZWdpc3RlckNsYXNzKHsgR1R5cGVOYW1lOiBcIk1lbnVCdXR0b25cIiB9LCB0aGlzKSB9XG4gICAgY29uc3RydWN0b3IocHJvcHM/OiBNZW51QnV0dG9uUHJvcHMsIGNoaWxkPzogQmluZGFibGVDaGlsZCkgeyBzdXBlcih7IGNoaWxkLCAuLi5wcm9wcyB9IGFzIGFueSkgfVxufVxuXG4vLyBPdmVybGF5XG5PYmplY3QuZGVmaW5lUHJvcGVydHkoQXN0YWwuT3ZlcmxheS5wcm90b3R5cGUsIFwib3ZlcmxheXNcIiwge1xuICAgIGdldCgpIHsgcmV0dXJuIHRoaXMuZ2V0X292ZXJsYXlzKCkgfSxcbiAgICBzZXQodikgeyB0aGlzLnNldF9vdmVybGF5cyh2KSB9LFxufSlcblxuZXhwb3J0IHR5cGUgT3ZlcmxheVByb3BzID0gQ29uc3RydWN0UHJvcHM8T3ZlcmxheSwgQXN0YWwuT3ZlcmxheS5Db25zdHJ1Y3RvclByb3BzPlxuZXhwb3J0IGNsYXNzIE92ZXJsYXkgZXh0ZW5kcyBhc3RhbGlmeShBc3RhbC5PdmVybGF5KSB7XG4gICAgc3RhdGljIHsgR09iamVjdC5yZWdpc3RlckNsYXNzKHsgR1R5cGVOYW1lOiBcIk92ZXJsYXlcIiB9LCB0aGlzKSB9XG4gICAgY29uc3RydWN0b3IocHJvcHM/OiBPdmVybGF5UHJvcHMsIC4uLmNoaWxkcmVuOiBBcnJheTxCaW5kYWJsZUNoaWxkPikgeyBzdXBlcih7IGNoaWxkcmVuLCAuLi5wcm9wcyB9IGFzIGFueSkgfVxuICAgIHByb3RlY3RlZCBzZXRDaGlsZHJlbihjaGlsZHJlbjogYW55W10pOiB2b2lkIHtcbiAgICAgICAgY29uc3QgW2NoaWxkLCAuLi5vdmVybGF5c10gPSBmaWx0ZXIoY2hpbGRyZW4pXG4gICAgICAgIHRoaXMuc2V0X2NoaWxkKGNoaWxkKVxuICAgICAgICB0aGlzLnNldF9vdmVybGF5cyhvdmVybGF5cylcbiAgICB9XG59XG5cbi8vIFJldmVhbGVyXG5leHBvcnQgdHlwZSBSZXZlYWxlclByb3BzID0gQ29uc3RydWN0UHJvcHM8UmV2ZWFsZXIsIEd0ay5SZXZlYWxlci5Db25zdHJ1Y3RvclByb3BzPlxuZXhwb3J0IGNsYXNzIFJldmVhbGVyIGV4dGVuZHMgYXN0YWxpZnkoR3RrLlJldmVhbGVyKSB7XG4gICAgc3RhdGljIHsgR09iamVjdC5yZWdpc3RlckNsYXNzKHsgR1R5cGVOYW1lOiBcIlJldmVhbGVyXCIgfSwgdGhpcykgfVxuICAgIGNvbnN0cnVjdG9yKHByb3BzPzogUmV2ZWFsZXJQcm9wcywgY2hpbGQ/OiBCaW5kYWJsZUNoaWxkKSB7IHN1cGVyKHsgY2hpbGQsIC4uLnByb3BzIH0gYXMgYW55KSB9XG59XG5cbi8vIFNjcm9sbGFibGVcbmV4cG9ydCB0eXBlIFNjcm9sbGFibGVQcm9wcyA9IENvbnN0cnVjdFByb3BzPFNjcm9sbGFibGUsIEFzdGFsLlNjcm9sbGFibGUuQ29uc3RydWN0b3JQcm9wcz5cbmV4cG9ydCBjbGFzcyBTY3JvbGxhYmxlIGV4dGVuZHMgYXN0YWxpZnkoQXN0YWwuU2Nyb2xsYWJsZSkge1xuICAgIHN0YXRpYyB7IEdPYmplY3QucmVnaXN0ZXJDbGFzcyh7IEdUeXBlTmFtZTogXCJTY3JvbGxhYmxlXCIgfSwgdGhpcykgfVxuICAgIGNvbnN0cnVjdG9yKHByb3BzPzogU2Nyb2xsYWJsZVByb3BzLCBjaGlsZD86IEJpbmRhYmxlQ2hpbGQpIHsgc3VwZXIoeyBjaGlsZCwgLi4ucHJvcHMgfSBhcyBhbnkpIH1cbn1cblxuLy8gU2xpZGVyXG5leHBvcnQgdHlwZSBTbGlkZXJQcm9wcyA9IENvbnN0cnVjdFByb3BzPFNsaWRlciwgQXN0YWwuU2xpZGVyLkNvbnN0cnVjdG9yUHJvcHMsIHtcbiAgICBvbkRyYWdnZWQ6IFtdXG59PlxuZXhwb3J0IGNsYXNzIFNsaWRlciBleHRlbmRzIGFzdGFsaWZ5KEFzdGFsLlNsaWRlcikge1xuICAgIHN0YXRpYyB7IEdPYmplY3QucmVnaXN0ZXJDbGFzcyh7IEdUeXBlTmFtZTogXCJTbGlkZXJcIiB9LCB0aGlzKSB9XG4gICAgY29uc3RydWN0b3IocHJvcHM/OiBTbGlkZXJQcm9wcykgeyBzdXBlcihwcm9wcyBhcyBhbnkpIH1cbn1cblxuLy8gU3RhY2tcbmV4cG9ydCB0eXBlIFN0YWNrUHJvcHMgPSBDb25zdHJ1Y3RQcm9wczxTdGFjaywgQXN0YWwuU3RhY2suQ29uc3RydWN0b3JQcm9wcz5cbmV4cG9ydCBjbGFzcyBTdGFjayBleHRlbmRzIGFzdGFsaWZ5KEFzdGFsLlN0YWNrKSB7XG4gICAgc3RhdGljIHsgR09iamVjdC5yZWdpc3RlckNsYXNzKHsgR1R5cGVOYW1lOiBcIlN0YWNrXCIgfSwgdGhpcykgfVxuICAgIGNvbnN0cnVjdG9yKHByb3BzPzogU3RhY2tQcm9wcywgLi4uY2hpbGRyZW46IEFycmF5PEJpbmRhYmxlQ2hpbGQ+KSB7IHN1cGVyKHsgY2hpbGRyZW4sIC4uLnByb3BzIH0gYXMgYW55KSB9XG4gICAgcHJvdGVjdGVkIHNldENoaWxkcmVuKGNoaWxkcmVuOiBhbnlbXSk6IHZvaWQgeyB0aGlzLnNldF9jaGlsZHJlbihmaWx0ZXIoY2hpbGRyZW4pKSB9XG59XG5cbi8vIFN3aXRjaFxuZXhwb3J0IHR5cGUgU3dpdGNoUHJvcHMgPSBDb25zdHJ1Y3RQcm9wczxTd2l0Y2gsIEd0ay5Td2l0Y2guQ29uc3RydWN0b3JQcm9wcz5cbmV4cG9ydCBjbGFzcyBTd2l0Y2ggZXh0ZW5kcyBhc3RhbGlmeShHdGsuU3dpdGNoKSB7XG4gICAgc3RhdGljIHsgR09iamVjdC5yZWdpc3RlckNsYXNzKHsgR1R5cGVOYW1lOiBcIlN3aXRjaFwiIH0sIHRoaXMpIH1cbiAgICBjb25zdHJ1Y3Rvcihwcm9wcz86IFN3aXRjaFByb3BzKSB7IHN1cGVyKHByb3BzIGFzIGFueSkgfVxufVxuXG4vLyBXaW5kb3dcbmV4cG9ydCB0eXBlIFdpbmRvd1Byb3BzID0gQ29uc3RydWN0UHJvcHM8V2luZG93LCBBc3RhbC5XaW5kb3cuQ29uc3RydWN0b3JQcm9wcz5cbmV4cG9ydCBjbGFzcyBXaW5kb3cgZXh0ZW5kcyBhc3RhbGlmeShBc3RhbC5XaW5kb3cpIHtcbiAgICBzdGF0aWMgeyBHT2JqZWN0LnJlZ2lzdGVyQ2xhc3MoeyBHVHlwZU5hbWU6IFwiV2luZG93XCIgfSwgdGhpcykgfVxuICAgIGNvbnN0cnVjdG9yKHByb3BzPzogV2luZG93UHJvcHMsIGNoaWxkPzogQmluZGFibGVDaGlsZCkgeyBzdXBlcih7IGNoaWxkLCAuLi5wcm9wcyB9IGFzIGFueSkgfVxufVxuIiwgImltcG9ydCBcIi4vb3ZlcnJpZGVzLmpzXCJcbmV4cG9ydCB7IGRlZmF1bHQgYXMgQXN0YWxJTyB9IGZyb20gXCJnaTovL0FzdGFsSU8/dmVyc2lvbj0wLjFcIlxuZXhwb3J0ICogZnJvbSBcIi4vcHJvY2Vzcy5qc1wiXG5leHBvcnQgKiBmcm9tIFwiLi90aW1lLmpzXCJcbmV4cG9ydCAqIGZyb20gXCIuL2ZpbGUuanNcIlxuZXhwb3J0ICogZnJvbSBcIi4vZ29iamVjdC5qc1wiXG5leHBvcnQgeyBCaW5kaW5nLCBiaW5kIH0gZnJvbSBcIi4vYmluZGluZy5qc1wiXG5leHBvcnQgeyBWYXJpYWJsZSwgZGVyaXZlIH0gZnJvbSBcIi4vdmFyaWFibGUuanNcIlxuIiwgImltcG9ydCBBc3RhbCBmcm9tIFwiZ2k6Ly9Bc3RhbElPXCJcbmltcG9ydCBHaW8gZnJvbSBcImdpOi8vR2lvP3ZlcnNpb249Mi4wXCJcblxuZXhwb3J0IHsgR2lvIH1cblxuZXhwb3J0IGZ1bmN0aW9uIHJlYWRGaWxlKHBhdGg6IHN0cmluZyk6IHN0cmluZyB7XG4gICAgcmV0dXJuIEFzdGFsLnJlYWRfZmlsZShwYXRoKSB8fCBcIlwiXG59XG5cbmV4cG9ydCBmdW5jdGlvbiByZWFkRmlsZUFzeW5jKHBhdGg6IHN0cmluZyk6IFByb21pc2U8c3RyaW5nPiB7XG4gICAgcmV0dXJuIG5ldyBQcm9taXNlKChyZXNvbHZlLCByZWplY3QpID0+IHtcbiAgICAgICAgQXN0YWwucmVhZF9maWxlX2FzeW5jKHBhdGgsIChfLCByZXMpID0+IHtcbiAgICAgICAgICAgIHRyeSB7XG4gICAgICAgICAgICAgICAgcmVzb2x2ZShBc3RhbC5yZWFkX2ZpbGVfZmluaXNoKHJlcykgfHwgXCJcIilcbiAgICAgICAgICAgIH0gY2F0Y2ggKGVycm9yKSB7XG4gICAgICAgICAgICAgICAgcmVqZWN0KGVycm9yKVxuICAgICAgICAgICAgfVxuICAgICAgICB9KVxuICAgIH0pXG59XG5cbmV4cG9ydCBmdW5jdGlvbiB3cml0ZUZpbGUocGF0aDogc3RyaW5nLCBjb250ZW50OiBzdHJpbmcpOiB2b2lkIHtcbiAgICBBc3RhbC53cml0ZV9maWxlKHBhdGgsIGNvbnRlbnQpXG59XG5cbmV4cG9ydCBmdW5jdGlvbiB3cml0ZUZpbGVBc3luYyhwYXRoOiBzdHJpbmcsIGNvbnRlbnQ6IHN0cmluZyk6IFByb21pc2U8dm9pZD4ge1xuICAgIHJldHVybiBuZXcgUHJvbWlzZSgocmVzb2x2ZSwgcmVqZWN0KSA9PiB7XG4gICAgICAgIEFzdGFsLndyaXRlX2ZpbGVfYXN5bmMocGF0aCwgY29udGVudCwgKF8sIHJlcykgPT4ge1xuICAgICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgICAgICByZXNvbHZlKEFzdGFsLndyaXRlX2ZpbGVfZmluaXNoKHJlcykpXG4gICAgICAgICAgICB9IGNhdGNoIChlcnJvcikge1xuICAgICAgICAgICAgICAgIHJlamVjdChlcnJvcilcbiAgICAgICAgICAgIH1cbiAgICAgICAgfSlcbiAgICB9KVxufVxuXG5leHBvcnQgZnVuY3Rpb24gbW9uaXRvckZpbGUoXG4gICAgcGF0aDogc3RyaW5nLFxuICAgIGNhbGxiYWNrOiAoZmlsZTogc3RyaW5nLCBldmVudDogR2lvLkZpbGVNb25pdG9yRXZlbnQpID0+IHZvaWQsXG4pOiBHaW8uRmlsZU1vbml0b3Ige1xuICAgIHJldHVybiBBc3RhbC5tb25pdG9yX2ZpbGUocGF0aCwgKGZpbGU6IHN0cmluZywgZXZlbnQ6IEdpby5GaWxlTW9uaXRvckV2ZW50KSA9PiB7XG4gICAgICAgIGNhbGxiYWNrKGZpbGUsIGV2ZW50KVxuICAgIH0pIVxufVxuIiwgImltcG9ydCBHT2JqZWN0IGZyb20gXCJnaTovL0dPYmplY3RcIlxuXG5leHBvcnQgeyBkZWZhdWx0IGFzIEdMaWIgfSBmcm9tIFwiZ2k6Ly9HTGliP3ZlcnNpb249Mi4wXCJcbmV4cG9ydCB7IEdPYmplY3QsIEdPYmplY3QgYXMgZGVmYXVsdCB9XG5cbmNvbnN0IG1ldGEgPSBTeW1ib2woXCJtZXRhXCIpXG5jb25zdCBwcml2ID0gU3ltYm9sKFwicHJpdlwiKVxuXG5jb25zdCB7IFBhcmFtU3BlYywgUGFyYW1GbGFncyB9ID0gR09iamVjdFxuXG5jb25zdCBrZWJhYmlmeSA9IChzdHI6IHN0cmluZykgPT4gc3RyXG4gICAgLnJlcGxhY2UoLyhbYS16XSkoW0EtWl0pL2csIFwiJDEtJDJcIilcbiAgICAucmVwbGFjZUFsbChcIl9cIiwgXCItXCIpXG4gICAgLnRvTG93ZXJDYXNlKClcblxudHlwZSBTaWduYWxEZWNsYXJhdGlvbiA9IHtcbiAgICBmbGFncz86IEdPYmplY3QuU2lnbmFsRmxhZ3NcbiAgICBhY2N1bXVsYXRvcj86IEdPYmplY3QuQWNjdW11bGF0b3JUeXBlXG4gICAgcmV0dXJuX3R5cGU/OiBHT2JqZWN0LkdUeXBlXG4gICAgcGFyYW1fdHlwZXM/OiBBcnJheTxHT2JqZWN0LkdUeXBlPlxufVxuXG50eXBlIFByb3BlcnR5RGVjbGFyYXRpb24gPVxuICAgIHwgSW5zdGFuY2VUeXBlPHR5cGVvZiBHT2JqZWN0LlBhcmFtU3BlYz5cbiAgICB8IHsgJGd0eXBlOiBHT2JqZWN0LkdUeXBlIH1cbiAgICB8IHR5cGVvZiBTdHJpbmdcbiAgICB8IHR5cGVvZiBOdW1iZXJcbiAgICB8IHR5cGVvZiBCb29sZWFuXG4gICAgfCB0eXBlb2YgT2JqZWN0XG5cbnR5cGUgR09iamVjdENvbnN0cnVjdG9yID0ge1xuICAgIFttZXRhXT86IHtcbiAgICAgICAgUHJvcGVydGllcz86IHsgW2tleTogc3RyaW5nXTogR09iamVjdC5QYXJhbVNwZWMgfVxuICAgICAgICBTaWduYWxzPzogeyBba2V5OiBzdHJpbmddOiBHT2JqZWN0LlNpZ25hbERlZmluaXRpb24gfVxuICAgIH1cbiAgICBuZXcoLi4uYXJnczogYW55W10pOiBhbnlcbn1cblxudHlwZSBNZXRhSW5mbyA9IEdPYmplY3QuTWV0YUluZm88bmV2ZXIsIEFycmF5PHsgJGd0eXBlOiBHT2JqZWN0LkdUeXBlIH0+LCBuZXZlcj5cblxuZXhwb3J0IGZ1bmN0aW9uIHJlZ2lzdGVyKG9wdGlvbnM6IE1ldGFJbmZvID0ge30pIHtcbiAgICByZXR1cm4gZnVuY3Rpb24gKGNsczogR09iamVjdENvbnN0cnVjdG9yKSB7XG4gICAgICAgIGNvbnN0IHQgPSBvcHRpb25zLlRlbXBsYXRlXG4gICAgICAgIGlmICh0eXBlb2YgdCA9PT0gXCJzdHJpbmdcIiAmJiAhdC5zdGFydHNXaXRoKFwicmVzb3VyY2U6Ly9cIikgJiYgIXQuc3RhcnRzV2l0aChcImZpbGU6Ly9cIikpIHtcbiAgICAgICAgICAgIC8vIGFzc3VtZSB4bWwgdGVtcGxhdGVcbiAgICAgICAgICAgIG9wdGlvbnMuVGVtcGxhdGUgPSBuZXcgVGV4dEVuY29kZXIoKS5lbmNvZGUodClcbiAgICAgICAgfVxuXG4gICAgICAgIEdPYmplY3QucmVnaXN0ZXJDbGFzcyh7XG4gICAgICAgICAgICBTaWduYWxzOiB7IC4uLmNsc1ttZXRhXT8uU2lnbmFscyB9LFxuICAgICAgICAgICAgUHJvcGVydGllczogeyAuLi5jbHNbbWV0YV0/LlByb3BlcnRpZXMgfSxcbiAgICAgICAgICAgIC4uLm9wdGlvbnMsXG4gICAgICAgIH0sIGNscylcblxuICAgICAgICBkZWxldGUgY2xzW21ldGFdXG4gICAgfVxufVxuXG5leHBvcnQgZnVuY3Rpb24gcHJvcGVydHkoZGVjbGFyYXRpb246IFByb3BlcnR5RGVjbGFyYXRpb24gPSBPYmplY3QpIHtcbiAgICByZXR1cm4gZnVuY3Rpb24gKHRhcmdldDogYW55LCBwcm9wOiBhbnksIGRlc2M/OiBQcm9wZXJ0eURlc2NyaXB0b3IpIHtcbiAgICAgICAgdGFyZ2V0LmNvbnN0cnVjdG9yW21ldGFdID8/PSB7fVxuICAgICAgICB0YXJnZXQuY29uc3RydWN0b3JbbWV0YV0uUHJvcGVydGllcyA/Pz0ge31cblxuICAgICAgICBjb25zdCBuYW1lID0ga2ViYWJpZnkocHJvcClcblxuICAgICAgICBpZiAoIWRlc2MpIHtcbiAgICAgICAgICAgIE9iamVjdC5kZWZpbmVQcm9wZXJ0eSh0YXJnZXQsIHByb3AsIHtcbiAgICAgICAgICAgICAgICBnZXQoKSB7XG4gICAgICAgICAgICAgICAgICAgIHJldHVybiB0aGlzW3ByaXZdPy5bcHJvcF0gPz8gZGVmYXVsdFZhbHVlKGRlY2xhcmF0aW9uKVxuICAgICAgICAgICAgICAgIH0sXG4gICAgICAgICAgICAgICAgc2V0KHY6IGFueSkge1xuICAgICAgICAgICAgICAgICAgICBpZiAodiAhPT0gdGhpc1twcm9wXSkge1xuICAgICAgICAgICAgICAgICAgICAgICAgdGhpc1twcml2XSA/Pz0ge31cbiAgICAgICAgICAgICAgICAgICAgICAgIHRoaXNbcHJpdl1bcHJvcF0gPSB2XG4gICAgICAgICAgICAgICAgICAgICAgICB0aGlzLm5vdGlmeShuYW1lKVxuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfSxcbiAgICAgICAgICAgIH0pXG5cbiAgICAgICAgICAgIE9iamVjdC5kZWZpbmVQcm9wZXJ0eSh0YXJnZXQsIGBzZXRfJHtuYW1lLnJlcGxhY2UoXCItXCIsIFwiX1wiKX1gLCB7XG4gICAgICAgICAgICAgICAgdmFsdWUodjogYW55KSB7XG4gICAgICAgICAgICAgICAgICAgIHRoaXNbcHJvcF0gPSB2XG4gICAgICAgICAgICAgICAgfSxcbiAgICAgICAgICAgIH0pXG5cbiAgICAgICAgICAgIE9iamVjdC5kZWZpbmVQcm9wZXJ0eSh0YXJnZXQsIGBnZXRfJHtuYW1lLnJlcGxhY2UoXCItXCIsIFwiX1wiKX1gLCB7XG4gICAgICAgICAgICAgICAgdmFsdWUoKSB7XG4gICAgICAgICAgICAgICAgICAgIHJldHVybiB0aGlzW3Byb3BdXG4gICAgICAgICAgICAgICAgfSxcbiAgICAgICAgICAgIH0pXG5cbiAgICAgICAgICAgIHRhcmdldC5jb25zdHJ1Y3RvclttZXRhXS5Qcm9wZXJ0aWVzW2tlYmFiaWZ5KHByb3ApXSA9IHBzcGVjKG5hbWUsIFBhcmFtRmxhZ3MuUkVBRFdSSVRFLCBkZWNsYXJhdGlvbilcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIGxldCBmbGFncyA9IDBcbiAgICAgICAgICAgIGlmIChkZXNjLmdldCkgZmxhZ3MgfD0gUGFyYW1GbGFncy5SRUFEQUJMRVxuICAgICAgICAgICAgaWYgKGRlc2Muc2V0KSBmbGFncyB8PSBQYXJhbUZsYWdzLldSSVRBQkxFXG5cbiAgICAgICAgICAgIHRhcmdldC5jb25zdHJ1Y3RvclttZXRhXS5Qcm9wZXJ0aWVzW2tlYmFiaWZ5KHByb3ApXSA9IHBzcGVjKG5hbWUsIGZsYWdzLCBkZWNsYXJhdGlvbilcbiAgICAgICAgfVxuICAgIH1cbn1cblxuZXhwb3J0IGZ1bmN0aW9uIHNpZ25hbCguLi5wYXJhbXM6IEFycmF5PHsgJGd0eXBlOiBHT2JqZWN0LkdUeXBlIH0gfCB0eXBlb2YgT2JqZWN0Pik6XG4odGFyZ2V0OiBhbnksIHNpZ25hbDogYW55LCBkZXNjPzogUHJvcGVydHlEZXNjcmlwdG9yKSA9PiB2b2lkXG5cbmV4cG9ydCBmdW5jdGlvbiBzaWduYWwoZGVjbGFyYXRpb24/OiBTaWduYWxEZWNsYXJhdGlvbik6XG4odGFyZ2V0OiBhbnksIHNpZ25hbDogYW55LCBkZXNjPzogUHJvcGVydHlEZXNjcmlwdG9yKSA9PiB2b2lkXG5cbmV4cG9ydCBmdW5jdGlvbiBzaWduYWwoXG4gICAgZGVjbGFyYXRpb24/OiBTaWduYWxEZWNsYXJhdGlvbiB8IHsgJGd0eXBlOiBHT2JqZWN0LkdUeXBlIH0gfCB0eXBlb2YgT2JqZWN0LFxuICAgIC4uLnBhcmFtczogQXJyYXk8eyAkZ3R5cGU6IEdPYmplY3QuR1R5cGUgfSB8IHR5cGVvZiBPYmplY3Q+XG4pIHtcbiAgICByZXR1cm4gZnVuY3Rpb24gKHRhcmdldDogYW55LCBzaWduYWw6IGFueSwgZGVzYz86IFByb3BlcnR5RGVzY3JpcHRvcikge1xuICAgICAgICB0YXJnZXQuY29uc3RydWN0b3JbbWV0YV0gPz89IHt9XG4gICAgICAgIHRhcmdldC5jb25zdHJ1Y3RvclttZXRhXS5TaWduYWxzID8/PSB7fVxuXG4gICAgICAgIGNvbnN0IG5hbWUgPSBrZWJhYmlmeShzaWduYWwpXG5cbiAgICAgICAgaWYgKGRlY2xhcmF0aW9uIHx8IHBhcmFtcy5sZW5ndGggPiAwKSB7XG4gICAgICAgICAgICAvLyBAdHMtZXhwZWN0LWVycm9yIFRPRE86IHR5cGUgYXNzZXJ0XG4gICAgICAgICAgICBjb25zdCBhcnIgPSBbZGVjbGFyYXRpb24sIC4uLnBhcmFtc10ubWFwKHYgPT4gdi4kZ3R5cGUpXG4gICAgICAgICAgICB0YXJnZXQuY29uc3RydWN0b3JbbWV0YV0uU2lnbmFsc1tuYW1lXSA9IHtcbiAgICAgICAgICAgICAgICBwYXJhbV90eXBlczogYXJyLFxuICAgICAgICAgICAgfVxuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgdGFyZ2V0LmNvbnN0cnVjdG9yW21ldGFdLlNpZ25hbHNbbmFtZV0gPSBkZWNsYXJhdGlvbiB8fCB7XG4gICAgICAgICAgICAgICAgcGFyYW1fdHlwZXM6IFtdLFxuICAgICAgICAgICAgfVxuICAgICAgICB9XG5cbiAgICAgICAgaWYgKCFkZXNjKSB7XG4gICAgICAgICAgICBPYmplY3QuZGVmaW5lUHJvcGVydHkodGFyZ2V0LCBzaWduYWwsIHtcbiAgICAgICAgICAgICAgICB2YWx1ZTogZnVuY3Rpb24gKC4uLmFyZ3M6IGFueVtdKSB7XG4gICAgICAgICAgICAgICAgICAgIHRoaXMuZW1pdChuYW1lLCAuLi5hcmdzKVxuICAgICAgICAgICAgICAgIH0sXG4gICAgICAgICAgICB9KVxuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgY29uc3Qgb2c6ICgoLi4uYXJnczogYW55W10pID0+IHZvaWQpID0gZGVzYy52YWx1ZVxuICAgICAgICAgICAgZGVzYy52YWx1ZSA9IGZ1bmN0aW9uICguLi5hcmdzOiBhbnlbXSkge1xuICAgICAgICAgICAgICAgIC8vIEB0cy1leHBlY3QtZXJyb3Igbm90IHR5cGVkXG4gICAgICAgICAgICAgICAgdGhpcy5lbWl0KG5hbWUsIC4uLmFyZ3MpXG4gICAgICAgICAgICB9XG4gICAgICAgICAgICBPYmplY3QuZGVmaW5lUHJvcGVydHkodGFyZ2V0LCBgb25fJHtuYW1lLnJlcGxhY2UoXCItXCIsIFwiX1wiKX1gLCB7XG4gICAgICAgICAgICAgICAgdmFsdWU6IGZ1bmN0aW9uICguLi5hcmdzOiBhbnlbXSkge1xuICAgICAgICAgICAgICAgICAgICByZXR1cm4gb2cuYXBwbHkodGhpcywgYXJncylcbiAgICAgICAgICAgICAgICB9LFxuICAgICAgICAgICAgfSlcbiAgICAgICAgfVxuICAgIH1cbn1cblxuZnVuY3Rpb24gcHNwZWMobmFtZTogc3RyaW5nLCBmbGFnczogbnVtYmVyLCBkZWNsYXJhdGlvbjogUHJvcGVydHlEZWNsYXJhdGlvbikge1xuICAgIGlmIChkZWNsYXJhdGlvbiBpbnN0YW5jZW9mIFBhcmFtU3BlYylcbiAgICAgICAgcmV0dXJuIGRlY2xhcmF0aW9uXG5cbiAgICBzd2l0Y2ggKGRlY2xhcmF0aW9uKSB7XG4gICAgICAgIGNhc2UgU3RyaW5nOlxuICAgICAgICAgICAgcmV0dXJuIFBhcmFtU3BlYy5zdHJpbmcobmFtZSwgXCJcIiwgXCJcIiwgZmxhZ3MsIFwiXCIpXG4gICAgICAgIGNhc2UgTnVtYmVyOlxuICAgICAgICAgICAgcmV0dXJuIFBhcmFtU3BlYy5kb3VibGUobmFtZSwgXCJcIiwgXCJcIiwgZmxhZ3MsIC1OdW1iZXIuTUFYX1ZBTFVFLCBOdW1iZXIuTUFYX1ZBTFVFLCAwKVxuICAgICAgICBjYXNlIEJvb2xlYW46XG4gICAgICAgICAgICByZXR1cm4gUGFyYW1TcGVjLmJvb2xlYW4obmFtZSwgXCJcIiwgXCJcIiwgZmxhZ3MsIGZhbHNlKVxuICAgICAgICBjYXNlIE9iamVjdDpcbiAgICAgICAgICAgIHJldHVybiBQYXJhbVNwZWMuanNvYmplY3QobmFtZSwgXCJcIiwgXCJcIiwgZmxhZ3MpXG4gICAgICAgIGRlZmF1bHQ6XG4gICAgICAgICAgICAvLyBAdHMtZXhwZWN0LWVycm9yIG1pc3N0eXBlZFxuICAgICAgICAgICAgcmV0dXJuIFBhcmFtU3BlYy5vYmplY3QobmFtZSwgXCJcIiwgXCJcIiwgZmxhZ3MsIGRlY2xhcmF0aW9uLiRndHlwZSlcbiAgICB9XG59XG5cbmZ1bmN0aW9uIGRlZmF1bHRWYWx1ZShkZWNsYXJhdGlvbjogUHJvcGVydHlEZWNsYXJhdGlvbikge1xuICAgIGlmIChkZWNsYXJhdGlvbiBpbnN0YW5jZW9mIFBhcmFtU3BlYylcbiAgICAgICAgcmV0dXJuIGRlY2xhcmF0aW9uLmdldF9kZWZhdWx0X3ZhbHVlKClcblxuICAgIHN3aXRjaCAoZGVjbGFyYXRpb24pIHtcbiAgICAgICAgY2FzZSBTdHJpbmc6XG4gICAgICAgICAgICByZXR1cm4gXCJcIlxuICAgICAgICBjYXNlIE51bWJlcjpcbiAgICAgICAgICAgIHJldHVybiAwXG4gICAgICAgIGNhc2UgQm9vbGVhbjpcbiAgICAgICAgICAgIHJldHVybiBmYWxzZVxuICAgICAgICBjYXNlIE9iamVjdDpcbiAgICAgICAgZGVmYXVsdDpcbiAgICAgICAgICAgIHJldHVybiBudWxsXG4gICAgfVxufVxuIiwgImltcG9ydCB7IEFwcCB9IGZyb20gJ2FzdGFsL2d0azMnXG5pbXBvcnQgeyBleGVjLCBtb25pdG9yRmlsZSB9IGZyb20gJ2FzdGFsJ1xuXG5jb25zdCBUTVAgPSBcIi90bXBcIlxuXG5leHBvcnQgZnVuY3Rpb24gY29tcGlsZVNjc3MoKTogc3RyaW5nIHtcbiAgdHJ5IHtcbiAgICBleGVjKGBzYXNzICR7U1JDfS9zdHlsZS5zY3NzICR7VE1QfS9zdHlsZS5jc3NgKVxuICAgIEFwcC5hcHBseV9jc3MoJy90bXAvc3R5bGUuY3NzJylcbiAgICByZXR1cm4gYCR7VE1QfS9zdHlsZS5zY3NzYFxuICB9IGNhdGNoKGVycikge1xuICAgIHByaW50ZXJyKCdFcnJvciBjb21waWxpbmcgc2NzcyBmaWxlcy4nLCBlcnIpXG4gICAgcmV0dXJuICcnXG4gIH1cbn1cblxuLy8gSG90IFJlbG9hZCBTY3NzXG4oZnVuY3Rpb24oKSB7XG4gIGNvbnN0IHNjc3NGaWxlcyA9XG4gICAgZXhlYyhgZmluZCAtTCAke1NSQ30gLWluYW1lICcqLnNjc3MnYClcbiAgICAgIC5zcGxpdCgnXFxuJylcblxuICAvLyBDb21waWxlIHNjc3MgZmlsZXMgYXQgc3RhcnR1cFxuICBjb21waWxlU2NzcygpXG5cbiAgc2Nzc0ZpbGVzXG4gICAgLmZvckVhY2goZmlsZSA9PlxuICAgICAgbW9uaXRvckZpbGUoZmlsZSwgY29tcGlsZVNjc3MpXG4gICAgKVxufSkoKVxuIiwgImltcG9ydCB7IEdMaWIsIFZhcmlhYmxlIH0gZnJvbSBcImFzdGFsXCJcbmltcG9ydCB7IGV4ZWNBc3luYyB9IGZyb20gXCJhc3RhbC9wcm9jZXNzXCJcbmltcG9ydCBNcHJpcyBmcm9tIFwiZ2k6Ly9Bc3RhbE1wcmlzXCJcblxuZXhwb3J0IGNvbnN0IHNob3dCYXIgPSBWYXJpYWJsZTxib29sZWFuPih0cnVlKVxuZXhwb3J0IGNvbnN0IHNob3dMZWZ0U2lkZWJhciA9IFZhcmlhYmxlPGJvb2xlYW4+KGZhbHNlKVxuZXhwb3J0IGNvbnN0IHNob3dSaWdodFNpZGViYXIgPSBWYXJpYWJsZTxib29sZWFuPihmYWxzZSlcbmV4cG9ydCBjb25zdCBzaG93Q3Jvc3NoYWlyID0gVmFyaWFibGU8Ym9vbGVhbj4oZmFsc2UpXG5leHBvcnQgY29uc3Qgc2hvd0xhdW5jaGVyID0gVmFyaWFibGU8Ym9vbGVhbj4oZmFsc2UpXG5leHBvcnQgY29uc3QgZG9Ob3REaXN0dXJiID0gVmFyaWFibGU8Ym9vbGVhbj4oZmFsc2UpXG5leHBvcnQgY29uc3QgbmlnaHRMaWdodEVuYWJsZWQgPSBWYXJpYWJsZTxib29sZWFuPihmYWxzZSlcbmV4cG9ydCBjb25zdCBub3RpZmljYXRpb25zTGVuZ3RoID0gVmFyaWFibGU8bnVtYmVyPigwKVxuZXhwb3J0IGNvbnN0IHNpZGViYXJQYW5lbCA9IFZhcmlhYmxlPHN0cmluZz4oXCJtYWluXCIpXG5leHBvcnQgY29uc3Qgc3BvdGlmeVBsYXllciA9IE1wcmlzLlBsYXllci5uZXcoXCJzcG90aWZ5XCIpXG5cbmV4ZWNBc3luYygncGdyZXAgLXggaHlwcnN1bnNldCcpXG4gIC50aGVuKCgpID0+IG5pZ2h0TGlnaHRFbmFibGVkLnNldCh0cnVlKSlcbiAgLmNhdGNoKCgpID0+IG5pZ2h0TGlnaHRFbmFibGVkLnNldChmYWxzZSkpXG5cbmV4cG9ydCBjb25zdCBjdXJyZW50VGltZSA9IFZhcmlhYmxlPHN0cmluZz4oXCJcIikucG9sbCgxMDAwLCAoKSA9PlxuICBHTGliLkRhdGVUaW1lLm5ld19ub3dfbG9jYWwoKS5mb3JtYXQoXCIlSDolTVwiKSEpXG5cbmV4cG9ydCBjb25zdCBjdXJyZW50RGF5ID0gVmFyaWFibGU8c3RyaW5nPihcIlwiKS5wb2xsKDEwMDAsICgpID0+XG4gIEdMaWIuRGF0ZVRpbWUubmV3X25vd19sb2NhbCgpLmZvcm1hdChcIl4lQSwgJWQgZGUgXiVCXCIpISlcblxuZXhwb3J0IGNvbnN0IHVwdGltZSA9IFZhcmlhYmxlKFwiXCIpLnBvbGwoNSAqIDYwICogMTAwMCwgYXN5bmMgKCkgPT4ge1xuICBjb25zdCBvdXRwdXQgPSBhd2FpdCBleGVjQXN5bmMoXCJ1cHRpbWUgLXBcIilcbiAgcmV0dXJuIG91dHB1dFxuICAgIC5yZXBsYWNlKC8gbWludXRlc3wgbWludXRlLywgXCJtXCIpXG4gICAgLnJlcGxhY2UoLyBob3Vyc3wgaG91ci8sIFwiaFwiKVxuICAgIC5yZXBsYWNlKC8gZGF5c3wgZGF5LywgXCJkXCIpXG4gICAgLnJlcGxhY2UoLyB3ZWVrc3wgd2Vlay8sIFwid1wiKVxufSlcblxuZXhwb3J0IGNvbnN0IG1lbW9yeVVzYWdlID0gVmFyaWFibGU8c3RyaW5nPihcIlwiKS5wb2xsKDUgKiAxMDAwLCBhc3luYyAoKSA9PiB7XG4gIGNvbnN0IG91dHB1dCA9IGF3YWl0IGV4ZWNBc3luYyhbXCJzaFwiLCBcIi1jXCIsIGBmcmVlIC0tbWVnYSB8IGF3ayAnTlI9PTJ7cHJpbnQgJDMgXCIgTUJcIn0nYF0pXG4gIHJldHVybiBvdXRwdXRcbn0pXG5cbnR5cGUgV2VhdGhlckRhdGEgPSB7XG4gIHRpbWVzdGFtcDogc3RyaW5nXG4gIHdlYXRoZXI6IGFueVxufTtcblxuZXhwb3J0IGNvbnN0IHdlYXRoZXJSZXBvcnQgPSBWYXJpYWJsZTxXZWF0aGVyRGF0YSB8IG51bGw+KG51bGwpLnBvbGwoMjAgKiA2MCAqIDEwMDAsIGFzeW5jICgpID0+IHtcbiAgdHJ5IHtcbiAgICBjb25zdCByZXN1bHQgPSBhd2FpdCBleGVjQXN5bmMoYGN1cmwgLXMgXCJ3dHRyLmluL0N1cml0aWJhP2Zvcm1hdD1qMVwiYClcbiAgICBjb25zdCB3ZWF0aGVyID0gSlNPTi5wYXJzZShyZXN1bHQpXG4gICAgY29uc3QgdGltZXN0YW1wID0gY3VycmVudFRpbWUuZ2V0KClcbiAgICByZXR1cm4geyB0aW1lc3RhbXAsIHdlYXRoZXIgfVxuICB9IGNhdGNoIChlcnIpIHtcbiAgICBjb25zb2xlLmVycm9yKFwiRXJyb3IgZmV0Y2hpbmcgd2VhdGhlcjpcIiwgZXJyKVxuICAgIHJldHVybiBudWxsXG4gIH1cbn0pXG4iLCAiaW1wb3J0IHsgQXBwLCBBc3RhbCwgR2RrLCBHdGsgfSBmcm9tIFwiYXN0YWwvZ3RrM1wiXG5pbXBvcnQgeyBWYXJpYWJsZSwgYmluZCB9IGZyb20gXCJhc3RhbFwiXG5pbXBvcnQgQmF0dGVyeSBmcm9tIFwiZ2k6Ly9Bc3RhbEJhdHRlcnlcIlxuaW1wb3J0IEJsdWV0b290aCBmcm9tIFwiZ2k6Ly9Bc3RhbEJsdWV0b290aFwiXG5pbXBvcnQgSHlwcmxhbmQgZnJvbSBcImdpOi8vQXN0YWxIeXBybGFuZFwiXG5pbXBvcnQgTXByaXMgZnJvbSBcImdpOi8vQXN0YWxNcHJpc1wiXG5pbXBvcnQgTmV0d29yayBmcm9tIFwiZ2k6Ly9Bc3RhbE5ldHdvcmtcIlxuaW1wb3J0IFRyYXkgZnJvbSBcImdpOi8vQXN0YWxUcmF5XCJcbmltcG9ydCBUaW1lIGZyb20gXCJAd2lkZ2V0cy9UaW1lL1RpbWVcIlxuaW1wb3J0IHsgZ2V0V2VhdGhlckVtb2ppIH0gZnJvbSBcIkBjb21tb24vZnVuY3Rpb25zXCJcbmltcG9ydCB7IG1lbW9yeVVzYWdlLCBub3RpZmljYXRpb25zTGVuZ3RoLCBzaG93TGVmdFNpZGViYXIsIHNob3dSaWdodFNpZGViYXIsIHdlYXRoZXJSZXBvcnQgfSBmcm9tIFwiQGNvbW1vbi92YXJzXCJcblxuZnVuY3Rpb24gU3lzVHJheSgpIHtcbiAgY29uc3QgdHJheSA9IFRyYXkuZ2V0X2RlZmF1bHQoKVxuXG4gIHJldHVybiA8Ym94IGNsYXNzTmFtZT1cIlN5c1RyYXlcIj5cbiAgICB7YmluZCh0cmF5LCBcIml0ZW1zXCIpLmFzKGl0ZW1zID0+IGl0ZW1zLm1hcChpdGVtID0+IChcbiAgICAgIDxtZW51YnV0dG9uXG4gICAgICAgIHRvb2x0aXBNYXJrdXA9e2JpbmQoaXRlbSwgXCJ0b29sdGlwTWFya3VwXCIpfVxuICAgICAgICB1c2VQb3BvdmVyPXtmYWxzZX1cbiAgICAgICAgYWN0aW9uR3JvdXA9e2JpbmQoaXRlbSwgXCJhY3Rpb25Hcm91cFwiKS5hcyhhZyA9PiBbXCJkYnVzbWVudVwiLCBhZ10pfVxuICAgICAgICBtZW51TW9kZWw9e2JpbmQoaXRlbSwgXCJtZW51TW9kZWxcIil9PlxuICAgICAgICA8aWNvbiBnaWNvbj17YmluZChpdGVtLCBcImdpY29uXCIpfSAvPlxuICAgICAgPC9tZW51YnV0dG9uPlxuICAgICkpKX1cbiAgPC9ib3g+XG59XG5cbmZ1bmN0aW9uIE5ldHdvcmtNb2R1bGUoKSB7XG4gIGNvbnN0IG5ldHdvcmsgPSBOZXR3b3JrLmdldF9kZWZhdWx0KClcbiAgY29uc3QgbmV0d29ya1R5cGVzID0geyBcIjFcIjogXCJ3aXJlZFwiLCBcIjJcIjogXCJ3aWZpXCIgfVxuXG4gIHJldHVybiBiaW5kKG5ldHdvcmssIFwicHJpbWFyeVwiKS5hcyhwID0+IHtcbiAgICBjb25zdCBkZXYgPSBuZXR3b3JrW25ldHdvcmtUeXBlc1twXV1cbiAgICBpZiAoZGV2KSB7XG4gICAgICByZXR1cm4gPGljb25cbiAgICAgICAgY2xhc3NOYW1lPVwiTmV0d29ya1wiXG4gICAgICAgIGljb249e2JpbmQoZGV2LCBcImljb25OYW1lXCIpfSAvPlxuICAgIH1cbiAgICByZXR1cm4gPGJveCAvPlxuICB9KVxufVxuXG5mdW5jdGlvbiBCbHVldG9vdGhNb2R1bGUoKSB7XG4gIGNvbnN0IGJsdWV0b290aCA9IEJsdWV0b290aC5nZXRfZGVmYXVsdCgpXG5cbiAgcmV0dXJuIDxyZXZlYWxlclxuICAgIHRyYW5zaXRpb25UeXBlPXtHdGsuUmV2ZWFsZXJUcmFuc2l0aW9uVHlwZS5TTElERV9MRUZUfVxuICAgIHJldmVhbENoaWxkPXtiaW5kKGJsdWV0b290aCwgXCJpc19jb25uZWN0ZWRcIil9PlxuICAgIDxsYWJlbCBjbGFzc05hbWU9XCJCbHVldG9vdGhcIiBsYWJlbD1cIlx1REI4MFx1RENCMVwiIC8+XG4gIDwvcmV2ZWFsZXI+XG59XG5cbmZ1bmN0aW9uIEJhdHRlcnlMZXZlbCgpIHtcbiAgY29uc3QgYmF0ID0gQmF0dGVyeS5nZXRfZGVmYXVsdCgpXG5cbiAgcmV0dXJuIDxib3ggY2xhc3NOYW1lPVwiQmF0dGVyeVwiXG4gICAgdmlzaWJsZT17YmluZChiYXQsIFwiaXNQcmVzZW50XCIpfT5cbiAgICA8bGFiZWwgbGFiZWw9e2JpbmQoYmF0LCBcInBlcmNlbnRhZ2VcIikuYXMocCA9PiBgJHtNYXRoLmZsb29yKHAgKiAxMDApfSVgKX0gLz5cbiAgICA8aWNvbiBpY29uPXtiaW5kKGJhdCwgXCJiYXR0ZXJ5SWNvbk5hbWVcIil9IC8+XG4gIDwvYm94PlxufVxuXG5mdW5jdGlvbiBnZXRUaXRsZShwbGF5ZXI6IE1wcmlzLlBsYXllcik6IHN0cmluZyB7XG4gIHJldHVybiBwbGF5ZXIuYXJ0aXN0XG4gICAgPyBgJHtwbGF5ZXIuYXJ0aXN0fTogJHtwbGF5ZXIudGl0bGV9YFxuICAgIDogcGxheWVyLmFsYnVtXG4gICAgICA/IGAke3BsYXllci5hbGJ1bX06ICR7cGxheWVyLnRpdGxlfWBcbiAgICAgIDogYCR7cGxheWVyLnRpdGxlfWBcbn1cblxuZnVuY3Rpb24gTWVkaWEoKSB7XG4gIGNvbnN0IG1wcmlzID0gTXByaXMuZ2V0X2RlZmF1bHQoKVxuXG4gIHJldHVybiBiaW5kKG1wcmlzLCBcInBsYXllcnNcIikuYXMocHMgPT4gcHNbMF0gPyAoXG4gICAgPGJ1dHRvbiBjbGFzc05hbWU9XCJNZWRpYVwiXG4gICAgICBvbkNsaWNrPXsoKSA9PiBwc1swXS5wbGF5X3BhdXNlKCl9PlxuICAgICAgPGxhYmVsXG4gICAgICAgIGNsYXNzTmFtZT17YmluZChwc1swXSwgXCJwbGF5YmFja1N0YXR1c1wiKS5hcyhzID0+IHMgPiAwID8gXCJwYXVzZWRcIiA6IFwicGxheWluZ1wiKX1cbiAgICAgICAgdHJ1bmNhdGVcbiAgICAgICAgbWF4V2lkdGhDaGFycz17ODB9XG4gICAgICAgIGxhYmVsPXtiaW5kKHBzWzBdLCBcIm1ldGFkYXRhXCIpLmFzKCgpID0+IGdldFRpdGxlKHBzWzBdKSl9IC8+XG4gICAgPC9idXR0b24+XG4gICkgOiAoPGJveCAvPikpXG59XG5cbmZ1bmN0aW9uIFdvcmtzcGFjZXMoKSB7XG4gIGNvbnN0IGh5cHIgPSBIeXBybGFuZC5nZXRfZGVmYXVsdCgpXG5cbiAgcmV0dXJuIDxib3ggY2xhc3NOYW1lPVwiV29ya3NwYWNlc1wiPlxuICAgIHtiaW5kKGh5cHIsIFwid29ya3NwYWNlc1wiKS5hcyh3c3MgPT4gd3NzXG4gICAgICAuZmlsdGVyKHdzID0+ICEod3MuaWQgPj0gLTk5ICYmIHdzLmlkIDw9IC0yKSkgLy8gZmlsdGVyIG91dCBzcGVjaWFsIHdvcmtzcGFjZXNcbiAgICAgIC5zb3J0KChhLCBiKSA9PiBhLmlkIC0gYi5pZClcbiAgICAgIC5tYXAod3MgPT4gKFxuICAgICAgICA8YnV0dG9uXG4gICAgICAgICAgY2xhc3NOYW1lPXtiaW5kKGh5cHIsIFwiZm9jdXNlZFdvcmtzcGFjZVwiKS5hcyhmdyA9PlxuICAgICAgICAgICAgd3MgPT09IGZ3ID8gXCJmb2N1c2VkXCIgOiBcIlwiKX1cbiAgICAgICAgICBvbkNsaWNrZWQ9eygpID0+IHdzLmZvY3VzKCl9PlxuICAgICAgICAgIHt3cy5pZH1cbiAgICAgICAgPC9idXR0b24+XG4gICAgICApKVxuICAgICl9XG4gIDwvYm94PlxufVxuXG5mdW5jdGlvbiBXZWF0aGVyKCkge1xuICBjb25zdCB2aXNpYmxlID0gVmFyaWFibGU8Ym9vbGVhbj4oZmFsc2UpXG4gIHJldHVybiA8cmV2ZWFsZXJcbiAgICB0cmFuc2l0aW9uVHlwZT17R3RrLlJldmVhbGVyVHJhbnNpdGlvblR5cGUuU0xJREVfUklHSFR9XG4gICAgcmV2ZWFsQ2hpbGQ9e3Zpc2libGUoKX0+XG4gICAge2JpbmQod2VhdGhlclJlcG9ydCkuYXMoKGRhdGEpID0+IHtcbiAgICAgIGlmIChkYXRhKSB7XG4gICAgICAgIGNvbnN0IGNvbmRpdGlvbiA9IGRhdGEud2VhdGhlci5jdXJyZW50X2NvbmRpdGlvblswXVxuICAgICAgICBjb25zdCB0ZW1wID0gY29uZGl0aW9uLnRlbXBfQ1xuICAgICAgICBjb25zdCBlbW9qaSA9IGdldFdlYXRoZXJFbW9qaShjb25kaXRpb24ud2VhdGhlckRlc2NbMF0udmFsdWUpXG4gICAgICAgIHZpc2libGUuc2V0KHRydWUpXG4gICAgICAgIHJldHVybiA8bGFiZWwgY2xhc3NOYW1lPVwiV2VhdGhlclwiIGxhYmVsPXtgJHt0ZW1wfVx1MDBCMEMgJHtlbW9qaX1gfSAvPlxuICAgICAgfVxuICAgICAgcmV0dXJuIDxib3ggLz5cbiAgICB9KX1cbiAgPC9yZXZlYWxlcj5cbn1cblxuZnVuY3Rpb24gTm90aWZpY2F0aW9uQmVsbCgpIHtcbiAgcmV0dXJuIDxyZXZlYWxlclxuICAgIHRyYW5zaXRpb25UeXBlPXtHdGsuUmV2ZWFsZXJUcmFuc2l0aW9uVHlwZS5TTElERV9MRUZUfVxuICAgIHJldmVhbENoaWxkPXtiaW5kKG5vdGlmaWNhdGlvbnNMZW5ndGgpLmFzKGwgPT4gbCA+IDEpfT5cbiAgICA8bGFiZWwgY2xhc3NOYW1lPVwiTm90aWZpY2F0aW9uQmVsbFwiIGxhYmVsPVwiXHVEQjg0XHVERDZCXCIgLz5cbiAgPC9yZXZlYWxlcj5cbn1cblxuZnVuY3Rpb24gTWVtb3J5KCkge1xuICByZXR1cm4gPGxhYmVsXG4gICAgY2xhc3NOYW1lPVwiTWVtb3J5XCJcbiAgICBvbkRlc3Ryb3k9eygpID0+IG1lbW9yeVVzYWdlLmRyb3AoKX1cbiAgICBsYWJlbD17bWVtb3J5VXNhZ2UoKX1cbiAgLz5cbn1cblxuZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gQmFyKG1vbml0b3I6IEdkay5Nb25pdG9yLCB2aXNpYmxlOiBWYXJpYWJsZTxib29sZWFuPikge1xuICBjb25zdCB7IFRPUCwgTEVGVCwgUklHSFQgfSA9IEFzdGFsLldpbmRvd0FuY2hvclxuXG4gIHJldHVybiA8d2luZG93XG4gICAgY2xhc3NOYW1lPVwiQmFyXCJcbiAgICBuYW1lc3BhY2U9XCJiYXJcIlxuICAgIGdka21vbml0b3I9e21vbml0b3J9XG4gICAgZXhjbHVzaXZpdHk9e0FzdGFsLkV4Y2x1c2l2aXR5LkVYQ0xVU0lWRX1cbiAgICBhcHBsaWNhdGlvbj17QXBwfVxuICAgIHZpc2libGU9e3Zpc2libGUoKX1cbiAgICBsYXllcj17QXN0YWwuTGF5ZXIuVE9QfVxuICAgIGFuY2hvcj17VE9QIHwgTEVGVCB8IFJJR0hUfT5cbiAgICA8Y2VudGVyYm94PlxuICAgICAgPGJveFxuICAgICAgICBoZXhwYW5kXG4gICAgICAgIGhhbGlnbj17R3RrLkFsaWduLlNUQVJUfVxuICAgICAgICBjc3M9XCJtYXJnaW4tbGVmdDogNHB4XCI+XG4gICAgICAgIDxidXR0b25cbiAgICAgICAgICBjbGFzc05hbWU9XCJUaW1lQW5kV2VhdGhlclwiXG4gICAgICAgICAgb25DbGlja2VkPXsoKSA9PiBzaG93TGVmdFNpZGViYXIuc2V0KCFzaG93TGVmdFNpZGViYXIuZ2V0KCkpfVxuICAgICAgICA+XG4gICAgICAgICAgPGJveD5cbiAgICAgICAgICAgIDxUaW1lIC8+XG4gICAgICAgICAgICA8V2VhdGhlciAvPlxuICAgICAgICAgIDwvYm94PlxuICAgICAgICA8L2J1dHRvbj5cbiAgICAgICAgPFdvcmtzcGFjZXMgLz5cbiAgICAgIDwvYm94PlxuICAgICAgPE1lZGlhIC8+XG4gICAgICA8Ym94XG4gICAgICAgIGhleHBhbmRcbiAgICAgICAgaGFsaWduPXtHdGsuQWxpZ24uRU5EfVxuICAgICAgICBjc3M9XCJtYXJnaW4tcmlnaHQ6IDRweFwiPlxuICAgICAgICA8U3lzVHJheSAvPlxuICAgICAgICA8YnV0dG9uXG4gICAgICAgICAgY2xhc3NOYW1lPVwiVGltZUFuZFdlYXRoZXJcIlxuICAgICAgICAgIG9uQ2xpY2tlZD17KCkgPT4gc2hvd1JpZ2h0U2lkZWJhci5zZXQoIXNob3dSaWdodFNpZGViYXIuZ2V0KCkpfVxuICAgICAgICA+XG4gICAgICAgICAgPGJveD5cbiAgICAgICAgICAgIDxCYXR0ZXJ5TGV2ZWwgLz5cbiAgICAgICAgICAgIDxOZXR3b3JrTW9kdWxlIC8+XG4gICAgICAgICAgICA8Qmx1ZXRvb3RoTW9kdWxlIC8+XG4gICAgICAgICAgICA8Tm90aWZpY2F0aW9uQmVsbCAvPlxuICAgICAgICAgICAgPE1lbW9yeSAvPlxuICAgICAgICAgIDwvYm94PlxuICAgICAgICA8L2J1dHRvbj5cbiAgICAgIDwvYm94PlxuICAgIDwvY2VudGVyYm94PlxuICA8L3dpbmRvdz5cbn1cbiIsICJpbXBvcnQgR3RrIGZyb20gXCJnaTovL0d0az92ZXJzaW9uPTMuMFwiXG5pbXBvcnQgeyB0eXBlIEJpbmRhYmxlQ2hpbGQgfSBmcm9tIFwiLi9hc3RhbGlmeS5qc1wiXG5pbXBvcnQgeyBtZXJnZUJpbmRpbmdzLCBqc3ggYXMgX2pzeCB9IGZyb20gXCIuLi9fYXN0YWwuanNcIlxuaW1wb3J0ICogYXMgV2lkZ2V0IGZyb20gXCIuL3dpZGdldC5qc1wiXG5cbmV4cG9ydCBmdW5jdGlvbiBGcmFnbWVudCh7IGNoaWxkcmVuID0gW10sIGNoaWxkIH06IHtcbiAgICBjaGlsZD86IEJpbmRhYmxlQ2hpbGRcbiAgICBjaGlsZHJlbj86IEFycmF5PEJpbmRhYmxlQ2hpbGQ+XG59KSB7XG4gICAgaWYgKGNoaWxkKSBjaGlsZHJlbi5wdXNoKGNoaWxkKVxuICAgIHJldHVybiBtZXJnZUJpbmRpbmdzKGNoaWxkcmVuKVxufVxuXG5leHBvcnQgZnVuY3Rpb24ganN4KFxuICAgIGN0b3I6IGtleW9mIHR5cGVvZiBjdG9ycyB8IHR5cGVvZiBHdGsuV2lkZ2V0LFxuICAgIHByb3BzOiBhbnksXG4pIHtcbiAgICByZXR1cm4gX2pzeChjdG9ycywgY3RvciBhcyBhbnksIHByb3BzKVxufVxuXG5jb25zdCBjdG9ycyA9IHtcbiAgICBib3g6IFdpZGdldC5Cb3gsXG4gICAgYnV0dG9uOiBXaWRnZXQuQnV0dG9uLFxuICAgIGNlbnRlcmJveDogV2lkZ2V0LkNlbnRlckJveCxcbiAgICBjaXJjdWxhcnByb2dyZXNzOiBXaWRnZXQuQ2lyY3VsYXJQcm9ncmVzcyxcbiAgICBkcmF3aW5nYXJlYTogV2lkZ2V0LkRyYXdpbmdBcmVhLFxuICAgIGVudHJ5OiBXaWRnZXQuRW50cnksXG4gICAgZXZlbnRib3g6IFdpZGdldC5FdmVudEJveCxcbiAgICAvLyBUT0RPOiBmaXhlZFxuICAgIC8vIFRPRE86IGZsb3dib3hcbiAgICBpY29uOiBXaWRnZXQuSWNvbixcbiAgICBsYWJlbDogV2lkZ2V0LkxhYmVsLFxuICAgIGxldmVsYmFyOiBXaWRnZXQuTGV2ZWxCYXIsXG4gICAgLy8gVE9ETzogbGlzdGJveFxuICAgIG1lbnVidXR0b246IFdpZGdldC5NZW51QnV0dG9uLFxuICAgIG92ZXJsYXk6IFdpZGdldC5PdmVybGF5LFxuICAgIHJldmVhbGVyOiBXaWRnZXQuUmV2ZWFsZXIsXG4gICAgc2Nyb2xsYWJsZTogV2lkZ2V0LlNjcm9sbGFibGUsXG4gICAgc2xpZGVyOiBXaWRnZXQuU2xpZGVyLFxuICAgIHN0YWNrOiBXaWRnZXQuU3RhY2ssXG4gICAgc3dpdGNoOiBXaWRnZXQuU3dpdGNoLFxuICAgIHdpbmRvdzogV2lkZ2V0LldpbmRvdyxcbn1cblxuZGVjbGFyZSBnbG9iYWwge1xuICAgIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBAdHlwZXNjcmlwdC1lc2xpbnQvbm8tbmFtZXNwYWNlXG4gICAgbmFtZXNwYWNlIEpTWCB7XG4gICAgICAgIHR5cGUgRWxlbWVudCA9IEd0ay5XaWRnZXRcbiAgICAgICAgdHlwZSBFbGVtZW50Q2xhc3MgPSBHdGsuV2lkZ2V0XG4gICAgICAgIGludGVyZmFjZSBJbnRyaW5zaWNFbGVtZW50cyB7XG4gICAgICAgICAgICBib3g6IFdpZGdldC5Cb3hQcm9wc1xuICAgICAgICAgICAgYnV0dG9uOiBXaWRnZXQuQnV0dG9uUHJvcHNcbiAgICAgICAgICAgIGNlbnRlcmJveDogV2lkZ2V0LkNlbnRlckJveFByb3BzXG4gICAgICAgICAgICBjaXJjdWxhcnByb2dyZXNzOiBXaWRnZXQuQ2lyY3VsYXJQcm9ncmVzc1Byb3BzXG4gICAgICAgICAgICBkcmF3aW5nYXJlYTogV2lkZ2V0LkRyYXdpbmdBcmVhUHJvcHNcbiAgICAgICAgICAgIGVudHJ5OiBXaWRnZXQuRW50cnlQcm9wc1xuICAgICAgICAgICAgZXZlbnRib3g6IFdpZGdldC5FdmVudEJveFByb3BzXG4gICAgICAgICAgICAvLyBUT0RPOiBmaXhlZFxuICAgICAgICAgICAgLy8gVE9ETzogZmxvd2JveFxuICAgICAgICAgICAgaWNvbjogV2lkZ2V0Lkljb25Qcm9wc1xuICAgICAgICAgICAgbGFiZWw6IFdpZGdldC5MYWJlbFByb3BzXG4gICAgICAgICAgICBsZXZlbGJhcjogV2lkZ2V0LkxldmVsQmFyUHJvcHNcbiAgICAgICAgICAgIC8vIFRPRE86IGxpc3Rib3hcbiAgICAgICAgICAgIG1lbnVidXR0b246IFdpZGdldC5NZW51QnV0dG9uUHJvcHNcbiAgICAgICAgICAgIG92ZXJsYXk6IFdpZGdldC5PdmVybGF5UHJvcHNcbiAgICAgICAgICAgIHJldmVhbGVyOiBXaWRnZXQuUmV2ZWFsZXJQcm9wc1xuICAgICAgICAgICAgc2Nyb2xsYWJsZTogV2lkZ2V0LlNjcm9sbGFibGVQcm9wc1xuICAgICAgICAgICAgc2xpZGVyOiBXaWRnZXQuU2xpZGVyUHJvcHNcbiAgICAgICAgICAgIHN0YWNrOiBXaWRnZXQuU3RhY2tQcm9wc1xuICAgICAgICAgICAgc3dpdGNoOiBXaWRnZXQuU3dpdGNoUHJvcHNcbiAgICAgICAgICAgIHdpbmRvdzogV2lkZ2V0LldpbmRvd1Byb3BzXG4gICAgICAgIH1cbiAgICB9XG59XG5cbmV4cG9ydCBjb25zdCBqc3hzID0ganN4XG4iLCAiaW1wb3J0IHsgYmluZCB9IGZyb20gXCJhc3RhbFwiXG5pbXBvcnQgeyBHdGsgfSBmcm9tIFwiYXN0YWwvZ3RrM1wiXG5pbXBvcnQgeyBjdXJyZW50VGltZSB9IGZyb20gXCJAY29tbW9uL3ZhcnNcIlxuXG5mdW5jdGlvbiBEaWdpdFN0YWNrKGluZGV4OiBudW1iZXIpIHtcbiAgcmV0dXJuIChcbiAgICA8c3RhY2tcbiAgICAgIHRyYW5zaXRpb25UeXBlPXtHdGsuU3RhY2tUcmFuc2l0aW9uVHlwZS5TTElERV9ET1dOfVxuICAgICAgdHJhbnNpdGlvbkR1cmF0aW9uPXs1MDB9XG4gICAgICB2aXNpYmxlQ2hpbGROYW1lPXtiaW5kKGN1cnJlbnRUaW1lKS5hcyh0aW1lID0+IHRpbWU/LltpbmRleF0gPz8gXCIwXCIpfVxuICAgICAgY2xhc3NOYW1lPVwiRGlnaXRTdGFja1wiXG4gICAgPlxuICAgICAge0FycmF5LmZyb20oeyBsZW5ndGg6IDEwIH0sIChfLCBpKSA9PiAoXG4gICAgICAgIDxsYWJlbCBuYW1lPXtpLnRvU3RyaW5nKCl9IGxhYmVsPXtpLnRvU3RyaW5nKCl9IC8+XG4gICAgICApKX1cbiAgICA8L3N0YWNrPlxuICApXG59XG5cbmV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIFRpbWUoKSB7XG4gIHJldHVybiAoXG4gICAgPGJveFxuICAgICAgY2xhc3NOYW1lPVwiVGltZVwiXG4gICAgICBoYWxpZ249e0d0ay5BbGlnbi5DRU5URVJ9XG4gICAgICB2YWxpZ249e0d0ay5BbGlnbi5DRU5URVJ9XG4gICAgPlxuICAgICAge0RpZ2l0U3RhY2soMCl9XG4gICAgICB7RGlnaXRTdGFjaygxKX1cbiAgICAgIDxsYWJlbCBsYWJlbD1cIjpcImNzcz1cImZvbnQtZmFtaWx5OiAnSmV0QnJhaW5zTW9ubyBOZXJkIEZvbnQnXCIgLz5cbiAgICAgIHtEaWdpdFN0YWNrKDMpfVxuICAgICAge0RpZ2l0U3RhY2soNCl9XG4gICAgPC9ib3g+XG4gIClcbn1cbiIsICJpbXBvcnQgeyBBc3RhbCB9IGZyb20gXCJhc3RhbC9ndGszXCJcblxuZXhwb3J0IGNvbnN0IGlzSWNvbiA9IChpY29uOiBzdHJpbmcpID0+XG4gICEhQXN0YWwuSWNvbi5sb29rdXBfaWNvbihpY29uKVxuXG5leHBvcnQgZnVuY3Rpb24gZ2V0V2VhdGhlckVtb2ppKGRlc2M6IHN0cmluZyk6IHN0cmluZyB7XG4gIGRlc2MgPSBkZXNjLnRvTG93ZXJDYXNlKClcblxuICBpZiAoZGVzYy5pbmNsdWRlcyhcInN1bm55XCIpIHx8IGRlc2MuaW5jbHVkZXMoXCJjbGVhclwiKSkgcmV0dXJuIFwiXHUyNjAwXHVGRTBGXCJcbiAgaWYgKGRlc2MuaW5jbHVkZXMoXCJwYXJ0bHlcIikpIHJldHVybiBcIlx1MjZDNVwiXG4gIGlmIChkZXNjLmluY2x1ZGVzKFwiY2xvdWR5XCIpIHx8IGRlc2MuaW5jbHVkZXMoXCJvdmVyY2FzdFwiKSkgcmV0dXJuIFwiXHUyNjAxXHVGRTBGXCJcbiAgaWYgKGRlc2MuaW5jbHVkZXMoXCJyYWluXCIpIHx8IGRlc2MuaW5jbHVkZXMoXCJkcml6emxlXCIpKSByZXR1cm4gXCJcdUQ4M0NcdURGMjdcdUZFMEZcIlxuICBpZiAoZGVzYy5pbmNsdWRlcyhcInRodW5kZXJcIikpIHJldHVybiBcIlx1MjZDOFx1RkUwRlwiXG4gIGlmIChkZXNjLmluY2x1ZGVzKFwic25vd1wiKSkgcmV0dXJuIFwiXHUyNzQ0XHVGRTBGXCJcbiAgaWYgKGRlc2MuaW5jbHVkZXMoXCJmb2dcIikgfHwgZGVzYy5pbmNsdWRlcyhcIm1pc3RcIikpIHJldHVybiBcIlx1RDgzQ1x1REYyQlx1RkUwRlwiXG5cbiAgcmV0dXJuIFwiXHVEODNDXHVERjA4XCIgLy8gZmFsbGJhY2tcbn1cblxuZXhwb3J0IGZ1bmN0aW9uIGdldFdlYXRoZXJJbWFnZShkZXNjOiBzdHJpbmcpOiBzdHJpbmcge1xuICBkZXNjID0gZGVzYy50b0xvd2VyQ2FzZSgpXG5cbiAgaWYgKGRlc2MuaW5jbHVkZXMoXCJzdW5ueVwiKSB8fCBkZXNjLmluY2x1ZGVzKFwiY2xlYXJcIikpIHJldHVybiBcImNsZWFyLnBuZ1wiXG4gIGlmIChkZXNjLmluY2x1ZGVzKFwicGFydGx5XCIpKSByZXR1cm4gXCJwYXJ0bHlfY2xvdWR5LnBuZ1wiXG4gIGlmIChkZXNjLmluY2x1ZGVzKFwiY2xvdWR5XCIpIHx8IGRlc2MuaW5jbHVkZXMoXCJvdmVyY2FzdFwiKSkgcmV0dXJuIFwiY2xvdWR5LnBuZ1wiXG4gIGlmIChkZXNjLmluY2x1ZGVzKFwibGlnaHRcIikpIHJldHVybiBcImxpZ2h0X3JhaW4ucG5nXCIgLy8gaW5jbHVpIHRibSBvIGxpZ2h0IGRyaXp6bGVcbiAgaWYgKGRlc2MuaW5jbHVkZXMoXCJyYWluXCIpIHx8IGRlc2MuaW5jbHVkZXMoXCJkcml6emxlXCIpKSByZXR1cm4gXCJyYWluLnBuZ1wiXG4gIGlmIChkZXNjLmluY2x1ZGVzKFwidGh1bmRlclwiKSkgcmV0dXJuIFwic3Rvcm0ucG5nXCJcbiAgLy8gaWYgKGRlc2MuaW5jbHVkZXMoXCJzbm93XCIpKSByZXR1cm4gXCJcdTI3NDRcdUZFMEZcIlxuICBpZiAoZGVzYy5pbmNsdWRlcyhcImZvZ1wiKSB8fCBkZXNjLmluY2x1ZGVzKFwibWlzdFwiKSkgcmV0dXJuIFwiZm9nLnBuZ1wiXG5cbiAgcmV0dXJuIFwib3RoZXIucG5nXCJcbn1cblxuZXhwb3J0IGZ1bmN0aW9uIGdldFdpZmlJY29uKGljb24pIHtcbiAgaWYgKGljb24uaW5jbHVkZXMoXCJvZmZsaW5lXCIpKSByZXR1cm4gXCJcdURCODJcdUREMkVcIlxuICBpZiAoaWNvbi5pbmNsdWRlcyhcIm5vLXJvdXRlXCIpKSByZXR1cm4gXCJcdURCODJcdUREMkRcIlxuICBpZiAoaWNvbi5pbmNsdWRlcyhcImNvbm5lY3RlZFwiKSkgcmV0dXJuIFwiXHVEQjgyXHVERDJCXCJcbiAgaWYgKGljb24uaW5jbHVkZXMoXCJzaWduYWwtbm9uZVwiKSkgcmV0dXJuIFwiXHVEQjgyXHVERDJGXCJcbiAgaWYgKGljb24uaW5jbHVkZXMoXCJzaWduYWwtd2Vha1wiKSkgcmV0dXJuIFwiXHVEQjgyXHVERDFGXCJcbiAgaWYgKGljb24uaW5jbHVkZXMoXCJzaWduYWwtb2tcIikpIHJldHVybiBcIlx1REI4Mlx1REQyMlwiXG4gIGlmIChpY29uLmluY2x1ZGVzKFwic2lnbmFsLWdvb2RcIikpIHJldHVybiBcIlx1REI4Mlx1REQyNVwiXG4gIGlmIChpY29uLmluY2x1ZGVzKFwiZW5jcnlwdGVkXCIpKSByZXR1cm4gXCJcdURCODJcdUREMkFcIlxuICByZXR1cm4gXCJcdURCODJcdUREMjhcIlxufVxuXG5leHBvcnQgZnVuY3Rpb24gZXNjYXBlTWFya3VwKHRleHQ6IHN0cmluZyk6IHN0cmluZyB7XG4gIHJldHVybiB0ZXh0LnJlcGxhY2UoLyYvZywgXCImYW1wO1wiKTtcbn1cbiIsICJpbXBvcnQgeyBBcHAsIEFzdGFsLCBHZGsgfSBmcm9tIFwiYXN0YWwvZ3RrM1wiXG5pbXBvcnQgeyBWYXJpYWJsZSB9IGZyb20gXCJhc3RhbFwiXG5cbmV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIENyb3NzaGFpcihtb25pdG9yOiBHZGsuTW9uaXRvciwgdmlzaWJsZTogVmFyaWFibGU8Ym9vbGVhbj4pIHtcbiAgcmV0dXJuIDx3aW5kb3dcbiAgICBjbGFzc05hbWU9XCJDcm9zc2hhaXJcIlxuICAgIG5hbWVzcGFjZT1cImNyb3NzaGFpclwiXG4gICAgZ2RrbW9uaXRvcj17bW9uaXRvcn1cbiAgICB2aXNpYmxlPXt2aXNpYmxlKCl9XG4gICAgbGF5ZXI9e0FzdGFsLkxheWVyLk9WRVJMQVl9XG4gICAgYXBwbGljYXRpb249e0FwcH1cbiAgICBleGNsdXNpdml0eT17QXN0YWwuRXhjbHVzaXZpdHkuSUdOT1JFfVxuICAgIGtleW1vZGU9e0FzdGFsLktleW1vZGUuTk9ORX1cbiAgICBjYW5Gb2N1cz17ZmFsc2V9XG4gICAgYWNjZXB0Rm9jdXM9e2ZhbHNlfVxuICA+XG4gICAgPGJveFxuICAgICAgY2xhc3NOYW1lPVwiRG90XCJcbiAgICAvPlxuICA8L3dpbmRvdz5cbn1cbiIsICJpbXBvcnQgeyBBcHAsIEFzdGFsLCBHZGssIEd0ayB9IGZyb20gXCJhc3RhbC9ndGszXCJcbmltcG9ydCB7IFZhcmlhYmxlIH0gZnJvbSBcImFzdGFsXCJcbmltcG9ydCBBcHBzIGZyb20gXCJnaTovL0FzdGFsQXBwc1wiXG5pbXBvcnQgeyBzaG93TGF1bmNoZXIgfSBmcm9tIFwiQGNvbW1vbi92YXJzXCJcblxuY29uc3QgTUFYX0lURU1TID0gOFxuXG5mdW5jdGlvbiBoaWRlKCkge1xuICBzaG93TGF1bmNoZXIuc2V0KGZhbHNlKVxufVxuXG5mdW5jdGlvbiBBcHBCdXR0b24oeyBhcHAgfTogeyBhcHA6IEFwcHMuQXBwbGljYXRpb24gfSkge1xuICByZXR1cm4gPGJ1dHRvblxuICAgIGNsYXNzTmFtZT1cIkFwcEJ1dHRvblwiXG4gICAgb25DbGlja2VkPXsoKSA9PiB7IGhpZGUoKTsgYXBwLmxhdW5jaCgpIH19PlxuICAgIDxib3g+XG4gICAgICA8aWNvbiBpY29uPXthcHAuaWNvbk5hbWUgfHwgXCJoZWxwLWJyb3dzZXJcIn0gLz5cbiAgICAgIDxib3ggdmFsaWduPXtHdGsuQWxpZ24uQ0VOVEVSfSB2ZXJ0aWNhbD5cbiAgICAgICAgPGxhYmVsXG4gICAgICAgICAgY2xhc3NOYW1lPVwibmFtZVwiXG4gICAgICAgICAgdHJ1bmNhdGVcbiAgICAgICAgICB4YWxpZ249ezB9XG4gICAgICAgICAgbGFiZWw9e2FwcC5uYW1lfVxuICAgICAgICAvPlxuICAgICAgICB7YXBwLmRlc2NyaXB0aW9uICYmIDxsYWJlbFxuICAgICAgICAgIGNsYXNzTmFtZT1cImRlc2NyaXB0aW9uXCJcbiAgICAgICAgICB3cmFwXG4gICAgICAgICAgeGFsaWduPXswfVxuICAgICAgICAgIGxhYmVsPXthcHAuZGVzY3JpcHRpb259XG4gICAgICAgIC8+fVxuICAgICAgPC9ib3g+XG4gICAgPC9ib3g+XG4gIDwvYnV0dG9uPlxufVxuXG5leHBvcnQgZGVmYXVsdCBmdW5jdGlvbiBMYXVuY2hlcihtb25pdG9yOiBHZGsuTW9uaXRvciwgdmlzaWJsZTogVmFyaWFibGU8Ym9vbGVhbj4pIHtcbiAgY29uc3QgYXBwcyA9IG5ldyBBcHBzLkFwcHMoKVxuICBjb25zdCB3aWR0aCA9IFZhcmlhYmxlKDEwMDApXG5cbiAgY29uc3QgdGV4dCA9IFZhcmlhYmxlKFwiXCIpXG4gIGNvbnN0IGxpc3QgPSB0ZXh0KHRleHQgPT4gYXBwcy5mdXp6eV9xdWVyeSh0ZXh0KS5zbGljZSgwLCBNQVhfSVRFTVMpKVxuICBjb25zdCBvbkVudGVyID0gKCkgPT4ge1xuICAgIGFwcHMuZnV6enlfcXVlcnkodGV4dC5nZXQoKSk/LlswXS5sYXVuY2goKVxuICAgIGhpZGUoKVxuICB9XG5cbiAgcmV0dXJuIDx3aW5kb3dcbiAgICBuYW1lPVwibGF1bmNoZXJcIlxuICAgIGV4Y2x1c2l2aXR5PXtBc3RhbC5FeGNsdXNpdml0eS5JR05PUkV9XG4gICAga2V5bW9kZT17QXN0YWwuS2V5bW9kZS5PTl9ERU1BTkR9XG4gICAgYXBwbGljYXRpb249e0FwcH1cbiAgICBnZGttb25pdG9yPXttb25pdG9yfVxuICAgIHZpc2libGU9e3Zpc2libGUoKX1cbiAgICBvblNob3c9eyhzZWxmKSA9PiB7XG4gICAgICB0ZXh0LnNldChcIlwiKVxuICAgICAgd2lkdGguc2V0KHNlbGYuZ2V0X2N1cnJlbnRfbW9uaXRvcigpLndvcmthcmVhLndpZHRoKVxuICAgIH19XG4gICAgb25LZXlQcmVzc0V2ZW50PXtmdW5jdGlvbihfLCBldmVudDogR2RrLkV2ZW50KSB7XG4gICAgICBpZiAoZXZlbnQuZ2V0X2tleXZhbCgpWzFdID09PSBHZGsuS0VZX0VzY2FwZSlcbiAgICAgICAgaGlkZSgpXG4gICAgfX0+XG4gICAgPGJveD5cbiAgICAgIDxldmVudGJveCB3aWR0aFJlcXVlc3Q9e3dpZHRoKHcgPT4gdyAvIDIpfSBleHBhbmQgb25DbGljaz17aGlkZX0gLz5cbiAgICAgIDxib3ggaGV4cGFuZD17ZmFsc2V9IHZlcnRpY2FsPlxuICAgICAgICA8ZXZlbnRib3ggaGVpZ2h0UmVxdWVzdD17MTAwfSBvbkNsaWNrPXtoaWRlfSAvPlxuICAgICAgICA8Ym94IHdpZHRoUmVxdWVzdD17NTAwfSBjbGFzc05hbWU9XCJBcHBsYXVuY2hlclwiIHZlcnRpY2FsPlxuICAgICAgICAgIDxlbnRyeVxuICAgICAgICAgICAgcGxhY2Vob2xkZXJUZXh0PVwiU2VhcmNoXCJcbiAgICAgICAgICAgIHRleHQ9e3RleHQoKX1cbiAgICAgICAgICAgIG9uQ2hhbmdlZD17c2VsZiA9PiB7XG4gICAgICAgICAgICAgIGlmIChzZWxmLnRleHQuc3RhcnRzV2l0aChcIjplXCIpKSBwcmludChcImVtb2ppXCIpXG4gICAgICAgICAgICAgIHJldHVybiB0ZXh0LnNldChzZWxmLnRleHQpXG4gICAgICAgICAgICB9fVxuICAgICAgICAgICAgb25BY3RpdmF0ZT17b25FbnRlcn1cbiAgICAgICAgICAvPlxuICAgICAgICAgIDxib3ggc3BhY2luZz17Nn0gdmVydGljYWw+XG4gICAgICAgICAgICB7bGlzdC5hcyhsaXN0ID0+IGxpc3QubWFwKGFwcCA9PiAoXG4gICAgICAgICAgICAgIDxBcHBCdXR0b24gYXBwPXthcHB9IC8+XG4gICAgICAgICAgICApKSl9XG4gICAgICAgICAgPC9ib3g+XG4gICAgICAgICAgPGJveFxuICAgICAgICAgICAgaGFsaWduPXtHdGsuQWxpZ24uQ0VOVEVSfVxuICAgICAgICAgICAgY2xhc3NOYW1lPVwibm90LWZvdW5kXCJcbiAgICAgICAgICAgIHZlcnRpY2FsXG4gICAgICAgICAgICB2aXNpYmxlPXtsaXN0LmFzKGwgPT4gbC5sZW5ndGggPT09IDApfT5cbiAgICAgICAgICAgIDxpY29uIGljb249XCJzeXN0ZW0tc2VhcmNoLXN5bWJvbGljXCIgLz5cbiAgICAgICAgICAgIDxsYWJlbCBsYWJlbD1cIk5vIG1hdGNoIGZvdW5kXCIgLz5cbiAgICAgICAgICA8L2JveD5cbiAgICAgICAgPC9ib3g+XG4gICAgICAgIDxldmVudGJveCBleHBhbmQgb25DbGljaz17aGlkZX0gLz5cbiAgICAgIDwvYm94PlxuICAgICAgPGV2ZW50Ym94IHdpZHRoUmVxdWVzdD17d2lkdGgodyA9PiB3IC8gMil9IGV4cGFuZCBvbkNsaWNrPXtoaWRlfSAvPlxuICAgIDwvYm94PlxuICA8L3dpbmRvdz5cbn1cbiIsICJpbXBvcnQgeyBHT2JqZWN0IH0gZnJvbSBcImFzdGFsXCJcbmltcG9ydCB7IGFzdGFsaWZ5LCBDb25zdHJ1Y3RQcm9wcywgR3RrIH0gZnJvbSBcImFzdGFsL2d0azNcIlxuXG5leHBvcnQgZGVmYXVsdCBjbGFzcyBDYWxlbmRhciBleHRlbmRzIGFzdGFsaWZ5KEd0ay5DYWxlbmRhcikge1xuICBzdGF0aWMge1xuICAgIEdPYmplY3QucmVnaXN0ZXJDbGFzcyh0aGlzKVxuICB9XG4gIGNvbnN0cnVjdG9yKFxuICAgIHByb3BzOiBDb25zdHJ1Y3RQcm9wczxHdGsuQ2FsZW5kYXIsIEd0ay5DYWxlbmRhci5Db25zdHJ1Y3RvclByb3BzPixcbiAgKSB7XG4gICAgc3VwZXIocHJvcHMgYXMgYW55KVxuICB9XG59XG4iLCAiaW1wb3J0IHsgQXBwLCBBc3RhbCwgR2RrLCBHdGsgfSBmcm9tIFwiYXN0YWwvZ3RrM1wiXG5pbXBvcnQgeyBiaW5kLCBWYXJpYWJsZSB9IGZyb20gXCJhc3RhbFwiXG5pbXBvcnQgQ2FsZW5kYXIgZnJvbSBcIkB3aWRnZXRzL0NhbGVuZGFyL0NhbGVuZGFyXCJcbmltcG9ydCBUaW1lIGZyb20gXCJAd2lkZ2V0cy9UaW1lL1RpbWVcIlxuaW1wb3J0IHsgZ2V0V2VhdGhlckVtb2ppLCBnZXRXZWF0aGVySW1hZ2UgfSBmcm9tIFwiQGNvbW1vbi9mdW5jdGlvbnNcIlxuaW1wb3J0IHsgY3VycmVudERheSwgd2VhdGhlclJlcG9ydCB9IGZyb20gXCJAY29tbW9uL3ZhcnNcIlxuXG5cbmZ1bmN0aW9uIFRpbWVBbmREYXRlKCkge1xuICByZXR1cm4gKFxuICAgIDxib3hcbiAgICAgIGNsYXNzTmFtZT1cIlRpbWVBbmREYXRlXCJcbiAgICAgIHZlcnRpY2FsXG4gICAgPlxuICAgICAgPFRpbWUgLz5cbiAgICAgIDxsYWJlbCBjbGFzc05hbWU9XCJUb2RheVwiIGxhYmVsPXtjdXJyZW50RGF5KCkuYXMoZGF5ID0+IGRheS5yZXBsYWNlKC9cXF4oXFx3KShcXHcqKS9nLCAoXywgZmlyc3QsIHJlc3QpID0+IGZpcnN0LnRvVXBwZXJDYXNlKCkgKyByZXN0LnRvTG93ZXJDYXNlKCkpKX0gLz5cbiAgICA8L2JveD5cbiAgKVxufVxuXG5mdW5jdGlvbiBDYWxlbmRhck1vZHVsZSgpIHtcbiAgcmV0dXJuIChcbiAgICA8Ym94IGNsYXNzTmFtZT1cImNhbGVuZGFyXCIgdmVydGljYWw+XG4gICAgICB7bmV3IENhbGVuZGFyKHsgaGV4cGFuZDogdHJ1ZSwgdmV4cGFuZDogdHJ1ZSB9KX1cbiAgICA8L2JveD5cbiAgKVxufVxuXG5mdW5jdGlvbiBnZXRVcGNvbWluZ0hvdXJzKGhvdXJseTogYW55W10pIHtcbiAgY29uc3Qgbm93ID0gbmV3IERhdGUoKVxuICBjb25zdCBjdXJyZW50SG91ciA9IG5vdy5nZXRIb3VycygpXG5cbiAgY29uc3QgcGFyc2VkSG91cmx5ID0gaG91cmx5Lm1hcChoID0+ICh7XG4gICAgLi4uaCxcbiAgICBob3VyOiBNYXRoLmZsb29yKE51bWJlcihoLnRpbWUpIC8gMTAwKSxcbiAgfSkpXG5cbiAgY29uc3Qgc3RhcnRJZHggPSBwYXJzZWRIb3VybHkuZmluZEluZGV4KGggPT4gaC5ob3VyID4gY3VycmVudEhvdXIpXG5cbiAgY29uc3Qgc2xpY2UgPSBwYXJzZWRIb3VybHkuc2xpY2Uoc3RhcnRJZHgsIHN0YXJ0SWR4ICsgNSlcbiAgcmV0dXJuIHNsaWNlLmxlbmd0aCA9PT0gNSA/IHNsaWNlIDogWy4uLnNsaWNlLCAuLi5wYXJzZWRIb3VybHkuc2xpY2UoMCwgNSAtIHNsaWNlLmxlbmd0aCldXG59XG5cblxuZnVuY3Rpb24gV2VhdGhlclNpZGViYXIoKSB7XG4gIHJldHVybiBiaW5kKHdlYXRoZXJSZXBvcnQpLmFzKChkYXRhKSA9PiB7XG4gICAgaWYgKCFkYXRhKSByZXR1cm4gPGJveCAvPlxuXG4gICAgY29uc3QgY3VycmVudCA9IGRhdGEud2VhdGhlci5jdXJyZW50X2NvbmRpdGlvblswXVxuICAgIGNvbnN0IHVwY29taW5nID0gZ2V0VXBjb21pbmdIb3VycyhkYXRhLndlYXRoZXIud2VhdGhlclswXS5ob3VybHkpXG4gICAgY29uc3QgaW1hZ2UgPSBnZXRXZWF0aGVySW1hZ2UoY3VycmVudC53ZWF0aGVyRGVzY1swXS52YWx1ZSlcblxuICAgIHJldHVybiA8Ym94XG4gICAgICBjbGFzc05hbWU9XCJXZWF0aGVyXCJcbiAgICAgIHZlcnRpY2FsPlxuICAgICAgPGJveFxuICAgICAgICBjbGFzc05hbWU9XCJJbWFnZVwiXG4gICAgICAgIGNzcz17YGJhY2tncm91bmQtaW1hZ2U6IHVybCgnJHtTUkN9L2Fzc2V0cy93ZWF0aGVyLyR7aW1hZ2V9JylgfT5cbiAgICAgICAgPGJveFxuICAgICAgICAgIGNsYXNzTmFtZT1cIkN1cnJlbnRcIj5cbiAgICAgICAgICA8Ym94IHZlcnRpY2FsIGhhbGlnbj17R3RrLkFsaWduLlNUQVJUfT5cbiAgICAgICAgICAgIDxsYWJlbFxuICAgICAgICAgICAgICBjbGFzc05hbWU9XCJJY29uXCJcbiAgICAgICAgICAgICAgeGFsaWduPXswfVxuICAgICAgICAgICAgICB5YWxpZ249ezB9XG4gICAgICAgICAgICAgIHZleHBhbmRcbiAgICAgICAgICAgICAgbGFiZWw9e2dldFdlYXRoZXJFbW9qaShjdXJyZW50LndlYXRoZXJEZXNjWzBdLnZhbHVlKX0gLz5cbiAgICAgICAgICAgIDxsYWJlbFxuICAgICAgICAgICAgICBjbGFzc05hbWU9XCJEZXNjcmlwdGlvblwiXG4gICAgICAgICAgICAgIHhhbGlnbj17MH1cbiAgICAgICAgICAgICAgbGFiZWw9e2N1cnJlbnQud2VhdGhlckRlc2NbMF0udmFsdWV9IC8+XG4gICAgICAgICAgPC9ib3g+XG4gICAgICAgICAgPGJveCBoZXhwYW5kIC8+XG4gICAgICAgICAgPGJveCB2ZXJ0aWNhbCBoYWxpZ249e0d0ay5BbGlnbi5FTkR9PlxuICAgICAgICAgICAgPGJveCB2ZXJ0aWNhbD5cbiAgICAgICAgICAgICAgPGxhYmVsXG4gICAgICAgICAgICAgICAgY2xhc3NOYW1lPVwiVGVtcFwiXG4gICAgICAgICAgICAgICAgeGFsaWduPXsxfVxuICAgICAgICAgICAgICAgIHlhbGlnbj17MH1cbiAgICAgICAgICAgICAgICBsYWJlbD17YCR7Y3VycmVudC50ZW1wX0N9XHUwMEIwYH0gLz5cbiAgICAgICAgICAgICAgPGxhYmVsXG4gICAgICAgICAgICAgICAgY2xhc3NOYW1lPVwiRmVlbHNMaWtlXCJcbiAgICAgICAgICAgICAgICB4YWxpZ249ezF9XG4gICAgICAgICAgICAgICAgeWFsaWduPXswfVxuICAgICAgICAgICAgICAgIHZleHBhbmRcbiAgICAgICAgICAgICAgICBsYWJlbD17YEZlZWxzIGxpa2U6ICR7Y3VycmVudC5GZWVsc0xpa2VDfVx1MDBCMGB9IC8+XG4gICAgICAgICAgICA8L2JveD5cbiAgICAgICAgICAgIDxib3hcbiAgICAgICAgICAgICAgY2xhc3NOYW1lPVwiSW5mb1wiXG4gICAgICAgICAgICAgIHZlcnRpY2FsPlxuICAgICAgICAgICAgICA8bGFiZWwgY2xhc3NOYW1lPVwiV2luZFwiIHhhbGlnbj17MX0gbGFiZWw9e2Ake2N1cnJlbnQud2luZHNwZWVkS21waH1rbSBcdUQ4M0RcdURDQThgfSAvPlxuICAgICAgICAgICAgICA8bGFiZWwgY2xhc3NOYW1lPVwiSHVtaWRpdHlcIiB4YWxpZ249ezF9IGxhYmVsPXtgJHtjdXJyZW50Lmh1bWlkaXR5fSUgXHVEODNEXHVEQ0E3YH0gLz5cbiAgICAgICAgICAgICAgPGxhYmVsIGNsYXNzTmFtZT1cIlByZWNpcGl0YXRpb25cIiB4YWxpZ249ezF9IGxhYmVsPXtgJHtjdXJyZW50LnByZWNpcE1NfW1tIFx1MjYxNGB9IC8+XG4gICAgICAgICAgICA8L2JveD5cbiAgICAgICAgICA8L2JveD5cbiAgICAgICAgPC9ib3g+XG4gICAgICA8L2JveD5cbiAgICAgIDxib3hcbiAgICAgICAgY2xhc3NOYW1lPVwiSG91cmx5Rm9yZWNhc3RcIlxuICAgICAgICBob21vZ2VuZW91cz5cbiAgICAgICAge3VwY29taW5nLm1hcChoID0+IChcbiAgICAgICAgICA8Ym94IG9yaWVudGF0aW9uPXsxfSBoZXhwYW5kPXt0cnVlfSBjbGFzc05hbWU9XCJIb3VybHlJdGVtXCIgc3BhY2luZz17NH0+XG4gICAgICAgICAgICA8bGFiZWwgbGFiZWw9e2Ake2guaG91ci50b1N0cmluZygpLnBhZFN0YXJ0KDIsIFwiMFwiKX06MDBgfSBjbGFzc05hbWU9XCJIb3VyXCIgLz5cbiAgICAgICAgICAgIDxsYWJlbFxuICAgICAgICAgICAgICBsYWJlbD17Z2V0V2VhdGhlckVtb2ppKGgud2VhdGhlckRlc2NbMF0udmFsdWUpfVxuICAgICAgICAgICAgICBjbGFzc05hbWU9XCJJY29uXCJcbiAgICAgICAgICAgICAgdG9vbHRpcFRleHQ9e2Ake2gud2VhdGhlckRlc2NbMF0udmFsdWV9LCBcdTI2MTQ6ICR7aC5wcmVjaXBNTX1tbWB9XG4gICAgICAgICAgICAvPlxuICAgICAgICAgICAgPGxhYmVsIGxhYmVsPXtgJHtoLnRlbXBDfVx1MDBCMGB9IGNsYXNzTmFtZT1cIlNtYWxsVGVtcFwiIC8+XG4gICAgICAgICAgPC9ib3g+XG4gICAgICAgICkpfVxuICAgICAgPC9ib3g+XG4gICAgPC9ib3g+XG4gIH0pXG59XG5cbmV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIExlZnRTaWRlYmFyKG1vbml0b3I6IEdkay5Nb25pdG9yLCB2aXNpYmxlOiBWYXJpYWJsZTxib29sZWFuPikge1xuICBjb25zdCB7IExFRlQsIFRPUCB9ID0gQXN0YWwuV2luZG93QW5jaG9yXG5cbiAgcmV0dXJuIDx3aW5kb3dcbiAgICBjbGFzc05hbWU9XCJMZWZ0U2lkZWJhclwiXG4gICAgbmFtZXNwYWNlPVwibGVmdHNpZGViYXJcIlxuICAgIGdka21vbml0b3I9e21vbml0b3J9XG4gICAgZXhjbHVzaXZpdHk9e0FzdGFsLkV4Y2x1c2l2aXR5LkVYQ0xVU0lWRX1cbiAgICBhcHBsaWNhdGlvbj17QXBwfVxuICAgIGxheWVyPXtBc3RhbC5MYXllci5UT1B9XG4gICAgdmlzaWJsZT17dmlzaWJsZSgpfVxuICAgIGFuY2hvcj17VE9QIHwgTEVGVH0+XG4gICAgPGJveFxuICAgICAgaGV4cGFuZFxuICAgICAgdmVydGljYWxcbiAgICAgIGNsYXNzTmFtZT1cInNpZGViYXJcIlxuICAgID5cbiAgICAgIDxUaW1lQW5kRGF0ZSAvPlxuICAgICAgPENhbGVuZGFyTW9kdWxlIC8+XG4gICAgICA8V2VhdGhlclNpZGViYXIgLz5cbiAgICA8L2JveD5cbiAgPC93aW5kb3c+XG59XG4iLCAiaW1wb3J0IHsgQXBwLCBBc3RhbCwgR2RrLCBHdGsgfSBmcm9tIFwiYXN0YWwvZ3RrM1wiXG5pbXBvcnQgeyB0eXBlIFN1YnNjcmliYWJsZSB9IGZyb20gXCJhc3RhbC9iaW5kaW5nXCJcbmltcG9ydCB7IFZhcmlhYmxlLCBiaW5kLCB0aW1lb3V0IH0gZnJvbSBcImFzdGFsXCJcbmltcG9ydCBOb3RpZmQgZnJvbSBcImdpOi8vQXN0YWxOb3RpZmRcIlxuaW1wb3J0IE5vdGlmaWNhdGlvbiBmcm9tIFwiQHdpZGdldHMvTm90aWZpY2F0aW9uL05vdGlmaWNhdGlvblwiXG5cbi8vIHNlZSBjb21tZW50IGJlbG93IGluIGNvbnN0cnVjdG9yXG5jb25zdCBUSU1FT1VUX0RFTEFZID0gNTAwMFxuXG4vLyBUaGUgcHVycG9zZSBpZiB0aGlzIGNsYXNzIGlzIHRvIHJlcGxhY2UgVmFyaWFibGU8QXJyYXk8V2lkZ2V0Pj5cbi8vIHdpdGggYSBNYXA8bnVtYmVyLCBXaWRnZXQ+IHR5cGUgaW4gb3JkZXIgdG8gdHJhY2sgbm90aWZpY2F0aW9uIHdpZGdldHNcbi8vIGJ5IHRoZWlyIGlkLCB3aGlsZSBtYWtpbmcgaXQgY29udmluaWVudGx5IGJpbmRhYmxlIGFzIGFuIGFycmF5XG5jbGFzcyBOb3RpZmlhdGlvbk1hcCBpbXBsZW1lbnRzIFN1YnNjcmliYWJsZSB7XG4gIC8vIHRoZSB1bmRlcmx5aW5nIG1hcCB0byBrZWVwIHRyYWNrIG9mIGlkIHdpZGdldCBwYWlyc1xuICBwcml2YXRlIG1hcDogTWFwPG51bWJlciwgR3RrLldpZGdldD4gPSBuZXcgTWFwKClcblxuICAvLyBpdCBtYWtlcyBzZW5zZSB0byB1c2UgYSBWYXJpYWJsZSB1bmRlciB0aGUgaG9vZCBhbmQgdXNlIGl0c1xuICAvLyByZWFjdGl2aXR5IGltcGxlbWVudGF0aW9uIGluc3RlYWQgb2Yga2VlcGluZyB0cmFjayBvZiBzdWJzY3JpYmVycyBvdXJzZWx2ZXNcbiAgcHJpdmF0ZSB2YXI6IFZhcmlhYmxlPEFycmF5PEd0ay5XaWRnZXQ+PiA9IFZhcmlhYmxlKFtdKVxuXG4gIC8vIG5vdGlmeSBzdWJzY3JpYmVycyB0byByZXJlbmRlciB3aGVuIHN0YXRlIGNoYW5nZXNcbiAgcHJpdmF0ZSBub3RpZml5KCkge1xuICAgIHRoaXMudmFyLnNldChbLi4udGhpcy5tYXAudmFsdWVzKCldKVxuICB9XG5cbiAgY29uc3RydWN0b3IoKSB7XG4gICAgY29uc3Qgbm90aWZkID0gTm90aWZkLmdldF9kZWZhdWx0KClcblxuICAgIG5vdGlmZC5jb25uZWN0KFwibm90aWZpZWRcIiwgKF8sIGlkKSA9PiB7XG4gICAgICB0aGlzLnNldChpZCwgTm90aWZpY2F0aW9uKHtcbiAgICAgICAgbm90aWZpY2F0aW9uOiBub3RpZmQuZ2V0X25vdGlmaWNhdGlvbihpZCkhLFxuXG4gICAgICAgIC8vIG9uY2UgaG92ZXJpbmcgb3ZlciB0aGUgbm90aWZpY2F0aW9uIGlzIGRvbmVcbiAgICAgICAgLy8gZGVzdHJveSB0aGUgd2lkZ2V0IHdpdGhvdXQgY2FsbGluZyBub3RpZmljYXRpb24uZGlzbWlzcygpXG4gICAgICAgIC8vIHNvIHRoYXQgaXQgYWN0cyBhcyBhIFwicG9wdXBcIiBhbmQgd2UgY2FuIHN0aWxsIGRpc3BsYXkgaXRcbiAgICAgICAgLy8gaW4gYSBub3RpZmljYXRpb24gY2VudGVyIGxpa2Ugd2lkZ2V0XG4gICAgICAgIC8vIGJ1dCBjbGlja2luZyBvbiB0aGUgY2xvc2UgYnV0dG9uIHdpbGwgY2xvc2UgaXRcbiAgICAgICAgb25Ib3Zlckxvc3Q6ICgpID0+IHRoaXMuZGVsZXRlKGlkKSxcblxuICAgICAgICAvLyBub3RpZmQgYnkgZGVmYXVsdCBkb2VzIG5vdCBjbG9zZSBub3RpZmljYXRpb25zXG4gICAgICAgIC8vIHVudGlsIHVzZXIgaW5wdXQgb3IgdGhlIHRpbWVvdXQgc3BlY2lmaWVkIGJ5IHNlbmRlclxuICAgICAgICAvLyB3aGljaCB3ZSBzZXQgdG8gaWdub3JlIGFib3ZlXG4gICAgICAgIHNldHVwOiAoKSA9PiB0aW1lb3V0KFRJTUVPVVRfREVMQVksICgpID0+IHtcbiAgICAgICAgICAvKipcbiAgICAgICAgICAgKiB1bmNvbW1lbnQgdGhpcyBpZiB5b3Ugd2FudCB0byBcImhpZGVcIiB0aGUgbm90aWZpY2F0aW9uc1xuICAgICAgICAgICAqIGFmdGVyIFRJTUVPVVRfREVMQVlcbiAgICAgICAgICAgKi9cbiAgICAgICAgICB0aGlzLmRlbGV0ZShpZClcbiAgICAgICAgfSlcbiAgICAgIH0pKVxuICAgIH0pXG5cbiAgICAvLyBub3RpZmljYXRpb25zIGNhbiBiZSBjbG9zZWQgYnkgdGhlIG91dHNpZGUgYmVmb3JlXG4gICAgLy8gYW55IHVzZXIgaW5wdXQsIHdoaWNoIGhhdmUgdG8gYmUgaGFuZGxlZCB0b29cbiAgICBub3RpZmQuY29ubmVjdChcInJlc29sdmVkXCIsIChfLCBpZCkgPT4ge1xuICAgICAgdGhpcy5kZWxldGUoaWQpXG4gICAgfSlcbiAgfVxuXG4gIHByaXZhdGUgc2V0KGtleTogbnVtYmVyLCB2YWx1ZTogR3RrLldpZGdldCkge1xuICAgIC8vIGluIGNhc2Ugb2YgcmVwbGFjZWNtZW50IGRlc3Ryb3kgcHJldmlvdXMgd2lkZ2V0XG4gICAgdGhpcy5tYXAuZ2V0KGtleSk/LmRlc3Ryb3koKVxuICAgIHRoaXMubWFwLnNldChrZXksIHZhbHVlKVxuICAgIHRoaXMubm90aWZpeSgpXG4gIH1cblxuICBwcml2YXRlIGRlbGV0ZShrZXk6IG51bWJlcikge1xuICAgIHRoaXMubWFwLmdldChrZXkpPy5kZXN0cm95KClcbiAgICB0aGlzLm1hcC5kZWxldGUoa2V5KVxuICAgIHRoaXMubm90aWZpeSgpXG4gIH1cblxuICAvLyBuZWVkZWQgYnkgdGhlIFN1YnNjcmliYWJsZSBpbnRlcmZhY2VcbiAgZ2V0KCkge1xuICAgIHJldHVybiB0aGlzLnZhci5nZXQoKVxuICB9XG5cbiAgLy8gbmVlZGVkIGJ5IHRoZSBTdWJzY3JpYmFibGUgaW50ZXJmYWNlXG4gIHN1YnNjcmliZShjYWxsYmFjazogKGxpc3Q6IEFycmF5PEd0ay5XaWRnZXQ+KSA9PiB2b2lkKSB7XG4gICAgcmV0dXJuIHRoaXMudmFyLnN1YnNjcmliZShjYWxsYmFjaylcbiAgfVxufVxuXG5leHBvcnQgZGVmYXVsdCBmdW5jdGlvbiBOb3RpZmljYXRpb25Qb3B1cHMoZ2RrbW9uaXRvcjogR2RrLk1vbml0b3IsIHZpc2libGU6IFZhcmlhYmxlPGJvb2xlYW4+KSB7XG4gIGNvbnN0IHsgQk9UVE9NLCBSSUdIVCB9ID0gQXN0YWwuV2luZG93QW5jaG9yXG4gIGNvbnN0IG5vdGlmcyA9IG5ldyBOb3RpZmlhdGlvbk1hcCgpXG5cbiAgcmV0dXJuIDx3aW5kb3dcbiAgICBoZXhwYW5kXG4gICAgY2xhc3NOYW1lPVwiTm90aWZpY2F0aW9uUG9wdXBzXCJcbiAgICBuYW1lc3BhY2U9XCJub3RpZmljYXRpb25cIlxuICAgIGdka21vbml0b3I9e2dka21vbml0b3J9XG4gICAgdmlzaWJsZT17YmluZCh2aXNpYmxlKS5hcyh2ID0+ICF2KX1cbiAgICBleGNsdXNpdml0eT17QXN0YWwuRXhjbHVzaXZpdHkuSUdOT1JFfVxuICAgIGFwcGxpY2F0aW9uPXtBcHB9XG4gICAgbGF5ZXI9e0FzdGFsLkxheWVyLk9WRVJMQVl9XG4gICAgYW5jaG9yPXtCT1RUT00gfCBSSUdIVH0+XG4gICAgPGJveCB2ZXJ0aWNhbD5cbiAgICAgIHtiaW5kKG5vdGlmcyl9XG4gICAgPC9ib3g+XG4gIDwvd2luZG93PlxufVxuIiwgImltcG9ydCB7IEdMaWIgfSBmcm9tIFwiYXN0YWxcIlxuaW1wb3J0IHsgR3RrIH0gZnJvbSBcImFzdGFsL2d0azNcIlxuaW1wb3J0IHsgdHlwZSBFdmVudEJveCB9IGZyb20gXCJhc3RhbC9ndGszL3dpZGdldFwiXG5pbXBvcnQgTm90aWZkIGZyb20gXCJnaTovL0FzdGFsTm90aWZkXCJcbmltcG9ydCB7IGlzSWNvbiB9IGZyb20gXCJAY29tbW9uL2Z1bmN0aW9uc1wiXG5cbmNvbnN0IGZpbGVFeGlzdHMgPSAocGF0aDogc3RyaW5nKSA9PlxuICBHTGliLmZpbGVfdGVzdChwYXRoLCBHTGliLkZpbGVUZXN0LkVYSVNUUylcblxuY29uc3QgZm9ybWF0VGltZSA9ICh0aW1lOiBudW1iZXIsIGZvcm1hdCA9IFwiJUg6JU1cIikgPT4gR0xpYi5EYXRlVGltZVxuICAubmV3X2Zyb21fdW5peF9sb2NhbCh0aW1lKVxuICAuZm9ybWF0KGZvcm1hdCkhXG5cbmNvbnN0IHVyZ2VuY3kgPSAobjogTm90aWZkLk5vdGlmaWNhdGlvbikgPT4ge1xuICBjb25zdCB7IExPVywgTk9STUFMLCBDUklUSUNBTCB9ID0gTm90aWZkLlVyZ2VuY3lcbiAgLy8gbWF0Y2ggb3BlcmF0b3Igd2hlbj9cbiAgc3dpdGNoIChuLnVyZ2VuY3kpIHtcbiAgICBjYXNlIExPVzogcmV0dXJuIFwibG93XCJcbiAgICBjYXNlIENSSVRJQ0FMOiByZXR1cm4gXCJjcml0aWNhbFwiXG4gICAgY2FzZSBOT1JNQUw6XG4gICAgZGVmYXVsdDogcmV0dXJuIFwibm9ybWFsXCJcbiAgfVxufVxuXG50eXBlIFByb3BzID0ge1xuICBzZXR1cChzZWxmOiBFdmVudEJveCk6IHZvaWRcbiAgb25Ib3Zlckxvc3Qoc2VsZjogRXZlbnRCb3gpOiB2b2lkXG4gIG5vdGlmaWNhdGlvbjogTm90aWZkLk5vdGlmaWNhdGlvblxufVxuXG5leHBvcnQgZGVmYXVsdCBmdW5jdGlvbiBOb3RpZmljYXRpb24ocHJvcHM6IFByb3BzKSB7XG4gIGNvbnN0IHsgbm90aWZpY2F0aW9uOiBuLCBvbkhvdmVyTG9zdCwgc2V0dXAgfSA9IHByb3BzXG4gIGNvbnN0IHsgU1RBUlQsIENFTlRFUiwgRU5EIH0gPSBHdGsuQWxpZ25cblxuICByZXR1cm4gPGV2ZW50Ym94XG4gICAgaGV4cGFuZFxuICAgIGNsYXNzTmFtZT17YE5vdGlmaWNhdGlvbiAke3VyZ2VuY3kobil9YH1cbiAgICBzZXR1cD17c2V0dXB9XG4gICAgb25Ib3Zlckxvc3Q9e29uSG92ZXJMb3N0fT5cbiAgICA8Ym94IHZlcnRpY2FsPlxuICAgICAgPGJveCBjbGFzc05hbWU9XCJoZWFkZXJcIj5cbiAgICAgICAgeyhuLmFwcEljb24gfHwgbi5kZXNrdG9wRW50cnkpICYmIDxpY29uXG4gICAgICAgICAgY2xhc3NOYW1lPVwiYXBwLWljb25cIlxuICAgICAgICAgIHZpc2libGU9e0Jvb2xlYW4obi5hcHBJY29uIHx8IG4uZGVza3RvcEVudHJ5KX1cbiAgICAgICAgICBpY29uPXtuLmFwcEljb24gfHwgbi5kZXNrdG9wRW50cnl9XG4gICAgICAgIC8+fVxuICAgICAgICA8bGFiZWxcbiAgICAgICAgICBjbGFzc05hbWU9XCJhcHAtbmFtZVwiXG4gICAgICAgICAgaGFsaWduPXtTVEFSVH1cbiAgICAgICAgICB0cnVuY2F0ZVxuICAgICAgICAgIGxhYmVsPXtuLmFwcE5hbWUgfHwgXCJVbmtub3duXCJ9XG4gICAgICAgIC8+XG4gICAgICAgIDxsYWJlbFxuICAgICAgICAgIGNsYXNzTmFtZT1cInRpbWVcIlxuICAgICAgICAgIGhleHBhbmRcbiAgICAgICAgICBoYWxpZ249e0VORH1cbiAgICAgICAgICBsYWJlbD17Zm9ybWF0VGltZShuLnRpbWUpfVxuICAgICAgICAvPlxuICAgICAgICA8YnV0dG9uIG9uQ2xpY2tlZD17KCkgPT4gbi5kaXNtaXNzKCl9PlxuICAgICAgICAgIDxpY29uIGljb249XCJ3aW5kb3ctY2xvc2Utc3ltYm9saWNcIiAvPlxuICAgICAgICA8L2J1dHRvbj5cbiAgICAgIDwvYm94PlxuICAgICAgPEd0ay5TZXBhcmF0b3IgdmlzaWJsZSAvPlxuICAgICAgPGJveCBjbGFzc05hbWU9XCJjb250ZW50XCI+XG4gICAgICAgIHtuLmltYWdlICYmIGZpbGVFeGlzdHMobi5pbWFnZSkgJiYgPGJveFxuICAgICAgICAgIHZhbGlnbj17U1RBUlR9XG4gICAgICAgICAgY2xhc3NOYW1lPVwiaW1hZ2VcIlxuICAgICAgICAgIGNzcz17YGJhY2tncm91bmQtaW1hZ2U6IHVybCgnJHtuLmltYWdlfScpYH1cbiAgICAgICAgLz59XG4gICAgICAgIHtuLmltYWdlICYmIGlzSWNvbihuLmltYWdlKSAmJiA8Ym94XG4gICAgICAgICAgZXhwYW5kPXtmYWxzZX1cbiAgICAgICAgICB2YWxpZ249e1NUQVJUfVxuICAgICAgICAgIGNsYXNzTmFtZT1cImljb24taW1hZ2VcIj5cbiAgICAgICAgICA8aWNvbiBpY29uPXtuLmltYWdlfSBleHBhbmQgaGFsaWduPXtDRU5URVJ9IHZhbGlnbj17Q0VOVEVSfSAvPlxuICAgICAgICA8L2JveD59XG4gICAgICAgIDxib3ggdmVydGljYWw+XG4gICAgICAgICAgPGxhYmVsXG4gICAgICAgICAgICBjbGFzc05hbWU9XCJzdW1tYXJ5XCJcbiAgICAgICAgICAgIGhhbGlnbj17U1RBUlR9XG4gICAgICAgICAgICB4YWxpZ249ezB9XG4gICAgICAgICAgICBsYWJlbD17bi5zdW1tYXJ5fVxuICAgICAgICAgICAgdHJ1bmNhdGVcbiAgICAgICAgICAvPlxuICAgICAgICAgIHtuLmJvZHkgJiYgPGxhYmVsXG4gICAgICAgICAgICBjbGFzc05hbWU9XCJib2R5XCJcbiAgICAgICAgICAgIHdyYXBcbiAgICAgICAgICAgIHVzZU1hcmt1cD17ZmFsc2V9XG4gICAgICAgICAgICBoYWxpZ249e1NUQVJUfVxuICAgICAgICAgICAgeGFsaWduPXswfVxuICAgICAgICAgICAgbGFiZWw9e24uYm9keX1cbiAgICAgICAgICAvPn1cbiAgICAgICAgPC9ib3g+XG4gICAgICA8L2JveD5cbiAgICAgIHtuLmdldF9hY3Rpb25zKCkubGVuZ3RoID4gMCAmJiA8Ym94IGNsYXNzTmFtZT1cImFjdGlvbnNcIj5cbiAgICAgICAge24uZ2V0X2FjdGlvbnMoKS5tYXAoKHsgbGFiZWwsIGlkIH0pID0+IChcbiAgICAgICAgICA8YnV0dG9uXG4gICAgICAgICAgICBoZXhwYW5kXG4gICAgICAgICAgICBvbkNsaWNrZWQ9eygpID0+IG4uaW52b2tlKGlkKX0+XG4gICAgICAgICAgICA8bGFiZWwgbGFiZWw9e2xhYmVsfSBoYWxpZ249e0NFTlRFUn0gaGV4cGFuZCAvPlxuICAgICAgICAgIDwvYnV0dG9uPlxuICAgICAgICApKX1cbiAgICAgIDwvYm94Pn1cbiAgICA8L2JveD5cbiAgPC9ldmVudGJveD5cbn1cbiIsICJpbXBvcnQgeyBBcHAsIEFzdGFsLCBHZGssIEd0ayB9IGZyb20gXCJhc3RhbC9ndGszXCJcbmltcG9ydCB7IHRpbWVvdXQgfSBmcm9tIFwiYXN0YWwvdGltZVwiXG5pbXBvcnQgVmFyaWFibGUgZnJvbSBcImFzdGFsL3ZhcmlhYmxlXCJcbmltcG9ydCBXcCBmcm9tIFwiZ2k6Ly9Bc3RhbFdwXCJcbmltcG9ydCBCcmlnaHRuZXNzIGZyb20gXCJAdXRpbHMvYnJpZ2h0bmVzc1wiXG5pbXBvcnQgeyBzcG90aWZ5UGxheWVyIH0gZnJvbSBcIkBjb21tb24vdmFyc1wiXG5cblxuZnVuY3Rpb24gT25TY3JlZW5Qcm9ncmVzcyh7IHZpc2libGUgfTogeyB2aXNpYmxlOiBWYXJpYWJsZTxib29sZWFuPiB9KSB7XG4gIGNvbnN0IGJyaWdodG5lc3MgPSBCcmlnaHRuZXNzLmdldF9kZWZhdWx0KClcbiAgY29uc3Qgc3BlYWtlciA9IFdwLmdldF9kZWZhdWx0KCkhLmdldF9kZWZhdWx0X3NwZWFrZXIoKVxuXG4gIGNvbnN0IGljb25OYW1lID0gVmFyaWFibGUoXCJcIilcbiAgY29uc3QgdmFsdWUgPSBWYXJpYWJsZSgwKVxuXG4gIGxldCBjb3VudCA9IDBcbiAgZnVuY3Rpb24gc2hvdyh2OiBudW1iZXIsIGljb246IHN0cmluZykge1xuICAgIHZpc2libGUuc2V0KHRydWUpXG4gICAgdmFsdWUuc2V0KHYpXG4gICAgaWNvbk5hbWUuc2V0KGljb24pXG4gICAgY291bnQrK1xuICAgIHRpbWVvdXQoMjAwMCwgKCkgPT4ge1xuICAgICAgY291bnQtLVxuICAgICAgaWYgKGNvdW50ID09PSAwKSB2aXNpYmxlLnNldChmYWxzZSlcbiAgICB9KVxuICB9XG5cbiAgcmV0dXJuIChcbiAgICA8Ym94XG4gICAgICBzZXR1cD17KHNlbGYpID0+IHtcbiAgICAgICAgc2VsZi5ob29rKGJyaWdodG5lc3MsIFwibm90aWZ5OjpzY3JlZW5cIiwgKCkgPT5cbiAgICAgICAgICBzaG93KGJyaWdodG5lc3Muc2NyZWVuLCBcImRpc3BsYXktYnJpZ2h0bmVzcy1zeW1ib2xpY1wiKSxcbiAgICAgICAgKVxuXG4gICAgICAgIGlmIChzcGVha2VyKSB7XG4gICAgICAgICAgc2VsZi5ob29rKHNwZWFrZXIsIFwibm90aWZ5Ojp2b2x1bWVcIiwgKCkgPT5cbiAgICAgICAgICAgIHNob3coc3BlYWtlci52b2x1bWUsIHNwZWFrZXIudm9sdW1lSWNvbiksXG4gICAgICAgICAgKVxuICAgICAgICB9XG5cbiAgICAgICAgc2VsZi5ob29rKHNwb3RpZnlQbGF5ZXIsIFwibm90aWZ5Ojp2b2x1bWVcIiwgKCkgPT5cbiAgICAgICAgICBzaG93KHNwb3RpZnlQbGF5ZXIudm9sdW1lLCBcInNwb3RpZnlcIilcbiAgICAgICAgKVxuICAgICAgfX0+XG4gICAgICA8Ym94IHZlcnRpY2FsIGNsYXNzTmFtZT1cIk9TRFwiPlxuICAgICAgICA8aWNvbiBpY29uPXtpY29uTmFtZSgpfS8+XG4gICAgICAgIDxsZXZlbGJhclxuICAgICAgICAgIHZhbGlnbj17R3RrLkFsaWduLkNFTlRFUn1cbiAgICAgICAgICBoZWlnaHRSZXF1ZXN0PXsxMDB9XG4gICAgICAgICAgd2lkdGhSZXF1ZXN0PXs4fVxuICAgICAgICAgIHZlcnRpY2FsXG4gICAgICAgICAgaW52ZXJ0ZWRcbiAgICAgICAgICB2YWx1ZT17dmFsdWUoKX1cbiAgICAgICAgLz5cbiAgICAgICAgPGxhYmVsIGxhYmVsPXt2YWx1ZSh2ID0+IGAke01hdGguZmxvb3IodiAqIDEwMCl9JWApfSAvPlxuICAgICAgPC9ib3g+XG4gICAgPC9ib3g+XG4gIClcbn1cblxuZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gT1NEKG1vbml0b3I6IEdkay5Nb25pdG9yKSB7XG4gIGNvbnN0IHZpc2libGUgPSBWYXJpYWJsZShmYWxzZSlcblxuICByZXR1cm4gKFxuICAgIDx3aW5kb3dcbiAgICAgIGdka21vbml0b3I9e21vbml0b3J9XG4gICAgICBjbGFzc05hbWU9XCJPU0RcIlxuICAgICAgbmFtZXNwYWNlPVwib3NkXCJcbiAgICAgIGFwcGxpY2F0aW9uPXtBcHB9XG4gICAgICB2aXNpYmxlPXt2aXNpYmxlKCl9XG4gICAgICBsYXllcj17QXN0YWwuTGF5ZXIuT1ZFUkxBWX1cbiAgICAgIGFuY2hvcj17QXN0YWwuV2luZG93QW5jaG9yLlJJR0hUfVxuICAgID5cbiAgICAgIDxldmVudGJveCBvbkNsaWNrPXsoKSA9PiB2aXNpYmxlLnNldChmYWxzZSl9PlxuICAgICAgICA8T25TY3JlZW5Qcm9ncmVzcyB2aXNpYmxlPXt2aXNpYmxlfSAvPlxuICAgICAgPC9ldmVudGJveD5cbiAgICA8L3dpbmRvdz5cbiAgKVxufVxuIiwgImltcG9ydCBHT2JqZWN0LCB7IHJlZ2lzdGVyLCBwcm9wZXJ0eSB9IGZyb20gXCJhc3RhbC9nb2JqZWN0XCJcbmltcG9ydCB7IG1vbml0b3JGaWxlLCByZWFkRmlsZUFzeW5jIH0gZnJvbSBcImFzdGFsL2ZpbGVcIlxuaW1wb3J0IHsgZXhlYywgZXhlY0FzeW5jIH0gZnJvbSBcImFzdGFsL3Byb2Nlc3NcIlxuXG5jb25zdCBnZXQgPSAoYXJnczogc3RyaW5nKSA9PiBOdW1iZXIoZXhlYyhgYnJpZ2h0bmVzc2N0bCAke2FyZ3N9YCkpXG5jb25zdCBzY3JlZW4gPSBleGVjKGBiYXNoIC1jIFwibHMgLXcxIC9zeXMvY2xhc3MvYmFja2xpZ2h0IHwgaGVhZCAtMVwiYClcblxuQHJlZ2lzdGVyKHsgR1R5cGVOYW1lOiBcIkJyaWdodG5lc3NcIiB9KVxuZXhwb3J0IGRlZmF1bHQgY2xhc3MgQnJpZ2h0bmVzcyBleHRlbmRzIEdPYmplY3QuT2JqZWN0IHtcbiAgc3RhdGljIGluc3RhbmNlOiBCcmlnaHRuZXNzXG4gIHN0YXRpYyBnZXRfZGVmYXVsdCgpIHtcbiAgICBpZiAoIXRoaXMuaW5zdGFuY2UpXG4gICAgICB0aGlzLmluc3RhbmNlID0gbmV3IEJyaWdodG5lc3MoKVxuXG4gICAgcmV0dXJuIHRoaXMuaW5zdGFuY2VcbiAgfVxuXG4gICNzY3JlZW5NYXggPSBnZXQoXCJtYXhcIilcbiAgI3NjcmVlbiA9IGdldChcImdldFwiKSAvIChnZXQoXCJtYXhcIikgfHwgMSlcblxuICBAcHJvcGVydHkoTnVtYmVyKVxuICBnZXQgc2NyZWVuKCkgeyByZXR1cm4gdGhpcy4jc2NyZWVuIH1cblxuICBzZXQgc2NyZWVuKHBlcmNlbnQpIHtcbiAgICBpZiAocGVyY2VudCA8IDApXG4gICAgICBwZXJjZW50ID0gMFxuXG4gICAgaWYgKHBlcmNlbnQgPiAxKVxuICAgICAgcGVyY2VudCA9IDFcblxuICAgIGV4ZWNBc3luYyhgYnJpZ2h0bmVzc2N0bCBzZXQgJHtNYXRoLmZsb29yKHBlcmNlbnQgKiAxMDApfSUgLXFgKS50aGVuKCgpID0+IHtcbiAgICAgIHRoaXMuI3NjcmVlbiA9IHBlcmNlbnRcbiAgICAgIHRoaXMubm90aWZ5KFwic2NyZWVuXCIpXG4gICAgfSlcbiAgfVxuXG4gIGNvbnN0cnVjdG9yKCkge1xuICAgIHN1cGVyKClcbiAgICBtb25pdG9yRmlsZShgL3N5cy9jbGFzcy9iYWNrbGlnaHQvJHtzY3JlZW59L2JyaWdodG5lc3NgLCBhc3luYyBmID0+IHtcbiAgICAgIGNvbnN0IHYgPSBhd2FpdCByZWFkRmlsZUFzeW5jKGYpXG4gICAgICB0aGlzLiNzY3JlZW4gPSBOdW1iZXIodikgLyB0aGlzLiNzY3JlZW5NYXhcbiAgICAgIHRoaXMubm90aWZ5KFwic2NyZWVuXCIpXG4gICAgfSlcbiAgfVxufVxuIiwgImltcG9ydCB7IEFwcCwgQXN0YWwsIEdkaywgR3RrIH0gZnJvbSBcImFzdGFsL2d0azNcIlxuaW1wb3J0IHsgVmFyaWFibGUsIGJpbmQgfSBmcm9tIFwiYXN0YWxcIlxuaW1wb3J0IHsgZXhlYywgZXhlY0FzeW5jIH0gZnJvbSBcImFzdGFsL3Byb2Nlc3NcIlxuaW1wb3J0IEJsdWV0b290aCBmcm9tIFwiZ2k6Ly9Bc3RhbEJsdWV0b290aFwiXG5pbXBvcnQgTXByaXMgZnJvbSBcImdpOi8vQXN0YWxNcHJpc1wiXG5pbXBvcnQgTmV0d29yayBmcm9tIFwiZ2k6Ly9Bc3RhbE5ldHdvcmtcIlxuaW1wb3J0IE5vdGlmZCBmcm9tIFwiZ2k6Ly9Bc3RhbE5vdGlmZFwiXG5pbXBvcnQgTWVkaWFQbGF5ZXIgZnJvbSBcIkB3aWRnZXRzL01lZGlhUGxheWVyL01lZGlhUGxheWVyXCJcbmltcG9ydCBOb3RpZmljYXRpb24gZnJvbSBcIkB3aWRnZXRzL05vdGlmaWNhdGlvbi9Ob3RpZmljYXRpb25cIlxuaW1wb3J0IHsgZ2V0V2lmaUljb24gfSBmcm9tIFwiQGNvbW1vbi9mdW5jdGlvbnNcIlxuaW1wb3J0IHsgZG9Ob3REaXN0dXJiLCBuaWdodExpZ2h0RW5hYmxlZCwgbm90aWZpY2F0aW9uc0xlbmd0aCwgc2lkZWJhclBhbmVsLCB1cHRpbWUgfSBmcm9tIFwiQGNvbW1vbi92YXJzXCJcblxuXG5mdW5jdGlvbiBVc2VyTW9kdWxlKCkge1xuICBjb25zdCB1c2VyTmFtZSA9IGV4ZWMoXCJ3aG9hbWlcIilcbiAgY29uc3QgdXNlckltZyA9IGAke1NSQ30vYXNzZXRzL3Byb2ZpbGUucG5nYFxuXG4gIHJldHVybiA8Ym94XG4gICAgY2xhc3NOYW1lPVwiVXNlck1vZHVsZVwiPlxuICAgIDxib3ggY2xhc3NOYW1lPVwiVXNlckltZ1wiIGNzcz17YGJhY2tncm91bmQtaW1hZ2U6IHVybCgnJHt1c2VySW1nfScpYH0gLz5cbiAgICA8Ym94IHZlcnRpY2FsIHZhbGlnbj17R3RrLkFsaWduLkNFTlRFUn0+XG4gICAgICA8bGFiZWwgY2xhc3NOYW1lPVwiVXNlcm5hbWVcIiBsYWJlbD17dXNlck5hbWV9IGhhbGlnbj17R3RrLkFsaWduLlNUQVJUfSAvPlxuICAgICAgPGxhYmVsIGNsYXNzTmFtZT1cIlVwdGltZVwiIGxhYmVsPXt1cHRpbWUoKX0gaGFsaWduPXtHdGsuQWxpZ24uU1RBUlR9IC8+XG4gICAgPC9ib3g+XG4gIDwvYm94PlxufVxuXG5mdW5jdGlvbiBzaWRlYmFyQnV0dG9uKGljb246IHN0cmluZywgbmFtZTogc3RyaW5nLCBzdGF0dXM6IHN0cmluZykge1xuICByZXR1cm4gKFxuICAgIDxib3g+XG4gICAgICA8bGFiZWwgY2xhc3NOYW1lPVwiSWNvblwiIGxhYmVsPXtpY29ufSAvPlxuICAgICAgPGJveFxuICAgICAgICBjbGFzc05hbWU9XCJEZXNjcmlwdGlvblwiXG4gICAgICAgIHZlcnRpY2FsXG4gICAgICAgIHZhbGlnbj17R3RrLkFsaWduLkNFTlRFUn0+XG4gICAgICAgIDxsYWJlbCBoYWxpZ249e0d0ay5BbGlnbi5TVEFSVH0gbGFiZWw9e25hbWV9IC8+XG4gICAgICAgIDxsYWJlbCBoYWxpZ249e0d0ay5BbGlnbi5TVEFSVH0gbGFiZWw9e3N0YXR1c30gLz5cbiAgICAgIDwvYm94PlxuICAgIDwvYm94PlxuICApXG59XG5cbmZ1bmN0aW9uIFdpZmlNb2R1bGUoKSB7XG4gIGNvbnN0IG5ldHdvcmsgPSBOZXR3b3JrLmdldF9kZWZhdWx0KClcblxuICByZXR1cm4gKFxuICAgIDxib3ggY2xhc3NOYW1lPVwiV2lmaVwiIGhhbGlnbj17R3RrLkFsaWduLkNFTlRFUn0+XG4gICAgICB7YmluZChuZXR3b3JrLCBcIndpZmlcIikuYXMod2lmaSA9PiA8Ym94PlxuICAgICAgICB7YmluZCh3aWZpLCBcImVuYWJsZWRcIikuYXMoZW5hYmxlZCA9PiB7XG4gICAgICAgICAgY29uc3QgaWNvbiA9IGJpbmQod2lmaSwgXCJpY29uTmFtZVwiKS5hcyhnZXRXaWZpSWNvbilcbiAgICAgICAgICBjb25zdCBuYW1lID0gZW5hYmxlZFxuICAgICAgICAgICAgPyBiaW5kKHdpZmksIFwic3NpZFwiKS5hcyhzc2lkID0+IHNzaWQgfHwgXCJXaWZpXCIpXG4gICAgICAgICAgICA6IFwiV2lmaVwiXG4gICAgICAgICAgY29uc3Qgc3RhdHVzID0gZW5hYmxlZCA/IFwib25cIiA6IFwib2ZmXCJcbiAgICAgICAgICByZXR1cm4gKFxuICAgICAgICAgICAgPGJ1dHRvblxuICAgICAgICAgICAgICBjbGFzc05hbWU9e2VuYWJsZWQgPyBcImVuYWJsZWRcIiA6IFwiZGlzYWJsZWRcIn1cbiAgICAgICAgICAgICAgb25DbGlja2VkPXsoKSA9PiB3aWZpLnNldF9lbmFibGVkKCFlbmFibGVkKX0+XG4gICAgICAgICAgICAgIHtzaWRlYmFyQnV0dG9uKGljb24sIG5hbWUsIHN0YXR1cyl9XG4gICAgICAgICAgICA8L2J1dHRvbj5cbiAgICAgICAgICApXG4gICAgICAgIH0pfVxuICAgICAgPC9ib3g+XG4gICAgICApfVxuICAgIDwvYm94PlxuICApXG59XG5cbmZ1bmN0aW9uIEJsdWV0b290aE1vZHVsZSgpIHtcbiAgY29uc3QgYmx1ZXRvb3RoID0gQmx1ZXRvb3RoLmdldF9kZWZhdWx0KClcblxuICBmdW5jdGlvbiBnZXRDb25uZWN0ZWREZXZpY2UoZW5hYmxlZDogQm9vbGVhbikge1xuICAgIGZvciAoY29uc3QgZGV2aWNlIG9mIGJsdWV0b290aC5nZXRfZGV2aWNlcygpKSB7XG4gICAgICBpZiAoZGV2aWNlLmNvbm5lY3RlZCkge1xuICAgICAgICBjb25zdCBuYW1lID0gZGV2aWNlLm5hbWVcbiAgICAgICAgY29uc3Qgc3RhdHVzID0gYmluZChkZXZpY2UsIFwiYmF0dGVyeVBlcmNlbnRhZ2VcIikuYXMocCA9PlxuICAgICAgICAgIHAgPiAwID8gYCR7TWF0aC5mbG9vcihwICogMTAwKX0lYCA6IGVuYWJsZWQgPyBcIm9uXCIgOiBcIm9mZlwiKVxuICAgICAgICByZXR1cm4geyBuYW1lLCBzdGF0dXMgfVxuICAgICAgfVxuICAgIH1cbiAgICBjb25zdCBuYW1lID0gXCJCbHVldG9vdGhcIlxuICAgIGNvbnN0IHN0YXR1cyA9IGVuYWJsZWQgPyBcIm9uXCIgOiBcIm9mZlwiXG4gICAgcmV0dXJuIHsgbmFtZSwgc3RhdHVzIH1cbiAgfVxuXG4gIHJldHVybiA8Ym94IGNsYXNzTmFtZT1cIkJsdWV0b290aFwiIGhhbGlnbj17R3RrLkFsaWduLkNFTlRFUn0+XG4gICAge2JpbmQoYmx1ZXRvb3RoLCBcImlzUG93ZXJlZFwiKS5hcyhwb3dlcmVkID0+IChcbiAgICAgIDxidXR0b25cbiAgICAgICAgY2xhc3NOYW1lPXtwb3dlcmVkID8gXCJlbmFibGVkXCIgOiBcImRpc2FibGVkXCJ9XG4gICAgICAgIG9uQ2xpY2tlZD17KCkgPT4gZXhlYyhcInJma2lsbCB0b2dnbGUgYmx1ZXRvb3RoXCIpfT5cbiAgICAgICAge2JpbmQoYmx1ZXRvb3RoLCBcImlzQ29ubmVjdGVkXCIpLmFzKGNvbm4gPT4ge1xuICAgICAgICAgIGNvbnN0IGljb24gPSBjb25uID8gXCJcdURCODBcdURDQjFcIiA6IFwiXHVEQjgwXHVEQ0FGXCJcbiAgICAgICAgICBjb25zdCB7IG5hbWUsIHN0YXR1cyB9ID0gZ2V0Q29ubmVjdGVkRGV2aWNlKHBvd2VyZWQpXG4gICAgICAgICAgcmV0dXJuIHNpZGViYXJCdXR0b24oaWNvbiwgbmFtZSwgc3RhdHVzKVxuICAgICAgICB9KX1cbiAgICAgIDwvYnV0dG9uPlxuICAgICkpfVxuICA8L2JveD5cbn1cblxuZnVuY3Rpb24gRG9Ob3REaXN0dXJiTW9kdWxlKCkge1xuICBjb25zdCBpY29uID0gXCJcdURCODBcdURGNzZcIlxuICBjb25zdCBuYW1lID0gXCJEbyBOb3QgRGlzdHVyYlwiXG4gIHJldHVybiBiaW5kKGRvTm90RGlzdHVyYikuYXMoZG5kID0+IHtcbiAgICBjb25zdCBzdGF0dXMgPSBkbmQgPyBcIm9uXCIgOiBcIm9mZlwiXG4gICAgcmV0dXJuIChcbiAgICAgIDxib3hcbiAgICAgICAgY2xhc3NOYW1lPVwiZG9Ob3REaXN0dXJiXCJcbiAgICAgICAgaGFsaWduPXtHdGsuQWxpZ24uQ0VOVEVSfT5cbiAgICAgICAgPGJ1dHRvblxuICAgICAgICAgIGNsYXNzTmFtZT17ZG5kID8gXCJlbmFibGVkXCIgOiBcImRpc2FibGVkXCJ9XG4gICAgICAgICAgb25DbGlja2VkPXsoKSA9PiBkb05vdERpc3R1cmIuc2V0KCFkbmQpfT5cbiAgICAgICAgICB7c2lkZWJhckJ1dHRvbihpY29uLCBuYW1lLCBzdGF0dXMpfVxuICAgICAgICA8L2J1dHRvbj5cbiAgICAgIDwvYm94PlxuICAgIClcbiAgfSlcbn1cblxuZnVuY3Rpb24gdG9nZ2xlTmlnaHRMaWdodCgpIHtcbiAgaWYgKG5pZ2h0TGlnaHRFbmFibGVkLmdldCgpKSB7XG4gICAgZXhlY0FzeW5jKFwicGtpbGwgLXggaHlwcnN1bnNldFwiKVxuICAgIG5pZ2h0TGlnaHRFbmFibGVkLnNldChmYWxzZSlcbiAgfSBlbHNlIHtcbiAgICBleGVjQXN5bmMoXCJoeXByc3Vuc2V0IC10IDUwMDBcIilcbiAgICBuaWdodExpZ2h0RW5hYmxlZC5zZXQodHJ1ZSlcbiAgfVxufVxuXG5mdW5jdGlvbiBOaWdodExpZ2h0TW9kdWxlKCkge1xuICBjb25zdCBuYW1lID0gXCJOaWdodCBMaWdodFwiXG4gIHJldHVybiBiaW5kKG5pZ2h0TGlnaHRFbmFibGVkKS5hcyhlbmFibGVkID0+IHtcbiAgICBjb25zdCBpY29uID0gZW5hYmxlZCA/IFwiXHVEQjg2XHVERTRDXCIgOiBcIlx1REI4MFx1REYzNlwiXG4gICAgY29uc3Qgc3RhdHVzID0gZW5hYmxlZCA/IFwib25cIiA6IFwib2ZmXCJcbiAgICByZXR1cm4gKFxuICAgICAgPGJveFxuICAgICAgICBjbGFzc05hbWU9XCJuaWdodExpZ2h0XCJcbiAgICAgICAgaGFsaWduPXtHdGsuQWxpZ24uQ0VOVEVSfT5cbiAgICAgICAgPGJ1dHRvblxuICAgICAgICAgIGNsYXNzTmFtZT17ZW5hYmxlZCA/IFwiZW5hYmxlZFwiIDogXCJkaXNhYmxlZFwifVxuICAgICAgICAgIG9uQ2xpY2tlZD17dG9nZ2xlTmlnaHRMaWdodH0+XG4gICAgICAgICAge3NpZGViYXJCdXR0b24oaWNvbiwgbmFtZSwgc3RhdHVzKX1cbiAgICAgICAgPC9idXR0b24+XG4gICAgICA8L2JveD5cbiAgICApXG4gIH0pXG59XG5cbmZ1bmN0aW9uIE5vdGlmaWNhdGlvbkxpc3QoKSB7XG4gIGNvbnN0IG5vdGlmZCA9IE5vdGlmZC5nZXRfZGVmYXVsdCgpXG5cbiAgcmV0dXJuIDxib3ggY2xhc3NOYW1lPVwiTm90aWZpY2F0aW9uTGlzdFwiPlxuICAgIHtiaW5kKG5vdGlmZCwgXCJub3RpZmljYXRpb25zXCIpLmFzKG5vdGlmcyA9PiB7XG4gICAgICBjb25zdCBuTGVuZ3RoID0gbm90aWZzLmxlbmd0aFxuICAgICAgbm90aWZpY2F0aW9uc0xlbmd0aC5zZXQobkxlbmd0aClcbiAgICAgIGNvbnN0IGJveEhlaWdodCA9IG5MZW5ndGggPiAwID8gNDAwIDogMzAwXG4gICAgICByZXR1cm4gPGJveCB2ZXJ0aWNhbFxuICAgICAgICBoZWlnaHRSZXF1ZXN0PXtib3hIZWlnaHR9XG4gICAgICAgIHdpZHRoUmVxdWVzdD17MzAwfVxuICAgICAgPlxuICAgICAgICA8Ym94PlxuICAgICAgICAgIDxsYWJlbCBjbGFzc05hbWU9XCJUaXRsZVwiIGxhYmVsPVwiTm90aWZpY2F0aW9uc1wiIC8+XG4gICAgICAgICAgPGJ1dHRvblxuICAgICAgICAgICAgY2xhc3NOYW1lPVwiZGlzbWlzc0FsbFwiXG4gICAgICAgICAgICBoYWxpZ249e0d0ay5BbGlnbi5FTkR9XG4gICAgICAgICAgICBoZXhwYW5kXG4gICAgICAgICAgICBsYWJlbD1cIkNsZWFyIEFsbFwiXG4gICAgICAgICAgICBvbkNsaWNrZWQ9eygpID0+IG5vdGlmcy5mb3JFYWNoKG4gPT4gbi5kaXNtaXNzKCkpfVxuICAgICAgICAgIC8+XG4gICAgICAgIDwvYm94PlxuICAgICAgICB7bkxlbmd0aCA+IDAgPyAoXG4gICAgICAgICAgPHNjcm9sbGFibGUgdmV4cGFuZD5cbiAgICAgICAgICAgIDxib3ggdmVydGljYWw+XG4gICAgICAgICAgICAgIHtub3RpZnMucmV2ZXJzZSgpLm1hcChuID0+IHtcbiAgICAgICAgICAgICAgICByZXR1cm4gTm90aWZpY2F0aW9uKHtcbiAgICAgICAgICAgICAgICAgIG5vdGlmaWNhdGlvbjogbixcbiAgICAgICAgICAgICAgICAgIHNldHVwOiAoKSA9PiB7IH0sXG4gICAgICAgICAgICAgICAgICBvbkhvdmVyTG9zdDogKCkgPT4geyB9XG4gICAgICAgICAgICAgICAgfSlcbiAgICAgICAgICAgICAgfSl9XG4gICAgICAgICAgICA8L2JveD5cbiAgICAgICAgICA8L3Njcm9sbGFibGU+XG4gICAgICAgICkgOiAoXG4gICAgICAgICAgPGJveFxuICAgICAgICAgICAgY2xhc3NOYW1lPVwibm9Ob3RpZmljYXRpb25zXCJcbiAgICAgICAgICAgIHZleHBhbmRcbiAgICAgICAgICAgIGhleHBhbmRcbiAgICAgICAgICAgIHZlcnRpY2FsXG4gICAgICAgICAgICB2YWxpZ249e0d0ay5BbGlnbi5DRU5URVJ9XG4gICAgICAgICAgPlxuICAgICAgICAgICAgPGxhYmVsIGxhYmVsPVwiXHVEQjg0XHVERkVDXCIgY2xhc3NOYW1lPVwiSWNvblwiIC8+XG4gICAgICAgICAgICA8bGFiZWwgbGFiZWw9XCJubyBub3RpZmljYXRpb25zIDooXCIgLz5cbiAgICAgICAgICA8L2JveD5cbiAgICAgICAgKX1cbiAgICAgIDwvYm94PlxuICAgIH0pfVxuICA8L2JveD5cbn1cblxuZnVuY3Rpb24gU2Nyb2xsYWJsZU1lZGlhUGxheWVycygpIHtcbiAgY29uc3QgbXByaXMgPSBNcHJpcy5nZXRfZGVmYXVsdCgpXG4gIGNvbnN0IGN1cnJlbnRQbGF5ZXIgPSBWYXJpYWJsZSgwKVxuICBjb25zdCBwbGF5ZXJzTGVuZ2h0ID0gVmFyaWFibGUoMClcblxuICByZXR1cm4gKFxuICAgIDxldmVudGJveFxuICAgICAgb25TY3JvbGw9eyhfLCBldmVudCkgPT4ge1xuICAgICAgICBjb25zdCBkZWx0YV95ID0gZXZlbnQuZGVsdGFfeVxuICAgICAgICBjb25zdCBjdXJyZW50ID0gY3VycmVudFBsYXllci5nZXQoKVxuICAgICAgICBjb25zdCBtYXggPSBwbGF5ZXJzTGVuZ2h0LmdldCgpIC0gMVxuXG4gICAgICAgIGlmIChkZWx0YV95IDwgMCkge1xuICAgICAgICAgIGlmIChjdXJyZW50IDwgbWF4KSBjdXJyZW50UGxheWVyLnNldChjdXJyZW50ICsgMSlcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICBpZiAoY3VycmVudCA+IDApIGN1cnJlbnRQbGF5ZXIuc2V0KGN1cnJlbnQgLSAxKVxuICAgICAgICB9XG4gICAgICB9fVxuICAgID5cbiAgICAgIHtiaW5kKG1wcmlzLCBcInBsYXllcnNcIikuYXMocHMgPT4ge1xuICAgICAgICBwbGF5ZXJzTGVuZ2h0LnNldChwcy5sZW5ndGgpXG4gICAgICAgIGlmIChwcy5sZW5ndGggPiAwKSByZXR1cm4gKFxuICAgICAgICAgIDxib3ggdmVydGljYWw+XG4gICAgICAgICAgICA8c3RhY2tcbiAgICAgICAgICAgICAgdHJhbnNpdGlvblR5cGU9e0d0ay5TdGFja1RyYW5zaXRpb25UeXBlLlNMSURFX0xFRlRfUklHSFR9XG4gICAgICAgICAgICAgIHRyYW5zaXRpb25EdXJhdGlvbj17MzAwfVxuICAgICAgICAgICAgICB2aXNpYmxlQ2hpbGROYW1lPXtiaW5kKGN1cnJlbnRQbGF5ZXIpLmFzKGN1cnJlbnQgPT4gcHNbY3VycmVudF0uZW50cnkpfT5cbiAgICAgICAgICAgICAge3BzLm1hcChwbGF5ZXIgPT4ge1xuICAgICAgICAgICAgICAgIHJldHVybiA8Ym94IG5hbWU9e3BsYXllci5lbnRyeX0+XG4gICAgICAgICAgICAgICAgICB7TWVkaWFQbGF5ZXIocGxheWVyKX1cbiAgICAgICAgICAgICAgICA8L2JveD5cbiAgICAgICAgICAgICAgfSl9XG4gICAgICAgICAgICA8L3N0YWNrPlxuICAgICAgICAgICAgPGJveFxuICAgICAgICAgICAgICBjbGFzc05hbWU9XCJwbGF5ZXJzQnV0dG9uc1wiXG4gICAgICAgICAgICAgIGhhbGlnbj17R3RrLkFsaWduLkNFTlRFUn1cbiAgICAgICAgICAgICAgdmlzaWJsZT17cHMubGVuZ3RoID4gMSA/IHRydWUgOiBmYWxzZX1cbiAgICAgICAgICAgID5cbiAgICAgICAgICAgICAge3BzLm1hcChwbGF5ZXIgPT4gKFxuICAgICAgICAgICAgICAgIDxidXR0b25cbiAgICAgICAgICAgICAgICAgIGNsYXNzTmFtZT17YmluZChjdXJyZW50UGxheWVyKS5hcyhjdXJyZW50ID0+XG4gICAgICAgICAgICAgICAgICAgIHBzW2N1cnJlbnRdLmVudHJ5ID09IHBsYXllci5lbnRyeVxuICAgICAgICAgICAgICAgICAgICAgID8gXCJlbmFibGVkXCJcbiAgICAgICAgICAgICAgICAgICAgICA6IFwiZGlzYWJsZWRcIlxuICAgICAgICAgICAgICAgICAgKX1cbiAgICAgICAgICAgICAgICAgIG9uQ2xpY2tlZD17KCkgPT4gY3VycmVudFBsYXllci5zZXQocHMuaW5kZXhPZihwbGF5ZXIpKX0+XG4gICAgICAgICAgICAgICAgICA8aWNvbiBpY29uPXtwbGF5ZXIuZW50cnkucmVwbGFjZSgvemVuLywgXCJ6ZW4tYnJvd3NlclwiKX0gLz5cbiAgICAgICAgICAgICAgICA8L2J1dHRvbj5cbiAgICAgICAgICAgICAgKSl9XG4gICAgICAgICAgICA8L2JveD5cbiAgICAgICAgICA8L2JveD4pXG4gICAgICAgIHJldHVybiA8Ym94IC8+XG4gICAgICB9KX1cbiAgICA8L2V2ZW50Ym94PlxuICApXG59XG5cbmZ1bmN0aW9uIFNpZGViYXJCbHVldG9vdGhQYW5lbCgpIHtcbiAgY29uc3QgYmx1ZXRvb3RoID0gQmx1ZXRvb3RoLmdldF9kZWZhdWx0KClcbiAgY29uc3QgYWRhcHRlciA9IGJsdWV0b290aC5hZGFwdGVyXG4gIGZ1bmN0aW9uIGxpc3RJdGVtKGRldmljZTogQmx1ZXRvb3RoLkRldmljZSkge1xuICAgIGlmIChkZXZpY2UubmFtZSA9PT0gbnVsbCkgcmV0dXJuIDxib3gvPlxuICAgIGNvbnN0IHZpc2libGVCaW5kaW5nID0gVmFyaWFibGUuZGVyaXZlKFxuICAgICAgICBbYmluZChkZXZpY2UsICdjb25uZWN0ZWQnKSwgYmluZChkZXZpY2UsICdwYWlyZWQnKV0sXG4gICAgICAgIChjb25uZWN0ZWQsIHBhaXJlZCkgPT4ge1xuICAgICAgICAgICAgcmV0dXJuIGNvbm5lY3RlZCB8fCBwYWlyZWQ7XG4gICAgICAgIH0sXG4gICAgKTtcbiAgICBjb25zdCBiYXR0ZXJ5ID0gYmluZChkZXZpY2UsIFwiYmF0dGVyeVBlcmNlbnRhZ2VcIikuYXMocCA9PlxuICAgICAgcCA+IDAgPyBgICgke01hdGguZmxvb3IocCAqIDEwMCl9JSlgIDogXCJcIilcbiAgICByZXR1cm4gPGJveCBjbGFzc05hbWU9XCJJdGVtXCI+XG4gICAgICA8Ym94PlxuICAgICAgICA8aWNvbiBpY29uPXtkZXZpY2UuaWNvbiB8fCBcImhlbHAtYnJvd3NlclwifSAvPlxuICAgICAgICA8Ym94IHZlcnRpY2FsPlxuICAgICAgICAgIDxib3ggaGFsaWduPXtHdGsuQWxpZ24uU1RBUlR9PlxuICAgICAgICAgICAgPGxhYmVsIGxhYmVsPXtkZXZpY2UubmFtZX0gY2xhc3NOYW1lPVwiTmFtZVwiIC8+XG4gICAgICAgICAgICA8bGFiZWwgbGFiZWw9e2JhdHRlcnl9IGNsYXNzTmFtZT1cIkJhdHRlcnlcIiAvPlxuICAgICAgICAgIDwvYm94PlxuICAgICAgICAgIDxsYWJlbFxuICAgICAgICAgICAgdmlzaWJsZT17dmlzaWJsZUJpbmRpbmcoKX1cbiAgICAgICAgICAgIGNsYXNzTmFtZT1cIlN0YXR1c1wiXG4gICAgICAgICAgICBoYWxpZ249e0d0ay5BbGlnbi5TVEFSVH1cbiAgICAgICAgICAgIGxhYmVsPXtiaW5kKGRldmljZSwgXCJjb25uZWN0ZWRcIikuYXMoY29ubiA9PiBjb25uID8gXCJDb25uZWN0ZWRcIiA6IFwiUGFpcmVkXCIpfVxuICAgICAgICAgIC8+XG4gICAgICAgIDwvYm94PlxuICAgICAgPC9ib3g+XG4gICAgICA8Ym94IGhleHBhbmQgLz5cbiAgICAgIDxib3ggY2xhc3NOYW1lPVwiQWN0aW9uc1wiPlxuICAgICAgICA8YnV0dG9uXG4gICAgICAgICAgbGFiZWw9XCJcdURCODVcdURFMTZcIlxuICAgICAgICAgIG9uQ2xpY2tlZD17KCkgPT4ge1xuICAgICAgICAgICAgaWYgKGRldmljZS5nZXRfY29ubmVjdGVkKCkpIHtcbiAgICAgICAgICAgICAgZGV2aWNlLmRpc2Nvbm5lY3RfZGV2aWNlKChyZXMpID0+IGNvbnNvbGUubG9nKHJlcykpXG4gICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICBkZXZpY2UuY29ubmVjdF9kZXZpY2UoKHJlcykgPT4gY29uc29sZS5sb2cocmVzKSlcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9fVxuICAgICAgICAvPlxuICAgICAgPC9ib3g+XG4gICAgPC9ib3g+XG4gIH1cblxuICByZXR1cm4gPGJveFxuICAgIG5hbWU9XCJibHVldG9vdGhcIlxuICAgIGNsYXNzTmFtZT1cIlNpZGViYXJCbHVldG9vdGhQYW5lbFwiXG4gICAgdmVydGljYWxcbiAgPlxuICAgIDxib3g+XG4gICAgICA8bGFiZWwgbGFiZWw9XCJCbHVldG9vdGhcIiBjbGFzc05hbWU9XCJUaXRsZVwiIC8+XG4gICAgICA8Ym94IGhleHBhbmQgLz5cbiAgICAgIDxidXR0b25cbiAgICAgICAgY2xhc3NOYW1lPVwiRGlzY292ZXJcIlxuICAgICAgICBjc3M9e2JpbmQoYWRhcHRlciwgXCJkaXNjb3ZlcmluZ1wiKS5hcyhkaXNjID0+XG4gICAgICAgICAgZGlzYyA/IFwiY29sb3I6ICM3ZTljZDg7XCJcbiAgICAgICAgICAgICAgIDogXCJjb2xvcjogI2M4YzA5MztcIlxuICAgICAgICApfVxuICAgICAgICBsYWJlbD1cIlx1REI4MVx1RENFNlwiXG4gICAgICAgIHRvb2x0aXBUZXh0PXtiaW5kKGFkYXB0ZXIsIFwiZGlzY292ZXJpbmdcIikuYXMoZGlzYyA9PiBkaXNjID8gXCJEaXNjb3ZlcmluZ1wiIDogXCJEaXNjb3ZlclwiKX1cbiAgICAgICAgb25DbGlja2VkPXsoKSA9PiB7XG4gICAgICAgICAgaWYgKGFkYXB0ZXIuZ2V0X2Rpc2NvdmVyaW5nKCkpIHtcbiAgICAgICAgICAgIGFkYXB0ZXIuc3RvcF9kaXNjb3ZlcnkoKVxuICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICBhZGFwdGVyLnN0YXJ0X2Rpc2NvdmVyeSgpXG4gICAgICAgICAgfVxuICAgICAgICB9fVxuICAgICAgPlxuICAgICAgPC9idXR0b24+XG4gICAgICA8c3dpdGNoXG4gICAgICAgIGFjdGl2ZT17YmluZChibHVldG9vdGgsIFwiaXNQb3dlcmVkXCIpfVxuICAgICAgICBvbkJ1dHRvblByZXNzRXZlbnQ9eygpID0+IGV4ZWNBc3luYyhcInJma2lsbCB0b2dnbGUgYmx1ZXRvb3RoXCIpfVxuICAgICAgLz5cbiAgICA8L2JveD5cbiAgICA8c2Nyb2xsYWJsZVxuICAgICAgdmV4cGFuZFxuICAgICAgY2xhc3NOYW1lPVwiSXRlbUxpc3RcIlxuICAgID5cbiAgICAgIDxib3ggdmVydGljYWw+XG4gICAgICAgIHtiaW5kKGJsdWV0b290aCwgXCJkZXZpY2VzXCIpLmFzKGRldnMgPT4gZGV2cy5tYXAoZCA9PiBsaXN0SXRlbShkKSkpfVxuICAgICAgPC9ib3g+XG4gICAgPC9zY3JvbGxhYmxlPlxuICA8L2JveD5cbn1cblxuZnVuY3Rpb24gU2lkZWJhcldpZmlQYW5lbCgpIHtcbiAgY29uc3QgbmV0d29yayA9IE5ldHdvcmsuZ2V0X2RlZmF1bHQoKVxuICBjb25zdCB3aWZpID0gbmV0d29yay53aWZpXG4gIGZ1bmN0aW9uIGl0ZW1MaXN0KGFwOiBOZXR3b3JrLkFjY2Vzc1BvaW50KSB7XG4gICAgaWYgKGFwLnNzaWQgPT09IG51bGwpIHJldHVybiA8Ym94Lz5cbiAgICByZXR1cm4gPGJveCBjbGFzc05hbWU9XCJJdGVtXCI+XG4gICAgICA8bGFiZWwgbGFiZWw9e2JpbmQoYXAsIFwiaWNvbk5hbWVcIikuYXMoaSA9PiBnZXRXaWZpSWNvbihpKSl9IGNsYXNzTmFtZT1cImljb25cIiAvPlxuICAgICAgPGJveCB2ZXJ0aWNhbCB2YWxpZ249e0d0ay5BbGlnbi5DRU5URVJ9PlxuICAgICAgICA8bGFiZWwgbGFiZWw9e2FwLnNzaWR9IGNsYXNzTmFtZT1cInNzaWRcIiBoYWxpZ249e0d0ay5BbGlnbi5TVEFSVH0vPlxuICAgICAgICA8bGFiZWxcbiAgICAgICAgICB2aXNpYmxlPXtiaW5kKHdpZmksIFwiYWN0aXZlQWNjZXNzUG9pbnRcIikuYXMoYWFwID0+IGFhcCA9PT0gYXApfVxuICAgICAgICAgIGhhbGlnbj17R3RrLkFsaWduLlNUQVJUfVxuICAgICAgICAgIGxhYmVsPVwiQ29ubmVjdGVkXCJcbiAgICAgICAgICBjbGFzc05hbWU9XCJzdGF0dXNcIiAvPlxuICAgICAgPC9ib3g+XG4gICAgICA8Ym94IGhleHBhbmQgLz5cbiAgICAgIDxidXR0b25cbiAgICAgICAgbGFiZWw9XCJcdURCODVcdURFMTZcIlxuICAgICAgICBvbkNsaWNrZWQ9eygpID0+IGV4ZWNBc3luYyhgbm1jbGkgZGV2aWNlIHdpZmkgY29ubmVjdCAke2FwLnNzaWR9YCl9XG4gICAgICAvPlxuICAgIDwvYm94PlxuICB9XG5cbiAgcmV0dXJuIDxib3hcbiAgICBuYW1lPVwid2lmaVwiXG4gICAgdmVydGljYWxcbiAgICBjbGFzc05hbWU9XCJTaWRlYmFyV2lmaVBhbmVsXCJcbiAgPlxuICAgIDxib3g+XG4gICAgICA8bGFiZWwgbGFiZWw9XCJXaWZpXCIgY2xhc3NOYW1lPVwiVGl0bGVcIiAvPlxuICAgICAgPGJveCBoZXhwYW5kIC8+XG4gICAgICA8c3dpdGNoXG4gICAgICAgIGFjdGl2ZT17YmluZCh3aWZpLCBcImVuYWJsZWRcIil9XG4gICAgICAgIG9uQnV0dG9uUHJlc3NFdmVudD17KCkgPT4gd2lmaS5zZXRfZW5hYmxlZCghd2lmaS5nZXRfZW5hYmxlZCgpKX1cbiAgICAgIC8+XG4gICAgPC9ib3g+XG4gICAgPHNjcm9sbGFibGVcbiAgICAgIHZleHBhbmRcbiAgICAgIGNsYXNzTmFtZT1cIkl0ZW1MaXN0XCJcbiAgICA+XG4gICAgICA8Ym94IHZlcnRpY2FsPlxuICAgICAgICB7YmluZCh3aWZpLCBcImFjY2Vzc19wb2ludHNcIikuYXMoYXBzID0+XG4gICAgICAgICAgYXBzXG4gICAgICAgICAgICAuc29ydCgoYSwgYikgPT4gYi5zdHJlbmd0aCAtIGEuc3RyZW5ndGgpXG4gICAgICAgICAgICAubWFwKGFwID0+IGl0ZW1MaXN0KGFwKSlcbiAgICAgICAgKX1cbiAgICAgIDwvYm94PlxuICAgIDwvc2Nyb2xsYWJsZT5cbiAgPC9ib3g+XG59XG5cbmZ1bmN0aW9uIFNpZGViYXJNYWluUGFuZWwoKSB7XG4gIHJldHVybiA8Ym94XG4gICAgbmFtZT1cIm1haW5cIlxuICAgIHZlcnRpY2FsXG4gICAgY2xhc3NOYW1lPVwiU2lkZWJhck1haW5QYW5lbFwiXG4gID5cbiAgICA8Ym94PlxuICAgICAgPFdpZmlNb2R1bGUgLz5cbiAgICAgIDxib3ggd2lkdGhSZXF1ZXN0PXs4fSAvPlxuICAgICAgPEJsdWV0b290aE1vZHVsZSAvPlxuICAgIDwvYm94PlxuICAgIDxib3g+XG4gICAgICA8RG9Ob3REaXN0dXJiTW9kdWxlIC8+XG4gICAgICA8Ym94IHdpZHRoUmVxdWVzdD17OH0gLz5cbiAgICAgIDxOaWdodExpZ2h0TW9kdWxlIC8+XG4gICAgPC9ib3g+XG4gICAgPFNjcm9sbGFibGVNZWRpYVBsYXllcnMgLz5cbiAgICA8Tm90aWZpY2F0aW9uTGlzdCAvPlxuICA8L2JveD5cbn1cblxuZnVuY3Rpb24gU2lkZWJhclBhbmVscygpIHtcbiAgcmV0dXJuIDxzdGFja1xuICAgIHRyYW5zaXRpb25UeXBlPXtHdGsuU3RhY2tUcmFuc2l0aW9uVHlwZS5TTElERV9MRUZUX1JJR0hUfVxuICAgIHZpc2libGVDaGlsZE5hbWU9e2JpbmQoc2lkZWJhclBhbmVsKS5hcyhzcCA9PiBzcCl9XG4gID5cbiAgICA8U2lkZWJhck1haW5QYW5lbCAvPlxuICAgIDxTaWRlYmFyQmx1ZXRvb3RoUGFuZWwgLz5cbiAgICA8U2lkZWJhcldpZmlQYW5lbCAvPlxuICA8L3N0YWNrPlxufVxuXG5mdW5jdGlvbiBTaWRlYmFyUGFuZWxzQnV0dG9ucygpIHtcbiAgY29uc3QgYWN0aW9ucyA9IFtcIm1haW5cIiwgXCJibHVldG9vdGhcIiwgXCJ3aWZpXCJdXG4gIHJldHVybiA8Y2VudGVyYm94IGNsYXNzTmFtZT1cIlNpZGViYXJQYW5lbHNCdXR0b25zXCI+XG4gICAge2FjdGlvbnMubWFwKGFjdGlvbiA9PlxuICAgICAgPGJ1dHRvblxuICAgICAgICBoZXhwYW5kXG4gICAgICAgIGxhYmVsPXthY3Rpb259XG4gICAgICAgIGNsYXNzTmFtZT17YmluZChzaWRlYmFyUGFuZWwpLmFzKHNwID0+IHNwID09PSBhY3Rpb24gPyBcImVuYWJsZWRcIiA6IFwiZGlzYWJsZWRcIil9XG4gICAgICAgIG9uQ2xpY2tlZD17KCkgPT4gc2lkZWJhclBhbmVsLnNldChhY3Rpb24pfVxuICAgICAgLz5cbiAgICApfVxuICA8L2NlbnRlcmJveD5cbn1cblxuXG5leHBvcnQgZGVmYXVsdCBmdW5jdGlvbiBSaWdodFNpZGViYXIobW9uaXRvcjogR2RrLk1vbml0b3IsIHZpc2libGU6IFZhcmlhYmxlPGJvb2xlYW4+KSB7XG4gIGNvbnN0IHsgVE9QLCBSSUdIVCB9ID0gQXN0YWwuV2luZG93QW5jaG9yXG5cbiAgcmV0dXJuIDx3aW5kb3dcbiAgICBjbGFzc05hbWU9XCJSaWdodFNpZGViYXJcIlxuICAgIG5hbWVzcGFjZT1cInJpZ2h0c2lkZWJhclwiXG4gICAgZ2RrbW9uaXRvcj17bW9uaXRvcn1cbiAgICBleGNsdXNpdml0eT17QXN0YWwuRXhjbHVzaXZpdHkuRVhDTFVTSVZFfVxuICAgIGFwcGxpY2F0aW9uPXtBcHB9XG4gICAgdmlzaWJsZT17dmlzaWJsZSgpfVxuICAgIGxheWVyPXtBc3RhbC5MYXllci5UT1B9XG4gICAgYW5jaG9yPXtUT1AgfCBSSUdIVH0+XG4gICAgPGJveFxuICAgICAgdmVydGljYWxcbiAgICAgIGNsYXNzTmFtZT1cInNpZGViYXJcIj5cbiAgICAgIDxib3g+XG4gICAgICAgIDxVc2VyTW9kdWxlIC8+XG4gICAgICAgIDxTaWRlYmFyUGFuZWxzQnV0dG9ucyAvPlxuICAgICAgPC9ib3g+XG4gICAgICA8U2lkZWJhclBhbmVscyAvPlxuICAgIDwvYm94PlxuICA8L3dpbmRvdz5cbn1cbiIsICJpbXBvcnQgeyBiaW5kIH0gZnJvbSBcImFzdGFsXCJcbmltcG9ydCB7IEd0ayB9IGZyb20gXCJhc3RhbC9ndGszXCJcbmltcG9ydCBWYXJpYWJsZSBmcm9tIFwiYXN0YWwvdmFyaWFibGVcIlxuaW1wb3J0IE1wcmlzIGZyb20gXCJnaTovL0FzdGFsTXByaXNcIlxuXG5cbmZ1bmN0aW9uIGxlbmd0aFN0cihsZW5ndGg6IG51bWJlcikge1xuICBjb25zdCBtaW4gPSBNYXRoLmZsb29yKGxlbmd0aCAvIDYwKVxuICBjb25zdCBzZWMgPSBNYXRoLmZsb29yKGxlbmd0aCAlIDYwKVxuICBjb25zdCBzZWMwID0gc2VjIDwgMTAgPyBcIjBcIiA6IFwiXCJcbiAgcmV0dXJuIGAke21pbn06JHtzZWMwfSR7c2VjfWBcbn1cblxuZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gTWVkaWFQbGF5ZXIocGxheWVyOiBNcHJpcy5QbGF5ZXIpIHtcbiAgY29uc3Qgc2hvd1Bvc2l0aW9uID0gVmFyaWFibGU8Ym9vbGVhbj4oZmFsc2UpXG5cbiAgY29uc3QgY292ZXJBcnQgPSBiaW5kKHBsYXllciwgXCJjb3ZlckFydFwiKS5hcyhjID0+XG4gICAgYGJhY2tncm91bmQtaW1hZ2U6IHVybCgnJHtjfScpYClcblxuICBjb25zdCBwbGF5SWNvbiA9IGJpbmQocGxheWVyLCBcInBsYXliYWNrU3RhdHVzXCIpLmFzKHMgPT5cbiAgICBzID09PSAwID8gXCJcdURCODBcdURGRTRcIiA6IFwiXHVEQjgxXHVEQzBBXCIpXG5cbiAgY29uc3QgcG9zaXRpb24gPSBiaW5kKHBsYXllciwgXCJwb3NpdGlvblwiKS5hcyhwID0+IHBsYXllci5sZW5ndGggPiAwXG4gICAgPyBwIC8gcGxheWVyLmxlbmd0aCA6IDApXG5cbiAgZnVuY3Rpb24gQXJ0aXN0VGl0bGUoKSB7XG4gICAgcmV0dXJuIDxib3ggdmVydGljYWwgaGV4cGFuZD5cbiAgICAgIDxsYWJlbFxuICAgICAgICBjbGFzc05hbWU9XCJUaXRsZVwiXG4gICAgICAgIHRydW5jYXRlXG4gICAgICAgIG1heFdpZHRoQ2hhcnM9ezM1fVxuICAgICAgICBoYWxpZ249e0d0ay5BbGlnbi5TVEFSVH1cbiAgICAgICAgdmFsaWduPXtHdGsuQWxpZ24uU1RBUlR9XG4gICAgICAgIGxhYmVsPXtiaW5kKHBsYXllciwgXCJtZXRhZGF0YVwiKS5hcygoKSA9PiBgJHtwbGF5ZXIudGl0bGV9YCl9IC8+XG4gICAgICA8bGFiZWxcbiAgICAgICAgY2xhc3NOYW1lPVwiQXJ0aXN0XCJcbiAgICAgICAgdmV4cGFuZFxuICAgICAgICBoYWxpZ249e0d0ay5BbGlnbi5TVEFSVH1cbiAgICAgICAgdmFsaWduPXtHdGsuQWxpZ24uU1RBUlR9XG4gICAgICAgIGxhYmVsPXtiaW5kKHBsYXllciwgXCJtZXRhZGF0YVwiKS5hcygoKSA9PiB7XG4gICAgICAgICAgaWYgKHBsYXllci5hcnRpc3QpIHJldHVybiBgJHtwbGF5ZXIuYXJ0aXN0fWBcbiAgICAgICAgICBpZiAocGxheWVyLmFsYnVtKSByZXR1cm4gYCR7cGxheWVyLmFsYnVtfWBcbiAgICAgICAgICByZXR1cm4gXCJcIlxuICAgICAgICB9KX0gLz5cbiAgICA8L2JveD5cbiAgfVxuXG4gIGZ1bmN0aW9uIFBvc2l0aW9uKCkge1xuICAgIHJldHVybiA8cmV2ZWFsZXJcbiAgICAgIHJldmVhbENoaWxkPXtiaW5kKHNob3dQb3NpdGlvbil9XG4gICAgICB0cmFuc2l0aW9uVHlwZT17R3RrLlJldmVhbGVyVHJhbnNpdGlvblR5cGUuU0xJREVfRE9XTn0+XG4gICAgICA8Ym94IHZlcnRpY2FsIGNsYXNzTmFtZT1cInBvc2l0aW9uXCI+XG4gICAgICAgIDxib3g+XG4gICAgICAgICAgPGxhYmVsXG4gICAgICAgICAgICBoYWxpZ249e0d0ay5BbGlnbi5TVEFSVH1cbiAgICAgICAgICAgIHZpc2libGU9e2JpbmQocGxheWVyLCBcImxlbmd0aFwiKS5hcyhsID0+IGwgPiAwKX1cbiAgICAgICAgICAgIGxhYmVsPXtiaW5kKHBsYXllciwgXCJwb3NpdGlvblwiKS5hcyhsZW5ndGhTdHIpfVxuICAgICAgICAgIC8+XG4gICAgICAgICAgPGxhYmVsXG4gICAgICAgICAgICBoZXhwYW5kXG4gICAgICAgICAgICBoYWxpZ249e0d0ay5BbGlnbi5TVEFSVH1cbiAgICAgICAgICAgIHZpc2libGU9e2JpbmQocGxheWVyLCBcImxlbmd0aFwiKS5hcyhsID0+IGwgPiAwKX1cbiAgICAgICAgICAgIGxhYmVsPXtiaW5kKHBsYXllciwgXCJsZW5ndGhcIikuYXMobCA9PiBsID4gMCA/IGAgLSAke2xlbmd0aFN0cihsKX1gIDogXCIgLSAwOjAwXCIpfVxuICAgICAgICAgIC8+XG4gICAgICAgIDwvYm94PlxuICAgICAgICA8c2xpZGVyXG4gICAgICAgICAgdmlzaWJsZT17YmluZChwbGF5ZXIsIFwibGVuZ3RoXCIpLmFzKGwgPT4gbCA+IDApfVxuICAgICAgICAgIG9uRHJhZ2dlZD17KHsgdmFsdWUgfSkgPT4gcGxheWVyLnBvc2l0aW9uID0gdmFsdWUgKiBwbGF5ZXIubGVuZ3RofVxuICAgICAgICAgIHZhbHVlPXtwb3NpdGlvbn1cbiAgICAgICAgLz5cbiAgICAgIDwvYm94PlxuICAgIDwvcmV2ZWFsZXI+XG4gIH1cblxuICBmdW5jdGlvbiBBY3Rpb25zKCkge1xuICAgIHJldHVybiA8Ym94XG4gICAgICBjbGFzc05hbWU9XCJBY3Rpb25zXCJcbiAgICAgIGhvbW9nZW5lb3VzXG4gICAgICB2ZXJ0aWNhbD5cbiAgICAgIDxidXR0b25cbiAgICAgICAgbGFiZWw9XCJcdURCODFcdURDQUVcIlxuICAgICAgICBvbkNsaWNrZWQ9eygpID0+IHBsYXllci5wcmV2aW91cygpfVxuICAgICAgLz5cbiAgICAgIDxidXR0b25cbiAgICAgICAgbGFiZWw9e3BsYXlJY29ufVxuICAgICAgICBvbkNsaWNrPXsoKSA9PiBwbGF5ZXIucGxheV9wYXVzZSgpfVxuICAgICAgLz5cbiAgICAgIDxidXR0b25cbiAgICAgICAgbGFiZWw9XCJcdURCODFcdURDQURcIlxuICAgICAgICBvbkNsaWNrZWQ9eygpID0+IHBsYXllci5uZXh0KCl9XG4gICAgICAvPlxuICAgIDwvYm94PlxuICB9XG5cbiAgcmV0dXJuIDxldmVudGJveFxuICAgIG9uSG92ZXI9eygpID0+IHNob3dQb3NpdGlvbi5zZXQodHJ1ZSl9XG4gICAgb25Ib3Zlckxvc3Q9eygpID0+IHNob3dQb3NpdGlvbi5zZXQoZmFsc2UpfT5cbiAgICA8Ym94IGNsYXNzTmFtZT1cIk1lZGlhUGxheWVyXCIgPlxuICAgICAgPGJveFxuICAgICAgICBjbGFzc05hbWU9XCJDb3ZlclwiXG4gICAgICAgIGhleHBhbmRcbiAgICAgICAgd2lkdGhSZXF1ZXN0PXszMDB9XG4gICAgICAgIGNzcz17Y292ZXJBcnR9PlxuICAgICAgICA8Ym94XG4gICAgICAgICAgY2xhc3NOYW1lPVwiRGVzY3JpcHRpb25cIlxuICAgICAgICAgIHZlcnRpY2FsPlxuICAgICAgICAgIDxBcnRpc3RUaXRsZSAvPlxuICAgICAgICAgIDxQb3NpdGlvbiAvPlxuICAgICAgICA8L2JveD5cbiAgICAgIDwvYm94PlxuICAgICAgPEFjdGlvbnMgLz5cbiAgICA8L2JveD5cbiAgPC9ldmVudGJveD5cbn1cbiIsICJpbXBvcnQgeyBzaG93QmFyLCBzaG93Q3Jvc3NoYWlyLCBzaG93TGF1bmNoZXIsIHNob3dMZWZ0U2lkZWJhciwgc2hvd1JpZ2h0U2lkZWJhciB9IGZyb20gXCJAY29tbW9uL3ZhcnNcIlxuaW1wb3J0IHsgVmFyaWFibGUgfSBmcm9tIFwiYXN0YWxcIlxuXG5lbnVtIFJldmVhbGVyQ29tbWFuZCB7XG4gIE9QRU4sXG4gIENMT1NFLFxuICBUT0dHTEVcbn1cblxuZnVuY3Rpb24gaGFuZGxlUmV2ZWFsZXIoY29tbWFuZDogUmV2ZWFsZXJDb21tYW5kLCByZXZlYWxlcjogVmFyaWFibGU8Ym9vbGVhbj4pOiBzdHJpbmcge1xuICBzd2l0Y2ggKGNvbW1hbmQpIHtcbiAgICBjYXNlIFJldmVhbGVyQ29tbWFuZC5UT0dHTEU6XG4gICAgICByZXZlYWxlci5zZXQoIXJldmVhbGVyLmdldCgpKVxuICAgICAgcmV0dXJuIGAke3JldmVhbGVyLmdldCgpfWBcbiAgICBkZWZhdWx0OiByZXR1cm4gJ1Vua25vd24gcmV2ZWFsIGNvbW1hbmQuJ1xuICB9XG59XG5cblxuZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gcmVxdWVzdEhhbmRsZXIocmVxdWVzdDogc3RyaW5nLCByZXM6IChyZXNwb25zZTogYW55KSA9PiB2b2lkKSB7XG4gIGNvbnN0IGFyZ3MgPSByZXF1ZXN0LnNwbGl0KCc6JylcblxuICBzd2l0Y2ggKGFyZ3NbMF0pIHtcbiAgICBjYXNlICdiYXInOlxuICAgICAgc3dpdGNoIChhcmdzWzFdKSB7XG4gICAgICAgIGNhc2UgJ3RvZ2dsZSc6IHJldHVybiByZXMoaGFuZGxlUmV2ZWFsZXIoUmV2ZWFsZXJDb21tYW5kLlRPR0dMRSwgc2hvd0JhcikpXG4gICAgICAgIGRlZmF1bHQ6IHJldHVybiByZXMoJ1Vua25vd24gY29tbWFuZCBmb3IgYmFyLicpXG4gICAgICB9XG4gICAgY2FzZSAnbGVmdHNpZGViYXInOlxuICAgICAgc3dpdGNoIChhcmdzWzFdKSB7XG4gICAgICAgIGNhc2UgJ3RvZ2dsZSc6IHJldHVybiByZXMoaGFuZGxlUmV2ZWFsZXIoUmV2ZWFsZXJDb21tYW5kLlRPR0dMRSwgc2hvd0xlZnRTaWRlYmFyKSlcbiAgICAgICAgZGVmYXVsdDogcmV0dXJuIHJlcygnVW5rbm93biBjb21tYW5kIGZvciBsZWZ0c2lkZWJhci4nKVxuICAgICAgfVxuICAgIGNhc2UgJ3JpZ2h0c2lkZWJhcic6XG4gICAgICBzd2l0Y2ggKGFyZ3NbMV0pIHtcbiAgICAgICAgY2FzZSAndG9nZ2xlJzogcmV0dXJuIHJlcyhoYW5kbGVSZXZlYWxlcihSZXZlYWxlckNvbW1hbmQuVE9HR0xFLCBzaG93UmlnaHRTaWRlYmFyKSlcbiAgICAgICAgZGVmYXVsdDogcmV0dXJuIHJlcygnVW5rbm93biBjb21tYW5kIGZvciByaWdodHNpZGViYXIuJylcbiAgICAgIH1cbiAgICBjYXNlICdsYXVuY2hlcic6XG4gICAgICBzd2l0Y2ggKGFyZ3NbMV0pIHtcbiAgICAgICAgY2FzZSAndG9nZ2xlJzogcmV0dXJuIHJlcyhoYW5kbGVSZXZlYWxlcihSZXZlYWxlckNvbW1hbmQuVE9HR0xFLCBzaG93TGF1bmNoZXIpKVxuICAgICAgICBkZWZhdWx0OiByZXR1cm4gcmVzKCdVbmtub3duIGNvbW1hbmQgZm9yIGxhdW5jaGVyLicpXG4gICAgICB9XG4gICAgY2FzZSAnY3Jvc3NoYWlyJzpcbiAgICAgIHN3aXRjaCAoYXJnc1sxXSkge1xuICAgICAgICBjYXNlICd0b2dnbGUnOiByZXR1cm4gcmVzKGhhbmRsZVJldmVhbGVyKFJldmVhbGVyQ29tbWFuZC5UT0dHTEUsIHNob3dDcm9zc2hhaXIpKVxuICAgICAgICBkZWZhdWx0OiByZXR1cm4gcmVzKCdVbmtub3duIGNvbW1hbmQgZm9yIGNyb3NzaGFpci4nKVxuICAgICAgfVxuICAgIGRlZmF1bHQ6XG4gICAgICByZXR1cm4gcmVzKCdVbmtub3duIHJlcXVlc3QuJylcbiAgfVxufVxuIiwgIiMhL3Vzci9iaW4vZ2pzIC1tXG5pbXBvcnQgeyBjb21waWxlU2NzcyB9IGZyb20gXCJAY29tbW9uL2Nzc0hvdFJlbG9hZFwiXG5pbXBvcnQgeyBkb05vdERpc3R1cmIsIHNob3dCYXIsIHNob3dDcm9zc2hhaXIsIHNob3dMYXVuY2hlciwgc2hvd0xlZnRTaWRlYmFyLCBzaG93UmlnaHRTaWRlYmFyIH0gZnJvbSBcIkBjb21tb24vdmFyc1wiXG5pbXBvcnQgQmFyIGZyb20gXCJAd2luZG93cy9iYXIvQmFyXCJcbmltcG9ydCBDcm9zc2hhaXIgZnJvbSBcIkB3aW5kb3dzL2Nyb3NzaGFpci9Dcm9zc2hhaXJcIlxuaW1wb3J0IExhdW5jaGVyIGZyb20gXCJAd2luZG93cy9sYXVuY2hlci9MYXVuY2hlclwiXG5pbXBvcnQgTGVmdFNpZGViYXIgZnJvbSBcIkB3aW5kb3dzL2xlZnRfc2lkZWJhci9MZWZ0U2lkZWJhclwiXG5pbXBvcnQgTm90aWZpY2F0aW9uUG9wdXBzIGZyb20gXCJAd2luZG93cy9ub3RpZmljYXRpb25fcG9wdXBzL05vdGlmaWNhdGlvblBvcHVwc1wiXG5pbXBvcnQgT1NEIGZyb20gXCJAd2luZG93cy9vc2QvT1NEXCJcbmltcG9ydCBSaWdodFNpZGViYXIgZnJvbSBcIkB3aW5kb3dzL3JpZ2h0X3NpZGViYXIvUmlnaHRTaWRlYmFyXCJcbmltcG9ydCB7IEFwcCwgR2RrIH0gZnJvbSBcImFzdGFsL2d0azNcIlxuaW1wb3J0IHJlcXVlc3RIYW5kbGVyIGZyb20gXCIuL3JlcXVlc3RIYW5kbGVyXCJcblxuZnVuY3Rpb24gZ2V0VGFyZ2V0TW9uaXRvcihtb25pdG9yczogQXJyYXk8R2RrLk1vbml0b3I+KSB7XG4gIGNvbnN0IG5vdGVib29rTW9kZWwgPSBcIjB4OTA1MVwiXG4gIGNvbnN0IHBjTW9kZWwgPSBcIjI0RzJXMUc0XCJcblxuICBjb25zdCBub3RlYm9va01vbml0b3IgPSBtb25pdG9ycy5maW5kKG0gPT4gbS5tb2RlbCA9PT0gbm90ZWJvb2tNb2RlbClcbiAgY29uc3QgcGNNb25pdG9yID0gbW9uaXRvcnMuZmluZChtID0+IG0ubW9kZWwgPT09IHBjTW9kZWwpXG5cbiAgcmV0dXJuIG5vdGVib29rTW9uaXRvciB8fCBwY01vbml0b3IgfHwgbW9uaXRvcnNbMF1cbn1cblxuQXBwLnN0YXJ0KHtcbiAgY3NzOiBjb21waWxlU2NzcygpLFxuICByZXF1ZXN0SGFuZGxlcjogcmVxdWVzdEhhbmRsZXIsXG4gIG1haW4oKSB7XG4gICAgY29uc3QgbW9uaXRvcnMgPSBBcHAuZ2V0X21vbml0b3JzKClcbiAgICBjb25zdCB0YXJnZXRNb25pdG9yID0gZ2V0VGFyZ2V0TW9uaXRvcihtb25pdG9ycylcblxuICAgIEJhcih0YXJnZXRNb25pdG9yLCBzaG93QmFyKVxuICAgIExlZnRTaWRlYmFyKHRhcmdldE1vbml0b3IsIHNob3dMZWZ0U2lkZWJhcilcbiAgICBSaWdodFNpZGViYXIodGFyZ2V0TW9uaXRvciwgc2hvd1JpZ2h0U2lkZWJhcilcbiAgICBDcm9zc2hhaXIodGFyZ2V0TW9uaXRvciwgc2hvd0Nyb3NzaGFpcilcbiAgICBPU0QodGFyZ2V0TW9uaXRvcilcbiAgICBOb3RpZmljYXRpb25Qb3B1cHModGFyZ2V0TW9uaXRvciwgZG9Ob3REaXN0dXJiKVxuICAgIExhdW5jaGVyKHRhcmdldE1vbml0b3IsIHNob3dMYXVuY2hlcilcblxuICAgIHByaW50KGBcXG5Bc3RhbCBXaW5kb3dzIGFwcGxpZWQgb24gbW9uaXRvcjogJHt0YXJnZXRNb25pdG9yLm1vZGVsfWApXG4gIH0sXG59KVxuIl0sCiAgIm1hcHBpbmdzIjogIjs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztBQUFBLE9BQU9BLFlBQVc7QUFDbEIsT0FBT0MsVUFBUztBQUNoQixPQUFPLFNBQVM7OztBQ0ZoQixPQUFPQyxZQUFXOzs7QUNBWCxJQUFNLFdBQVcsQ0FBQyxRQUFnQixJQUNwQyxRQUFRLG1CQUFtQixPQUFPLEVBQ2xDLFdBQVcsS0FBSyxHQUFHLEVBQ25CLFlBQVk7QUFFVixJQUFNLFdBQVcsQ0FBQyxRQUFnQixJQUNwQyxRQUFRLG1CQUFtQixPQUFPLEVBQ2xDLFdBQVcsS0FBSyxHQUFHLEVBQ25CLFlBQVk7QUFjVixJQUFNLFVBQU4sTUFBTSxTQUFlO0FBQUEsRUFDaEIsY0FBYyxDQUFDLE1BQVc7QUFBQSxFQUVsQztBQUFBLEVBQ0E7QUFBQSxFQVNBLE9BQU8sS0FBSyxTQUFxQyxNQUFlO0FBQzVELFdBQU8sSUFBSSxTQUFRLFNBQVMsSUFBSTtBQUFBLEVBQ3BDO0FBQUEsRUFFUSxZQUFZLFNBQTRDLE1BQWU7QUFDM0UsU0FBSyxXQUFXO0FBQ2hCLFNBQUssUUFBUSxRQUFRLFNBQVMsSUFBSTtBQUFBLEVBQ3RDO0FBQUEsRUFFQSxXQUFXO0FBQ1AsV0FBTyxXQUFXLEtBQUssUUFBUSxHQUFHLEtBQUssUUFBUSxNQUFNLEtBQUssS0FBSyxNQUFNLEVBQUU7QUFBQSxFQUMzRTtBQUFBLEVBRUEsR0FBTSxJQUFpQztBQUNuQyxVQUFNQyxRQUFPLElBQUksU0FBUSxLQUFLLFVBQVUsS0FBSyxLQUFLO0FBQ2xELElBQUFBLE1BQUssY0FBYyxDQUFDLE1BQWEsR0FBRyxLQUFLLFlBQVksQ0FBQyxDQUFDO0FBQ3ZELFdBQU9BO0FBQUEsRUFDWDtBQUFBLEVBRUEsTUFBYTtBQUNULFFBQUksT0FBTyxLQUFLLFNBQVMsUUFBUTtBQUM3QixhQUFPLEtBQUssWUFBWSxLQUFLLFNBQVMsSUFBSSxDQUFDO0FBRS9DLFFBQUksT0FBTyxLQUFLLFVBQVUsVUFBVTtBQUNoQyxZQUFNLFNBQVMsT0FBTyxTQUFTLEtBQUssS0FBSyxDQUFDO0FBQzFDLFVBQUksT0FBTyxLQUFLLFNBQVMsTUFBTSxNQUFNO0FBQ2pDLGVBQU8sS0FBSyxZQUFZLEtBQUssU0FBUyxNQUFNLEVBQUUsQ0FBQztBQUVuRCxhQUFPLEtBQUssWUFBWSxLQUFLLFNBQVMsS0FBSyxLQUFLLENBQUM7QUFBQSxJQUNyRDtBQUVBLFVBQU0sTUFBTSw4QkFBOEI7QUFBQSxFQUM5QztBQUFBLEVBRUEsVUFBVSxVQUE4QztBQUNwRCxRQUFJLE9BQU8sS0FBSyxTQUFTLGNBQWMsWUFBWTtBQUMvQyxhQUFPLEtBQUssU0FBUyxVQUFVLE1BQU07QUFDakMsaUJBQVMsS0FBSyxJQUFJLENBQUM7QUFBQSxNQUN2QixDQUFDO0FBQUEsSUFDTCxXQUFXLE9BQU8sS0FBSyxTQUFTLFlBQVksWUFBWTtBQUNwRCxZQUFNLFNBQVMsV0FBVyxLQUFLLEtBQUs7QUFDcEMsWUFBTSxLQUFLLEtBQUssU0FBUyxRQUFRLFFBQVEsTUFBTTtBQUMzQyxpQkFBUyxLQUFLLElBQUksQ0FBQztBQUFBLE1BQ3ZCLENBQUM7QUFDRCxhQUFPLE1BQU07QUFDVCxRQUFDLEtBQUssU0FBUyxXQUF5QyxFQUFFO0FBQUEsTUFDOUQ7QUFBQSxJQUNKO0FBQ0EsVUFBTSxNQUFNLEdBQUcsS0FBSyxRQUFRLGtCQUFrQjtBQUFBLEVBQ2xEO0FBQ0o7QUFFTyxJQUFNLEVBQUUsS0FBSyxJQUFJO0FBQ3hCLElBQU8sa0JBQVE7OztBQ3hGZixPQUFPLFdBQVc7QUFHWCxJQUFNLE9BQU8sTUFBTTtBQUVuQixTQUFTLFNBQVNDLFdBQWtCLFVBQXVCO0FBQzlELFNBQU8sTUFBTSxLQUFLLFNBQVNBLFdBQVUsTUFBTSxLQUFLLFdBQVcsQ0FBQztBQUNoRTtBQUVPLFNBQVMsUUFBUUMsVUFBaUIsVUFBdUI7QUFDNUQsU0FBTyxNQUFNLEtBQUssUUFBUUEsVUFBUyxNQUFNLEtBQUssV0FBVyxDQUFDO0FBQzlEOzs7QUNYQSxPQUFPQyxZQUFXO0FBU1gsSUFBTSxVQUFVQSxPQUFNO0FBVXRCLFNBQVMsV0FDWixXQUNBLFFBQWtDLE9BQ2xDLFFBQWtDLFVBQ3BDO0FBQ0UsUUFBTSxPQUFPLE1BQU0sUUFBUSxTQUFTLEtBQUssT0FBTyxjQUFjO0FBQzlELFFBQU0sRUFBRSxLQUFLLEtBQUssSUFBSSxJQUFJO0FBQUEsSUFDdEIsS0FBSyxPQUFPLFlBQVksVUFBVTtBQUFBLElBQ2xDLEtBQUssT0FBTyxRQUFRLFVBQVUsT0FBTztBQUFBLElBQ3JDLEtBQUssT0FBTyxRQUFRLFVBQVUsT0FBTztBQUFBLEVBQ3pDO0FBRUEsUUFBTSxPQUFPLE1BQU0sUUFBUSxHQUFHLElBQ3hCQSxPQUFNLFFBQVEsWUFBWSxHQUFHLElBQzdCQSxPQUFNLFFBQVEsV0FBVyxHQUFHO0FBRWxDLE9BQUssUUFBUSxVQUFVLENBQUMsR0FBRyxXQUFtQixJQUFJLE1BQU0sQ0FBQztBQUN6RCxPQUFLLFFBQVEsVUFBVSxDQUFDLEdBQUcsV0FBbUIsSUFBSSxNQUFNLENBQUM7QUFDekQsU0FBTztBQUNYO0FBR08sU0FBUyxLQUFLLEtBQXdCO0FBQ3pDLFNBQU8sTUFBTSxRQUFRLEdBQUcsSUFDbEJBLE9BQU0sUUFBUSxNQUFNLEdBQUcsSUFDdkJBLE9BQU0sUUFBUSxLQUFLLEdBQUc7QUFDaEM7QUFFTyxTQUFTLFVBQVUsS0FBeUM7QUFDL0QsU0FBTyxJQUFJLFFBQVEsQ0FBQyxTQUFTLFdBQVc7QUFDcEMsUUFBSSxNQUFNLFFBQVEsR0FBRyxHQUFHO0FBQ3BCLE1BQUFBLE9BQU0sUUFBUSxZQUFZLEtBQUssQ0FBQyxHQUFHLFFBQVE7QUFDdkMsWUFBSTtBQUNBLGtCQUFRQSxPQUFNLFFBQVEsbUJBQW1CLEdBQUcsQ0FBQztBQUFBLFFBQ2pELFNBQVMsT0FBTztBQUNaLGlCQUFPLEtBQUs7QUFBQSxRQUNoQjtBQUFBLE1BQ0osQ0FBQztBQUFBLElBQ0wsT0FBTztBQUNILE1BQUFBLE9BQU0sUUFBUSxXQUFXLEtBQUssQ0FBQyxHQUFHLFFBQVE7QUFDdEMsWUFBSTtBQUNBLGtCQUFRQSxPQUFNLFFBQVEsWUFBWSxHQUFHLENBQUM7QUFBQSxRQUMxQyxTQUFTLE9BQU87QUFDWixpQkFBTyxLQUFLO0FBQUEsUUFDaEI7QUFBQSxNQUNKLENBQUM7QUFBQSxJQUNMO0FBQUEsRUFDSixDQUFDO0FBQ0w7OztBSDlEQSxJQUFNLGtCQUFOLGNBQWlDLFNBQVM7QUFBQSxFQUM5QjtBQUFBLEVBQ0EsYUFBYyxRQUFRO0FBQUEsRUFFdEI7QUFBQSxFQUNBO0FBQUEsRUFDQTtBQUFBLEVBRUEsZUFBZTtBQUFBLEVBQ2Y7QUFBQSxFQUNBO0FBQUEsRUFDQTtBQUFBLEVBRUE7QUFBQSxFQUNBO0FBQUEsRUFFUixZQUFZLE1BQVM7QUFDakIsVUFBTTtBQUNOLFNBQUssU0FBUztBQUNkLFNBQUssV0FBVyxJQUFJQyxPQUFNLGFBQWE7QUFDdkMsU0FBSyxTQUFTLFFBQVEsV0FBVyxNQUFNO0FBQ25DLFdBQUssVUFBVTtBQUNmLFdBQUssU0FBUztBQUFBLElBQ2xCLENBQUM7QUFDRCxTQUFLLFNBQVMsUUFBUSxTQUFTLENBQUMsR0FBRyxRQUFRLEtBQUssYUFBYSxHQUFHLENBQUM7QUFDakUsV0FBTyxJQUFJLE1BQU0sTUFBTTtBQUFBLE1BQ25CLE9BQU8sQ0FBQyxRQUFRLEdBQUcsU0FBUyxPQUFPLE1BQU0sS0FBSyxDQUFDLENBQUM7QUFBQSxJQUNwRCxDQUFDO0FBQUEsRUFDTDtBQUFBLEVBRVEsTUFBYSxXQUF5QztBQUMxRCxVQUFNLElBQUksZ0JBQVEsS0FBSyxJQUFJO0FBQzNCLFdBQU8sWUFBWSxFQUFFLEdBQUcsU0FBUyxJQUFJO0FBQUEsRUFDekM7QUFBQSxFQUVBLFdBQVc7QUFDUCxXQUFPLE9BQU8sWUFBWSxLQUFLLElBQUksQ0FBQyxHQUFHO0FBQUEsRUFDM0M7QUFBQSxFQUVBLE1BQVM7QUFBRSxXQUFPLEtBQUs7QUFBQSxFQUFPO0FBQUEsRUFDOUIsSUFBSSxPQUFVO0FBQ1YsUUFBSSxVQUFVLEtBQUssUUFBUTtBQUN2QixXQUFLLFNBQVM7QUFDZCxXQUFLLFNBQVMsS0FBSyxTQUFTO0FBQUEsSUFDaEM7QUFBQSxFQUNKO0FBQUEsRUFFQSxZQUFZO0FBQ1IsUUFBSSxLQUFLO0FBQ0w7QUFFSixRQUFJLEtBQUssUUFBUTtBQUNiLFdBQUssUUFBUSxTQUFTLEtBQUssY0FBYyxNQUFNO0FBQzNDLGNBQU0sSUFBSSxLQUFLLE9BQVEsS0FBSyxJQUFJLENBQUM7QUFDakMsWUFBSSxhQUFhLFNBQVM7QUFDdEIsWUFBRSxLQUFLLENBQUFDLE9BQUssS0FBSyxJQUFJQSxFQUFDLENBQUMsRUFDbEIsTUFBTSxTQUFPLEtBQUssU0FBUyxLQUFLLFNBQVMsR0FBRyxDQUFDO0FBQUEsUUFDdEQsT0FBTztBQUNILGVBQUssSUFBSSxDQUFDO0FBQUEsUUFDZDtBQUFBLE1BQ0osQ0FBQztBQUFBLElBQ0wsV0FBVyxLQUFLLFVBQVU7QUFDdEIsV0FBSyxRQUFRLFNBQVMsS0FBSyxjQUFjLE1BQU07QUFDM0Msa0JBQVUsS0FBSyxRQUFTLEVBQ25CLEtBQUssT0FBSyxLQUFLLElBQUksS0FBSyxjQUFlLEdBQUcsS0FBSyxJQUFJLENBQUMsQ0FBQyxDQUFDLEVBQ3RELE1BQU0sU0FBTyxLQUFLLFNBQVMsS0FBSyxTQUFTLEdBQUcsQ0FBQztBQUFBLE1BQ3RELENBQUM7QUFBQSxJQUNMO0FBQUEsRUFDSjtBQUFBLEVBRUEsYUFBYTtBQUNULFFBQUksS0FBSztBQUNMO0FBRUosU0FBSyxTQUFTLFdBQVc7QUFBQSxNQUNyQixLQUFLLEtBQUs7QUFBQSxNQUNWLEtBQUssU0FBTyxLQUFLLElBQUksS0FBSyxlQUFnQixLQUFLLEtBQUssSUFBSSxDQUFDLENBQUM7QUFBQSxNQUMxRCxLQUFLLFNBQU8sS0FBSyxTQUFTLEtBQUssU0FBUyxHQUFHO0FBQUEsSUFDL0MsQ0FBQztBQUFBLEVBQ0w7QUFBQSxFQUVBLFdBQVc7QUFDUCxTQUFLLE9BQU8sT0FBTztBQUNuQixXQUFPLEtBQUs7QUFBQSxFQUNoQjtBQUFBLEVBRUEsWUFBWTtBQUNSLFNBQUssUUFBUSxLQUFLO0FBQ2xCLFdBQU8sS0FBSztBQUFBLEVBQ2hCO0FBQUEsRUFFQSxZQUFZO0FBQUUsV0FBTyxDQUFDLENBQUMsS0FBSztBQUFBLEVBQU07QUFBQSxFQUNsQyxhQUFhO0FBQUUsV0FBTyxDQUFDLENBQUMsS0FBSztBQUFBLEVBQU87QUFBQSxFQUVwQyxPQUFPO0FBQ0gsU0FBSyxTQUFTLEtBQUssU0FBUztBQUFBLEVBQ2hDO0FBQUEsRUFFQSxVQUFVLFVBQXNCO0FBQzVCLFNBQUssU0FBUyxRQUFRLFdBQVcsUUFBUTtBQUN6QyxXQUFPO0FBQUEsRUFDWDtBQUFBLEVBRUEsUUFBUSxVQUFpQztBQUNyQyxXQUFPLEtBQUs7QUFDWixTQUFLLFNBQVMsUUFBUSxTQUFTLENBQUMsR0FBRyxRQUFRLFNBQVMsR0FBRyxDQUFDO0FBQ3hELFdBQU87QUFBQSxFQUNYO0FBQUEsRUFFQSxVQUFVLFVBQThCO0FBQ3BDLFVBQU0sS0FBSyxLQUFLLFNBQVMsUUFBUSxXQUFXLE1BQU07QUFDOUMsZUFBUyxLQUFLLElBQUksQ0FBQztBQUFBLElBQ3ZCLENBQUM7QUFDRCxXQUFPLE1BQU0sS0FBSyxTQUFTLFdBQVcsRUFBRTtBQUFBLEVBQzVDO0FBQUEsRUFhQSxLQUNJQyxXQUNBQyxPQUNBLFlBQTRDLFNBQU8sS0FDckQ7QUFDRSxTQUFLLFNBQVM7QUFDZCxTQUFLLGVBQWVEO0FBQ3BCLFNBQUssZ0JBQWdCO0FBQ3JCLFFBQUksT0FBT0MsVUFBUyxZQUFZO0FBQzVCLFdBQUssU0FBU0E7QUFDZCxhQUFPLEtBQUs7QUFBQSxJQUNoQixPQUFPO0FBQ0gsV0FBSyxXQUFXQTtBQUNoQixhQUFPLEtBQUs7QUFBQSxJQUNoQjtBQUNBLFNBQUssVUFBVTtBQUNmLFdBQU87QUFBQSxFQUNYO0FBQUEsRUFFQSxNQUNJQSxPQUNBLFlBQTRDLFNBQU8sS0FDckQ7QUFDRSxTQUFLLFVBQVU7QUFDZixTQUFLLFlBQVlBO0FBQ2pCLFNBQUssaUJBQWlCO0FBQ3RCLFNBQUssV0FBVztBQUNoQixXQUFPO0FBQUEsRUFDWDtBQUFBLEVBYUEsUUFDSSxNQUNBLFNBQ0EsVUFDRjtBQUNFLFVBQU0sSUFBSSxPQUFPLFlBQVksYUFBYSxVQUFVLGFBQWEsTUFBTSxLQUFLLElBQUk7QUFDaEYsVUFBTSxNQUFNLENBQUMsUUFBcUIsU0FBZ0IsS0FBSyxJQUFJLEVBQUUsS0FBSyxHQUFHLElBQUksQ0FBQztBQUUxRSxRQUFJLE1BQU0sUUFBUSxJQUFJLEdBQUc7QUFDckIsaUJBQVcsT0FBTyxNQUFNO0FBQ3BCLGNBQU0sQ0FBQyxHQUFHLENBQUMsSUFBSTtBQUNmLGNBQU0sS0FBSyxFQUFFLFFBQVEsR0FBRyxHQUFHO0FBQzNCLGFBQUssVUFBVSxNQUFNLEVBQUUsV0FBVyxFQUFFLENBQUM7QUFBQSxNQUN6QztBQUFBLElBQ0osT0FBTztBQUNILFVBQUksT0FBTyxZQUFZLFVBQVU7QUFDN0IsY0FBTSxLQUFLLEtBQUssUUFBUSxTQUFTLEdBQUc7QUFDcEMsYUFBSyxVQUFVLE1BQU0sS0FBSyxXQUFXLEVBQUUsQ0FBQztBQUFBLE1BQzVDO0FBQUEsSUFDSjtBQUVBLFdBQU87QUFBQSxFQUNYO0FBQUEsRUFFQSxPQUFPLE9BTUwsTUFBWSxLQUEyQixJQUFJLFNBQVMsTUFBc0I7QUFDeEUsVUFBTSxTQUFTLE1BQU0sR0FBRyxHQUFHLEtBQUssSUFBSSxPQUFLLEVBQUUsSUFBSSxDQUFDLENBQVM7QUFDekQsVUFBTSxVQUFVLElBQUksU0FBUyxPQUFPLENBQUM7QUFDckMsVUFBTSxTQUFTLEtBQUssSUFBSSxTQUFPLElBQUksVUFBVSxNQUFNLFFBQVEsSUFBSSxPQUFPLENBQUMsQ0FBQyxDQUFDO0FBQ3pFLFlBQVEsVUFBVSxNQUFNLE9BQU8sSUFBSSxXQUFTLE1BQU0sQ0FBQyxDQUFDO0FBQ3BELFdBQU87QUFBQSxFQUNYO0FBQ0o7QUFPTyxJQUFNLFdBQVcsSUFBSSxNQUFNLGlCQUF3QjtBQUFBLEVBQ3RELE9BQU8sQ0FBQyxJQUFJLElBQUksU0FBUyxJQUFJLGdCQUFnQixLQUFLLENBQUMsQ0FBQztBQUN4RCxDQUFDO0FBTU0sSUFBTSxFQUFFLE9BQU8sSUFBSTtBQUMxQixJQUFPLG1CQUFROzs7QUk5TlIsSUFBTSxvQkFBb0IsT0FBTyx3QkFBd0I7QUFDekQsSUFBTSxjQUFjLE9BQU8sd0JBQXdCO0FBRW5ELFNBQVMsY0FBYyxPQUFjO0FBQ3hDLFdBQVMsYUFBYSxNQUFhO0FBQy9CLFFBQUksSUFBSTtBQUNSLFdBQU8sTUFBTTtBQUFBLE1BQUksV0FBUyxpQkFBaUIsa0JBQ3JDLEtBQUssR0FBRyxJQUNSO0FBQUEsSUFDTjtBQUFBLEVBQ0o7QUFFQSxRQUFNLFdBQVcsTUFBTSxPQUFPLE9BQUssYUFBYSxlQUFPO0FBRXZELE1BQUksU0FBUyxXQUFXO0FBQ3BCLFdBQU87QUFFWCxNQUFJLFNBQVMsV0FBVztBQUNwQixXQUFPLFNBQVMsQ0FBQyxFQUFFLEdBQUcsU0FBUztBQUVuQyxTQUFPLGlCQUFTLE9BQU8sVUFBVSxTQUFTLEVBQUU7QUFDaEQ7QUFFTyxTQUFTLFFBQVEsS0FBVSxNQUFjLE9BQVk7QUFDeEQsTUFBSTtBQUNBLFVBQU0sU0FBUyxPQUFPLFNBQVMsSUFBSSxDQUFDO0FBQ3BDLFFBQUksT0FBTyxJQUFJLE1BQU0sTUFBTTtBQUN2QixhQUFPLElBQUksTUFBTSxFQUFFLEtBQUs7QUFFNUIsV0FBUSxJQUFJLElBQUksSUFBSTtBQUFBLEVBQ3hCLFNBQVMsT0FBTztBQUNaLFlBQVEsTUFBTSwyQkFBMkIsSUFBSSxRQUFRLEdBQUcsS0FBSyxLQUFLO0FBQUEsRUFDdEU7QUFDSjtBQU1PLFNBQVMsS0FDWixRQUNBLFFBQ0Esa0JBQ0EsVUFDRjtBQUNFLE1BQUksT0FBTyxPQUFPLFlBQVksY0FBYyxVQUFVO0FBQ2xELFVBQU0sS0FBSyxPQUFPLFFBQVEsa0JBQWtCLENBQUMsTUFBVyxTQUFvQjtBQUN4RSxhQUFPLFNBQVMsUUFBUSxHQUFHLElBQUk7QUFBQSxJQUNuQyxDQUFDO0FBQ0QsV0FBTyxRQUFRLFdBQVcsTUFBTTtBQUM1QixNQUFDLE9BQU8sV0FBeUMsRUFBRTtBQUFBLElBQ3ZELENBQUM7QUFBQSxFQUNMLFdBQVcsT0FBTyxPQUFPLGNBQWMsY0FBYyxPQUFPLHFCQUFxQixZQUFZO0FBQ3pGLFVBQU0sUUFBUSxPQUFPLFVBQVUsSUFBSSxTQUFvQjtBQUNuRCx1QkFBaUIsUUFBUSxHQUFHLElBQUk7QUFBQSxJQUNwQyxDQUFDO0FBQ0QsV0FBTyxRQUFRLFdBQVcsS0FBSztBQUFBLEVBQ25DO0FBQ0o7QUFFTyxTQUFTLFVBQXFGLFFBQWdCLFFBQWE7QUFFOUgsTUFBSSxFQUFFLE9BQU8sT0FBTyxXQUFXLENBQUMsR0FBRyxHQUFHLE1BQU0sSUFBSTtBQUVoRCxNQUFJLG9CQUFvQixpQkFBUztBQUM3QixlQUFXLENBQUMsUUFBUTtBQUFBLEVBQ3hCO0FBRUEsTUFBSSxPQUFPO0FBQ1AsYUFBUyxRQUFRLEtBQUs7QUFBQSxFQUMxQjtBQUdBLGFBQVcsQ0FBQyxLQUFLLEtBQUssS0FBSyxPQUFPLFFBQVEsS0FBSyxHQUFHO0FBQzlDLFFBQUksVUFBVSxRQUFXO0FBQ3JCLGFBQU8sTUFBTSxHQUFHO0FBQUEsSUFDcEI7QUFBQSxFQUNKO0FBR0EsUUFBTSxXQUEwQyxPQUMzQyxLQUFLLEtBQUssRUFDVixPQUFPLENBQUMsS0FBVSxTQUFTO0FBQ3hCLFFBQUksTUFBTSxJQUFJLGFBQWEsaUJBQVM7QUFDaEMsWUFBTSxVQUFVLE1BQU0sSUFBSTtBQUMxQixhQUFPLE1BQU0sSUFBSTtBQUNqQixhQUFPLENBQUMsR0FBRyxLQUFLLENBQUMsTUFBTSxPQUFPLENBQUM7QUFBQSxJQUNuQztBQUNBLFdBQU87QUFBQSxFQUNYLEdBQUcsQ0FBQyxDQUFDO0FBR1QsUUFBTSxhQUF3RCxPQUN6RCxLQUFLLEtBQUssRUFDVixPQUFPLENBQUMsS0FBVSxRQUFRO0FBQ3ZCLFFBQUksSUFBSSxXQUFXLElBQUksR0FBRztBQUN0QixZQUFNLE1BQU0sU0FBUyxHQUFHLEVBQUUsTUFBTSxHQUFHLEVBQUUsTUFBTSxDQUFDLEVBQUUsS0FBSyxHQUFHO0FBQ3RELFlBQU0sVUFBVSxNQUFNLEdBQUc7QUFDekIsYUFBTyxNQUFNLEdBQUc7QUFDaEIsYUFBTyxDQUFDLEdBQUcsS0FBSyxDQUFDLEtBQUssT0FBTyxDQUFDO0FBQUEsSUFDbEM7QUFDQSxXQUFPO0FBQUEsRUFDWCxHQUFHLENBQUMsQ0FBQztBQUdULFFBQU0saUJBQWlCLGNBQWMsU0FBUyxLQUFLLFFBQVEsQ0FBQztBQUM1RCxNQUFJLDBCQUEwQixpQkFBUztBQUNuQyxXQUFPLFdBQVcsRUFBRSxlQUFlLElBQUksQ0FBQztBQUN4QyxXQUFPLFFBQVEsV0FBVyxlQUFlLFVBQVUsQ0FBQyxNQUFNO0FBQ3RELGFBQU8sV0FBVyxFQUFFLENBQUM7QUFBQSxJQUN6QixDQUFDLENBQUM7QUFBQSxFQUNOLE9BQU87QUFDSCxRQUFJLGVBQWUsU0FBUyxHQUFHO0FBQzNCLGFBQU8sV0FBVyxFQUFFLGNBQWM7QUFBQSxJQUN0QztBQUFBLEVBQ0o7QUFHQSxhQUFXLENBQUMsUUFBUSxRQUFRLEtBQUssWUFBWTtBQUN6QyxVQUFNLE1BQU0sT0FBTyxXQUFXLFFBQVEsSUFDaEMsT0FBTyxRQUFRLEtBQUssSUFBSSxJQUN4QjtBQUVOLFFBQUksT0FBTyxhQUFhLFlBQVk7QUFDaEMsYUFBTyxRQUFRLEtBQUssUUFBUTtBQUFBLElBQ2hDLE9BQU87QUFDSCxhQUFPLFFBQVEsS0FBSyxNQUFNLFVBQVUsUUFBUSxFQUN2QyxLQUFLLEtBQUssRUFBRSxNQUFNLFFBQVEsS0FBSyxDQUFDO0FBQUEsSUFDekM7QUFBQSxFQUNKO0FBR0EsYUFBVyxDQUFDLE1BQU0sT0FBTyxLQUFLLFVBQVU7QUFDcEMsUUFBSSxTQUFTLFdBQVcsU0FBUyxZQUFZO0FBQ3pDLGFBQU8sUUFBUSxXQUFXLFFBQVEsVUFBVSxDQUFDLE1BQVc7QUFDcEQsZUFBTyxXQUFXLEVBQUUsQ0FBQztBQUFBLE1BQ3pCLENBQUMsQ0FBQztBQUFBLElBQ047QUFDQSxXQUFPLFFBQVEsV0FBVyxRQUFRLFVBQVUsQ0FBQyxNQUFXO0FBQ3BELGNBQVEsUUFBUSxNQUFNLENBQUM7QUFBQSxJQUMzQixDQUFDLENBQUM7QUFDRixZQUFRLFFBQVEsTUFBTSxRQUFRLElBQUksQ0FBQztBQUFBLEVBQ3ZDO0FBR0EsYUFBVyxDQUFDLEtBQUssS0FBSyxLQUFLLE9BQU8sUUFBUSxLQUFLLEdBQUc7QUFDOUMsUUFBSSxVQUFVLFFBQVc7QUFDckIsYUFBTyxNQUFNLEdBQUc7QUFBQSxJQUNwQjtBQUFBLEVBQ0o7QUFFQSxTQUFPLE9BQU8sUUFBUSxLQUFLO0FBQzNCLFVBQVEsTUFBTTtBQUNkLFNBQU87QUFDWDtBQUVBLFNBQVMsZ0JBQWdCLE1BQXVDO0FBQzVELFNBQU8sQ0FBQyxPQUFPLE9BQU8sTUFBTSxXQUFXO0FBQzNDO0FBRU8sU0FBUyxJQUNaQyxRQUNBLE1BQ0EsRUFBRSxVQUFVLEdBQUcsTUFBTSxHQUN2QjtBQUNFLGVBQWEsQ0FBQztBQUVkLE1BQUksQ0FBQyxNQUFNLFFBQVEsUUFBUTtBQUN2QixlQUFXLENBQUMsUUFBUTtBQUV4QixhQUFXLFNBQVMsT0FBTyxPQUFPO0FBRWxDLE1BQUksU0FBUyxXQUFXO0FBQ3BCLFVBQU0sUUFBUSxTQUFTLENBQUM7QUFBQSxXQUNuQixTQUFTLFNBQVM7QUFDdkIsVUFBTSxXQUFXO0FBRXJCLE1BQUksT0FBTyxTQUFTLFVBQVU7QUFDMUIsUUFBSSxnQkFBZ0JBLE9BQU0sSUFBSSxDQUFDO0FBQzNCLGFBQU9BLE9BQU0sSUFBSSxFQUFFLEtBQUs7QUFFNUIsV0FBTyxJQUFJQSxPQUFNLElBQUksRUFBRSxLQUFLO0FBQUEsRUFDaEM7QUFFQSxNQUFJLGdCQUFnQixJQUFJO0FBQ3BCLFdBQU8sS0FBSyxLQUFLO0FBRXJCLFNBQU8sSUFBSSxLQUFLLEtBQUs7QUFDekI7OztBQy9MQSxPQUFPQyxZQUFXO0FBQ2xCLE9BQU8sU0FBUztBQUVoQixPQUFPLGFBQWE7QUFNTCxTQUFSLFNBRUwsS0FBUSxVQUFVLElBQUksTUFBTTtBQUFBLEVBQzFCLE1BQU0sZUFBZSxJQUFJO0FBQUEsSUFDckIsSUFBSSxNQUFjO0FBQUUsYUFBT0MsT0FBTSxlQUFlLElBQUk7QUFBQSxJQUFFO0FBQUEsSUFDdEQsSUFBSSxJQUFJLEtBQWE7QUFBRSxNQUFBQSxPQUFNLGVBQWUsTUFBTSxHQUFHO0FBQUEsSUFBRTtBQUFBLElBQ3ZELFVBQWtCO0FBQUUsYUFBTyxLQUFLO0FBQUEsSUFBSTtBQUFBLElBQ3BDLFFBQVEsS0FBYTtBQUFFLFdBQUssTUFBTTtBQUFBLElBQUk7QUFBQSxJQUV0QyxJQUFJLFlBQW9CO0FBQUUsYUFBT0EsT0FBTSx1QkFBdUIsSUFBSSxFQUFFLEtBQUssR0FBRztBQUFBLElBQUU7QUFBQSxJQUM5RSxJQUFJLFVBQVUsV0FBbUI7QUFBRSxNQUFBQSxPQUFNLHVCQUF1QixNQUFNLFVBQVUsTUFBTSxLQUFLLENBQUM7QUFBQSxJQUFFO0FBQUEsSUFDOUYsaUJBQXlCO0FBQUUsYUFBTyxLQUFLO0FBQUEsSUFBVTtBQUFBLElBQ2pELGVBQWUsV0FBbUI7QUFBRSxXQUFLLFlBQVk7QUFBQSxJQUFVO0FBQUEsSUFFL0QsSUFBSSxTQUFpQjtBQUFFLGFBQU9BLE9BQU0sa0JBQWtCLElBQUk7QUFBQSxJQUFZO0FBQUEsSUFDdEUsSUFBSSxPQUFPLFFBQWdCO0FBQUUsTUFBQUEsT0FBTSxrQkFBa0IsTUFBTSxNQUFNO0FBQUEsSUFBRTtBQUFBLElBQ25FLGFBQXFCO0FBQUUsYUFBTyxLQUFLO0FBQUEsSUFBTztBQUFBLElBQzFDLFdBQVcsUUFBZ0I7QUFBRSxXQUFLLFNBQVM7QUFBQSxJQUFPO0FBQUEsSUFFbEQsSUFBSSxlQUF3QjtBQUFFLGFBQU9BLE9BQU0seUJBQXlCLElBQUk7QUFBQSxJQUFFO0FBQUEsSUFDMUUsSUFBSSxhQUFhLGNBQXVCO0FBQUUsTUFBQUEsT0FBTSx5QkFBeUIsTUFBTSxZQUFZO0FBQUEsSUFBRTtBQUFBLElBQzdGLG9CQUE2QjtBQUFFLGFBQU8sS0FBSztBQUFBLElBQWE7QUFBQSxJQUN4RCxrQkFBa0IsY0FBdUI7QUFBRSxXQUFLLGVBQWU7QUFBQSxJQUFhO0FBQUEsSUFHNUUsSUFBSSxvQkFBNkI7QUFBRSxhQUFPLEtBQUssaUJBQWlCO0FBQUEsSUFBRTtBQUFBLElBQ2xFLElBQUksa0JBQWtCLE9BQWdCO0FBQUUsV0FBSyxpQkFBaUIsSUFBSTtBQUFBLElBQU07QUFBQSxJQUV4RSxJQUFJLFlBQVksQ0FBQyxRQUFRLEtBQUssR0FBZ0I7QUFBRSxXQUFLLG9CQUFvQixRQUFRLEtBQUs7QUFBQSxJQUFFO0FBQUEsSUFDeEYsaUJBQWlCLGFBQTBCO0FBQUUsV0FBSyxjQUFjO0FBQUEsSUFBWTtBQUFBLElBRWxFLGNBQWlDO0FBQ3ZDLFVBQUksZ0JBQWdCLElBQUksS0FBSztBQUN6QixlQUFPLEtBQUssVUFBVSxJQUFJLENBQUMsS0FBSyxVQUFVLENBQUUsSUFBSSxDQUFDO0FBQUEsTUFDckQsV0FBVyxnQkFBZ0IsSUFBSSxXQUFXO0FBQ3RDLGVBQU8sS0FBSyxhQUFhO0FBQUEsTUFDN0I7QUFDQSxhQUFPLENBQUM7QUFBQSxJQUNaO0FBQUEsSUFFVSxZQUFZLFVBQWlCO0FBQ25DLGlCQUFXLFNBQVMsS0FBSyxRQUFRLEVBQUUsSUFBSSxRQUFNLGNBQWMsSUFBSSxTQUN6RCxLQUNBLElBQUksSUFBSSxNQUFNLEVBQUUsU0FBUyxNQUFNLE9BQU8sT0FBTyxFQUFFLEVBQUUsQ0FBQyxDQUFDO0FBRXpELFVBQUksZ0JBQWdCLElBQUksV0FBVztBQUMvQixtQkFBVyxNQUFNO0FBQ2IsZUFBSyxJQUFJLEVBQUU7QUFBQSxNQUNuQixPQUFPO0FBQ0gsY0FBTSxNQUFNLDJCQUEyQixLQUFLLFlBQVksSUFBSSxFQUFFO0FBQUEsTUFDbEU7QUFBQSxJQUNKO0FBQUEsSUFFQSxDQUFDLFdBQVcsRUFBRSxVQUFpQjtBQUUzQixVQUFJLGdCQUFnQixJQUFJLFdBQVc7QUFDL0IsbUJBQVcsTUFBTSxLQUFLLFlBQVksR0FBRztBQUNqQyxlQUFLLE9BQU8sRUFBRTtBQUNkLGNBQUksQ0FBQyxTQUFTLFNBQVMsRUFBRSxLQUFLLENBQUMsS0FBSztBQUNoQyxnQkFBSSxRQUFRO0FBQUEsUUFDcEI7QUFBQSxNQUNKO0FBR0EsV0FBSyxZQUFZLFFBQVE7QUFBQSxJQUM3QjtBQUFBLElBRUEsZ0JBQWdCLElBQVksT0FBTyxNQUFNO0FBQ3JDLE1BQUFBLE9BQU0seUJBQXlCLE1BQU0sSUFBSSxJQUFJO0FBQUEsSUFDakQ7QUFBQSxJQVdBLEtBQ0ksUUFDQSxrQkFDQSxVQUNGO0FBQ0UsV0FBSyxNQUFNLFFBQVEsa0JBQWtCLFFBQVE7QUFDN0MsYUFBTztBQUFBLElBQ1g7QUFBQSxJQUVBLGVBQWUsUUFBZTtBQUMxQixZQUFNO0FBQ04sWUFBTSxRQUFRLE9BQU8sQ0FBQyxLQUFLLENBQUM7QUFDNUIsWUFBTSxZQUFZO0FBQ2xCLGdCQUFVLE1BQU0sS0FBSztBQUFBLElBQ3pCO0FBQUEsRUFDSjtBQUVBLFVBQVEsY0FBYztBQUFBLElBQ2xCLFdBQVcsU0FBUyxPQUFPO0FBQUEsSUFDM0IsWUFBWTtBQUFBLE1BQ1IsY0FBYyxRQUFRLFVBQVU7QUFBQSxRQUM1QjtBQUFBLFFBQWM7QUFBQSxRQUFJO0FBQUEsUUFBSSxRQUFRLFdBQVc7QUFBQSxRQUFXO0FBQUEsTUFDeEQ7QUFBQSxNQUNBLE9BQU8sUUFBUSxVQUFVO0FBQUEsUUFDckI7QUFBQSxRQUFPO0FBQUEsUUFBSTtBQUFBLFFBQUksUUFBUSxXQUFXO0FBQUEsUUFBVztBQUFBLE1BQ2pEO0FBQUEsTUFDQSxVQUFVLFFBQVEsVUFBVTtBQUFBLFFBQ3hCO0FBQUEsUUFBVTtBQUFBLFFBQUk7QUFBQSxRQUFJLFFBQVEsV0FBVztBQUFBLFFBQVc7QUFBQSxNQUNwRDtBQUFBLE1BQ0EsaUJBQWlCLFFBQVEsVUFBVTtBQUFBLFFBQy9CO0FBQUEsUUFBaUI7QUFBQSxRQUFJO0FBQUEsUUFBSSxRQUFRLFdBQVc7QUFBQSxRQUFXO0FBQUEsTUFDM0Q7QUFBQSxNQUNBLHVCQUF1QixRQUFRLFVBQVU7QUFBQSxRQUNyQztBQUFBLFFBQXVCO0FBQUEsUUFBSTtBQUFBLFFBQUksUUFBUSxXQUFXO0FBQUEsUUFBVztBQUFBLE1BQ2pFO0FBQUEsSUFDSjtBQUFBLEVBQ0osR0FBRyxNQUFNO0FBRVQsU0FBTztBQUNYOzs7QUNqSUEsT0FBT0MsVUFBUztBQUNoQixPQUFPQyxZQUFXOzs7QUNLbEIsSUFBTUMsWUFBVyxDQUFDLFFBQWdCLElBQzdCLFFBQVEsbUJBQW1CLE9BQU8sRUFDbEMsV0FBVyxLQUFLLEdBQUcsRUFDbkIsWUFBWTtBQUVqQixlQUFlLFNBQVksS0FBOEJDLFFBQXVCO0FBQzVFLFNBQU8sSUFBSSxLQUFLLE9BQUtBLE9BQU0sRUFBRSxPQUFPLENBQUMsRUFBRSxNQUFNLE1BQU0sTUFBTTtBQUM3RDtBQUVBLFNBQVMsTUFBd0IsT0FBVSxNQUFnQztBQUN2RSxTQUFPLGVBQWUsT0FBTyxNQUFNO0FBQUEsSUFDL0IsTUFBTTtBQUFFLGFBQU8sS0FBSyxPQUFPRCxVQUFTLElBQUksQ0FBQyxFQUFFLEVBQUU7QUFBQSxJQUFFO0FBQUEsRUFDbkQsQ0FBQztBQUNMO0FBRUEsTUFBTSxTQUFTLE9BQU8sZ0JBQWdCLEdBQUcsQ0FBQyxFQUFFLE1BQUFFLE9BQU0sWUFBWSxNQUFNO0FBQ2hFLFFBQU1BLE1BQUssV0FBVyxNQUFNO0FBQzVCLFFBQU0sWUFBWSxXQUFXLFVBQVU7QUFDdkMsUUFBTSxZQUFZLFdBQVcsWUFBWTtBQUM3QyxDQUFDO0FBRUQsTUFBTSxTQUFTLE9BQU8sbUJBQW1CLEdBQUcsQ0FBQyxFQUFFLE9BQU8sTUFBTTtBQUN4RCxRQUFNLE9BQU8sV0FBVyxTQUFTO0FBQ3JDLENBQUM7QUFFRCxNQUFNLFNBQVMsT0FBTyxxQkFBcUIsR0FBRyxDQUFDLEVBQUUsU0FBUyxXQUFBQyxZQUFXLE9BQU8sTUFBTTtBQUM5RSxRQUFNLFFBQVEsV0FBVyxPQUFPO0FBQ2hDLFFBQU1BLFdBQVUsV0FBVyxVQUFVO0FBQ3JDLFFBQU1BLFdBQVUsV0FBVyxTQUFTO0FBQ3BDLFFBQU0sT0FBTyxXQUFXLE9BQU87QUFDbkMsQ0FBQztBQUVELE1BQU0sU0FBUyxPQUFPLG9CQUFvQixHQUFHLENBQUMsRUFBRSxVQUFBQyxXQUFVLFNBQVMsVUFBVSxNQUFNO0FBQy9FLFFBQU1BLFVBQVMsV0FBVyxPQUFPO0FBQ2pDLFFBQU1BLFVBQVMsV0FBVyxVQUFVO0FBQ3BDLFFBQU1BLFVBQVMsV0FBVyxZQUFZO0FBQ3RDLFFBQU1BLFVBQVMsV0FBVyxTQUFTO0FBQ25DLFFBQU0sUUFBUSxXQUFXLGdCQUFnQjtBQUN6QyxRQUFNLFFBQVEsV0FBVyxpQkFBaUI7QUFDMUMsUUFBTSxVQUFVLFdBQVcsU0FBUztBQUN4QyxDQUFDO0FBRUQsTUFBTSxTQUFTLE9BQU8saUJBQWlCLEdBQUcsQ0FBQyxFQUFFLE9BQUFDLFFBQU8sT0FBTyxNQUFNO0FBQzdELFFBQU1BLE9BQU0sV0FBVyxTQUFTO0FBQ2hDLFFBQU0sT0FBTyxXQUFXLHVCQUF1QjtBQUMvQyxRQUFNLE9BQU8sV0FBVyxxQkFBcUI7QUFDN0MsUUFBTSxPQUFPLFdBQVcsc0JBQXNCO0FBQzlDLFFBQU0sT0FBTyxXQUFXLG9CQUFvQjtBQUM1QyxRQUFNLE9BQU8sV0FBVyxVQUFVO0FBQ3RDLENBQUM7QUFFRCxNQUFNLFNBQVMsT0FBTyxtQkFBbUIsR0FBRyxDQUFDLEVBQUUsS0FBSyxNQUFNO0FBQ3RELFFBQU0sS0FBSyxXQUFXLGVBQWU7QUFDckMsUUFBTSxLQUFLLFdBQVcsY0FBYztBQUN4QyxDQUFDO0FBRUQsTUFBTSxTQUFTLE9BQU8sa0JBQWtCLEdBQUcsQ0FBQyxFQUFFLFFBQUFDLFNBQVEsY0FBQUMsY0FBYSxNQUFNO0FBQ3JFLFFBQU1ELFFBQU8sV0FBVyxlQUFlO0FBQ3ZDLFFBQU1DLGNBQWEsV0FBVyxTQUFTO0FBQzNDLENBQUM7QUFFRCxNQUFNLFNBQVMsT0FBTyx5QkFBeUIsR0FBRyxDQUFDLEVBQUUsY0FBYyxNQUFNO0FBQ3JFLFFBQU0sY0FBYyxXQUFXLFNBQVM7QUFDNUMsQ0FBQztBQUVELE1BQU0sU0FBUyxPQUFPLGNBQWMsR0FBRyxDQUFDLEVBQUUsSUFBQUMsS0FBSSxPQUFPLE1BQU0sTUFBTTtBQUM3RCxRQUFNQSxJQUFHLFdBQVcsV0FBVztBQUMvQixRQUFNQSxJQUFHLFdBQVcsU0FBUztBQUM3QixRQUFNLE1BQU0sV0FBVyxTQUFTO0FBQ2hDLFFBQU0sTUFBTSxXQUFXLFdBQVc7QUFDbEMsUUFBTSxNQUFNLFdBQVcsYUFBYTtBQUNwQyxRQUFNLE1BQU0sV0FBVyxVQUFVO0FBQ2pDLFFBQU0sTUFBTSxXQUFXLFNBQVM7QUFDaEMsUUFBTSxNQUFNLFdBQVcsU0FBUztBQUNoQyxRQUFNLE1BQU0sV0FBVyxXQUFXO0FBQ2xDLFFBQU0sTUFBTSxXQUFXLE9BQU87QUFDOUIsUUFBTSxNQUFNLFdBQVcsU0FBUztBQUNoQyxRQUFNLE1BQU0sV0FBVyxTQUFTO0FBQ3BDLENBQUM7OztBQ25GRCxTQUFTLDJCQUEyQjtBQUNwQyxTQUFTLE1BQU0sbUJBQW1CO0FBQ2xDLE9BQU8sUUFBUTtBQUNmLE9BQU9DLGNBQWE7QUF3Q2IsU0FBUyxNQUFNLEtBQWtCO0FBQ3BDLFNBQU8sSUFBSyxNQUFNLGdCQUFnQixJQUFJO0FBQUEsSUFDbEMsT0FBTztBQUFFLE1BQUFBLFNBQVEsY0FBYyxFQUFFLFdBQVcsVUFBVSxHQUFHLElBQVc7QUFBQSxJQUFFO0FBQUEsSUFFdEUsS0FBSyxNQUE0QjtBQUM3QixhQUFPLElBQUksUUFBUSxDQUFDLEtBQUssUUFBUTtBQUM3QixZQUFJO0FBQ0EsZ0JBQU0sS0FBSyxTQUFTO0FBQUEsMEJBQ2QsS0FBSyxTQUFTLEdBQUcsSUFBSSxPQUFPLFVBQVUsSUFBSSxHQUFHO0FBQUEsdUJBQ2hEO0FBQ0gsYUFBRyxFQUFFLEVBQUUsS0FBSyxHQUFHLEVBQUUsTUFBTSxHQUFHO0FBQUEsUUFDOUIsU0FBUyxPQUFPO0FBQ1osY0FBSSxLQUFLO0FBQUEsUUFDYjtBQUFBLE1BQ0osQ0FBQztBQUFBLElBQ0w7QUFBQSxJQUVBO0FBQUEsSUFFQSxjQUFjLEtBQWEsTUFBa0M7QUFDekQsVUFBSSxPQUFPLEtBQUssbUJBQW1CLFlBQVk7QUFDM0MsYUFBSyxlQUFlLEtBQUssQ0FBQyxhQUFhO0FBQ25DLGFBQUc7QUFBQSxZQUFXO0FBQUEsWUFBTSxPQUFPLFFBQVE7QUFBQSxZQUFHLENBQUMsR0FBRyxRQUN0QyxHQUFHLGtCQUFrQixHQUFHO0FBQUEsVUFDNUI7QUFBQSxRQUNKLENBQUM7QUFBQSxNQUNMLE9BQU87QUFDSCxjQUFNLGNBQWMsS0FBSyxJQUFJO0FBQUEsTUFDakM7QUFBQSxJQUNKO0FBQUEsSUFFQSxVQUFVLE9BQWUsUUFBUSxPQUFPO0FBQ3BDLFlBQU0sVUFBVSxPQUFPLEtBQUs7QUFBQSxJQUNoQztBQUFBLElBRUEsS0FBSyxNQUFxQjtBQUN0QixZQUFNLEtBQUs7QUFDWCxXQUFLLFFBQVEsQ0FBQztBQUFBLElBQ2xCO0FBQUEsSUFFQSxNQUFNLEVBQUUsZ0JBQUFDLGlCQUFnQixLQUFLLE1BQU0sTUFBTSxRQUFRLE9BQU8sR0FBRyxJQUFJLElBQVksQ0FBQyxHQUFHO0FBQzNFLFlBQU0sTUFBTTtBQUVaLGlCQUFXLE1BQU07QUFDYixjQUFNLG1CQUFtQixJQUFJLFlBQVksbUJBQW1CO0FBQzVELGFBQUssQ0FBQztBQUFBLE1BQ1Y7QUFFQSxhQUFPLE9BQU8sTUFBTSxHQUFHO0FBQ3ZCLDBCQUFvQixJQUFJLFlBQVk7QUFFcEMsV0FBSyxpQkFBaUJBO0FBQ3RCLFVBQUksUUFBUSxZQUFZLE1BQU07QUFDMUIsZUFBTyxHQUFHLFdBQVc7QUFBQSxNQUN6QixDQUFDO0FBRUQsVUFBSTtBQUNBLFlBQUksZUFBZTtBQUFBLE1BQ3ZCLFNBQVMsT0FBTztBQUNaLGVBQU8sT0FBTyxTQUFPLEdBQUcsYUFBYSxJQUFJLGNBQWMsR0FBRyxHQUFJLEdBQUcsV0FBVztBQUFBLE1BQ2hGO0FBRUEsVUFBSTtBQUNBLGFBQUssVUFBVSxLQUFLLEtBQUs7QUFFN0IsVUFBSTtBQUNBLFlBQUksVUFBVSxLQUFLO0FBRXZCLGVBQVM7QUFDVCxVQUFJO0FBQ0EsWUFBSSxLQUFLO0FBRWIsVUFBSSxTQUFTLENBQUMsQ0FBQztBQUFBLElBQ25CO0FBQUEsRUFDSjtBQUNKOzs7QUZuSEFDLEtBQUksS0FBSyxJQUFJO0FBRWIsSUFBTyxjQUFRLE1BQU1DLE9BQU0sV0FBVzs7O0FHTHRDLE9BQU9DLFlBQVc7QUFDbEIsT0FBT0MsVUFBUztBQUNoQixPQUFPQyxjQUFhO0FBR3BCLFNBQVMsT0FBTyxVQUFpQjtBQUM3QixTQUFPLFNBQVMsS0FBSyxRQUFRLEVBQUUsSUFBSSxRQUFNLGNBQWNDLEtBQUksU0FDckQsS0FDQSxJQUFJQSxLQUFJLE1BQU0sRUFBRSxTQUFTLE1BQU0sT0FBTyxPQUFPLEVBQUUsRUFBRSxDQUFDLENBQUM7QUFDN0Q7QUFHQSxPQUFPLGVBQWVDLE9BQU0sSUFBSSxXQUFXLFlBQVk7QUFBQSxFQUNuRCxNQUFNO0FBQUUsV0FBTyxLQUFLLGFBQWE7QUFBQSxFQUFFO0FBQUEsRUFDbkMsSUFBSSxHQUFHO0FBQUUsU0FBSyxhQUFhLENBQUM7QUFBQSxFQUFFO0FBQ2xDLENBQUM7QUFHTSxJQUFNLE1BQU4sY0FBa0IsU0FBU0EsT0FBTSxHQUFHLEVBQUU7QUFBQSxFQUN6QyxPQUFPO0FBQUUsSUFBQUMsU0FBUSxjQUFjLEVBQUUsV0FBVyxNQUFNLEdBQUcsSUFBSTtBQUFBLEVBQUU7QUFBQSxFQUMzRCxZQUFZLFVBQXFCLFVBQWdDO0FBQUUsVUFBTSxFQUFFLFVBQVUsR0FBRyxNQUFNLENBQVE7QUFBQSxFQUFFO0FBQUEsRUFDOUYsWUFBWSxVQUF1QjtBQUFFLFNBQUssYUFBYSxPQUFPLFFBQVEsQ0FBQztBQUFBLEVBQUU7QUFDdkY7QUFXTyxJQUFNLFNBQU4sY0FBcUIsU0FBU0QsT0FBTSxNQUFNLEVBQUU7QUFBQSxFQUMvQyxPQUFPO0FBQUUsSUFBQUMsU0FBUSxjQUFjLEVBQUUsV0FBVyxTQUFTLEdBQUcsSUFBSTtBQUFBLEVBQUU7QUFBQSxFQUM5RCxZQUFZLE9BQXFCLE9BQXVCO0FBQUUsVUFBTSxFQUFFLE9BQU8sR0FBRyxNQUFNLENBQVE7QUFBQSxFQUFFO0FBQ2hHO0FBSU8sSUFBTSxZQUFOLGNBQXdCLFNBQVNELE9BQU0sU0FBUyxFQUFFO0FBQUEsRUFDckQsT0FBTztBQUFFLElBQUFDLFNBQVEsY0FBYyxFQUFFLFdBQVcsWUFBWSxHQUFHLElBQUk7QUFBQSxFQUFFO0FBQUEsRUFDakUsWUFBWSxVQUEyQixVQUFnQztBQUFFLFVBQU0sRUFBRSxVQUFVLEdBQUcsTUFBTSxDQUFRO0FBQUEsRUFBRTtBQUFBLEVBQ3BHLFlBQVksVUFBdUI7QUFDekMsVUFBTSxLQUFLLE9BQU8sUUFBUTtBQUMxQixTQUFLLGNBQWMsR0FBRyxDQUFDLEtBQUssSUFBSUYsS0FBSTtBQUNwQyxTQUFLLGVBQWUsR0FBRyxDQUFDLEtBQUssSUFBSUEsS0FBSTtBQUNyQyxTQUFLLFlBQVksR0FBRyxDQUFDLEtBQUssSUFBSUEsS0FBSTtBQUFBLEVBQ3RDO0FBQ0o7QUFJTyxJQUFNLG1CQUFOLGNBQStCLFNBQVNDLE9BQU0sZ0JBQWdCLEVBQUU7QUFBQSxFQUNuRSxPQUFPO0FBQUUsSUFBQUMsU0FBUSxjQUFjLEVBQUUsV0FBVyxtQkFBbUIsR0FBRyxJQUFJO0FBQUEsRUFBRTtBQUFBLEVBQ3hFLFlBQVksT0FBK0IsT0FBdUI7QUFBRSxVQUFNLEVBQUUsT0FBTyxHQUFHLE1BQU0sQ0FBUTtBQUFBLEVBQUU7QUFDMUc7QUFNTyxJQUFNLGNBQU4sY0FBMEIsU0FBU0YsS0FBSSxXQUFXLEVBQUU7QUFBQSxFQUN2RCxPQUFPO0FBQUUsSUFBQUUsU0FBUSxjQUFjLEVBQUUsV0FBVyxjQUFjLEdBQUcsSUFBSTtBQUFBLEVBQUU7QUFBQSxFQUNuRSxZQUFZLE9BQTBCO0FBQUUsVUFBTSxLQUFZO0FBQUEsRUFBRTtBQUNoRTtBQU9PLElBQU0sUUFBTixjQUFvQixTQUFTRixLQUFJLEtBQUssRUFBRTtBQUFBLEVBQzNDLE9BQU87QUFBRSxJQUFBRSxTQUFRLGNBQWMsRUFBRSxXQUFXLFFBQVEsR0FBRyxJQUFJO0FBQUEsRUFBRTtBQUFBLEVBQzdELFlBQVksT0FBb0I7QUFBRSxVQUFNLEtBQVk7QUFBQSxFQUFFO0FBQzFEO0FBVU8sSUFBTSxXQUFOLGNBQXVCLFNBQVNELE9BQU0sUUFBUSxFQUFFO0FBQUEsRUFDbkQsT0FBTztBQUFFLElBQUFDLFNBQVEsY0FBYyxFQUFFLFdBQVcsV0FBVyxHQUFHLElBQUk7QUFBQSxFQUFFO0FBQUEsRUFDaEUsWUFBWSxPQUF1QixPQUF1QjtBQUFFLFVBQU0sRUFBRSxPQUFPLEdBQUcsTUFBTSxDQUFRO0FBQUEsRUFBRTtBQUNsRztBQU9PLElBQU0sT0FBTixjQUFtQixTQUFTRCxPQUFNLElBQUksRUFBRTtBQUFBLEVBQzNDLE9BQU87QUFBRSxJQUFBQyxTQUFRLGNBQWMsRUFBRSxXQUFXLE9BQU8sR0FBRyxJQUFJO0FBQUEsRUFBRTtBQUFBLEVBQzVELFlBQVksT0FBbUI7QUFBRSxVQUFNLEtBQVk7QUFBQSxFQUFFO0FBQ3pEO0FBSU8sSUFBTSxRQUFOLGNBQW9CLFNBQVNELE9BQU0sS0FBSyxFQUFFO0FBQUEsRUFDN0MsT0FBTztBQUFFLElBQUFDLFNBQVEsY0FBYyxFQUFFLFdBQVcsUUFBUSxHQUFHLElBQUk7QUFBQSxFQUFFO0FBQUEsRUFDN0QsWUFBWSxPQUFvQjtBQUFFLFVBQU0sS0FBWTtBQUFBLEVBQUU7QUFBQSxFQUM1QyxZQUFZLFVBQXVCO0FBQUUsU0FBSyxRQUFRLE9BQU8sUUFBUTtBQUFBLEVBQUU7QUFDakY7QUFJTyxJQUFNLFdBQU4sY0FBdUIsU0FBU0QsT0FBTSxRQUFRLEVBQUU7QUFBQSxFQUNuRCxPQUFPO0FBQUUsSUFBQUMsU0FBUSxjQUFjLEVBQUUsV0FBVyxXQUFXLEdBQUcsSUFBSTtBQUFBLEVBQUU7QUFBQSxFQUNoRSxZQUFZLE9BQXVCO0FBQUUsVUFBTSxLQUFZO0FBQUEsRUFBRTtBQUM3RDtBQU1PLElBQU0sYUFBTixjQUF5QixTQUFTRixLQUFJLFVBQVUsRUFBRTtBQUFBLEVBQ3JELE9BQU87QUFBRSxJQUFBRSxTQUFRLGNBQWMsRUFBRSxXQUFXLGFBQWEsR0FBRyxJQUFJO0FBQUEsRUFBRTtBQUFBLEVBQ2xFLFlBQVksT0FBeUIsT0FBdUI7QUFBRSxVQUFNLEVBQUUsT0FBTyxHQUFHLE1BQU0sQ0FBUTtBQUFBLEVBQUU7QUFDcEc7QUFHQSxPQUFPLGVBQWVELE9BQU0sUUFBUSxXQUFXLFlBQVk7QUFBQSxFQUN2RCxNQUFNO0FBQUUsV0FBTyxLQUFLLGFBQWE7QUFBQSxFQUFFO0FBQUEsRUFDbkMsSUFBSSxHQUFHO0FBQUUsU0FBSyxhQUFhLENBQUM7QUFBQSxFQUFFO0FBQ2xDLENBQUM7QUFHTSxJQUFNLFVBQU4sY0FBc0IsU0FBU0EsT0FBTSxPQUFPLEVBQUU7QUFBQSxFQUNqRCxPQUFPO0FBQUUsSUFBQUMsU0FBUSxjQUFjLEVBQUUsV0FBVyxVQUFVLEdBQUcsSUFBSTtBQUFBLEVBQUU7QUFBQSxFQUMvRCxZQUFZLFVBQXlCLFVBQWdDO0FBQUUsVUFBTSxFQUFFLFVBQVUsR0FBRyxNQUFNLENBQVE7QUFBQSxFQUFFO0FBQUEsRUFDbEcsWUFBWSxVQUF1QjtBQUN6QyxVQUFNLENBQUMsT0FBTyxHQUFHLFFBQVEsSUFBSSxPQUFPLFFBQVE7QUFDNUMsU0FBSyxVQUFVLEtBQUs7QUFDcEIsU0FBSyxhQUFhLFFBQVE7QUFBQSxFQUM5QjtBQUNKO0FBSU8sSUFBTSxXQUFOLGNBQXVCLFNBQVNGLEtBQUksUUFBUSxFQUFFO0FBQUEsRUFDakQsT0FBTztBQUFFLElBQUFFLFNBQVEsY0FBYyxFQUFFLFdBQVcsV0FBVyxHQUFHLElBQUk7QUFBQSxFQUFFO0FBQUEsRUFDaEUsWUFBWSxPQUF1QixPQUF1QjtBQUFFLFVBQU0sRUFBRSxPQUFPLEdBQUcsTUFBTSxDQUFRO0FBQUEsRUFBRTtBQUNsRztBQUlPLElBQU0sYUFBTixjQUF5QixTQUFTRCxPQUFNLFVBQVUsRUFBRTtBQUFBLEVBQ3ZELE9BQU87QUFBRSxJQUFBQyxTQUFRLGNBQWMsRUFBRSxXQUFXLGFBQWEsR0FBRyxJQUFJO0FBQUEsRUFBRTtBQUFBLEVBQ2xFLFlBQVksT0FBeUIsT0FBdUI7QUFBRSxVQUFNLEVBQUUsT0FBTyxHQUFHLE1BQU0sQ0FBUTtBQUFBLEVBQUU7QUFDcEc7QUFNTyxJQUFNLFNBQU4sY0FBcUIsU0FBU0QsT0FBTSxNQUFNLEVBQUU7QUFBQSxFQUMvQyxPQUFPO0FBQUUsSUFBQUMsU0FBUSxjQUFjLEVBQUUsV0FBVyxTQUFTLEdBQUcsSUFBSTtBQUFBLEVBQUU7QUFBQSxFQUM5RCxZQUFZLE9BQXFCO0FBQUUsVUFBTSxLQUFZO0FBQUEsRUFBRTtBQUMzRDtBQUlPLElBQU0sUUFBTixjQUFvQixTQUFTRCxPQUFNLEtBQUssRUFBRTtBQUFBLEVBQzdDLE9BQU87QUFBRSxJQUFBQyxTQUFRLGNBQWMsRUFBRSxXQUFXLFFBQVEsR0FBRyxJQUFJO0FBQUEsRUFBRTtBQUFBLEVBQzdELFlBQVksVUFBdUIsVUFBZ0M7QUFBRSxVQUFNLEVBQUUsVUFBVSxHQUFHLE1BQU0sQ0FBUTtBQUFBLEVBQUU7QUFBQSxFQUNoRyxZQUFZLFVBQXVCO0FBQUUsU0FBSyxhQUFhLE9BQU8sUUFBUSxDQUFDO0FBQUEsRUFBRTtBQUN2RjtBQUlPLElBQU0sU0FBTixjQUFxQixTQUFTRixLQUFJLE1BQU0sRUFBRTtBQUFBLEVBQzdDLE9BQU87QUFBRSxJQUFBRSxTQUFRLGNBQWMsRUFBRSxXQUFXLFNBQVMsR0FBRyxJQUFJO0FBQUEsRUFBRTtBQUFBLEVBQzlELFlBQVksT0FBcUI7QUFBRSxVQUFNLEtBQVk7QUFBQSxFQUFFO0FBQzNEO0FBSU8sSUFBTSxTQUFOLGNBQXFCLFNBQVNELE9BQU0sTUFBTSxFQUFFO0FBQUEsRUFDL0MsT0FBTztBQUFFLElBQUFDLFNBQVEsY0FBYyxFQUFFLFdBQVcsU0FBUyxHQUFHLElBQUk7QUFBQSxFQUFFO0FBQUEsRUFDOUQsWUFBWSxPQUFxQixPQUF1QjtBQUFFLFVBQU0sRUFBRSxPQUFPLEdBQUcsTUFBTSxDQUFRO0FBQUEsRUFBRTtBQUNoRzs7O0FDeExBLFNBQW9CLFdBQVhDLGdCQUEwQjs7O0FDRG5DLE9BQU9DLFlBQVc7QUFDbEIsT0FBTyxTQUFTO0FBUVQsU0FBUyxjQUFjLE1BQStCO0FBQ3pELFNBQU8sSUFBSSxRQUFRLENBQUMsU0FBUyxXQUFXO0FBQ3BDLElBQUFDLE9BQU0sZ0JBQWdCLE1BQU0sQ0FBQyxHQUFHLFFBQVE7QUFDcEMsVUFBSTtBQUNBLGdCQUFRQSxPQUFNLGlCQUFpQixHQUFHLEtBQUssRUFBRTtBQUFBLE1BQzdDLFNBQVMsT0FBTztBQUNaLGVBQU8sS0FBSztBQUFBLE1BQ2hCO0FBQUEsSUFDSixDQUFDO0FBQUEsRUFDTCxDQUFDO0FBQ0w7QUFrQk8sU0FBUyxZQUNaLE1BQ0EsVUFDZTtBQUNmLFNBQU9DLE9BQU0sYUFBYSxNQUFNLENBQUMsTUFBYyxVQUFnQztBQUMzRSxhQUFTLE1BQU0sS0FBSztBQUFBLEVBQ3hCLENBQUM7QUFDTDs7O0FDNUNBLE9BQU9DLGNBQWE7QUFFcEIsU0FBb0IsV0FBWEMsZ0JBQXVCO0FBR2hDLElBQU0sT0FBTyxPQUFPLE1BQU07QUFDMUIsSUFBTSxPQUFPLE9BQU8sTUFBTTtBQUUxQixJQUFNLEVBQUUsV0FBVyxXQUFXLElBQUlDO0FBRWxDLElBQU1DLFlBQVcsQ0FBQyxRQUFnQixJQUM3QixRQUFRLG1CQUFtQixPQUFPLEVBQ2xDLFdBQVcsS0FBSyxHQUFHLEVBQ25CLFlBQVk7QUEyQlYsU0FBUyxTQUFTLFVBQW9CLENBQUMsR0FBRztBQUM3QyxTQUFPLFNBQVUsS0FBeUI7QUFDdEMsVUFBTSxJQUFJLFFBQVE7QUFDbEIsUUFBSSxPQUFPLE1BQU0sWUFBWSxDQUFDLEVBQUUsV0FBVyxhQUFhLEtBQUssQ0FBQyxFQUFFLFdBQVcsU0FBUyxHQUFHO0FBRW5GLGNBQVEsV0FBVyxJQUFJLFlBQVksRUFBRSxPQUFPLENBQUM7QUFBQSxJQUNqRDtBQUVBLElBQUFELFNBQVEsY0FBYztBQUFBLE1BQ2xCLFNBQVMsRUFBRSxHQUFHLElBQUksSUFBSSxHQUFHLFFBQVE7QUFBQSxNQUNqQyxZQUFZLEVBQUUsR0FBRyxJQUFJLElBQUksR0FBRyxXQUFXO0FBQUEsTUFDdkMsR0FBRztBQUFBLElBQ1AsR0FBRyxHQUFHO0FBRU4sV0FBTyxJQUFJLElBQUk7QUFBQSxFQUNuQjtBQUNKO0FBRU8sU0FBUyxTQUFTLGNBQW1DLFFBQVE7QUFDaEUsU0FBTyxTQUFVLFFBQWEsTUFBVyxNQUEyQjtBQUNoRSxXQUFPLFlBQVksSUFBSSxNQUFNLENBQUM7QUFDOUIsV0FBTyxZQUFZLElBQUksRUFBRSxlQUFlLENBQUM7QUFFekMsVUFBTSxPQUFPQyxVQUFTLElBQUk7QUFFMUIsUUFBSSxDQUFDLE1BQU07QUFDUCxhQUFPLGVBQWUsUUFBUSxNQUFNO0FBQUEsUUFDaEMsTUFBTTtBQUNGLGlCQUFPLEtBQUssSUFBSSxJQUFJLElBQUksS0FBSyxhQUFhLFdBQVc7QUFBQSxRQUN6RDtBQUFBLFFBQ0EsSUFBSSxHQUFRO0FBQ1IsY0FBSSxNQUFNLEtBQUssSUFBSSxHQUFHO0FBQ2xCLGlCQUFLLElBQUksTUFBTSxDQUFDO0FBQ2hCLGlCQUFLLElBQUksRUFBRSxJQUFJLElBQUk7QUFDbkIsaUJBQUssT0FBTyxJQUFJO0FBQUEsVUFDcEI7QUFBQSxRQUNKO0FBQUEsTUFDSixDQUFDO0FBRUQsYUFBTyxlQUFlLFFBQVEsT0FBTyxLQUFLLFFBQVEsS0FBSyxHQUFHLENBQUMsSUFBSTtBQUFBLFFBQzNELE1BQU0sR0FBUTtBQUNWLGVBQUssSUFBSSxJQUFJO0FBQUEsUUFDakI7QUFBQSxNQUNKLENBQUM7QUFFRCxhQUFPLGVBQWUsUUFBUSxPQUFPLEtBQUssUUFBUSxLQUFLLEdBQUcsQ0FBQyxJQUFJO0FBQUEsUUFDM0QsUUFBUTtBQUNKLGlCQUFPLEtBQUssSUFBSTtBQUFBLFFBQ3BCO0FBQUEsTUFDSixDQUFDO0FBRUQsYUFBTyxZQUFZLElBQUksRUFBRSxXQUFXQSxVQUFTLElBQUksQ0FBQyxJQUFJLE1BQU0sTUFBTSxXQUFXLFdBQVcsV0FBVztBQUFBLElBQ3ZHLE9BQU87QUFDSCxVQUFJLFFBQVE7QUFDWixVQUFJLEtBQUssSUFBSyxVQUFTLFdBQVc7QUFDbEMsVUFBSSxLQUFLLElBQUssVUFBUyxXQUFXO0FBRWxDLGFBQU8sWUFBWSxJQUFJLEVBQUUsV0FBV0EsVUFBUyxJQUFJLENBQUMsSUFBSSxNQUFNLE1BQU0sT0FBTyxXQUFXO0FBQUEsSUFDeEY7QUFBQSxFQUNKO0FBQ0o7QUFtREEsU0FBUyxNQUFNLE1BQWMsT0FBZSxhQUFrQztBQUMxRSxNQUFJLHVCQUF1QjtBQUN2QixXQUFPO0FBRVgsVUFBUSxhQUFhO0FBQUEsSUFDakIsS0FBSztBQUNELGFBQU8sVUFBVSxPQUFPLE1BQU0sSUFBSSxJQUFJLE9BQU8sRUFBRTtBQUFBLElBQ25ELEtBQUs7QUFDRCxhQUFPLFVBQVUsT0FBTyxNQUFNLElBQUksSUFBSSxPQUFPLENBQUMsT0FBTyxXQUFXLE9BQU8sV0FBVyxDQUFDO0FBQUEsSUFDdkYsS0FBSztBQUNELGFBQU8sVUFBVSxRQUFRLE1BQU0sSUFBSSxJQUFJLE9BQU8sS0FBSztBQUFBLElBQ3ZELEtBQUs7QUFDRCxhQUFPLFVBQVUsU0FBUyxNQUFNLElBQUksSUFBSSxLQUFLO0FBQUEsSUFDakQ7QUFFSSxhQUFPLFVBQVUsT0FBTyxNQUFNLElBQUksSUFBSSxPQUFPLFlBQVksTUFBTTtBQUFBLEVBQ3ZFO0FBQ0o7QUFFQSxTQUFTLGFBQWEsYUFBa0M7QUFDcEQsTUFBSSx1QkFBdUI7QUFDdkIsV0FBTyxZQUFZLGtCQUFrQjtBQUV6QyxVQUFRLGFBQWE7QUFBQSxJQUNqQixLQUFLO0FBQ0QsYUFBTztBQUFBLElBQ1gsS0FBSztBQUNELGFBQU87QUFBQSxJQUNYLEtBQUs7QUFDRCxhQUFPO0FBQUEsSUFDWCxLQUFLO0FBQUEsSUFDTDtBQUNJLGFBQU87QUFBQSxFQUNmO0FBQ0o7OztBQ3RMQSxJQUFNLE1BQU07QUFFTCxTQUFTLGNBQXNCO0FBQ3BDLE1BQUk7QUFDRixTQUFLLFFBQVEsd0JBQUcsZUFBZSxHQUFHLFlBQVk7QUFDOUMsZ0JBQUksVUFBVSxnQkFBZ0I7QUFDOUIsV0FBTyxHQUFHLEdBQUc7QUFBQSxFQUNmLFNBQVEsS0FBSztBQUNYLGFBQVMsK0JBQStCLEdBQUc7QUFDM0MsV0FBTztBQUFBLEVBQ1Q7QUFDRjtBQUFBLENBR0MsV0FBVztBQUNWLFFBQU0sWUFDSixLQUFLLFdBQVcsd0JBQUcsa0JBQWtCLEVBQ2xDLE1BQU0sSUFBSTtBQUdmLGNBQVk7QUFFWixZQUNHO0FBQUEsSUFBUSxVQUNQLFlBQVksTUFBTSxXQUFXO0FBQUEsRUFDL0I7QUFDSixHQUFHOzs7QUMzQkgsT0FBTyxXQUFXO0FBRVgsSUFBTSxVQUFVLFNBQWtCLElBQUk7QUFDdEMsSUFBTSxrQkFBa0IsU0FBa0IsS0FBSztBQUMvQyxJQUFNLG1CQUFtQixTQUFrQixLQUFLO0FBQ2hELElBQU0sZ0JBQWdCLFNBQWtCLEtBQUs7QUFDN0MsSUFBTSxlQUFlLFNBQWtCLEtBQUs7QUFDNUMsSUFBTSxlQUFlLFNBQWtCLEtBQUs7QUFDNUMsSUFBTSxvQkFBb0IsU0FBa0IsS0FBSztBQUNqRCxJQUFNLHNCQUFzQixTQUFpQixDQUFDO0FBQzlDLElBQU0sZUFBZSxTQUFpQixNQUFNO0FBQzVDLElBQU0sZ0JBQWdCLE1BQU0sT0FBTyxJQUFJLFNBQVM7QUFFdkQsVUFBVSxxQkFBcUIsRUFDNUIsS0FBSyxNQUFNLGtCQUFrQixJQUFJLElBQUksQ0FBQyxFQUN0QyxNQUFNLE1BQU0sa0JBQWtCLElBQUksS0FBSyxDQUFDO0FBRXBDLElBQU0sY0FBYyxTQUFpQixFQUFFLEVBQUUsS0FBSyxLQUFNLE1BQ3pEQyxTQUFLLFNBQVMsY0FBYyxFQUFFLE9BQU8sT0FBTyxDQUFFO0FBRXpDLElBQU0sYUFBYSxTQUFpQixFQUFFLEVBQUUsS0FBSyxLQUFNLE1BQ3hEQSxTQUFLLFNBQVMsY0FBYyxFQUFFLE9BQU8sZ0JBQWdCLENBQUU7QUFFbEQsSUFBTSxTQUFTLFNBQVMsRUFBRSxFQUFFLEtBQUssSUFBSSxLQUFLLEtBQU0sWUFBWTtBQUNqRSxRQUFNLFNBQVMsTUFBTSxVQUFVLFdBQVc7QUFDMUMsU0FBTyxPQUNKLFFBQVEsb0JBQW9CLEdBQUcsRUFDL0IsUUFBUSxnQkFBZ0IsR0FBRyxFQUMzQixRQUFRLGNBQWMsR0FBRyxFQUN6QixRQUFRLGdCQUFnQixHQUFHO0FBQ2hDLENBQUM7QUFFTSxJQUFNLGNBQWMsU0FBaUIsRUFBRSxFQUFFLEtBQUssSUFBSSxLQUFNLFlBQVk7QUFDekUsUUFBTSxTQUFTLE1BQU0sVUFBVSxDQUFDLE1BQU0sTUFBTSwyQ0FBMkMsQ0FBQztBQUN4RixTQUFPO0FBQ1QsQ0FBQztBQU9NLElBQU0sZ0JBQWdCLFNBQTZCLElBQUksRUFBRSxLQUFLLEtBQUssS0FBSyxLQUFNLFlBQVk7QUFDL0YsTUFBSTtBQUNGLFVBQU0sU0FBUyxNQUFNLFVBQVUsc0NBQXNDO0FBQ3JFLFVBQU0sVUFBVSxLQUFLLE1BQU0sTUFBTTtBQUNqQyxVQUFNLFlBQVksWUFBWSxJQUFJO0FBQ2xDLFdBQU8sRUFBRSxXQUFXLFFBQVE7QUFBQSxFQUM5QixTQUFTLEtBQUs7QUFDWixZQUFRLE1BQU0sMkJBQTJCLEdBQUc7QUFDNUMsV0FBTztBQUFBLEVBQ1Q7QUFDRixDQUFDOzs7QUNwREQsT0FBTyxhQUFhO0FBQ3BCLE9BQU8sZUFBZTtBQUN0QixPQUFPLGNBQWM7QUFDckIsT0FBT0MsWUFBVztBQUNsQixPQUFPLGFBQWE7QUFDcEIsT0FBTyxVQUFVOzs7QUNNVixTQUFTQyxLQUNaLE1BQ0EsT0FDRjtBQUNFLFNBQU8sSUFBSyxPQUFPLE1BQWEsS0FBSztBQUN6QztBQUVBLElBQU0sUUFBUTtBQUFBLEVBQ1YsS0FBWTtBQUFBLEVBQ1osUUFBZTtBQUFBLEVBQ2YsV0FBa0I7QUFBQSxFQUNsQixrQkFBeUI7QUFBQSxFQUN6QixhQUFvQjtBQUFBLEVBQ3BCLE9BQWM7QUFBQSxFQUNkLFVBQWlCO0FBQUE7QUFBQTtBQUFBLEVBR2pCLE1BQWE7QUFBQSxFQUNiLE9BQWM7QUFBQSxFQUNkLFVBQWlCO0FBQUE7QUFBQSxFQUVqQixZQUFtQjtBQUFBLEVBQ25CLFNBQWdCO0FBQUEsRUFDaEIsVUFBaUI7QUFBQSxFQUNqQixZQUFtQjtBQUFBLEVBQ25CLFFBQWU7QUFBQSxFQUNmLE9BQWM7QUFBQSxFQUNkLFFBQWU7QUFBQSxFQUNmLFFBQWU7QUFDbkI7QUFpQ08sSUFBTSxPQUFPQTs7O0FDdkVwQixTQUFTLFdBQVcsT0FBZTtBQUNqQyxTQUNFLGdCQUFBQztBQUFBLElBQUM7QUFBQTtBQUFBLE1BQ0MsZ0JBQWdCQyxLQUFJLG9CQUFvQjtBQUFBLE1BQ3hDLG9CQUFvQjtBQUFBLE1BQ3BCLGtCQUFrQixLQUFLLFdBQVcsRUFBRSxHQUFHLFVBQVEsT0FBTyxLQUFLLEtBQUssR0FBRztBQUFBLE1BQ25FLFdBQVU7QUFBQSxNQUVULGdCQUFNLEtBQUssRUFBRSxRQUFRLEdBQUcsR0FBRyxDQUFDLEdBQUcsTUFDOUIsZ0JBQUFELEtBQUMsV0FBTSxNQUFNLEVBQUUsU0FBUyxHQUFHLE9BQU8sRUFBRSxTQUFTLEdBQUcsQ0FDakQ7QUFBQTtBQUFBLEVBQ0g7QUFFSjtBQUVlLFNBQVJFLFFBQXdCO0FBQzdCLFNBQ0U7QUFBQSxJQUFDO0FBQUE7QUFBQSxNQUNDLFdBQVU7QUFBQSxNQUNWLFFBQVFELEtBQUksTUFBTTtBQUFBLE1BQ2xCLFFBQVFBLEtBQUksTUFBTTtBQUFBLE1BRWpCO0FBQUEsbUJBQVcsQ0FBQztBQUFBLFFBQ1osV0FBVyxDQUFDO0FBQUEsUUFDYixnQkFBQUQsS0FBQyxXQUFNLE9BQU0sS0FBRyxLQUFJLDBDQUF5QztBQUFBLFFBQzVELFdBQVcsQ0FBQztBQUFBLFFBQ1osV0FBVyxDQUFDO0FBQUE7QUFBQTtBQUFBLEVBQ2Y7QUFFSjs7O0FDL0JPLElBQU0sU0FBUyxDQUFDLFNBQ3JCLENBQUMsQ0FBQ0csT0FBTSxLQUFLLFlBQVksSUFBSTtBQUV4QixTQUFTLGdCQUFnQixNQUFzQjtBQUNwRCxTQUFPLEtBQUssWUFBWTtBQUV4QixNQUFJLEtBQUssU0FBUyxPQUFPLEtBQUssS0FBSyxTQUFTLE9BQU8sRUFBRyxRQUFPO0FBQzdELE1BQUksS0FBSyxTQUFTLFFBQVEsRUFBRyxRQUFPO0FBQ3BDLE1BQUksS0FBSyxTQUFTLFFBQVEsS0FBSyxLQUFLLFNBQVMsVUFBVSxFQUFHLFFBQU87QUFDakUsTUFBSSxLQUFLLFNBQVMsTUFBTSxLQUFLLEtBQUssU0FBUyxTQUFTLEVBQUcsUUFBTztBQUM5RCxNQUFJLEtBQUssU0FBUyxTQUFTLEVBQUcsUUFBTztBQUNyQyxNQUFJLEtBQUssU0FBUyxNQUFNLEVBQUcsUUFBTztBQUNsQyxNQUFJLEtBQUssU0FBUyxLQUFLLEtBQUssS0FBSyxTQUFTLE1BQU0sRUFBRyxRQUFPO0FBRTFELFNBQU87QUFDVDtBQUVPLFNBQVMsZ0JBQWdCLE1BQXNCO0FBQ3BELFNBQU8sS0FBSyxZQUFZO0FBRXhCLE1BQUksS0FBSyxTQUFTLE9BQU8sS0FBSyxLQUFLLFNBQVMsT0FBTyxFQUFHLFFBQU87QUFDN0QsTUFBSSxLQUFLLFNBQVMsUUFBUSxFQUFHLFFBQU87QUFDcEMsTUFBSSxLQUFLLFNBQVMsUUFBUSxLQUFLLEtBQUssU0FBUyxVQUFVLEVBQUcsUUFBTztBQUNqRSxNQUFJLEtBQUssU0FBUyxPQUFPLEVBQUcsUUFBTztBQUNuQyxNQUFJLEtBQUssU0FBUyxNQUFNLEtBQUssS0FBSyxTQUFTLFNBQVMsRUFBRyxRQUFPO0FBQzlELE1BQUksS0FBSyxTQUFTLFNBQVMsRUFBRyxRQUFPO0FBRXJDLE1BQUksS0FBSyxTQUFTLEtBQUssS0FBSyxLQUFLLFNBQVMsTUFBTSxFQUFHLFFBQU87QUFFMUQsU0FBTztBQUNUO0FBRU8sU0FBUyxZQUFZLE1BQU07QUFDaEMsTUFBSSxLQUFLLFNBQVMsU0FBUyxFQUFHLFFBQU87QUFDckMsTUFBSSxLQUFLLFNBQVMsVUFBVSxFQUFHLFFBQU87QUFDdEMsTUFBSSxLQUFLLFNBQVMsV0FBVyxFQUFHLFFBQU87QUFDdkMsTUFBSSxLQUFLLFNBQVMsYUFBYSxFQUFHLFFBQU87QUFDekMsTUFBSSxLQUFLLFNBQVMsYUFBYSxFQUFHLFFBQU87QUFDekMsTUFBSSxLQUFLLFNBQVMsV0FBVyxFQUFHLFFBQU87QUFDdkMsTUFBSSxLQUFLLFNBQVMsYUFBYSxFQUFHLFFBQU87QUFDekMsTUFBSSxLQUFLLFNBQVMsV0FBVyxFQUFHLFFBQU87QUFDdkMsU0FBTztBQUNUOzs7QUhoQ0EsU0FBUyxVQUFVO0FBQ2pCLFFBQU0sT0FBTyxLQUFLLFlBQVk7QUFFOUIsU0FBTyxnQkFBQUMsS0FBQyxTQUFJLFdBQVUsV0FDbkIsZUFBSyxNQUFNLE9BQU8sRUFBRSxHQUFHLFdBQVMsTUFBTSxJQUFJLFVBQ3pDLGdCQUFBQTtBQUFBLElBQUM7QUFBQTtBQUFBLE1BQ0MsZUFBZSxLQUFLLE1BQU0sZUFBZTtBQUFBLE1BQ3pDLFlBQVk7QUFBQSxNQUNaLGFBQWEsS0FBSyxNQUFNLGFBQWEsRUFBRSxHQUFHLFFBQU0sQ0FBQyxZQUFZLEVBQUUsQ0FBQztBQUFBLE1BQ2hFLFdBQVcsS0FBSyxNQUFNLFdBQVc7QUFBQSxNQUNqQywwQkFBQUEsS0FBQyxVQUFLLE9BQU8sS0FBSyxNQUFNLE9BQU8sR0FBRztBQUFBO0FBQUEsRUFDcEMsQ0FDRCxDQUFDLEdBQ0o7QUFDRjtBQUVBLFNBQVMsZ0JBQWdCO0FBQ3ZCLFFBQU0sVUFBVSxRQUFRLFlBQVk7QUFDcEMsUUFBTSxlQUFlLEVBQUUsS0FBSyxTQUFTLEtBQUssT0FBTztBQUVqRCxTQUFPLEtBQUssU0FBUyxTQUFTLEVBQUUsR0FBRyxPQUFLO0FBQ3RDLFVBQU0sTUFBTSxRQUFRLGFBQWEsQ0FBQyxDQUFDO0FBQ25DLFFBQUksS0FBSztBQUNQLGFBQU8sZ0JBQUFBO0FBQUEsUUFBQztBQUFBO0FBQUEsVUFDTixXQUFVO0FBQUEsVUFDVixNQUFNLEtBQUssS0FBSyxVQUFVO0FBQUE7QUFBQSxNQUFHO0FBQUEsSUFDakM7QUFDQSxXQUFPLGdCQUFBQSxLQUFDLFNBQUk7QUFBQSxFQUNkLENBQUM7QUFDSDtBQUVBLFNBQVMsa0JBQWtCO0FBQ3pCLFFBQU0sWUFBWSxVQUFVLFlBQVk7QUFFeEMsU0FBTyxnQkFBQUE7QUFBQSxJQUFDO0FBQUE7QUFBQSxNQUNOLGdCQUFnQkMsS0FBSSx1QkFBdUI7QUFBQSxNQUMzQyxhQUFhLEtBQUssV0FBVyxjQUFjO0FBQUEsTUFDM0MsMEJBQUFELEtBQUMsV0FBTSxXQUFVLGFBQVksT0FBTSxhQUFLO0FBQUE7QUFBQSxFQUMxQztBQUNGO0FBRUEsU0FBUyxlQUFlO0FBQ3RCLFFBQU0sTUFBTSxRQUFRLFlBQVk7QUFFaEMsU0FBTztBQUFBLElBQUM7QUFBQTtBQUFBLE1BQUksV0FBVTtBQUFBLE1BQ3BCLFNBQVMsS0FBSyxLQUFLLFdBQVc7QUFBQSxNQUM5QjtBQUFBLHdCQUFBQSxLQUFDLFdBQU0sT0FBTyxLQUFLLEtBQUssWUFBWSxFQUFFLEdBQUcsT0FBSyxHQUFHLEtBQUssTUFBTSxJQUFJLEdBQUcsQ0FBQyxHQUFHLEdBQUc7QUFBQSxRQUMxRSxnQkFBQUEsS0FBQyxVQUFLLE1BQU0sS0FBSyxLQUFLLGlCQUFpQixHQUFHO0FBQUE7QUFBQTtBQUFBLEVBQzVDO0FBQ0Y7QUFFQSxTQUFTLFNBQVMsUUFBOEI7QUFDOUMsU0FBTyxPQUFPLFNBQ1YsR0FBRyxPQUFPLE1BQU0sS0FBSyxPQUFPLEtBQUssS0FDakMsT0FBTyxRQUNMLEdBQUcsT0FBTyxLQUFLLEtBQUssT0FBTyxLQUFLLEtBQ2hDLEdBQUcsT0FBTyxLQUFLO0FBQ3ZCO0FBRUEsU0FBUyxRQUFRO0FBQ2YsUUFBTSxRQUFRRSxPQUFNLFlBQVk7QUFFaEMsU0FBTyxLQUFLLE9BQU8sU0FBUyxFQUFFLEdBQUcsUUFBTSxHQUFHLENBQUMsSUFDekMsZ0JBQUFGO0FBQUEsSUFBQztBQUFBO0FBQUEsTUFBTyxXQUFVO0FBQUEsTUFDaEIsU0FBUyxNQUFNLEdBQUcsQ0FBQyxFQUFFLFdBQVc7QUFBQSxNQUNoQywwQkFBQUE7QUFBQSxRQUFDO0FBQUE7QUFBQSxVQUNDLFdBQVcsS0FBSyxHQUFHLENBQUMsR0FBRyxnQkFBZ0IsRUFBRSxHQUFHLE9BQUssSUFBSSxJQUFJLFdBQVcsU0FBUztBQUFBLFVBQzdFLFVBQVE7QUFBQSxVQUNSLGVBQWU7QUFBQSxVQUNmLE9BQU8sS0FBSyxHQUFHLENBQUMsR0FBRyxVQUFVLEVBQUUsR0FBRyxNQUFNLFNBQVMsR0FBRyxDQUFDLENBQUMsQ0FBQztBQUFBO0FBQUEsTUFBRztBQUFBO0FBQUEsRUFDOUQsSUFDRyxnQkFBQUEsS0FBQyxTQUFJLENBQUc7QUFDZjtBQUVBLFNBQVMsYUFBYTtBQUNwQixRQUFNLE9BQU8sU0FBUyxZQUFZO0FBRWxDLFNBQU8sZ0JBQUFBLEtBQUMsU0FBSSxXQUFVLGNBQ25CLGVBQUssTUFBTSxZQUFZLEVBQUU7QUFBQSxJQUFHLFNBQU8sSUFDakMsT0FBTyxRQUFNLEVBQUUsR0FBRyxNQUFNLE9BQU8sR0FBRyxNQUFNLEdBQUcsRUFDM0MsS0FBSyxDQUFDLEdBQUcsTUFBTSxFQUFFLEtBQUssRUFBRSxFQUFFLEVBQzFCLElBQUksUUFDSCxnQkFBQUE7QUFBQSxNQUFDO0FBQUE7QUFBQSxRQUNDLFdBQVcsS0FBSyxNQUFNLGtCQUFrQixFQUFFLEdBQUcsUUFDM0MsT0FBTyxLQUFLLFlBQVksRUFBRTtBQUFBLFFBQzVCLFdBQVcsTUFBTSxHQUFHLE1BQU07QUFBQSxRQUN6QixhQUFHO0FBQUE7QUFBQSxJQUNOLENBQ0Q7QUFBQSxFQUNILEdBQ0Y7QUFDRjtBQUVBLFNBQVMsVUFBVTtBQUNqQixRQUFNLFVBQVUsU0FBa0IsS0FBSztBQUN2QyxTQUFPLGdCQUFBQTtBQUFBLElBQUM7QUFBQTtBQUFBLE1BQ04sZ0JBQWdCQyxLQUFJLHVCQUF1QjtBQUFBLE1BQzNDLGFBQWEsUUFBUTtBQUFBLE1BQ3BCLGVBQUssYUFBYSxFQUFFLEdBQUcsQ0FBQyxTQUFTO0FBQ2hDLFlBQUksTUFBTTtBQUNSLGdCQUFNLFlBQVksS0FBSyxRQUFRLGtCQUFrQixDQUFDO0FBQ2xELGdCQUFNLE9BQU8sVUFBVTtBQUN2QixnQkFBTSxRQUFRLGdCQUFnQixVQUFVLFlBQVksQ0FBQyxFQUFFLEtBQUs7QUFDNUQsa0JBQVEsSUFBSSxJQUFJO0FBQ2hCLGlCQUFPLGdCQUFBRCxLQUFDLFdBQU0sV0FBVSxXQUFVLE9BQU8sR0FBRyxJQUFJLFNBQU0sS0FBSyxJQUFJO0FBQUEsUUFDakU7QUFDQSxlQUFPLGdCQUFBQSxLQUFDLFNBQUk7QUFBQSxNQUNkLENBQUM7QUFBQTtBQUFBLEVBQ0g7QUFDRjtBQUVBLFNBQVMsbUJBQW1CO0FBQzFCLFNBQU8sZ0JBQUFBO0FBQUEsSUFBQztBQUFBO0FBQUEsTUFDTixnQkFBZ0JDLEtBQUksdUJBQXVCO0FBQUEsTUFDM0MsYUFBYSxLQUFLLG1CQUFtQixFQUFFLEdBQUcsT0FBSyxJQUFJLENBQUM7QUFBQSxNQUNwRCwwQkFBQUQsS0FBQyxXQUFNLFdBQVUsb0JBQW1CLE9BQU0sYUFBSztBQUFBO0FBQUEsRUFDakQ7QUFDRjtBQUVBLFNBQVMsU0FBUztBQUNoQixTQUFPLGdCQUFBQTtBQUFBLElBQUM7QUFBQTtBQUFBLE1BQ04sV0FBVTtBQUFBLE1BQ1YsV0FBVyxNQUFNLFlBQVksS0FBSztBQUFBLE1BQ2xDLE9BQU8sWUFBWTtBQUFBO0FBQUEsRUFDckI7QUFDRjtBQUVlLFNBQVIsSUFBcUIsU0FBc0IsU0FBNEI7QUFDNUUsUUFBTSxFQUFFLEtBQUssTUFBTSxNQUFNLElBQUlHLE9BQU07QUFFbkMsU0FBTyxnQkFBQUg7QUFBQSxJQUFDO0FBQUE7QUFBQSxNQUNOLFdBQVU7QUFBQSxNQUNWLFdBQVU7QUFBQSxNQUNWLFlBQVk7QUFBQSxNQUNaLGFBQWFHLE9BQU0sWUFBWTtBQUFBLE1BQy9CLGFBQWE7QUFBQSxNQUNiLFNBQVMsUUFBUTtBQUFBLE1BQ2pCLE9BQU9BLE9BQU0sTUFBTTtBQUFBLE1BQ25CLFFBQVEsTUFBTSxPQUFPO0FBQUEsTUFDckIsK0JBQUMsZUFDQztBQUFBO0FBQUEsVUFBQztBQUFBO0FBQUEsWUFDQyxTQUFPO0FBQUEsWUFDUCxRQUFRRixLQUFJLE1BQU07QUFBQSxZQUNsQixLQUFJO0FBQUEsWUFDSjtBQUFBLDhCQUFBRDtBQUFBLGdCQUFDO0FBQUE7QUFBQSxrQkFDQyxXQUFVO0FBQUEsa0JBQ1YsV0FBVyxNQUFNLGdCQUFnQixJQUFJLENBQUMsZ0JBQWdCLElBQUksQ0FBQztBQUFBLGtCQUUzRCwrQkFBQyxTQUNDO0FBQUEsb0NBQUFBLEtBQUNJLE9BQUEsRUFBSztBQUFBLG9CQUNOLGdCQUFBSixLQUFDLFdBQVE7QUFBQSxxQkFDWDtBQUFBO0FBQUEsY0FDRjtBQUFBLGNBQ0EsZ0JBQUFBLEtBQUMsY0FBVztBQUFBO0FBQUE7QUFBQSxRQUNkO0FBQUEsUUFDQSxnQkFBQUEsS0FBQyxTQUFNO0FBQUEsUUFDUDtBQUFBLFVBQUM7QUFBQTtBQUFBLFlBQ0MsU0FBTztBQUFBLFlBQ1AsUUFBUUMsS0FBSSxNQUFNO0FBQUEsWUFDbEIsS0FBSTtBQUFBLFlBQ0o7QUFBQSw4QkFBQUQsS0FBQyxXQUFRO0FBQUEsY0FDVCxnQkFBQUE7QUFBQSxnQkFBQztBQUFBO0FBQUEsa0JBQ0MsV0FBVTtBQUFBLGtCQUNWLFdBQVcsTUFBTSxpQkFBaUIsSUFBSSxDQUFDLGlCQUFpQixJQUFJLENBQUM7QUFBQSxrQkFFN0QsK0JBQUMsU0FDQztBQUFBLG9DQUFBQSxLQUFDLGdCQUFhO0FBQUEsb0JBQ2QsZ0JBQUFBLEtBQUMsaUJBQWM7QUFBQSxvQkFDZixnQkFBQUEsS0FBQyxtQkFBZ0I7QUFBQSxvQkFDakIsZ0JBQUFBLEtBQUMsb0JBQWlCO0FBQUEsb0JBQ2xCLGdCQUFBQSxLQUFDLFVBQU87QUFBQSxxQkFDVjtBQUFBO0FBQUEsY0FDRjtBQUFBO0FBQUE7QUFBQSxRQUNGO0FBQUEsU0FDRjtBQUFBO0FBQUEsRUFDRjtBQUNGOzs7QUl6TGUsU0FBUixVQUEyQixTQUFzQixTQUE0QjtBQUNsRixTQUFPLGdCQUFBSztBQUFBLElBQUM7QUFBQTtBQUFBLE1BQ04sV0FBVTtBQUFBLE1BQ1YsV0FBVTtBQUFBLE1BQ1YsWUFBWTtBQUFBLE1BQ1osU0FBUyxRQUFRO0FBQUEsTUFDakIsT0FBT0MsT0FBTSxNQUFNO0FBQUEsTUFDbkIsYUFBYTtBQUFBLE1BQ2IsYUFBYUEsT0FBTSxZQUFZO0FBQUEsTUFDL0IsU0FBU0EsT0FBTSxRQUFRO0FBQUEsTUFDdkIsVUFBVTtBQUFBLE1BQ1YsYUFBYTtBQUFBLE1BRWIsMEJBQUFEO0FBQUEsUUFBQztBQUFBO0FBQUEsVUFDQyxXQUFVO0FBQUE7QUFBQSxNQUNaO0FBQUE7QUFBQSxFQUNGO0FBQ0Y7OztBQ2xCQSxPQUFPLFVBQVU7QUFHakIsSUFBTSxZQUFZO0FBRWxCLFNBQVMsT0FBTztBQUNkLGVBQWEsSUFBSSxLQUFLO0FBQ3hCO0FBRUEsU0FBUyxVQUFVLEVBQUUsSUFBSSxHQUE4QjtBQUNyRCxTQUFPLGdCQUFBRTtBQUFBLElBQUM7QUFBQTtBQUFBLE1BQ04sV0FBVTtBQUFBLE1BQ1YsV0FBVyxNQUFNO0FBQUUsYUFBSztBQUFHLFlBQUksT0FBTztBQUFBLE1BQUU7QUFBQSxNQUN4QywrQkFBQyxTQUNDO0FBQUEsd0JBQUFBLEtBQUMsVUFBSyxNQUFNLElBQUksWUFBWSxnQkFBZ0I7QUFBQSxRQUM1QyxxQkFBQyxTQUFJLFFBQVFDLEtBQUksTUFBTSxRQUFRLFVBQVEsTUFDckM7QUFBQSwwQkFBQUQ7QUFBQSxZQUFDO0FBQUE7QUFBQSxjQUNDLFdBQVU7QUFBQSxjQUNWLFVBQVE7QUFBQSxjQUNSLFFBQVE7QUFBQSxjQUNSLE9BQU8sSUFBSTtBQUFBO0FBQUEsVUFDYjtBQUFBLFVBQ0MsSUFBSSxlQUFlLGdCQUFBQTtBQUFBLFlBQUM7QUFBQTtBQUFBLGNBQ25CLFdBQVU7QUFBQSxjQUNWLE1BQUk7QUFBQSxjQUNKLFFBQVE7QUFBQSxjQUNSLE9BQU8sSUFBSTtBQUFBO0FBQUEsVUFDYjtBQUFBLFdBQ0Y7QUFBQSxTQUNGO0FBQUE7QUFBQSxFQUNGO0FBQ0Y7QUFFZSxTQUFSLFNBQTBCLFNBQXNCLFNBQTRCO0FBQ2pGLFFBQU0sT0FBTyxJQUFJLEtBQUssS0FBSztBQUMzQixRQUFNLFFBQVEsU0FBUyxHQUFJO0FBRTNCLFFBQU0sT0FBTyxTQUFTLEVBQUU7QUFDeEIsUUFBTSxPQUFPLEtBQUssQ0FBQUUsVUFBUSxLQUFLLFlBQVlBLEtBQUksRUFBRSxNQUFNLEdBQUcsU0FBUyxDQUFDO0FBQ3BFLFFBQU0sVUFBVSxNQUFNO0FBQ3BCLFNBQUssWUFBWSxLQUFLLElBQUksQ0FBQyxJQUFJLENBQUMsRUFBRSxPQUFPO0FBQ3pDLFNBQUs7QUFBQSxFQUNQO0FBRUEsU0FBTyxnQkFBQUY7QUFBQSxJQUFDO0FBQUE7QUFBQSxNQUNOLE1BQUs7QUFBQSxNQUNMLGFBQWFHLE9BQU0sWUFBWTtBQUFBLE1BQy9CLFNBQVNBLE9BQU0sUUFBUTtBQUFBLE1BQ3ZCLGFBQWE7QUFBQSxNQUNiLFlBQVk7QUFBQSxNQUNaLFNBQVMsUUFBUTtBQUFBLE1BQ2pCLFFBQVEsQ0FBQyxTQUFTO0FBQ2hCLGFBQUssSUFBSSxFQUFFO0FBQ1gsY0FBTSxJQUFJLEtBQUssb0JBQW9CLEVBQUUsU0FBUyxLQUFLO0FBQUEsTUFDckQ7QUFBQSxNQUNBLGlCQUFpQixTQUFTLEdBQUcsT0FBa0I7QUFDN0MsWUFBSSxNQUFNLFdBQVcsRUFBRSxDQUFDLE1BQU0sSUFBSTtBQUNoQyxlQUFLO0FBQUEsTUFDVDtBQUFBLE1BQ0EsK0JBQUMsU0FDQztBQUFBLHdCQUFBSCxLQUFDLGNBQVMsY0FBYyxNQUFNLE9BQUssSUFBSSxDQUFDLEdBQUcsUUFBTSxNQUFDLFNBQVMsTUFBTTtBQUFBLFFBQ2pFLHFCQUFDLFNBQUksU0FBUyxPQUFPLFVBQVEsTUFDM0I7QUFBQSwwQkFBQUEsS0FBQyxjQUFTLGVBQWUsS0FBSyxTQUFTLE1BQU07QUFBQSxVQUM3QyxxQkFBQyxTQUFJLGNBQWMsS0FBSyxXQUFVLGVBQWMsVUFBUSxNQUN0RDtBQUFBLDRCQUFBQTtBQUFBLGNBQUM7QUFBQTtBQUFBLGdCQUNDLGlCQUFnQjtBQUFBLGdCQUNoQixNQUFNLEtBQUs7QUFBQSxnQkFDWCxXQUFXLFVBQVE7QUFDakIsc0JBQUksS0FBSyxLQUFLLFdBQVcsSUFBSSxFQUFHLE9BQU0sT0FBTztBQUM3Qyx5QkFBTyxLQUFLLElBQUksS0FBSyxJQUFJO0FBQUEsZ0JBQzNCO0FBQUEsZ0JBQ0EsWUFBWTtBQUFBO0FBQUEsWUFDZDtBQUFBLFlBQ0EsZ0JBQUFBLEtBQUMsU0FBSSxTQUFTLEdBQUcsVUFBUSxNQUN0QixlQUFLLEdBQUcsQ0FBQUksVUFBUUEsTUFBSyxJQUFJLFNBQ3hCLGdCQUFBSixLQUFDLGFBQVUsS0FBVSxDQUN0QixDQUFDLEdBQ0o7QUFBQSxZQUNBO0FBQUEsY0FBQztBQUFBO0FBQUEsZ0JBQ0MsUUFBUUMsS0FBSSxNQUFNO0FBQUEsZ0JBQ2xCLFdBQVU7QUFBQSxnQkFDVixVQUFRO0FBQUEsZ0JBQ1IsU0FBUyxLQUFLLEdBQUcsT0FBSyxFQUFFLFdBQVcsQ0FBQztBQUFBLGdCQUNwQztBQUFBLGtDQUFBRCxLQUFDLFVBQUssTUFBSywwQkFBeUI7QUFBQSxrQkFDcEMsZ0JBQUFBLEtBQUMsV0FBTSxPQUFNLGtCQUFpQjtBQUFBO0FBQUE7QUFBQSxZQUNoQztBQUFBLGFBQ0Y7QUFBQSxVQUNBLGdCQUFBQSxLQUFDLGNBQVMsUUFBTSxNQUFDLFNBQVMsTUFBTTtBQUFBLFdBQ2xDO0FBQUEsUUFDQSxnQkFBQUEsS0FBQyxjQUFTLGNBQWMsTUFBTSxPQUFLLElBQUksQ0FBQyxHQUFHLFFBQU0sTUFBQyxTQUFTLE1BQU07QUFBQSxTQUNuRTtBQUFBO0FBQUEsRUFDRjtBQUNGOzs7QUMzRkEsSUFBcUIsV0FBckIsY0FBc0MsU0FBU0ssS0FBSSxRQUFRLEVBQUU7QUFBQSxFQUMzRCxPQUFPO0FBQ0wsSUFBQUMsU0FBUSxjQUFjLElBQUk7QUFBQSxFQUM1QjtBQUFBLEVBQ0EsWUFDRSxPQUNBO0FBQ0EsVUFBTSxLQUFZO0FBQUEsRUFDcEI7QUFDRjs7O0FDSkEsU0FBUyxjQUFjO0FBQ3JCLFNBQ0U7QUFBQSxJQUFDO0FBQUE7QUFBQSxNQUNDLFdBQVU7QUFBQSxNQUNWLFVBQVE7QUFBQSxNQUVSO0FBQUEsd0JBQUFDLEtBQUNDLE9BQUEsRUFBSztBQUFBLFFBQ04sZ0JBQUFELEtBQUMsV0FBTSxXQUFVLFNBQVEsT0FBTyxXQUFXLEVBQUUsR0FBRyxTQUFPLElBQUksUUFBUSxnQkFBZ0IsQ0FBQyxHQUFHLE9BQU8sU0FBUyxNQUFNLFlBQVksSUFBSSxLQUFLLFlBQVksQ0FBQyxDQUFDLEdBQUc7QUFBQTtBQUFBO0FBQUEsRUFDcko7QUFFSjtBQUVBLFNBQVMsaUJBQWlCO0FBQ3hCLFNBQ0UsZ0JBQUFBLEtBQUMsU0FBSSxXQUFVLFlBQVcsVUFBUSxNQUMvQixjQUFJLFNBQVMsRUFBRSxTQUFTLE1BQU0sU0FBUyxLQUFLLENBQUMsR0FDaEQ7QUFFSjtBQUVBLFNBQVMsaUJBQWlCLFFBQWU7QUFDdkMsUUFBTSxNQUFNLG9CQUFJLEtBQUs7QUFDckIsUUFBTSxjQUFjLElBQUksU0FBUztBQUVqQyxRQUFNLGVBQWUsT0FBTyxJQUFJLFFBQU07QUFBQSxJQUNwQyxHQUFHO0FBQUEsSUFDSCxNQUFNLEtBQUssTUFBTSxPQUFPLEVBQUUsSUFBSSxJQUFJLEdBQUc7QUFBQSxFQUN2QyxFQUFFO0FBRUYsUUFBTSxXQUFXLGFBQWEsVUFBVSxPQUFLLEVBQUUsT0FBTyxXQUFXO0FBRWpFLFFBQU0sUUFBUSxhQUFhLE1BQU0sVUFBVSxXQUFXLENBQUM7QUFDdkQsU0FBTyxNQUFNLFdBQVcsSUFBSSxRQUFRLENBQUMsR0FBRyxPQUFPLEdBQUcsYUFBYSxNQUFNLEdBQUcsSUFBSSxNQUFNLE1BQU0sQ0FBQztBQUMzRjtBQUdBLFNBQVMsaUJBQWlCO0FBQ3hCLFNBQU8sS0FBSyxhQUFhLEVBQUUsR0FBRyxDQUFDLFNBQVM7QUFDdEMsUUFBSSxDQUFDLEtBQU0sUUFBTyxnQkFBQUEsS0FBQyxTQUFJO0FBRXZCLFVBQU0sVUFBVSxLQUFLLFFBQVEsa0JBQWtCLENBQUM7QUFDaEQsVUFBTSxXQUFXLGlCQUFpQixLQUFLLFFBQVEsUUFBUSxDQUFDLEVBQUUsTUFBTTtBQUNoRSxVQUFNLFFBQVEsZ0JBQWdCLFFBQVEsWUFBWSxDQUFDLEVBQUUsS0FBSztBQUUxRCxXQUFPO0FBQUEsTUFBQztBQUFBO0FBQUEsUUFDTixXQUFVO0FBQUEsUUFDVixVQUFRO0FBQUEsUUFDUjtBQUFBLDBCQUFBQTtBQUFBLFlBQUM7QUFBQTtBQUFBLGNBQ0MsV0FBVTtBQUFBLGNBQ1YsS0FBSywwQkFBMEIsd0JBQUcsbUJBQW1CLEtBQUs7QUFBQSxjQUMxRDtBQUFBLGdCQUFDO0FBQUE7QUFBQSxrQkFDQyxXQUFVO0FBQUEsa0JBQ1Y7QUFBQSx5Q0FBQyxTQUFJLFVBQVEsTUFBQyxRQUFRRSxLQUFJLE1BQU0sT0FDOUI7QUFBQSxzQ0FBQUY7QUFBQSx3QkFBQztBQUFBO0FBQUEsMEJBQ0MsV0FBVTtBQUFBLDBCQUNWLFFBQVE7QUFBQSwwQkFDUixRQUFRO0FBQUEsMEJBQ1IsU0FBTztBQUFBLDBCQUNQLE9BQU8sZ0JBQWdCLFFBQVEsWUFBWSxDQUFDLEVBQUUsS0FBSztBQUFBO0FBQUEsc0JBQUc7QUFBQSxzQkFDeEQsZ0JBQUFBO0FBQUEsd0JBQUM7QUFBQTtBQUFBLDBCQUNDLFdBQVU7QUFBQSwwQkFDVixRQUFRO0FBQUEsMEJBQ1IsT0FBTyxRQUFRLFlBQVksQ0FBQyxFQUFFO0FBQUE7QUFBQSxzQkFBTztBQUFBLHVCQUN6QztBQUFBLG9CQUNBLGdCQUFBQSxLQUFDLFNBQUksU0FBTyxNQUFDO0FBQUEsb0JBQ2IscUJBQUMsU0FBSSxVQUFRLE1BQUMsUUFBUUUsS0FBSSxNQUFNLEtBQzlCO0FBQUEsMkNBQUMsU0FBSSxVQUFRLE1BQ1g7QUFBQSx3Q0FBQUY7QUFBQSwwQkFBQztBQUFBO0FBQUEsNEJBQ0MsV0FBVTtBQUFBLDRCQUNWLFFBQVE7QUFBQSw0QkFDUixRQUFRO0FBQUEsNEJBQ1IsT0FBTyxHQUFHLFFBQVEsTUFBTTtBQUFBO0FBQUEsd0JBQUs7QUFBQSx3QkFDL0IsZ0JBQUFBO0FBQUEsMEJBQUM7QUFBQTtBQUFBLDRCQUNDLFdBQVU7QUFBQSw0QkFDVixRQUFRO0FBQUEsNEJBQ1IsUUFBUTtBQUFBLDRCQUNSLFNBQU87QUFBQSw0QkFDUCxPQUFPLGVBQWUsUUFBUSxVQUFVO0FBQUE7QUFBQSx3QkFBSztBQUFBLHlCQUNqRDtBQUFBLHNCQUNBO0FBQUEsd0JBQUM7QUFBQTtBQUFBLDBCQUNDLFdBQVU7QUFBQSwwQkFDVixVQUFRO0FBQUEsMEJBQ1I7QUFBQSw0Q0FBQUEsS0FBQyxXQUFNLFdBQVUsUUFBTyxRQUFRLEdBQUcsT0FBTyxHQUFHLFFBQVEsYUFBYSxnQkFBUztBQUFBLDRCQUMzRSxnQkFBQUEsS0FBQyxXQUFNLFdBQVUsWUFBVyxRQUFRLEdBQUcsT0FBTyxHQUFHLFFBQVEsUUFBUSxlQUFRO0FBQUEsNEJBQ3pFLGdCQUFBQSxLQUFDLFdBQU0sV0FBVSxpQkFBZ0IsUUFBUSxHQUFHLE9BQU8sR0FBRyxRQUFRLFFBQVEsYUFBUTtBQUFBO0FBQUE7QUFBQSxzQkFDaEY7QUFBQSx1QkFDRjtBQUFBO0FBQUE7QUFBQSxjQUNGO0FBQUE7QUFBQSxVQUNGO0FBQUEsVUFDQSxnQkFBQUE7QUFBQSxZQUFDO0FBQUE7QUFBQSxjQUNDLFdBQVU7QUFBQSxjQUNWLGFBQVc7QUFBQSxjQUNWLG1CQUFTLElBQUksT0FDWixxQkFBQyxTQUFJLGFBQWEsR0FBRyxTQUFTLE1BQU0sV0FBVSxjQUFhLFNBQVMsR0FDbEU7QUFBQSxnQ0FBQUEsS0FBQyxXQUFNLE9BQU8sR0FBRyxFQUFFLEtBQUssU0FBUyxFQUFFLFNBQVMsR0FBRyxHQUFHLENBQUMsT0FBTyxXQUFVLFFBQU87QUFBQSxnQkFDM0UsZ0JBQUFBO0FBQUEsa0JBQUM7QUFBQTtBQUFBLG9CQUNDLE9BQU8sZ0JBQWdCLEVBQUUsWUFBWSxDQUFDLEVBQUUsS0FBSztBQUFBLG9CQUM3QyxXQUFVO0FBQUEsb0JBQ1YsYUFBYSxHQUFHLEVBQUUsWUFBWSxDQUFDLEVBQUUsS0FBSyxhQUFRLEVBQUUsUUFBUTtBQUFBO0FBQUEsZ0JBQzFEO0FBQUEsZ0JBQ0EsZ0JBQUFBLEtBQUMsV0FBTSxPQUFPLEdBQUcsRUFBRSxLQUFLLFFBQUssV0FBVSxhQUFZO0FBQUEsaUJBQ3JELENBQ0Q7QUFBQTtBQUFBLFVBQ0g7QUFBQTtBQUFBO0FBQUEsSUFDRjtBQUFBLEVBQ0YsQ0FBQztBQUNIO0FBRWUsU0FBUixZQUE2QixTQUFzQixTQUE0QjtBQUNwRixRQUFNLEVBQUUsTUFBTSxJQUFJLElBQUlHLE9BQU07QUFFNUIsU0FBTyxnQkFBQUg7QUFBQSxJQUFDO0FBQUE7QUFBQSxNQUNOLFdBQVU7QUFBQSxNQUNWLFdBQVU7QUFBQSxNQUNWLFlBQVk7QUFBQSxNQUNaLGFBQWFHLE9BQU0sWUFBWTtBQUFBLE1BQy9CLGFBQWE7QUFBQSxNQUNiLE9BQU9BLE9BQU0sTUFBTTtBQUFBLE1BQ25CLFNBQVMsUUFBUTtBQUFBLE1BQ2pCLFFBQVEsTUFBTTtBQUFBLE1BQ2Q7QUFBQSxRQUFDO0FBQUE7QUFBQSxVQUNDLFNBQU87QUFBQSxVQUNQLFVBQVE7QUFBQSxVQUNSLFdBQVU7QUFBQSxVQUVWO0FBQUEsNEJBQUFILEtBQUMsZUFBWTtBQUFBLFlBQ2IsZ0JBQUFBLEtBQUMsa0JBQWU7QUFBQSxZQUNoQixnQkFBQUEsS0FBQyxrQkFBZTtBQUFBO0FBQUE7QUFBQSxNQUNsQjtBQUFBO0FBQUEsRUFDRjtBQUNGOzs7QUN2SUEsT0FBT0ksYUFBWTs7O0FDQW5CLE9BQU8sWUFBWTtBQUduQixJQUFNLGFBQWEsQ0FBQyxTQUNsQkMsU0FBSyxVQUFVLE1BQU1BLFNBQUssU0FBUyxNQUFNO0FBRTNDLElBQU0sYUFBYSxDQUFDLE1BQWMsU0FBUyxZQUFZQSxTQUFLLFNBQ3pELG9CQUFvQixJQUFJLEVBQ3hCLE9BQU8sTUFBTTtBQUVoQixJQUFNLFVBQVUsQ0FBQyxNQUEyQjtBQUMxQyxRQUFNLEVBQUUsS0FBSyxRQUFRLFNBQVMsSUFBSSxPQUFPO0FBRXpDLFVBQVEsRUFBRSxTQUFTO0FBQUEsSUFDakIsS0FBSztBQUFLLGFBQU87QUFBQSxJQUNqQixLQUFLO0FBQVUsYUFBTztBQUFBLElBQ3RCLEtBQUs7QUFBQSxJQUNMO0FBQVMsYUFBTztBQUFBLEVBQ2xCO0FBQ0Y7QUFRZSxTQUFSLGFBQThCLE9BQWM7QUFDakQsUUFBTSxFQUFFLGNBQWMsR0FBRyxhQUFhLE1BQU0sSUFBSTtBQUNoRCxRQUFNLEVBQUUsT0FBTyxRQUFRLElBQUksSUFBSUMsS0FBSTtBQUVuQyxTQUFPLGdCQUFBQztBQUFBLElBQUM7QUFBQTtBQUFBLE1BQ04sU0FBTztBQUFBLE1BQ1AsV0FBVyxnQkFBZ0IsUUFBUSxDQUFDLENBQUM7QUFBQSxNQUNyQztBQUFBLE1BQ0E7QUFBQSxNQUNBLCtCQUFDLFNBQUksVUFBUSxNQUNYO0FBQUEsNkJBQUMsU0FBSSxXQUFVLFVBQ1g7QUFBQSxhQUFFLFdBQVcsRUFBRSxpQkFBaUIsZ0JBQUFBO0FBQUEsWUFBQztBQUFBO0FBQUEsY0FDakMsV0FBVTtBQUFBLGNBQ1YsU0FBUyxRQUFRLEVBQUUsV0FBVyxFQUFFLFlBQVk7QUFBQSxjQUM1QyxNQUFNLEVBQUUsV0FBVyxFQUFFO0FBQUE7QUFBQSxVQUN2QjtBQUFBLFVBQ0EsZ0JBQUFBO0FBQUEsWUFBQztBQUFBO0FBQUEsY0FDQyxXQUFVO0FBQUEsY0FDVixRQUFRO0FBQUEsY0FDUixVQUFRO0FBQUEsY0FDUixPQUFPLEVBQUUsV0FBVztBQUFBO0FBQUEsVUFDdEI7QUFBQSxVQUNBLGdCQUFBQTtBQUFBLFlBQUM7QUFBQTtBQUFBLGNBQ0MsV0FBVTtBQUFBLGNBQ1YsU0FBTztBQUFBLGNBQ1AsUUFBUTtBQUFBLGNBQ1IsT0FBTyxXQUFXLEVBQUUsSUFBSTtBQUFBO0FBQUEsVUFDMUI7QUFBQSxVQUNBLGdCQUFBQSxLQUFDLFlBQU8sV0FBVyxNQUFNLEVBQUUsUUFBUSxHQUNqQywwQkFBQUEsS0FBQyxVQUFLLE1BQUsseUJBQXdCLEdBQ3JDO0FBQUEsV0FDRjtBQUFBLFFBQ0EsZ0JBQUFBLEtBQUNELEtBQUksV0FBSixFQUFjLFNBQU8sTUFBQztBQUFBLFFBQ3ZCLHFCQUFDLFNBQUksV0FBVSxXQUNaO0FBQUEsWUFBRSxTQUFTLFdBQVcsRUFBRSxLQUFLLEtBQUssZ0JBQUFDO0FBQUEsWUFBQztBQUFBO0FBQUEsY0FDbEMsUUFBUTtBQUFBLGNBQ1IsV0FBVTtBQUFBLGNBQ1YsS0FBSywwQkFBMEIsRUFBRSxLQUFLO0FBQUE7QUFBQSxVQUN4QztBQUFBLFVBQ0MsRUFBRSxTQUFTLE9BQU8sRUFBRSxLQUFLLEtBQUssZ0JBQUFBO0FBQUEsWUFBQztBQUFBO0FBQUEsY0FDOUIsUUFBUTtBQUFBLGNBQ1IsUUFBUTtBQUFBLGNBQ1IsV0FBVTtBQUFBLGNBQ1YsMEJBQUFBLEtBQUMsVUFBSyxNQUFNLEVBQUUsT0FBTyxRQUFNLE1BQUMsUUFBUSxRQUFRLFFBQVEsUUFBUTtBQUFBO0FBQUEsVUFDOUQ7QUFBQSxVQUNBLHFCQUFDLFNBQUksVUFBUSxNQUNYO0FBQUEsNEJBQUFBO0FBQUEsY0FBQztBQUFBO0FBQUEsZ0JBQ0MsV0FBVTtBQUFBLGdCQUNWLFFBQVE7QUFBQSxnQkFDUixRQUFRO0FBQUEsZ0JBQ1IsT0FBTyxFQUFFO0FBQUEsZ0JBQ1QsVUFBUTtBQUFBO0FBQUEsWUFDVjtBQUFBLFlBQ0MsRUFBRSxRQUFRLGdCQUFBQTtBQUFBLGNBQUM7QUFBQTtBQUFBLGdCQUNWLFdBQVU7QUFBQSxnQkFDVixNQUFJO0FBQUEsZ0JBQ0osV0FBVztBQUFBLGdCQUNYLFFBQVE7QUFBQSxnQkFDUixRQUFRO0FBQUEsZ0JBQ1IsT0FBTyxFQUFFO0FBQUE7QUFBQSxZQUNYO0FBQUEsYUFDRjtBQUFBLFdBQ0Y7QUFBQSxRQUNDLEVBQUUsWUFBWSxFQUFFLFNBQVMsS0FBSyxnQkFBQUEsS0FBQyxTQUFJLFdBQVUsV0FDM0MsWUFBRSxZQUFZLEVBQUUsSUFBSSxDQUFDLEVBQUUsT0FBTyxHQUFHLE1BQ2hDLGdCQUFBQTtBQUFBLFVBQUM7QUFBQTtBQUFBLFlBQ0MsU0FBTztBQUFBLFlBQ1AsV0FBVyxNQUFNLEVBQUUsT0FBTyxFQUFFO0FBQUEsWUFDNUIsMEJBQUFBLEtBQUMsV0FBTSxPQUFjLFFBQVEsUUFBUSxTQUFPLE1BQUM7QUFBQTtBQUFBLFFBQy9DLENBQ0QsR0FDSDtBQUFBLFNBQ0Y7QUFBQTtBQUFBLEVBQ0Y7QUFDRjs7O0FEakdBLElBQU0sZ0JBQWdCO0FBS3RCLElBQU0saUJBQU4sTUFBNkM7QUFBQTtBQUFBLEVBRW5DLE1BQStCLG9CQUFJLElBQUk7QUFBQTtBQUFBO0FBQUEsRUFJdkMsTUFBbUMsU0FBUyxDQUFDLENBQUM7QUFBQTtBQUFBLEVBRzlDLFVBQVU7QUFDaEIsU0FBSyxJQUFJLElBQUksQ0FBQyxHQUFHLEtBQUssSUFBSSxPQUFPLENBQUMsQ0FBQztBQUFBLEVBQ3JDO0FBQUEsRUFFQSxjQUFjO0FBQ1osVUFBTSxTQUFTQyxRQUFPLFlBQVk7QUFFbEMsV0FBTyxRQUFRLFlBQVksQ0FBQyxHQUFHLE9BQU87QUFDcEMsV0FBSyxJQUFJLElBQUksYUFBYTtBQUFBLFFBQ3hCLGNBQWMsT0FBTyxpQkFBaUIsRUFBRTtBQUFBO0FBQUE7QUFBQTtBQUFBO0FBQUE7QUFBQSxRQU94QyxhQUFhLE1BQU0sS0FBSyxPQUFPLEVBQUU7QUFBQTtBQUFBO0FBQUE7QUFBQSxRQUtqQyxPQUFPLE1BQU0sUUFBUSxlQUFlLE1BQU07QUFLeEMsZUFBSyxPQUFPLEVBQUU7QUFBQSxRQUNoQixDQUFDO0FBQUEsTUFDSCxDQUFDLENBQUM7QUFBQSxJQUNKLENBQUM7QUFJRCxXQUFPLFFBQVEsWUFBWSxDQUFDLEdBQUcsT0FBTztBQUNwQyxXQUFLLE9BQU8sRUFBRTtBQUFBLElBQ2hCLENBQUM7QUFBQSxFQUNIO0FBQUEsRUFFUSxJQUFJLEtBQWEsT0FBbUI7QUFFMUMsU0FBSyxJQUFJLElBQUksR0FBRyxHQUFHLFFBQVE7QUFDM0IsU0FBSyxJQUFJLElBQUksS0FBSyxLQUFLO0FBQ3ZCLFNBQUssUUFBUTtBQUFBLEVBQ2Y7QUFBQSxFQUVRLE9BQU8sS0FBYTtBQUMxQixTQUFLLElBQUksSUFBSSxHQUFHLEdBQUcsUUFBUTtBQUMzQixTQUFLLElBQUksT0FBTyxHQUFHO0FBQ25CLFNBQUssUUFBUTtBQUFBLEVBQ2Y7QUFBQTtBQUFBLEVBR0EsTUFBTTtBQUNKLFdBQU8sS0FBSyxJQUFJLElBQUk7QUFBQSxFQUN0QjtBQUFBO0FBQUEsRUFHQSxVQUFVLFVBQTZDO0FBQ3JELFdBQU8sS0FBSyxJQUFJLFVBQVUsUUFBUTtBQUFBLEVBQ3BDO0FBQ0Y7QUFFZSxTQUFSLG1CQUFvQyxZQUF5QixTQUE0QjtBQUM5RixRQUFNLEVBQUUsUUFBUSxNQUFNLElBQUlDLE9BQU07QUFDaEMsUUFBTSxTQUFTLElBQUksZUFBZTtBQUVsQyxTQUFPLGdCQUFBQztBQUFBLElBQUM7QUFBQTtBQUFBLE1BQ04sU0FBTztBQUFBLE1BQ1AsV0FBVTtBQUFBLE1BQ1YsV0FBVTtBQUFBLE1BQ1Y7QUFBQSxNQUNBLFNBQVMsS0FBSyxPQUFPLEVBQUUsR0FBRyxPQUFLLENBQUMsQ0FBQztBQUFBLE1BQ2pDLGFBQWFELE9BQU0sWUFBWTtBQUFBLE1BQy9CLGFBQWE7QUFBQSxNQUNiLE9BQU9BLE9BQU0sTUFBTTtBQUFBLE1BQ25CLFFBQVEsU0FBUztBQUFBLE1BQ2pCLDBCQUFBQyxLQUFDLFNBQUksVUFBUSxNQUNWLGVBQUssTUFBTSxHQUNkO0FBQUE7QUFBQSxFQUNGO0FBQ0Y7OztBRWxHQSxPQUFPLFFBQVE7OztBQ0NmLElBQU0sTUFBTSxDQUFDLFNBQWlCLE9BQU8sS0FBSyxpQkFBaUIsSUFBSSxFQUFFLENBQUM7QUFDbEUsSUFBTSxTQUFTLEtBQUssaURBQWlEO0FBTHJFO0FBUUEsSUFBcUIsYUFBckIsY0FBd0NDLFNBQVEsT0FBTztBQUFBLEVBNEJyRCxjQUFjO0FBQ1osVUFBTTtBQXBCUixtQ0FBYSxJQUFJLEtBQUs7QUFDdEIsZ0NBQVUsSUFBSSxLQUFLLEtBQUssSUFBSSxLQUFLLEtBQUs7QUFvQnBDLGdCQUFZLHdCQUF3QixNQUFNLGVBQWUsT0FBTSxNQUFLO0FBQ2xFLFlBQU0sSUFBSSxNQUFNLGNBQWMsQ0FBQztBQUMvQix5QkFBSyxTQUFVLE9BQU8sQ0FBQyxJQUFJLG1CQUFLO0FBQ2hDLFdBQUssT0FBTyxRQUFRO0FBQUEsSUFDdEIsQ0FBQztBQUFBLEVBQ0g7QUFBQSxFQWpDQSxPQUFPLGNBQWM7QUFDbkIsUUFBSSxDQUFDLEtBQUs7QUFDUixXQUFLLFdBQVcsSUFBSSxXQUFXO0FBRWpDLFdBQU8sS0FBSztBQUFBLEVBQ2Q7QUFBQSxFQU1BLElBQUksU0FBUztBQUFFLFdBQU8sbUJBQUs7QUFBQSxFQUFRO0FBQUEsRUFFbkMsSUFBSSxPQUFPLFNBQVM7QUFDbEIsUUFBSSxVQUFVO0FBQ1osZ0JBQVU7QUFFWixRQUFJLFVBQVU7QUFDWixnQkFBVTtBQUVaLGNBQVUscUJBQXFCLEtBQUssTUFBTSxVQUFVLEdBQUcsQ0FBQyxNQUFNLEVBQUUsS0FBSyxNQUFNO0FBQ3pFLHlCQUFLLFNBQVU7QUFDZixXQUFLLE9BQU8sUUFBUTtBQUFBLElBQ3RCLENBQUM7QUFBQSxFQUNIO0FBVUY7QUEzQkU7QUFDQTtBQVRBLGNBRG1CLFlBQ1o7QUFZSDtBQUFBLEVBREgsU0FBUyxNQUFNO0FBQUEsR0FaRyxXQWFmO0FBYmUsYUFBckI7QUFBQSxFQURDLFNBQVMsRUFBRSxXQUFXLGFBQWEsQ0FBQztBQUFBLEdBQ2hCOzs7QURBckIsU0FBUyxpQkFBaUIsRUFBRSxRQUFRLEdBQW1DO0FBQ3JFLFFBQU0sYUFBYSxXQUFXLFlBQVk7QUFDMUMsUUFBTSxVQUFVLEdBQUcsWUFBWSxFQUFHLG9CQUFvQjtBQUV0RCxRQUFNLFdBQVcsaUJBQVMsRUFBRTtBQUM1QixRQUFNLFFBQVEsaUJBQVMsQ0FBQztBQUV4QixNQUFJLFFBQVE7QUFDWixXQUFTLEtBQUssR0FBVyxNQUFjO0FBQ3JDLFlBQVEsSUFBSSxJQUFJO0FBQ2hCLFVBQU0sSUFBSSxDQUFDO0FBQ1gsYUFBUyxJQUFJLElBQUk7QUFDakI7QUFDQSxZQUFRLEtBQU0sTUFBTTtBQUNsQjtBQUNBLFVBQUksVUFBVSxFQUFHLFNBQVEsSUFBSSxLQUFLO0FBQUEsSUFDcEMsQ0FBQztBQUFBLEVBQ0g7QUFFQSxTQUNFLGdCQUFBQztBQUFBLElBQUM7QUFBQTtBQUFBLE1BQ0MsT0FBTyxDQUFDLFNBQVM7QUFDZixhQUFLO0FBQUEsVUFBSztBQUFBLFVBQVk7QUFBQSxVQUFrQixNQUN0QyxLQUFLLFdBQVcsUUFBUSw2QkFBNkI7QUFBQSxRQUN2RDtBQUVBLFlBQUksU0FBUztBQUNYLGVBQUs7QUFBQSxZQUFLO0FBQUEsWUFBUztBQUFBLFlBQWtCLE1BQ25DLEtBQUssUUFBUSxRQUFRLFFBQVEsVUFBVTtBQUFBLFVBQ3pDO0FBQUEsUUFDRjtBQUVBLGFBQUs7QUFBQSxVQUFLO0FBQUEsVUFBZTtBQUFBLFVBQWtCLE1BQ3pDLEtBQUssY0FBYyxRQUFRLFNBQVM7QUFBQSxRQUN0QztBQUFBLE1BQ0Y7QUFBQSxNQUNBLCtCQUFDLFNBQUksVUFBUSxNQUFDLFdBQVUsT0FDdEI7QUFBQSx3QkFBQUEsS0FBQyxVQUFLLE1BQU0sU0FBUyxHQUFFO0FBQUEsUUFDdkIsZ0JBQUFBO0FBQUEsVUFBQztBQUFBO0FBQUEsWUFDQyxRQUFRQyxLQUFJLE1BQU07QUFBQSxZQUNsQixlQUFlO0FBQUEsWUFDZixjQUFjO0FBQUEsWUFDZCxVQUFRO0FBQUEsWUFDUixVQUFRO0FBQUEsWUFDUixPQUFPLE1BQU07QUFBQTtBQUFBLFFBQ2Y7QUFBQSxRQUNBLGdCQUFBRCxLQUFDLFdBQU0sT0FBTyxNQUFNLE9BQUssR0FBRyxLQUFLLE1BQU0sSUFBSSxHQUFHLENBQUMsR0FBRyxHQUFHO0FBQUEsU0FDdkQ7QUFBQTtBQUFBLEVBQ0Y7QUFFSjtBQUVlLFNBQVIsSUFBcUIsU0FBc0I7QUFDaEQsUUFBTSxVQUFVLGlCQUFTLEtBQUs7QUFFOUIsU0FDRSxnQkFBQUE7QUFBQSxJQUFDO0FBQUE7QUFBQSxNQUNDLFlBQVk7QUFBQSxNQUNaLFdBQVU7QUFBQSxNQUNWLFdBQVU7QUFBQSxNQUNWLGFBQWE7QUFBQSxNQUNiLFNBQVMsUUFBUTtBQUFBLE1BQ2pCLE9BQU9FLE9BQU0sTUFBTTtBQUFBLE1BQ25CLFFBQVFBLE9BQU0sYUFBYTtBQUFBLE1BRTNCLDBCQUFBRixLQUFDLGNBQVMsU0FBUyxNQUFNLFFBQVEsSUFBSSxLQUFLLEdBQ3hDLDBCQUFBQSxLQUFDLG9CQUFpQixTQUFrQixHQUN0QztBQUFBO0FBQUEsRUFDRjtBQUVKOzs7QUUzRUEsT0FBT0csZ0JBQWU7QUFDdEIsT0FBT0MsWUFBVztBQUNsQixPQUFPQyxjQUFhO0FBQ3BCLE9BQU9DLGFBQVk7OztBQ0FuQixTQUFTLFVBQVUsUUFBZ0I7QUFDakMsUUFBTSxNQUFNLEtBQUssTUFBTSxTQUFTLEVBQUU7QUFDbEMsUUFBTSxNQUFNLEtBQUssTUFBTSxTQUFTLEVBQUU7QUFDbEMsUUFBTSxPQUFPLE1BQU0sS0FBSyxNQUFNO0FBQzlCLFNBQU8sR0FBRyxHQUFHLElBQUksSUFBSSxHQUFHLEdBQUc7QUFDN0I7QUFFZSxTQUFSLFlBQTZCLFFBQXNCO0FBQ3hELFFBQU0sZUFBZSxpQkFBa0IsS0FBSztBQUU1QyxRQUFNLFdBQVcsS0FBSyxRQUFRLFVBQVUsRUFBRSxHQUFHLE9BQzNDLDBCQUEwQixDQUFDLElBQUk7QUFFakMsUUFBTSxXQUFXLEtBQUssUUFBUSxnQkFBZ0IsRUFBRSxHQUFHLE9BQ2pELE1BQU0sSUFBSSxjQUFPLFdBQUk7QUFFdkIsUUFBTSxXQUFXLEtBQUssUUFBUSxVQUFVLEVBQUUsR0FBRyxPQUFLLE9BQU8sU0FBUyxJQUM5RCxJQUFJLE9BQU8sU0FBUyxDQUFDO0FBRXpCLFdBQVMsY0FBYztBQUNyQixXQUFPLHFCQUFDLFNBQUksVUFBUSxNQUFDLFNBQU8sTUFDMUI7QUFBQSxzQkFBQUM7QUFBQSxRQUFDO0FBQUE7QUFBQSxVQUNDLFdBQVU7QUFBQSxVQUNWLFVBQVE7QUFBQSxVQUNSLGVBQWU7QUFBQSxVQUNmLFFBQVFDLEtBQUksTUFBTTtBQUFBLFVBQ2xCLFFBQVFBLEtBQUksTUFBTTtBQUFBLFVBQ2xCLE9BQU8sS0FBSyxRQUFRLFVBQVUsRUFBRSxHQUFHLE1BQU0sR0FBRyxPQUFPLEtBQUssRUFBRTtBQUFBO0FBQUEsTUFBRztBQUFBLE1BQy9ELGdCQUFBRDtBQUFBLFFBQUM7QUFBQTtBQUFBLFVBQ0MsV0FBVTtBQUFBLFVBQ1YsU0FBTztBQUFBLFVBQ1AsUUFBUUMsS0FBSSxNQUFNO0FBQUEsVUFDbEIsUUFBUUEsS0FBSSxNQUFNO0FBQUEsVUFDbEIsT0FBTyxLQUFLLFFBQVEsVUFBVSxFQUFFLEdBQUcsTUFBTTtBQUN2QyxnQkFBSSxPQUFPLE9BQVEsUUFBTyxHQUFHLE9BQU8sTUFBTTtBQUMxQyxnQkFBSSxPQUFPLE1BQU8sUUFBTyxHQUFHLE9BQU8sS0FBSztBQUN4QyxtQkFBTztBQUFBLFVBQ1QsQ0FBQztBQUFBO0FBQUEsTUFBRztBQUFBLE9BQ1I7QUFBQSxFQUNGO0FBRUEsV0FBUyxXQUFXO0FBQ2xCLFdBQU8sZ0JBQUFEO0FBQUEsTUFBQztBQUFBO0FBQUEsUUFDTixhQUFhLEtBQUssWUFBWTtBQUFBLFFBQzlCLGdCQUFnQkMsS0FBSSx1QkFBdUI7QUFBQSxRQUMzQywrQkFBQyxTQUFJLFVBQVEsTUFBQyxXQUFVLFlBQ3RCO0FBQUEsK0JBQUMsU0FDQztBQUFBLDRCQUFBRDtBQUFBLGNBQUM7QUFBQTtBQUFBLGdCQUNDLFFBQVFDLEtBQUksTUFBTTtBQUFBLGdCQUNsQixTQUFTLEtBQUssUUFBUSxRQUFRLEVBQUUsR0FBRyxPQUFLLElBQUksQ0FBQztBQUFBLGdCQUM3QyxPQUFPLEtBQUssUUFBUSxVQUFVLEVBQUUsR0FBRyxTQUFTO0FBQUE7QUFBQSxZQUM5QztBQUFBLFlBQ0EsZ0JBQUFEO0FBQUEsY0FBQztBQUFBO0FBQUEsZ0JBQ0MsU0FBTztBQUFBLGdCQUNQLFFBQVFDLEtBQUksTUFBTTtBQUFBLGdCQUNsQixTQUFTLEtBQUssUUFBUSxRQUFRLEVBQUUsR0FBRyxPQUFLLElBQUksQ0FBQztBQUFBLGdCQUM3QyxPQUFPLEtBQUssUUFBUSxRQUFRLEVBQUUsR0FBRyxPQUFLLElBQUksSUFBSSxNQUFNLFVBQVUsQ0FBQyxDQUFDLEtBQUssU0FBUztBQUFBO0FBQUEsWUFDaEY7QUFBQSxhQUNGO0FBQUEsVUFDQSxnQkFBQUQ7QUFBQSxZQUFDO0FBQUE7QUFBQSxjQUNDLFNBQVMsS0FBSyxRQUFRLFFBQVEsRUFBRSxHQUFHLE9BQUssSUFBSSxDQUFDO0FBQUEsY0FDN0MsV0FBVyxDQUFDLEVBQUUsTUFBTSxNQUFNLE9BQU8sV0FBVyxRQUFRLE9BQU87QUFBQSxjQUMzRCxPQUFPO0FBQUE7QUFBQSxVQUNUO0FBQUEsV0FDRjtBQUFBO0FBQUEsSUFDRjtBQUFBLEVBQ0Y7QUFFQSxXQUFTLFVBQVU7QUFDakIsV0FBTztBQUFBLE1BQUM7QUFBQTtBQUFBLFFBQ04sV0FBVTtBQUFBLFFBQ1YsYUFBVztBQUFBLFFBQ1gsVUFBUTtBQUFBLFFBQ1I7QUFBQSwwQkFBQUE7QUFBQSxZQUFDO0FBQUE7QUFBQSxjQUNDLE9BQU07QUFBQSxjQUNOLFdBQVcsTUFBTSxPQUFPLFNBQVM7QUFBQTtBQUFBLFVBQ25DO0FBQUEsVUFDQSxnQkFBQUE7QUFBQSxZQUFDO0FBQUE7QUFBQSxjQUNDLE9BQU87QUFBQSxjQUNQLFNBQVMsTUFBTSxPQUFPLFdBQVc7QUFBQTtBQUFBLFVBQ25DO0FBQUEsVUFDQSxnQkFBQUE7QUFBQSxZQUFDO0FBQUE7QUFBQSxjQUNDLE9BQU07QUFBQSxjQUNOLFdBQVcsTUFBTSxPQUFPLEtBQUs7QUFBQTtBQUFBLFVBQy9CO0FBQUE7QUFBQTtBQUFBLElBQ0Y7QUFBQSxFQUNGO0FBRUEsU0FBTyxnQkFBQUE7QUFBQSxJQUFDO0FBQUE7QUFBQSxNQUNOLFNBQVMsTUFBTSxhQUFhLElBQUksSUFBSTtBQUFBLE1BQ3BDLGFBQWEsTUFBTSxhQUFhLElBQUksS0FBSztBQUFBLE1BQ3pDLCtCQUFDLFNBQUksV0FBVSxlQUNiO0FBQUEsd0JBQUFBO0FBQUEsVUFBQztBQUFBO0FBQUEsWUFDQyxXQUFVO0FBQUEsWUFDVixTQUFPO0FBQUEsWUFDUCxjQUFjO0FBQUEsWUFDZCxLQUFLO0FBQUEsWUFDTDtBQUFBLGNBQUM7QUFBQTtBQUFBLGdCQUNDLFdBQVU7QUFBQSxnQkFDVixVQUFRO0FBQUEsZ0JBQ1I7QUFBQSxrQ0FBQUEsS0FBQyxlQUFZO0FBQUEsa0JBQ2IsZ0JBQUFBLEtBQUMsWUFBUztBQUFBO0FBQUE7QUFBQSxZQUNaO0FBQUE7QUFBQSxRQUNGO0FBQUEsUUFDQSxnQkFBQUEsS0FBQyxXQUFRO0FBQUEsU0FDWDtBQUFBO0FBQUEsRUFDRjtBQUNGOzs7QURwR0EsU0FBUyxhQUFhO0FBQ3BCLFFBQU0sV0FBVyxLQUFLLFFBQVE7QUFDOUIsUUFBTSxVQUFVLEdBQUcsd0JBQUc7QUFFdEIsU0FBTztBQUFBLElBQUM7QUFBQTtBQUFBLE1BQ04sV0FBVTtBQUFBLE1BQ1Y7QUFBQSx3QkFBQUUsS0FBQyxTQUFJLFdBQVUsV0FBVSxLQUFLLDBCQUEwQixPQUFPLE1BQU07QUFBQSxRQUNyRSxxQkFBQyxTQUFJLFVBQVEsTUFBQyxRQUFRQyxLQUFJLE1BQU0sUUFDOUI7QUFBQSwwQkFBQUQsS0FBQyxXQUFNLFdBQVUsWUFBVyxPQUFPLFVBQVUsUUFBUUMsS0FBSSxNQUFNLE9BQU87QUFBQSxVQUN0RSxnQkFBQUQsS0FBQyxXQUFNLFdBQVUsVUFBUyxPQUFPLE9BQU8sR0FBRyxRQUFRQyxLQUFJLE1BQU0sT0FBTztBQUFBLFdBQ3RFO0FBQUE7QUFBQTtBQUFBLEVBQ0Y7QUFDRjtBQUVBLFNBQVMsY0FBYyxNQUFjLE1BQWMsUUFBZ0I7QUFDakUsU0FDRSxxQkFBQyxTQUNDO0FBQUEsb0JBQUFELEtBQUMsV0FBTSxXQUFVLFFBQU8sT0FBTyxNQUFNO0FBQUEsSUFDckM7QUFBQSxNQUFDO0FBQUE7QUFBQSxRQUNDLFdBQVU7QUFBQSxRQUNWLFVBQVE7QUFBQSxRQUNSLFFBQVFDLEtBQUksTUFBTTtBQUFBLFFBQ2xCO0FBQUEsMEJBQUFELEtBQUMsV0FBTSxRQUFRQyxLQUFJLE1BQU0sT0FBTyxPQUFPLE1BQU07QUFBQSxVQUM3QyxnQkFBQUQsS0FBQyxXQUFNLFFBQVFDLEtBQUksTUFBTSxPQUFPLE9BQU8sUUFBUTtBQUFBO0FBQUE7QUFBQSxJQUNqRDtBQUFBLEtBQ0Y7QUFFSjtBQUVBLFNBQVMsYUFBYTtBQUNwQixRQUFNLFVBQVVDLFNBQVEsWUFBWTtBQUVwQyxTQUNFLGdCQUFBRixLQUFDLFNBQUksV0FBVSxRQUFPLFFBQVFDLEtBQUksTUFBTSxRQUNyQyxlQUFLLFNBQVMsTUFBTSxFQUFFO0FBQUEsSUFBRyxVQUFRLGdCQUFBRCxLQUFDLFNBQ2hDLGVBQUssTUFBTSxTQUFTLEVBQUUsR0FBRyxhQUFXO0FBQ25DLFlBQU0sT0FBTyxLQUFLLE1BQU0sVUFBVSxFQUFFLEdBQUcsV0FBVztBQUNsRCxZQUFNLE9BQU8sVUFDVCxLQUFLLE1BQU0sTUFBTSxFQUFFLEdBQUcsVUFBUSxRQUFRLE1BQU0sSUFDNUM7QUFDSixZQUFNLFNBQVMsVUFBVSxPQUFPO0FBQ2hDLGFBQ0UsZ0JBQUFBO0FBQUEsUUFBQztBQUFBO0FBQUEsVUFDQyxXQUFXLFVBQVUsWUFBWTtBQUFBLFVBQ2pDLFdBQVcsTUFBTSxLQUFLLFlBQVksQ0FBQyxPQUFPO0FBQUEsVUFDekMsd0JBQWMsTUFBTSxNQUFNLE1BQU07QUFBQTtBQUFBLE1BQ25DO0FBQUEsSUFFSixDQUFDLEdBQ0g7QUFBQSxFQUNBLEdBQ0Y7QUFFSjtBQUVBLFNBQVNHLG1CQUFrQjtBQUN6QixRQUFNLFlBQVlDLFdBQVUsWUFBWTtBQUV4QyxXQUFTLG1CQUFtQixTQUFrQjtBQUM1QyxlQUFXLFVBQVUsVUFBVSxZQUFZLEdBQUc7QUFDNUMsVUFBSSxPQUFPLFdBQVc7QUFDcEIsY0FBTUMsUUFBTyxPQUFPO0FBQ3BCLGNBQU1DLFVBQVMsS0FBSyxRQUFRLG1CQUFtQixFQUFFLEdBQUcsT0FDbEQsSUFBSSxJQUFJLEdBQUcsS0FBSyxNQUFNLElBQUksR0FBRyxDQUFDLE1BQU0sVUFBVSxPQUFPLEtBQUs7QUFDNUQsZUFBTyxFQUFFLE1BQUFELE9BQU0sUUFBQUMsUUFBTztBQUFBLE1BQ3hCO0FBQUEsSUFDRjtBQUNBLFVBQU0sT0FBTztBQUNiLFVBQU0sU0FBUyxVQUFVLE9BQU87QUFDaEMsV0FBTyxFQUFFLE1BQU0sT0FBTztBQUFBLEVBQ3hCO0FBRUEsU0FBTyxnQkFBQU4sS0FBQyxTQUFJLFdBQVUsYUFBWSxRQUFRQyxLQUFJLE1BQU0sUUFDakQsZUFBSyxXQUFXLFdBQVcsRUFBRSxHQUFHLGFBQy9CLGdCQUFBRDtBQUFBLElBQUM7QUFBQTtBQUFBLE1BQ0MsV0FBVyxVQUFVLFlBQVk7QUFBQSxNQUNqQyxXQUFXLE1BQU0sS0FBSyx5QkFBeUI7QUFBQSxNQUM5QyxlQUFLLFdBQVcsYUFBYSxFQUFFLEdBQUcsVUFBUTtBQUN6QyxjQUFNLE9BQU8sT0FBTyxjQUFPO0FBQzNCLGNBQU0sRUFBRSxNQUFNLE9BQU8sSUFBSSxtQkFBbUIsT0FBTztBQUNuRCxlQUFPLGNBQWMsTUFBTSxNQUFNLE1BQU07QUFBQSxNQUN6QyxDQUFDO0FBQUE7QUFBQSxFQUNILENBQ0QsR0FDSDtBQUNGO0FBRUEsU0FBUyxxQkFBcUI7QUFDNUIsUUFBTSxPQUFPO0FBQ2IsUUFBTSxPQUFPO0FBQ2IsU0FBTyxLQUFLLFlBQVksRUFBRSxHQUFHLFNBQU87QUFDbEMsVUFBTSxTQUFTLE1BQU0sT0FBTztBQUM1QixXQUNFLGdCQUFBQTtBQUFBLE1BQUM7QUFBQTtBQUFBLFFBQ0MsV0FBVTtBQUFBLFFBQ1YsUUFBUUMsS0FBSSxNQUFNO0FBQUEsUUFDbEIsMEJBQUFEO0FBQUEsVUFBQztBQUFBO0FBQUEsWUFDQyxXQUFXLE1BQU0sWUFBWTtBQUFBLFlBQzdCLFdBQVcsTUFBTSxhQUFhLElBQUksQ0FBQyxHQUFHO0FBQUEsWUFDckMsd0JBQWMsTUFBTSxNQUFNLE1BQU07QUFBQTtBQUFBLFFBQ25DO0FBQUE7QUFBQSxJQUNGO0FBQUEsRUFFSixDQUFDO0FBQ0g7QUFFQSxTQUFTLG1CQUFtQjtBQUMxQixNQUFJLGtCQUFrQixJQUFJLEdBQUc7QUFDM0IsY0FBVSxxQkFBcUI7QUFDL0Isc0JBQWtCLElBQUksS0FBSztBQUFBLEVBQzdCLE9BQU87QUFDTCxjQUFVLG9CQUFvQjtBQUM5QixzQkFBa0IsSUFBSSxJQUFJO0FBQUEsRUFDNUI7QUFDRjtBQUVBLFNBQVMsbUJBQW1CO0FBQzFCLFFBQU0sT0FBTztBQUNiLFNBQU8sS0FBSyxpQkFBaUIsRUFBRSxHQUFHLGFBQVc7QUFDM0MsVUFBTSxPQUFPLFVBQVUsY0FBTztBQUM5QixVQUFNLFNBQVMsVUFBVSxPQUFPO0FBQ2hDLFdBQ0UsZ0JBQUFBO0FBQUEsTUFBQztBQUFBO0FBQUEsUUFDQyxXQUFVO0FBQUEsUUFDVixRQUFRQyxLQUFJLE1BQU07QUFBQSxRQUNsQiwwQkFBQUQ7QUFBQSxVQUFDO0FBQUE7QUFBQSxZQUNDLFdBQVcsVUFBVSxZQUFZO0FBQUEsWUFDakMsV0FBVztBQUFBLFlBQ1Ysd0JBQWMsTUFBTSxNQUFNLE1BQU07QUFBQTtBQUFBLFFBQ25DO0FBQUE7QUFBQSxJQUNGO0FBQUEsRUFFSixDQUFDO0FBQ0g7QUFFQSxTQUFTLG1CQUFtQjtBQUMxQixRQUFNLFNBQVNPLFFBQU8sWUFBWTtBQUVsQyxTQUFPLGdCQUFBUCxLQUFDLFNBQUksV0FBVSxvQkFDbkIsZUFBSyxRQUFRLGVBQWUsRUFBRSxHQUFHLFlBQVU7QUFDMUMsVUFBTSxVQUFVLE9BQU87QUFDdkIsd0JBQW9CLElBQUksT0FBTztBQUMvQixVQUFNLFlBQVksVUFBVSxJQUFJLE1BQU07QUFDdEMsV0FBTztBQUFBLE1BQUM7QUFBQTtBQUFBLFFBQUksVUFBUTtBQUFBLFFBQ2xCLGVBQWU7QUFBQSxRQUNmLGNBQWM7QUFBQSxRQUVkO0FBQUEsK0JBQUMsU0FDQztBQUFBLDRCQUFBQSxLQUFDLFdBQU0sV0FBVSxTQUFRLE9BQU0saUJBQWdCO0FBQUEsWUFDL0MsZ0JBQUFBO0FBQUEsY0FBQztBQUFBO0FBQUEsZ0JBQ0MsV0FBVTtBQUFBLGdCQUNWLFFBQVFDLEtBQUksTUFBTTtBQUFBLGdCQUNsQixTQUFPO0FBQUEsZ0JBQ1AsT0FBTTtBQUFBLGdCQUNOLFdBQVcsTUFBTSxPQUFPLFFBQVEsT0FBSyxFQUFFLFFBQVEsQ0FBQztBQUFBO0FBQUEsWUFDbEQ7QUFBQSxhQUNGO0FBQUEsVUFDQyxVQUFVLElBQ1QsZ0JBQUFELEtBQUMsZ0JBQVcsU0FBTyxNQUNqQiwwQkFBQUEsS0FBQyxTQUFJLFVBQVEsTUFDVixpQkFBTyxRQUFRLEVBQUUsSUFBSSxPQUFLO0FBQ3pCLG1CQUFPLGFBQWE7QUFBQSxjQUNsQixjQUFjO0FBQUEsY0FDZCxPQUFPLE1BQU07QUFBQSxjQUFFO0FBQUEsY0FDZixhQUFhLE1BQU07QUFBQSxjQUFFO0FBQUEsWUFDdkIsQ0FBQztBQUFBLFVBQ0gsQ0FBQyxHQUNILEdBQ0YsSUFFQTtBQUFBLFlBQUM7QUFBQTtBQUFBLGNBQ0MsV0FBVTtBQUFBLGNBQ1YsU0FBTztBQUFBLGNBQ1AsU0FBTztBQUFBLGNBQ1AsVUFBUTtBQUFBLGNBQ1IsUUFBUUMsS0FBSSxNQUFNO0FBQUEsY0FFbEI7QUFBQSxnQ0FBQUQsS0FBQyxXQUFNLE9BQU0sYUFBSyxXQUFVLFFBQU87QUFBQSxnQkFDbkMsZ0JBQUFBLEtBQUMsV0FBTSxPQUFNLHVCQUFzQjtBQUFBO0FBQUE7QUFBQSxVQUNyQztBQUFBO0FBQUE7QUFBQSxJQUVKO0FBQUEsRUFDRixDQUFDLEdBQ0g7QUFDRjtBQUVBLFNBQVMseUJBQXlCO0FBQ2hDLFFBQU0sUUFBUVEsT0FBTSxZQUFZO0FBQ2hDLFFBQU0sZ0JBQWdCLFNBQVMsQ0FBQztBQUNoQyxRQUFNLGdCQUFnQixTQUFTLENBQUM7QUFFaEMsU0FDRSxnQkFBQVI7QUFBQSxJQUFDO0FBQUE7QUFBQSxNQUNDLFVBQVUsQ0FBQyxHQUFHLFVBQVU7QUFDdEIsY0FBTSxVQUFVLE1BQU07QUFDdEIsY0FBTSxVQUFVLGNBQWMsSUFBSTtBQUNsQyxjQUFNLE1BQU0sY0FBYyxJQUFJLElBQUk7QUFFbEMsWUFBSSxVQUFVLEdBQUc7QUFDZixjQUFJLFVBQVUsSUFBSyxlQUFjLElBQUksVUFBVSxDQUFDO0FBQUEsUUFDbEQsT0FBTztBQUNMLGNBQUksVUFBVSxFQUFHLGVBQWMsSUFBSSxVQUFVLENBQUM7QUFBQSxRQUNoRDtBQUFBLE1BQ0Y7QUFBQSxNQUVDLGVBQUssT0FBTyxTQUFTLEVBQUUsR0FBRyxRQUFNO0FBQy9CLHNCQUFjLElBQUksR0FBRyxNQUFNO0FBQzNCLFlBQUksR0FBRyxTQUFTLEVBQUcsUUFDakIscUJBQUMsU0FBSSxVQUFRLE1BQ1g7QUFBQSwwQkFBQUE7QUFBQSxZQUFDO0FBQUE7QUFBQSxjQUNDLGdCQUFnQkMsS0FBSSxvQkFBb0I7QUFBQSxjQUN4QyxvQkFBb0I7QUFBQSxjQUNwQixrQkFBa0IsS0FBSyxhQUFhLEVBQUUsR0FBRyxhQUFXLEdBQUcsT0FBTyxFQUFFLEtBQUs7QUFBQSxjQUNwRSxhQUFHLElBQUksWUFBVTtBQUNoQix1QkFBTyxnQkFBQUQsS0FBQyxTQUFJLE1BQU0sT0FBTyxPQUN0QixzQkFBWSxNQUFNLEdBQ3JCO0FBQUEsY0FDRixDQUFDO0FBQUE7QUFBQSxVQUNIO0FBQUEsVUFDQSxnQkFBQUE7QUFBQSxZQUFDO0FBQUE7QUFBQSxjQUNDLFdBQVU7QUFBQSxjQUNWLFFBQVFDLEtBQUksTUFBTTtBQUFBLGNBQ2xCLFNBQVMsR0FBRyxTQUFTLElBQUksT0FBTztBQUFBLGNBRS9CLGFBQUcsSUFBSSxZQUNOLGdCQUFBRDtBQUFBLGdCQUFDO0FBQUE7QUFBQSxrQkFDQyxXQUFXLEtBQUssYUFBYSxFQUFFO0FBQUEsb0JBQUcsYUFDaEMsR0FBRyxPQUFPLEVBQUUsU0FBUyxPQUFPLFFBQ3hCLFlBQ0E7QUFBQSxrQkFDTjtBQUFBLGtCQUNBLFdBQVcsTUFBTSxjQUFjLElBQUksR0FBRyxRQUFRLE1BQU0sQ0FBQztBQUFBLGtCQUNyRCwwQkFBQUEsS0FBQyxVQUFLLE1BQU0sT0FBTyxNQUFNLFFBQVEsT0FBTyxhQUFhLEdBQUc7QUFBQTtBQUFBLGNBQzFELENBQ0Q7QUFBQTtBQUFBLFVBQ0g7QUFBQSxXQUNGO0FBQ0YsZUFBTyxnQkFBQUEsS0FBQyxTQUFJO0FBQUEsTUFDZCxDQUFDO0FBQUE7QUFBQSxFQUNIO0FBRUo7QUFFQSxTQUFTLHdCQUF3QjtBQUMvQixRQUFNLFlBQVlJLFdBQVUsWUFBWTtBQUN4QyxRQUFNLFVBQVUsVUFBVTtBQUMxQixXQUFTLFNBQVMsUUFBMEI7QUFDMUMsUUFBSSxPQUFPLFNBQVMsS0FBTSxRQUFPLGdCQUFBSixLQUFDLFNBQUc7QUFDckMsVUFBTSxpQkFBaUIsU0FBUztBQUFBLE1BQzVCLENBQUMsS0FBSyxRQUFRLFdBQVcsR0FBRyxLQUFLLFFBQVEsUUFBUSxDQUFDO0FBQUEsTUFDbEQsQ0FBQyxXQUFXLFdBQVc7QUFDbkIsZUFBTyxhQUFhO0FBQUEsTUFDeEI7QUFBQSxJQUNKO0FBQ0EsVUFBTSxVQUFVLEtBQUssUUFBUSxtQkFBbUIsRUFBRSxHQUFHLE9BQ25ELElBQUksSUFBSSxLQUFLLEtBQUssTUFBTSxJQUFJLEdBQUcsQ0FBQyxPQUFPLEVBQUU7QUFDM0MsV0FBTyxxQkFBQyxTQUFJLFdBQVUsUUFDcEI7QUFBQSwyQkFBQyxTQUNDO0FBQUEsd0JBQUFBLEtBQUMsVUFBSyxNQUFNLE9BQU8sUUFBUSxnQkFBZ0I7QUFBQSxRQUMzQyxxQkFBQyxTQUFJLFVBQVEsTUFDWDtBQUFBLCtCQUFDLFNBQUksUUFBUUMsS0FBSSxNQUFNLE9BQ3JCO0FBQUEsNEJBQUFELEtBQUMsV0FBTSxPQUFPLE9BQU8sTUFBTSxXQUFVLFFBQU87QUFBQSxZQUM1QyxnQkFBQUEsS0FBQyxXQUFNLE9BQU8sU0FBUyxXQUFVLFdBQVU7QUFBQSxhQUM3QztBQUFBLFVBQ0EsZ0JBQUFBO0FBQUEsWUFBQztBQUFBO0FBQUEsY0FDQyxTQUFTLGVBQWU7QUFBQSxjQUN4QixXQUFVO0FBQUEsY0FDVixRQUFRQyxLQUFJLE1BQU07QUFBQSxjQUNsQixPQUFPLEtBQUssUUFBUSxXQUFXLEVBQUUsR0FBRyxVQUFRLE9BQU8sY0FBYyxRQUFRO0FBQUE7QUFBQSxVQUMzRTtBQUFBLFdBQ0Y7QUFBQSxTQUNGO0FBQUEsTUFDQSxnQkFBQUQsS0FBQyxTQUFJLFNBQU8sTUFBQztBQUFBLE1BQ2IsZ0JBQUFBLEtBQUMsU0FBSSxXQUFVLFdBQ2IsMEJBQUFBO0FBQUEsUUFBQztBQUFBO0FBQUEsVUFDQyxPQUFNO0FBQUEsVUFDTixXQUFXLE1BQU07QUFDZixnQkFBSSxPQUFPLGNBQWMsR0FBRztBQUMxQixxQkFBTyxrQkFBa0IsQ0FBQyxRQUFRLFFBQVEsSUFBSSxHQUFHLENBQUM7QUFBQSxZQUNwRCxPQUFPO0FBQ0wscUJBQU8sZUFBZSxDQUFDLFFBQVEsUUFBUSxJQUFJLEdBQUcsQ0FBQztBQUFBLFlBQ2pEO0FBQUEsVUFDRjtBQUFBO0FBQUEsTUFDRixHQUNGO0FBQUEsT0FDRjtBQUFBLEVBQ0Y7QUFFQSxTQUFPO0FBQUEsSUFBQztBQUFBO0FBQUEsTUFDTixNQUFLO0FBQUEsTUFDTCxXQUFVO0FBQUEsTUFDVixVQUFRO0FBQUEsTUFFUjtBQUFBLDZCQUFDLFNBQ0M7QUFBQSwwQkFBQUEsS0FBQyxXQUFNLE9BQU0sYUFBWSxXQUFVLFNBQVE7QUFBQSxVQUMzQyxnQkFBQUEsS0FBQyxTQUFJLFNBQU8sTUFBQztBQUFBLFVBQ2IsZ0JBQUFBO0FBQUEsWUFBQztBQUFBO0FBQUEsY0FDQyxXQUFVO0FBQUEsY0FDVixLQUFLLEtBQUssU0FBUyxhQUFhLEVBQUU7QUFBQSxnQkFBRyxVQUNuQyxPQUFPLG9CQUNBO0FBQUEsY0FDVDtBQUFBLGNBQ0EsT0FBTTtBQUFBLGNBQ04sYUFBYSxLQUFLLFNBQVMsYUFBYSxFQUFFLEdBQUcsVUFBUSxPQUFPLGdCQUFnQixVQUFVO0FBQUEsY0FDdEYsV0FBVyxNQUFNO0FBQ2Ysb0JBQUksUUFBUSxnQkFBZ0IsR0FBRztBQUM3QiwwQkFBUSxlQUFlO0FBQUEsZ0JBQ3pCLE9BQU87QUFDTCwwQkFBUSxnQkFBZ0I7QUFBQSxnQkFDMUI7QUFBQSxjQUNGO0FBQUE7QUFBQSxVQUVGO0FBQUEsVUFDQSxnQkFBQUE7QUFBQSxZQUFDO0FBQUE7QUFBQSxjQUNDLFFBQVEsS0FBSyxXQUFXLFdBQVc7QUFBQSxjQUNuQyxvQkFBb0IsTUFBTSxVQUFVLHlCQUF5QjtBQUFBO0FBQUEsVUFDL0Q7QUFBQSxXQUNGO0FBQUEsUUFDQSxnQkFBQUE7QUFBQSxVQUFDO0FBQUE7QUFBQSxZQUNDLFNBQU87QUFBQSxZQUNQLFdBQVU7QUFBQSxZQUVWLDBCQUFBQSxLQUFDLFNBQUksVUFBUSxNQUNWLGVBQUssV0FBVyxTQUFTLEVBQUUsR0FBRyxVQUFRLEtBQUssSUFBSSxPQUFLLFNBQVMsQ0FBQyxDQUFDLENBQUMsR0FDbkU7QUFBQTtBQUFBLFFBQ0Y7QUFBQTtBQUFBO0FBQUEsRUFDRjtBQUNGO0FBRUEsU0FBUyxtQkFBbUI7QUFDMUIsUUFBTSxVQUFVRSxTQUFRLFlBQVk7QUFDcEMsUUFBTSxPQUFPLFFBQVE7QUFDckIsV0FBUyxTQUFTLElBQXlCO0FBQ3pDLFFBQUksR0FBRyxTQUFTLEtBQU0sUUFBTyxnQkFBQUYsS0FBQyxTQUFHO0FBQ2pDLFdBQU8scUJBQUMsU0FBSSxXQUFVLFFBQ3BCO0FBQUEsc0JBQUFBLEtBQUMsV0FBTSxPQUFPLEtBQUssSUFBSSxVQUFVLEVBQUUsR0FBRyxPQUFLLFlBQVksQ0FBQyxDQUFDLEdBQUcsV0FBVSxRQUFPO0FBQUEsTUFDN0UscUJBQUMsU0FBSSxVQUFRLE1BQUMsUUFBUUMsS0FBSSxNQUFNLFFBQzlCO0FBQUEsd0JBQUFELEtBQUMsV0FBTSxPQUFPLEdBQUcsTUFBTSxXQUFVLFFBQU8sUUFBUUMsS0FBSSxNQUFNLE9BQU07QUFBQSxRQUNoRSxnQkFBQUQ7QUFBQSxVQUFDO0FBQUE7QUFBQSxZQUNDLFNBQVMsS0FBSyxNQUFNLG1CQUFtQixFQUFFLEdBQUcsU0FBTyxRQUFRLEVBQUU7QUFBQSxZQUM3RCxRQUFRQyxLQUFJLE1BQU07QUFBQSxZQUNsQixPQUFNO0FBQUEsWUFDTixXQUFVO0FBQUE7QUFBQSxRQUFTO0FBQUEsU0FDdkI7QUFBQSxNQUNBLGdCQUFBRCxLQUFDLFNBQUksU0FBTyxNQUFDO0FBQUEsTUFDYixnQkFBQUE7QUFBQSxRQUFDO0FBQUE7QUFBQSxVQUNDLE9BQU07QUFBQSxVQUNOLFdBQVcsTUFBTSxVQUFVLDZCQUE2QixHQUFHLElBQUksRUFBRTtBQUFBO0FBQUEsTUFDbkU7QUFBQSxPQUNGO0FBQUEsRUFDRjtBQUVBLFNBQU87QUFBQSxJQUFDO0FBQUE7QUFBQSxNQUNOLE1BQUs7QUFBQSxNQUNMLFVBQVE7QUFBQSxNQUNSLFdBQVU7QUFBQSxNQUVWO0FBQUEsNkJBQUMsU0FDQztBQUFBLDBCQUFBQSxLQUFDLFdBQU0sT0FBTSxRQUFPLFdBQVUsU0FBUTtBQUFBLFVBQ3RDLGdCQUFBQSxLQUFDLFNBQUksU0FBTyxNQUFDO0FBQUEsVUFDYixnQkFBQUE7QUFBQSxZQUFDO0FBQUE7QUFBQSxjQUNDLFFBQVEsS0FBSyxNQUFNLFNBQVM7QUFBQSxjQUM1QixvQkFBb0IsTUFBTSxLQUFLLFlBQVksQ0FBQyxLQUFLLFlBQVksQ0FBQztBQUFBO0FBQUEsVUFDaEU7QUFBQSxXQUNGO0FBQUEsUUFDQSxnQkFBQUE7QUFBQSxVQUFDO0FBQUE7QUFBQSxZQUNDLFNBQU87QUFBQSxZQUNQLFdBQVU7QUFBQSxZQUVWLDBCQUFBQSxLQUFDLFNBQUksVUFBUSxNQUNWLGVBQUssTUFBTSxlQUFlLEVBQUU7QUFBQSxjQUFHLFNBQzlCLElBQ0csS0FBSyxDQUFDLEdBQUcsTUFBTSxFQUFFLFdBQVcsRUFBRSxRQUFRLEVBQ3RDLElBQUksUUFBTSxTQUFTLEVBQUUsQ0FBQztBQUFBLFlBQzNCLEdBQ0Y7QUFBQTtBQUFBLFFBQ0Y7QUFBQTtBQUFBO0FBQUEsRUFDRjtBQUNGO0FBRUEsU0FBUyxtQkFBbUI7QUFDMUIsU0FBTztBQUFBLElBQUM7QUFBQTtBQUFBLE1BQ04sTUFBSztBQUFBLE1BQ0wsVUFBUTtBQUFBLE1BQ1IsV0FBVTtBQUFBLE1BRVY7QUFBQSw2QkFBQyxTQUNDO0FBQUEsMEJBQUFBLEtBQUMsY0FBVztBQUFBLFVBQ1osZ0JBQUFBLEtBQUMsU0FBSSxjQUFjLEdBQUc7QUFBQSxVQUN0QixnQkFBQUEsS0FBQ0csa0JBQUEsRUFBZ0I7QUFBQSxXQUNuQjtBQUFBLFFBQ0EscUJBQUMsU0FDQztBQUFBLDBCQUFBSCxLQUFDLHNCQUFtQjtBQUFBLFVBQ3BCLGdCQUFBQSxLQUFDLFNBQUksY0FBYyxHQUFHO0FBQUEsVUFDdEIsZ0JBQUFBLEtBQUMsb0JBQWlCO0FBQUEsV0FDcEI7QUFBQSxRQUNBLGdCQUFBQSxLQUFDLDBCQUF1QjtBQUFBLFFBQ3hCLGdCQUFBQSxLQUFDLG9CQUFpQjtBQUFBO0FBQUE7QUFBQSxFQUNwQjtBQUNGO0FBRUEsU0FBUyxnQkFBZ0I7QUFDdkIsU0FBTztBQUFBLElBQUM7QUFBQTtBQUFBLE1BQ04sZ0JBQWdCQyxLQUFJLG9CQUFvQjtBQUFBLE1BQ3hDLGtCQUFrQixLQUFLLFlBQVksRUFBRSxHQUFHLFFBQU0sRUFBRTtBQUFBLE1BRWhEO0FBQUEsd0JBQUFELEtBQUMsb0JBQWlCO0FBQUEsUUFDbEIsZ0JBQUFBLEtBQUMseUJBQXNCO0FBQUEsUUFDdkIsZ0JBQUFBLEtBQUMsb0JBQWlCO0FBQUE7QUFBQTtBQUFBLEVBQ3BCO0FBQ0Y7QUFFQSxTQUFTLHVCQUF1QjtBQUM5QixRQUFNLFVBQVUsQ0FBQyxRQUFRLGFBQWEsTUFBTTtBQUM1QyxTQUFPLGdCQUFBQSxLQUFDLGVBQVUsV0FBVSx3QkFDekIsa0JBQVE7QUFBQSxJQUFJLFlBQ1gsZ0JBQUFBO0FBQUEsTUFBQztBQUFBO0FBQUEsUUFDQyxTQUFPO0FBQUEsUUFDUCxPQUFPO0FBQUEsUUFDUCxXQUFXLEtBQUssWUFBWSxFQUFFLEdBQUcsUUFBTSxPQUFPLFNBQVMsWUFBWSxVQUFVO0FBQUEsUUFDN0UsV0FBVyxNQUFNLGFBQWEsSUFBSSxNQUFNO0FBQUE7QUFBQSxJQUMxQztBQUFBLEVBQ0YsR0FDRjtBQUNGO0FBR2UsU0FBUixhQUE4QixTQUFzQixTQUE0QjtBQUNyRixRQUFNLEVBQUUsS0FBSyxNQUFNLElBQUlTLE9BQU07QUFFN0IsU0FBTyxnQkFBQVQ7QUFBQSxJQUFDO0FBQUE7QUFBQSxNQUNOLFdBQVU7QUFBQSxNQUNWLFdBQVU7QUFBQSxNQUNWLFlBQVk7QUFBQSxNQUNaLGFBQWFTLE9BQU0sWUFBWTtBQUFBLE1BQy9CLGFBQWE7QUFBQSxNQUNiLFNBQVMsUUFBUTtBQUFBLE1BQ2pCLE9BQU9BLE9BQU0sTUFBTTtBQUFBLE1BQ25CLFFBQVEsTUFBTTtBQUFBLE1BQ2Q7QUFBQSxRQUFDO0FBQUE7QUFBQSxVQUNDLFVBQVE7QUFBQSxVQUNSLFdBQVU7QUFBQSxVQUNWO0FBQUEsaUNBQUMsU0FDQztBQUFBLDhCQUFBVCxLQUFDLGNBQVc7QUFBQSxjQUNaLGdCQUFBQSxLQUFDLHdCQUFxQjtBQUFBLGVBQ3hCO0FBQUEsWUFDQSxnQkFBQUEsS0FBQyxpQkFBYztBQUFBO0FBQUE7QUFBQSxNQUNqQjtBQUFBO0FBQUEsRUFDRjtBQUNGOzs7QUVyY0EsU0FBUyxlQUFlLFNBQTBCLFVBQXFDO0FBQ3JGLFVBQVEsU0FBUztBQUFBLElBQ2YsS0FBSztBQUNILGVBQVMsSUFBSSxDQUFDLFNBQVMsSUFBSSxDQUFDO0FBQzVCLGFBQU8sR0FBRyxTQUFTLElBQUksQ0FBQztBQUFBLElBQzFCO0FBQVMsYUFBTztBQUFBLEVBQ2xCO0FBQ0Y7QUFHZSxTQUFSLGVBQWdDLFNBQWlCLEtBQThCO0FBQ3BGLFFBQU0sT0FBTyxRQUFRLE1BQU0sR0FBRztBQUU5QixVQUFRLEtBQUssQ0FBQyxHQUFHO0FBQUEsSUFDZixLQUFLO0FBQ0gsY0FBUSxLQUFLLENBQUMsR0FBRztBQUFBLFFBQ2YsS0FBSztBQUFVLGlCQUFPLElBQUksZUFBZSxnQkFBd0IsT0FBTyxDQUFDO0FBQUEsUUFDekU7QUFBUyxpQkFBTyxJQUFJLDBCQUEwQjtBQUFBLE1BQ2hEO0FBQUEsSUFDRixLQUFLO0FBQ0gsY0FBUSxLQUFLLENBQUMsR0FBRztBQUFBLFFBQ2YsS0FBSztBQUFVLGlCQUFPLElBQUksZUFBZSxnQkFBd0IsZUFBZSxDQUFDO0FBQUEsUUFDakY7QUFBUyxpQkFBTyxJQUFJLGtDQUFrQztBQUFBLE1BQ3hEO0FBQUEsSUFDRixLQUFLO0FBQ0gsY0FBUSxLQUFLLENBQUMsR0FBRztBQUFBLFFBQ2YsS0FBSztBQUFVLGlCQUFPLElBQUksZUFBZSxnQkFBd0IsZ0JBQWdCLENBQUM7QUFBQSxRQUNsRjtBQUFTLGlCQUFPLElBQUksbUNBQW1DO0FBQUEsTUFDekQ7QUFBQSxJQUNGLEtBQUs7QUFDSCxjQUFRLEtBQUssQ0FBQyxHQUFHO0FBQUEsUUFDZixLQUFLO0FBQVUsaUJBQU8sSUFBSSxlQUFlLGdCQUF3QixZQUFZLENBQUM7QUFBQSxRQUM5RTtBQUFTLGlCQUFPLElBQUksK0JBQStCO0FBQUEsTUFDckQ7QUFBQSxJQUNGLEtBQUs7QUFDSCxjQUFRLEtBQUssQ0FBQyxHQUFHO0FBQUEsUUFDZixLQUFLO0FBQVUsaUJBQU8sSUFBSSxlQUFlLGdCQUF3QixhQUFhLENBQUM7QUFBQSxRQUMvRTtBQUFTLGlCQUFPLElBQUksZ0NBQWdDO0FBQUEsTUFDdEQ7QUFBQSxJQUNGO0FBQ0UsYUFBTyxJQUFJLGtCQUFrQjtBQUFBLEVBQ2pDO0FBQ0Y7OztBQ3RDQSxTQUFTLGlCQUFpQixVQUE4QjtBQUN0RCxRQUFNLGdCQUFnQjtBQUN0QixRQUFNLFVBQVU7QUFFaEIsUUFBTSxrQkFBa0IsU0FBUyxLQUFLLE9BQUssRUFBRSxVQUFVLGFBQWE7QUFDcEUsUUFBTSxZQUFZLFNBQVMsS0FBSyxPQUFLLEVBQUUsVUFBVSxPQUFPO0FBRXhELFNBQU8sbUJBQW1CLGFBQWEsU0FBUyxDQUFDO0FBQ25EO0FBRUEsWUFBSSxNQUFNO0FBQUEsRUFDUixLQUFLLFlBQVk7QUFBQSxFQUNqQjtBQUFBLEVBQ0EsT0FBTztBQUNMLFVBQU0sV0FBVyxZQUFJLGFBQWE7QUFDbEMsVUFBTSxnQkFBZ0IsaUJBQWlCLFFBQVE7QUFFL0MsUUFBSSxlQUFlLE9BQU87QUFDMUIsZ0JBQVksZUFBZSxlQUFlO0FBQzFDLGlCQUFhLGVBQWUsZ0JBQWdCO0FBQzVDLGNBQVUsZUFBZSxhQUFhO0FBQ3RDLFFBQUksYUFBYTtBQUNqQix1QkFBbUIsZUFBZSxZQUFZO0FBQzlDLGFBQVMsZUFBZSxZQUFZO0FBRXBDLFVBQU07QUFBQSxvQ0FBdUMsY0FBYyxLQUFLLEVBQUU7QUFBQSxFQUNwRTtBQUNGLENBQUM7IiwKICAibmFtZXMiOiBbIkFzdGFsIiwgIkd0ayIsICJBc3RhbCIsICJiaW5kIiwgImludGVydmFsIiwgInRpbWVvdXQiLCAiQXN0YWwiLCAiQXN0YWwiLCAidiIsICJpbnRlcnZhbCIsICJleGVjIiwgImN0b3JzIiwgIkFzdGFsIiwgIkFzdGFsIiwgIkd0ayIsICJBc3RhbCIsICJzbmFrZWlmeSIsICJwYXRjaCIsICJBcHBzIiwgIkJsdWV0b290aCIsICJIeXBybGFuZCIsICJNcHJpcyIsICJOb3RpZmQiLCAiTm90aWZpY2F0aW9uIiwgIldwIiwgIkdPYmplY3QiLCAicmVxdWVzdEhhbmRsZXIiLCAiR3RrIiwgIkFzdGFsIiwgIkFzdGFsIiwgIkd0ayIsICJHT2JqZWN0IiwgIkd0ayIsICJBc3RhbCIsICJHT2JqZWN0IiwgImRlZmF1bHQiLCAiQXN0YWwiLCAiQXN0YWwiLCAiQXN0YWwiLCAiR09iamVjdCIsICJkZWZhdWx0IiwgIkdPYmplY3QiLCAia2ViYWJpZnkiLCAiZGVmYXVsdCIsICJNcHJpcyIsICJqc3giLCAianN4IiwgIkd0ayIsICJUaW1lIiwgIkFzdGFsIiwgImpzeCIsICJHdGsiLCAiTXByaXMiLCAiQXN0YWwiLCAiVGltZSIsICJqc3giLCAiQXN0YWwiLCAianN4IiwgIkd0ayIsICJ0ZXh0IiwgIkFzdGFsIiwgImxpc3QiLCAiR3RrIiwgIkdPYmplY3QiLCAianN4IiwgIlRpbWUiLCAiR3RrIiwgIkFzdGFsIiwgIk5vdGlmZCIsICJkZWZhdWx0IiwgIkd0ayIsICJqc3giLCAiTm90aWZkIiwgIkFzdGFsIiwgImpzeCIsICJHT2JqZWN0IiwgImpzeCIsICJHdGsiLCAiQXN0YWwiLCAiQmx1ZXRvb3RoIiwgIk1wcmlzIiwgIk5ldHdvcmsiLCAiTm90aWZkIiwgImpzeCIsICJHdGsiLCAianN4IiwgIkd0ayIsICJOZXR3b3JrIiwgIkJsdWV0b290aE1vZHVsZSIsICJCbHVldG9vdGgiLCAibmFtZSIsICJzdGF0dXMiLCAiTm90aWZkIiwgIk1wcmlzIiwgIkFzdGFsIl0KfQo=
