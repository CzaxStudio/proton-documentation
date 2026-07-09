# Buttons

Buttons are how users tell your app to do things. Proton has four kinds,
plus clickable links and a way to make literally anything tappable.

---

## The One Rule

Every button needs its own `proton.Clickable` field in your state struct.

```go
type UI struct {
    save   proton.Clickable
    cancel proton.Clickable
    delete proton.Clickable
}
```

Don't share one between two buttons. If you do, clicking either one fires
both — which is a fun bug to debug and a terrible UX.

Also, buttons must be inside a layout wrapper (`Pad`, `Row`, `Column`, etc.)
for clicks to register. See [Getting Started](./00-getting-started.md) for why.

---

## Button

Filled, solid, primary action. Use this for the thing you most want the
user to click.

```go
var save proton.Clickable

proton.Pad(ctx, 8, func(ctx proton.Context) {
    if proton.Button(ctx, &save, "Save") {
        doSave()
    }
})
```

Returns `true` on the frame it gets clicked. One click, one `true`. It
doesn't keep firing while held down.

```go
proton.Button(ctx proton.Context, state *proton.Clickable, label string) bool
```

---

## OutlineButton

Ghost/outline style. Same behavior as Button but without the filled
background. Use it for secondary actions — things the user might want
to do, but that aren't the primary action.

```go
var save   proton.Clickable
var cancel proton.Clickable

proton.Row(ctx,
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.OutlineButton(ctx, &cancel, "Cancel") {
                handleCancel()
            }
        })
    },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &save, "Save") {
                handleSave()
            }
        })
    },
)
```

The visual hierarchy here — outline for Cancel, filled for Save — tells
users which one is the primary action without a single word of explanation.

```go
proton.OutlineButton(ctx proton.Context, state *proton.Clickable, label string) bool
```

---

## IconButton

An icon-only button. No text, just an icon. Common in toolbars.

```go
// icon is a *proton.Icon — load one with widget.NewIcon() from gioui.org/widget
var closeBtn proton.Clickable

if proton.IconButton(ctx, &closeBtn, closeIcon, "Close window") {
    win.Close()
}
```

The fourth argument is the accessibility description — what a screen reader
would say. Don't skip it.

```go
proton.IconButton(ctx proton.Context, state *proton.Clickable, icon *proton.Icon, desc string) bool
```

---

## Tappable

Makes any content clickable. The entire area you draw inside the callback
becomes the hit target. Use it for cards, list rows, custom buttons, or
anything where a standard button label isn't what you want.

```go
var rowClick proton.Clickable

if proton.Tappable(ctx, &rowClick, func(ctx proton.Context) {
    proton.Card(ctx, proton.RGB(0x2a2a3e), 8, 12, func(ctx proton.Context) {
        proton.Label(ctx, "Click anywhere on this card")
        proton.Gap(ctx, 4)
        proton.Muted(ctx, "The whole thing is a button")
    })
}) {
    println("card clicked")
}
```

```go
proton.Tappable(ctx proton.Context, state *proton.Clickable, content func(proton.Context)) bool
```

---

## Link and LinkSmall

Underlined clickable text styled like a hyperlink. Handle the click yourself —
Proton doesn't open URLs for you, it just tells you the user clicked.

```go
var githubLink proton.Clickable

if proton.Link(ctx, &githubLink, "View on GitHub") {
    openBrowser("https://github.com/CzaxStudio/proton")
}
```

`LinkSmall` is the same thing but uses caption-sized text:

```go
var termsLink proton.Clickable

if proton.LinkSmall(ctx, &termsLink, "Terms of service") {
    showTerms()
}
```

```go
proton.Link(ctx proton.Context, state *proton.Clickable, text string) bool
proton.LinkSmall(ctx proton.Context, state *proton.Clickable, text string) bool
```

---

## Common Patterns

### Confirm / Cancel row (right-aligned)

```go
type UI struct {
    save   proton.Clickable
    cancel proton.Clickable
}

proton.RowEnd(ctx,
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.OutlineButton(ctx, &u.cancel, "Cancel") {
                handleCancel()
            }
        })
    },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.save, "Save changes") {
                handleSave()
            }
        })
    },
)
```

`RowEnd` pushes everything to the right edge — standard placement for
confirm/cancel pairs.

### Toolbar

```go
type UI struct {
    newFile  proton.Clickable
    openFile proton.Clickable
    saveFile proton.Clickable
}

proton.Row(ctx,
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.newFile, "New") { handleNew() }
        })
    },
    func(ctx proton.Context) { proton.Gap(ctx, 4) },
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.OutlineButton(ctx, &u.openFile, "Open") { handleOpen() }
        })
    },
    func(ctx proton.Context) { proton.Gap(ctx, 4) },
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.OutlineButton(ctx, &u.saveFile, "Save") { handleSave() }
        })
    },
)
```

### Clickable list rows

```go
type UI struct {
    rows   [100]proton.Clickable
    chosen int
}

items := []string{"Alpha", "Beta", "Gamma", "Delta"}

proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
    if proton.Tappable(ctx, &u.rows[i], func(ctx proton.Context) {
        proton.PadV(ctx, 10, func(ctx proton.Context) {
            proton.PadH(ctx, 12, func(ctx proton.Context) {
                proton.Label(ctx, items[i])
            })
        })
    }) {
        u.chosen = i
    }
    proton.Divider(ctx)
})
```
