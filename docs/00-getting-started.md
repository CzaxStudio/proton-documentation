# Getting Started

You want to build a desktop app in Go. You've come to the right place!

---

## Prerequisites

Go 1.22 or newer. Check with:

```bash
go version
```

If you're on Linux, you also need three system packages. macOS and Windows users
can skip this and feel smug:

```bash
sudo apt install libwayland-dev libxkbcommon-dev libvulkan-dev
```

---

## Install

In your project directory:

```bash
go get github.com/CzaxStudio/proton
go mod tidy
```

The `go mod tidy` step is important — it pulls Gio's transitive dependencies
and writes them to `go.sum`. Skip it and you'll see red squiggles everywhere.

---

## Your First Window

```go
package main

import "github.com/CzaxStudio/proton"

func main() {
    a := proton.New("hello")
    a.Window("Hello", 480, 320, func(ctx proton.Context) {
        proton.H3(ctx, "Hello from Proton!") // ⓘ You can change proton.H3 to any size you want
    })
    a.Run()
}
```

```bash
go run .
```

A window appears. That's a complete, working GUI app in 9 lines. No XML,
no `implements Runnable`, no dependency injection framework, no webpack.

---

## Adding State

Widgets that do something — buttons, text inputs, checkboxes — need a state
field in your own struct. Declare them once, pass pointers to the widgets.

```go
package main

import (
    "fmt"
    "github.com/CzaxStudio/proton"
)

type UI struct {
    name proton.Editor
    btn  proton.Clickable
}

func main() {
    u := &UI{}

    a := proton.New("greeter")
    a.Window("Greeter", 400, 240, func(ctx proton.Context) {
        proton.Input(ctx, &u.name, "Your name")
        proton.Gap(ctx, 8)
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.btn, "Say hello") {
                fmt.Println("Hello,", u.name.Text())
            }
        })
    })
    a.Run()
}
```

The draw function runs every frame. `Button` returns `true` on the frame it
gets clicked. The `if` block runs, prints the name, and that's it.

---

## The State Types

Declare these in your UI struct. They're all zero-value ready — no constructors.

```go
type UI struct {
    btn     proton.Clickable    // Button, OutlineButton, Tappable, Link
    name    proton.Editor       // Input, TextArea
    checked proton.Bool         // Checkbox, Toggle
    choice  proton.Enum         // RadioButton group
    vol     proton.Float        // Slider
    scroll  proton.Scrollable   // List, HList, Scroll, TextView, LogView
}
```

One field per widget. Don't share a `Clickable` between two buttons — they'll
both fire on the same click, which is almost never what you want.

---

## How the Layout Works

Without any layout wrappers, widgets stack vertically top to bottom. `Gap`
adds space between them.

```go
proton.H4(ctx, "Settings")
proton.Gap(ctx, 12)
proton.Label(ctx, "Adjust your preferences below.")
proton.Gap(ctx, 16)
proton.Divider(ctx)
proton.Gap(ctx, 16)
proton.Toggle(ctx, &u.darkMode, "Dark mode")
```

For side-by-side layout, use `Row`. For more control, see [04-layout.md](./04-layout.md).

---

## Buttons Need a Layout Wrapper

Buttons (and other interactive widgets) must be inside a layout helper for
clicks to register correctly. This is a Gio thing — the layout pass is what
establishes hit areas on screen.

```go
// correct — button is inside Pad
proton.Pad(ctx, 8, func(ctx proton.Context) {
    if proton.Button(ctx, &u.btn, "Save") {
        save()
    }
})

// also correct — button is inside Row
proton.Row(ctx,
    func(ctx proton.Context) {
        if proton.Button(ctx, &u.btn, "Save") {
            save()
        }
    },
)
```

If you put a button at the very top level of the draw function without any
wrapper, it'll draw but won't respond to clicks. `Pad(ctx, 0, ...)` is the
minimum wrapper if you want zero visual padding.

---

## Theming

```go
a := proton.New("myapp")
a.ApplyPalette(proton.NordPalette)
a.Window("App", 800, 600, draw)
a.Run()
```

46 palettes are built in. See [07-theming.md](./07-theming.md) for all of them
and for building your own with hex color codes.

---

## Multiple Windows

```go
a := proton.New("app")
a.Window("Main", 800, 600, drawMain)
a.Window("Settings", 400, 300, drawSettings)
a.Run() // opens both
```

All windows share the same `*App`. The process stays alive until all windows
are closed.

---

## Next Steps

- **[01-text.md](./01-text.md)** — text widgets
- **[02-buttons.md](./02-buttons.md)** — buttons and clickable areas
- **[03-inputs.md](./03-inputs.md)** — text fields, toggles, sliders
- **[04-layout.md](./04-layout.md)** — arranging things on screen
- **[09-examples.md](./09-examples.md)** — complete working programs to copy
