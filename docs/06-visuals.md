# Visual Widgets

Shapes, cards, images, badges, progress rings, tables, avatars — the things
that make your app look like it was designed on purpose.

---

## Divider

A thin horizontal rule. Use it between sections.

```go
proton.H5(ctx, "Section One")
proton.Gap(ctx, 8)
proton.Label(ctx, "Some content.")
proton.Gap(ctx, 12)
proton.Divider(ctx)
proton.Gap(ctx, 12)
proton.H5(ctx, "Section Two")
```

```go
proton.Divider(ctx proton.Context)
```

### LabeledDivider

Same as Divider but with a centered text label.

```go
proton.LabeledDivider(ctx, "Advanced Settings")
proton.LabeledDivider(ctx, "")   // plain divider — same as Divider
```

```go
proton.LabeledDivider(ctx proton.Context, label string)
```

---

## Rect

A solid colored rectangle. Pass 0 for width or height to fill the
available space on that axis.

```go
// 100dp wide, 4dp tall accent bar
proton.Rect(ctx, proton.RGB(0x89b4fa), 100, 4)

// full width, 2dp tall separator
proton.Rect(ctx, proton.RGB(0x333344), 0, 2)

// fill all available space
proton.Rect(ctx, proton.RGB(0x1a1a2e), 0, 0)
```

```go
proton.Rect(ctx proton.Context, c color.NRGBA, widthDp, heightDp float32)
```

### RoundRect

Same as Rect but with rounded corners.

```go
proton.RoundRect(ctx, proton.RGB(0x2a2a3e), 200, 60, 12)  // 12dp corner radius
proton.RoundRect(ctx, proton.RGB(0x4c566a), 0, 40, 20)    // full width, pill shape
```

```go
proton.RoundRect(ctx proton.Context, c color.NRGBA, widthDp, heightDp, radiusDp float32)
```

---

## Card

Content inside a padded, rounded-rectangle background with a subtle shadow.
The go-to container for grouping related content.

```go
proton.Card(ctx, proton.RGB(0x2a2a3e), 12, 16, func(ctx proton.Context) {
    proton.H6(ctx, "Card Title")
    proton.Gap(ctx, 4)
    proton.Label(ctx, "Card content goes here.")
    proton.Gap(ctx, 12)
    proton.Pad(ctx, 4, func(ctx proton.Context) {
        if proton.Button(ctx, &u.btn, "Action") { doThing() }
    })
})
```

```go
proton.Card(ctx proton.Context, bg color.NRGBA, cornerDp, padDp float32, content func(proton.Context))
```

- `bg` — background color
- `cornerDp` — corner radius (8–12 looks good for most cards)
- `padDp` — padding between the card edge and the content

### HoverCard

A card that changes background color on hover. Returns true if clicked.

```go
if proton.HoverCard(ctx, &u.cardBtn,
    proton.RGB(0x2e3440),  // normal background
    proton.RGB(0x3b4252),  // hover background
    8,                     // corner radius dp
    func(ctx proton.Context) {
        proton.PadV(ctx, 10, func(ctx proton.Context) {
            proton.PadH(ctx, 12, func(ctx proton.Context) {
                proton.Label(ctx, "Click this card")
            })
        })
    },
) {
    println("card clicked")
}
```

```go
proton.HoverCard(ctx proton.Context, state *proton.Clickable, bg, hover color.NRGBA, cornerDp float32, content func(proton.Context)) bool
```

---

## Badge

A small rounded chip with text. For status labels, tags, counts, anything
that needs a colored pill.

```go
proton.Badge(ctx, proton.RGB(0x5e81ac), proton.RGB(0xeceff4), "stable")
proton.Badge(ctx, proton.RGB(0xa3be8c), proton.RGB(0x2e3440), "passing")
proton.Badge(ctx, proton.RGB(0xbf616a), proton.RGB(0xeceff4), "failing")
```

```go
proton.Badge(ctx proton.Context, bg, fg color.NRGBA, text string)
```

Badges in a row:

```go
proton.Row(ctx,
    func(ctx proton.Context) { proton.Badge(ctx, proton.RGB(0x5e81ac), proton.RGB(0xeceff4), "Go") },
    func(ctx proton.Context) { proton.Gap(ctx, 5) },
    func(ctx proton.Context) { proton.Badge(ctx, proton.RGB(0xa3be8c), proton.RGB(0x2e3440), "v1.0") },
    func(ctx proton.Context) { proton.Gap(ctx, 5) },
    func(ctx proton.Context) { proton.Badge(ctx, proton.RGB(0xebcb8b), proton.RGB(0x2e3440), "MIT") },
)
```

---

## StatusDot

A small colored circle. Online/offline indicators, build status, anything
that needs a colored dot next to some text.

```go
proton.Row(ctx,
    func(ctx proton.Context) { proton.StatusDot(ctx, proton.RGB(0x4ade80), 9) },
    func(ctx proton.Context) { proton.Gap(ctx, 6) },
    func(ctx proton.Context) { proton.Caption(ctx, "Connected") },
)
```

```go
proton.StatusDot(ctx proton.Context, c color.NRGBA, sizeDp float32)
```

---

## Avatar

A circular badge showing initials. For user profile pictures when no image
is available — which is most of the time.

```go
proton.Avatar(ctx, "AJ", proton.RGB(0x5e81ac), proton.RGB(0xeceff4), 40)
proton.Avatar(ctx, "BC", proton.RGB(0xa3be8c), proton.RGB(0x2e3440), 32)
```

```go
proton.Avatar(ctx proton.Context, initials string, bg, fg color.NRGBA, sizeDp float32)
```

---

## ProgressRing

A circular progress indicator. Good for stat cards and dashboards where
the circular shape communicates percentage more visually than a bar does.

```go
proton.ProgressRing(ctx, 0.72, 48, 5, proton.RGB(0x88c0d0))
//                       ^     ^   ^   ^
//                  progress  sz  strokeW  color
```

```go
proton.ProgressRing(ctx proton.Context, progress, sizeDp, strokeDp float32, c color.NRGBA)
```

`progress` is 0.0–1.0. `sizeDp` is the diameter. `strokeDp` is the ring
thickness — 4–6dp looks good for most sizes.

---

## Table

A data table with a header row and alternating row shading.

```go
proton.Table(ctx,
    []string{"Name", "Role", "Status"},
    []proton.TableRow{
        {"Alice", "Engineer", "Active"},
        {"Bob",   "Designer", "Away"},
        {"Carol", "PM",       "Active"},
    },
)
```

```go
proton.Table(ctx proton.Context, columns []string, rows []proton.TableRow)
```

`proton.TableRow` is just `[]string`. Columns are equally wide.

---

## Stepper

A horizontal step-progress indicator for multi-step flows.

```go
proton.Stepper(ctx, 1, []string{"Account", "Profile", "Payment", "Done"})
//                  ^
//              current step (0-based)
```

```go
proton.Stepper(ctx proton.Context, current int, steps []string)
```

Step 0 is the first step. Completed steps (index < current) get a filled
accent color. The current step is highlighted. Future steps are dim.

---

## Tooltip

A small label that appears when the user hovers over something.

```go
type UI struct {
    saveHover proton.Clickable  // for tracking hover — separate from the button's Clickable
    saveBtn   proton.Clickable
}

proton.Tooltip(ctx, &u.saveHover, "Saves your work to disk (Ctrl+S)", func(ctx proton.Context) {
    proton.Pad(ctx, 4, func(ctx proton.Context) {
        if proton.Button(ctx, &u.saveBtn, "Save") {
            save()
        }
    })
})
```

```go
proton.Tooltip(ctx proton.Context, state *proton.Clickable, tip string, content func(proton.Context))
```

The `state` Clickable tracks hover for the tooltip area. It's separate from
any button inside the content — declare a dedicated one for each tooltip.

---

## Images

Load once at startup. Draw every frame.

```go
// load at startup — not in the draw function
img, err := proton.LoadImage("photo.png")
if err != nil {
    log.Fatal(err)
}

// in the draw function
proton.Image(ctx, img, 200, 150)  // 200dp wide, 150dp tall
proton.Image(ctx, img, 0, 0)      // natural pixel size
```

```go
proton.LoadImage(path string) (proton.ImageOp, error)
proton.Image(ctx proton.Context, img proton.ImageOp, widthDp, heightDp float32)
```

PNG and JPEG are both supported.

---

## Logo

Your app logo, loaded once and drawn anywhere. See [07-theming.md](./07-theming.md)
for the full setup. The short version:

```go
//go:embed logo.png
var logoBytes []byte

// at startup
a.SetLogoBytes(logoBytes)

// in the draw function
proton.Logo(ctx, 48, 48)
```

```go
proton.Logo(ctx proton.Context, widthDp, heightDp float32)
proton.HasLogo(ctx proton.Context) bool
```

---

## CodeBlock

Monospace text in a rounded bordered box. For showing commands, file paths,
snippets — anything the user is likely to copy.

```go
proton.CodeBlock(ctx, "go get github.com/CzaxStudio/proton")
proton.CodeBlock(ctx, `a.Window("App", 480, 300, draw)
a.Run()`)
```

```go
proton.CodeBlock(ctx proton.Context, code string)
```

---

## ShortcutHint

A small keyboard badge. Show these next to menu items or button labels
to communicate keyboard shortcuts.

```go
proton.Row(ctx,
    func(ctx proton.Context) { proton.Label(ctx, "Save") },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) { proton.ShortcutHint(ctx, "Ctrl+S") },
)
```

```go
proton.ShortcutHint(ctx proton.Context, keys string)
```

---

## ColorSwatch

A row of colored circles the user can click to select a color. Returns
the index of the selected one, or -1 if none selected yet.

```go
type UI struct {
    swatches     [6]proton.Clickable
    chosenColor  int
}

palette := []color.NRGBA{
    proton.RGB(0xf87171),
    proton.RGB(0xfbbf24),
    proton.RGB(0x4ade80),
    proton.RGB(0x60a5fa),
    proton.RGB(0xa78bfa),
    proton.RGB(0xf472b6),
}

i := proton.ColorSwatch(ctx, u.swatches[:], palette, u.chosenColor, 26)
if i >= 0 {
    u.chosenColor = i
}
```

```go
proton.ColorSwatch(ctx proton.Context, btns []proton.Clickable, colors []color.NRGBA, selected int, sizeDp float32) int
```

The selected circle gets a ring around it.
