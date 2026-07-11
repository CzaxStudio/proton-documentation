# Advanced

Keyboard shortcuts, async goroutines, toast notifications, modals, tabs,
accordion, context menus, and everything else that doesn't fit neatly into
the earlier pages.

---

## Toast Notifications

A timed message that appears, stays for a few seconds, and disappears on its
own. No dialog, no blocking the user.

```go
type UI struct {
    toast proton.ToastState
}

// trigger from anywhere — goroutine-safe
u.toast.Show("File saved!", 2*time.Second)

// draw it LAST in your draw function so it renders on top of everything
proton.Toast(ctx, &u.toast)
```

If there's no active toast, `Toast` draws nothing. No need to check first.

```go
func (t *ToastState) Show(msg string, duration time.Duration)
proton.Toast(ctx proton.Context, state *proton.ToastState)
```

---

## Overlay / Modal

A dimmed backdrop with centered content on top of everything.

```go
type UI struct {
    modal    proton.OverlayState
    openBtn  proton.Clickable
    closeBtn proton.Clickable
}

// open it
proton.Pad(ctx, 4, func(ctx proton.Context) {
    if proton.Button(ctx, &u.openBtn, "Open dialog") {
        u.modal.Show()
    }
})

// draw it — also at the end of your draw function
proton.Overlay(ctx, &u.modal, func(ctx proton.Context) {
    proton.MinSize(ctx, 300, 0, func(ctx proton.Context) {
        proton.Card(ctx, proton.RGB(0x2e3440), 12, 24, func(ctx proton.Context) {
            proton.H5(ctx, "Are you sure?")
            proton.Gap(ctx, 8)
            proton.Label(ctx, "This cannot be undone.")
            proton.Gap(ctx, 20)
            proton.RowEnd(ctx,
                func(ctx proton.Context) {
                    proton.Pad(ctx, 4, func(ctx proton.Context) {
                        if proton.OutlineButton(ctx, &u.closeBtn, "Cancel") {
                            u.modal.Hide()
                        }
                    })
                },
                func(ctx proton.Context) { proton.Gap(ctx, 8) },
                func(ctx proton.Context) {
                    proton.Pad(ctx, 4, func(ctx proton.Context) {
                        if proton.Button(ctx, &u.openBtn, "Confirm") {
                            u.modal.Hide()
                            doThing()
                        }
                    })
                },
            )
        })
    })
})
```

```go
func (o *OverlayState) Show()
func (o *OverlayState) Hide()
func (o *OverlayState) Toggle()

proton.Overlay(ctx proton.Context, state *proton.OverlayState, content func(proton.Context))
```

`Overlay` draws nothing when `state.Visible` is false, so you can call it
every frame without any wrapping condition.

---

## Keyboard Shortcuts

Register a function to fire when a key combination is pressed.

```go
proton.OnKey(ctx, proton.ModCtrl, "S", func() { save() })
proton.OnKey(ctx, proton.ModCtrl, "Z", func() { undo() })
proton.OnKey(ctx, proton.ModCtrl|proton.ModShift, "N", func() { newFile() })
proton.OnKey(ctx, proton.ModNone, proton.KeyEscape, func() { closeDialog() })
```

Call `OnKey` inside your draw function. It registers the shortcut for that
frame. Since the draw function runs every frame, shortcuts stay active as
long as the window is open.

```go
proton.OnKey(ctx proton.Context, modifiers proton.Modifier, keyName string, fn func())
```

**Modifier constants:**

```go
proton.ModNone   // no modifier — just the key
proton.ModCtrl   // Ctrl (Cmd on macOS)
proton.ModShift
proton.ModAlt

// combine with |
proton.ModCtrl | proton.ModShift
```

**Key name constants** (for non-letter keys):

```go
proton.KeyEscape
proton.KeyReturn
proton.KeyBackspace
proton.KeyDelete
proton.KeyTab
proton.KeySpace
proton.KeyUp
proton.KeyDown
proton.KeyLeft
proton.KeyRight
```

Letter keys are just strings: `"S"`, `"Z"`, `"N"`, `"A"`.

---

## Tabs

A horizontal tab bar with one content area that switches based on the
selected tab.

```go
type UI struct {
    tabs    proton.TabState
    tabBtns [3]proton.Clickable
}

proton.Tabs(ctx,
    []string{"Files", "Settings", "About"},
    u.tabBtns[:],
    &u.tabs,
    func(ctx proton.Context, i int) {
        switch i {
        case 0: drawFiles(ctx)
        case 1: drawSettings(ctx)
        case 2: drawAbout(ctx)
        }
    },
)
```

`u.tabs.Selected` holds the active tab index. You can set it programmatically
to switch tabs from code.

```go
proton.Tabs(ctx proton.Context, labels []string, btns []proton.Clickable, state *proton.TabState, content func(proton.Context, int))
```

The `btns` slice needs one `Clickable` per tab. Passing `u.tabBtns[:]` is
the idiomatic way when you declare a fixed-size array in your struct.

---

## Accordion

A collapsible section with a clickable header.

```go
type UI struct {
    sec1    proton.AccordionState
    sec1btn proton.Clickable
}

proton.Accordion(ctx, &u.sec1, &u.sec1btn, "Advanced Options", func(ctx proton.Context) {
    proton.Label(ctx, "These options are hidden until the user expands this.")
    proton.Gap(ctx, 8)
    proton.Toggle(ctx, &u.expertMode, "Expert mode")
})
```

```go
proton.Accordion(ctx proton.Context, state *proton.AccordionState, btn *proton.Clickable, title string, content func(proton.Context))
```

`state.Open` tracks whether it's expanded. You can set it directly to start
an accordion open: `u.sec1.Open = true`.

---

## Context Menu

A right-click menu that appears at the cursor position.

```go
type UI struct {
    menu    proton.ContextMenuState
    menuTag proton.FrameTag
}

items := []proton.ContextMenuItem{
    {Label: "Copy"},
    {Label: "Paste"},
    {Label: "Delete"},
    {Label: "Disabled option", Disabled: true},
}

chosen := proton.ContextMenu(ctx, &u.menu, &u.menuTag, items, func(ctx proton.Context) {
    proton.Label(ctx, "Right-click anywhere in this area")
})

if chosen >= 0 {
    fmt.Println("User picked:", items[chosen].Label)
}
```

```go
proton.ContextMenu(ctx proton.Context, state *proton.ContextMenuState, tag *proton.FrameTag, items []proton.ContextMenuItem, content func(proton.Context)) int
```

Returns -1 when nothing was selected, and the item index on the frame
something gets clicked. The menu closes automatically after a selection.

---

## Async Updates and Goroutines

Your draw function runs on the main thread. When a goroutine finishes work
and changes state, call `ctx.Invalidate()` to ask for a redraw.

```go
type UI struct {
    loading bool
    result  string
    fetchBtn proton.Clickable
}

// in your draw function
proton.Pad(ctx, 4, func(ctx proton.Context) {
    if proton.Button(ctx, &u.fetchBtn, "Fetch") && !u.loading {
        u.loading = true
        go func() {
            data := fetchFromAPI()        // takes a while
            u.result = data
            u.loading = false
            ctx.Invalidate()              // wake up the render loop
        }()
    }
})

if u.loading {
    proton.Row(ctx,
        func(ctx proton.Context) { proton.Spinner(ctx, &u.spin, 18) },
        func(ctx proton.Context) { proton.Gap(ctx, 8) },
        func(ctx proton.Context) { proton.Muted(ctx, "Loading...") },
    )
} else if u.result != "" {
    proton.Label(ctx, u.result)
}
```

Without `ctx.Invalidate()`, the window won't redraw until the user moves
the mouse or interacts with it. Always call it after changing state from
a goroutine.

---

## Spinner

An animated loading indicator. Calling `Spinner` automatically keeps the
window redrawing — no `Invalidate()` loop needed.

```go
type UI struct {
    spin proton.SpinnerState
}

proton.Spinner(ctx, &u.spin, 32)  // 32dp diameter
```

```go
proton.Spinner(ctx proton.Context, state *proton.SpinnerState, sizeDp float32)
```

`SpinnerState` tracks the animation start time. Declare one per spinner
in your state struct.

---

## SelectBox (Dropdown)

```go
type UI struct {
    langSel proton.SelectBoxState
}

langs := []string{"Go", "Rust", "Zig", "C", "Python"}
i := proton.SelectBox(ctx, &u.langSel, langs)
proton.Caption(ctx, "Selected: "+langs[i])
```

The dropdown opens below the button and closes on selection or outside click.

```go
proton.SelectBox(ctx proton.Context, state *proton.SelectBoxState, options []string) int
```

---

## If — Conditional Rendering

Renders content only when a condition is true. Saves a `if` block when you
just want to show or hide a single widget.

```go
proton.If(ctx, user.IsAdmin, func(ctx proton.Context) {
    proton.Pad(ctx, 4, func(ctx proton.Context) {
        if proton.Button(ctx, &u.deleteBtn, "Delete everything") {
            deleteEverything()
        }
    })
})
```

```go
proton.If(ctx proton.Context, cond bool, content func(proton.Context))
```

---

## FocusArea — Scoped Key Handling

When you need keyboard events only active inside a specific region of the UI,
not globally. Usually `OnKey` is enough — reach for this when you have two
panels that should have independent keyboard shortcuts.

```go
type UI struct {
    editorTag proton.FrameTag
}

proton.FocusArea(ctx, &u.editorTag, "A", func(ctx proton.Context) {
    proton.TextArea(ctx, &u.text, "Type here...")
})
```

```go
proton.FocusArea(ctx proton.Context, tag *proton.FrameTag, keyName string, content func(proton.Context))
```

---

## Window Options

```go
// fullscreen
a.WindowEx("App", 800, 600, []proton.WindowOption{
    proton.Fullscreen(),
}, draw)

// maximized
a.WindowEx("App", 800, 600, []proton.WindowOption{
    proton.Maximized(),
}, draw)
```

```go
proton.Fullscreen() proton.WindowOption
proton.Maximized()  proton.WindowOption
```

---

## Keeping Animations Running

Proton only redraws when there's user input or you call `ctx.Invalidate()`.
For animations — progress bars that fill over time, countdowns, anything
time-based — call `Invalidate` at the end of each frame to keep the redraws
going:

```go
func draw(ctx proton.Context, u *UI) {
    if u.animating {
        u.progress += 0.01
        if u.progress >= 1.0 {
            u.progress = 0
            u.animating = false
        }
        proton.ProgressBar(ctx, u.progress)
        ctx.Invalidate()  // draw again next frame
    }
}
```

When `u.animating` goes false, `Invalidate` stops being called and Proton
goes back to redrawing only on user input. The Spinner widget does this
automatically — you don't need to manage it yourself.
