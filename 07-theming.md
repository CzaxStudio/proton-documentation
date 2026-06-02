# Theming

Proton uses a palette system — four colors that control the look of your
entire app. Change the palette, everything updates. No hunting through CSS
files, no component-level overrides, no `!important`.

---

## The Palette

```go
type Palette struct {
    Bg        color.NRGBA   // window background
    Fg        color.NRGBA   // text and icons
    Primary   color.NRGBA   // buttons, sliders, progress bars, accents
    PrimaryFg color.NRGBA   // text drawn on top of primary elements
}
```

Apply it after `proton.New()` and before `a.Run()`:

```go
a := proton.New("my app")

a.ApplyPalette(proton.Palette{
    Bg:        proton.RGB(0x1e1e2e),
    Fg:        proton.RGB(0xcdd6f4),
    Primary:   proton.RGB(0x89b4fa),
    PrimaryFg: proton.RGB(0x1e1e2e),
})

a.Window("My App", 800, 600, draw)
a.Run()
```

---

## Built-in Palettes

Four ready-made palettes. Pick one and move on with your life.

### DarkPalette

A clean, neutral dark theme. Good default if you want dark without committing
to a specific aesthetic.

```go
a.ApplyPalette(proton.DarkPalette)
```

### NordPalette

The blue-grey arctic one. Half the GitHub repos use this color scheme.
You probably already like it.

```go
a.ApplyPalette(proton.NordPalette)
```

Colors: dark navy background, soft blue-white text, calm sky-blue accent.

### RosePinePalette

Warm, muted, and a bit moody. Good for apps where you want a calm, focused
feel rather than the stark contrast of a typical dark theme.

```go
a.ApplyPalette(proton.RosePinePalette)
```

### CatppuccinPalette

Pastel. Very popular right now. Makes your app look like it was designed in 2024
(which it was).

```go
a.ApplyPalette(proton.CatppuccinPalette)
```

---

## Custom Palettes

Build your own. You only need four hex values.

### Starting from scratch

```go
a.ApplyPalette(proton.Palette{
    Bg:        proton.RGB(0x0d1117),   // near black
    Fg:        proton.RGB(0xe6edf3),   // off white
    Primary:   proton.RGB(0x1f6feb),   // github blue
    PrimaryFg: proton.RGB(0xffffff),   // white text on blue
})
```

### Copy-paste presets

**Hacker Green** — your app will look like it belongs in a 90s movie

```go
a.ApplyPalette(proton.Palette{
    Bg:        proton.RGB(0x000000),
    Fg:        proton.RGB(0x00ff00),
    Primary:   proton.RGB(0x008f11),
    PrimaryFg: proton.RGB(0x000000),
})
```

**Midnight Ocean** — dark navy with sky blue accents

```go
a.ApplyPalette(proton.Palette{
    Bg:        proton.RGB(0x0f172a),
    Fg:        proton.RGB(0xf8fafc),
    Primary:   proton.RGB(0x38bdf8),
    PrimaryFg: proton.RGB(0x0f172a),
})
```

**Cyberpunk Red** — neon pink on near-black, lime green accent

```go
a.ApplyPalette(proton.Palette{
    Bg:        proton.RGB(0x1a0b0b),
    Fg:        proton.RGB(0xff2a6d),
    Primary:   proton.RGB(0xd1ff00),
    PrimaryFg: proton.RGB(0x000000),
})
```

**Solarized Dark** — the classic

```go
a.ApplyPalette(proton.Palette{
    Bg:        proton.RGB(0x002b36),
    Fg:        proton.RGB(0x839496),
    Primary:   proton.RGB(0x268bd2),
    PrimaryFg: proton.RGB(0xfdf6e3),
})
```

**Dracula** — purple dark theme, extremely popular

```go
a.ApplyPalette(proton.Palette{
    Bg:        proton.RGB(0x282a36),
    Fg:        proton.RGB(0xf8f8f2),
    Primary:   proton.RGB(0xbd93f9),
    PrimaryFg: proton.RGB(0x282a36),
})
```

**Gruvbox Dark** — warm earthy tones

```go
a.ApplyPalette(proton.Palette{
    Bg:        proton.RGB(0x282828),
    Fg:        proton.RGB(0xebdbb2),
    Primary:   proton.RGB(0xd79921),
    PrimaryFg: proton.RGB(0x282828),
})
```

---

## Font Scale

Make all text in the app bigger or smaller with a single call.
`1.0` is the default. Go up for readability, down if you need to fit more.

```go
a.SetFontScale(1.1)   // 10% bigger — good for accessibility
a.SetFontScale(1.2)   // 20% bigger
a.SetFontScale(0.9)   // 10% smaller — if you're cramming a lot in
```

Call this after `proton.New()` and before `a.Run()`.

---

## Designing Your Own Palette

A few tips from staring at color pickers for too long:

**Contrast ratio matters.** Your `Fg` should be clearly readable against
`Bg`. Light text on dark background or dark text on light background.
Don't do grey text on grey background and call it minimalist.

**Primary should pop, not scream.** It's the accent color on buttons and
interactive elements. Something with medium-high saturation usually works
well. Avoid full-saturation red (0xff0000) — it looks like an error.

**PrimaryFg is what gets drawn ON your buttons.** Usually either white or
the same as `Bg`. If your primary is very dark, use white. If it's light,
use a dark color.

**Test with a divider.** Call `proton.Divider(win)` with your palette.
If you can barely see it, your Fg might be too close to your Bg.

---

## Using Colors in Widgets

The palette affects Proton's built-in widgets automatically. For custom
elements like `Rect`, `Card`, and `Badge`, you supply colors directly:

```go
// using your own color
proton.Card(win, proton.RGB(0x2a2a3e), 10, 12, func(win *proton.Win) {
    proton.Label(win, "Custom card color")
})

// using theme colors via the material theme directly
th := win.Theme()
proton.Card(win, th.Palette.Bg, 10, 12, func(win *proton.Win) {
    proton.Label(win, "Uses whatever Bg the palette set")
})
```

`win.Theme()` returns the underlying `*material.Theme` if you need access
to the current palette colors programmatically.
