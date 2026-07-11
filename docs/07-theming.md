# Theming

Four colors control the look of your entire app. Change them, everything updates.
No hunting through component stylesheets. No CSS specificity wars.

---

## The Palette

```go
type Palette struct {
    Bg        color.NRGBA  // window background
    Fg        color.NRGBA  // text and icons
    Primary   color.NRGBA  // buttons, sliders, accents
    PrimaryFg color.NRGBA  // text drawn on top of primary elements
}
```

Apply it after `proton.New()` and before `a.Run()`:

```go
a := proton.New("myapp")

a.ApplyPalette(proton.Palette{
    Bg:        proton.RGB(0x1e1e2e),
    Fg:        proton.RGB(0xcdd6f4),
    Primary:   proton.RGB(0x89b4fa),
    PrimaryFg: proton.RGB(0x1e1e2e),
})

a.Window("App", 800, 600, draw)
a.Run()
```

---

## Built-in Palettes

46 palettes. One line each.

### Dark Themes

```go
a.ApplyPalette(proton.DarkPalette)           // neutral dark
a.ApplyPalette(proton.NordPalette)           // arctic blue-grey
a.ApplyPalette(proton.RosePinePalette)       // warm muted purple
a.ApplyPalette(proton.RosePineMoonPalette)   // dark moon variant
a.ApplyPalette(proton.CatppuccinPalette)     // Catppuccin Mocha
a.ApplyPalette(proton.CatppuccinFrappePalette)
a.ApplyPalette(proton.CatppuccinMacchiatoPalette)
a.ApplyPalette(proton.DraculaPalette)        // purple, the classic
a.ApplyPalette(proton.GruvboxDarkPalette)    // warm earthy retro
a.ApplyPalette(proton.GruvboxMaterialDarkPalette)
a.ApplyPalette(proton.TokyoNightPalette)     // deep blue-purple
a.ApplyPalette(proton.TokyoNightStormPalette)
a.ApplyPalette(proton.MonokaiPalette)        // Sublime Text classic
a.ApplyPalette(proton.SolarizedDarkPalette)
a.ApplyPalette(proton.OneDarkPalette)        // Atom One Dark
a.ApplyPalette(proton.MaterialDarkPalette)
a.ApplyPalette(proton.AyuDarkPalette)
a.ApplyPalette(proton.AyuMiragePalette)
a.ApplyPalette(proton.EverforestDarkPalette) // muted green forest
a.ApplyPalette(proton.KanagawaPalette)       // inspired by The Great Wave
a.ApplyPalette(proton.VesperPalette)         // minimal warm dark
a.ApplyPalette(proton.NightOwlPalette)
a.ApplyPalette(proton.CarbonPalette)         // IBM Carbon
a.ApplyPalette(proton.MidnightPalette)       // deep navy
a.ApplyPalette(proton.ObsidianPalette)
a.ApplyPalette(proton.HackerPalette)         // green on black
a.ApplyPalette(proton.CyberpunkPalette)      // neon pink + lime
a.ApplyPalette(proton.OleDarkPalette)        // warm lamplight
a.ApplyPalette(proton.SlackPalette)          // Slack sidebar purple
a.ApplyPalette(proton.TerminalGreenPalette)  // CRT phosphor green
a.ApplyPalette(proton.TerminalAmberPalette)  // CRT phosphor amber
a.ApplyPalette(proton.OceanicNextPalette)
a.ApplyPalette(proton.IcebergPalette)
a.ApplyPalette(proton.SynthwavePalette)      // 80s neon
```

### Light Themes

```go
a.ApplyPalette(proton.LightPalette)
a.ApplyPalette(proton.SolarizedLightPalette)
a.ApplyPalette(proton.RosePineDawnPalette)   // Rose Pine light
a.ApplyPalette(proton.CatppuccinLattePalette)
a.ApplyPalette(proton.FluentLightPalette)    // Microsoft Fluent
a.ApplyPalette(proton.PaperPalette)          // warm off-white
a.ApplyPalette(proton.GithubLightPalette)
a.ApplyPalette(proton.AyuLightPalette)
a.ApplyPalette(proton.EverforestLightPalette)
a.ApplyPalette(proton.NordLightPalette)
a.ApplyPalette(proton.GruvboxLightPalette)
a.ApplyPalette(proton.TokyoNightDayPalette)
```

---

## Hex Color Codes

If staring at 0x prefixes makes your eyes glaze over, use hex strings instead.

```go
a.ThemeBuilder().
    Bg("#1e1e2e").
    Fg("#cdd6f4").
    Primary("#89b4fa").
    PrimaryFg("#1e1e2e").
    Apply()
```

Start from scratch or build on an existing palette:

```go
// start from Nord, override just the primary color
a.ApplyPalette(proton.NordPalette)
a.ThemeBuilder().Primary("#ff6b6b").Apply()
```

`ThemeBuilder()` is pre-loaded with the current palette colors, so calling
it after `ApplyPalette` lets you patch individual slots without touching the rest.

### Single-slot shortcut

```go
a.ColorCode("bg",        "#0d1117")
a.ColorCode("fg",        "#e6edf3")
a.ColorCode("primary",   "#1f6feb")
a.ColorCode("primaryfg", "#ffffff")
```

Valid slot names: `"bg"`, `"background"`, `"fg"`, `"foreground"`, `"text"`,
`"primary"`, `"accent"`, `"primaryfg"`, `"primarytext"`.

Accepted hex formats: `"#rrggbb"`, `"rrggbb"`, `"#rgb"`, `"#rrggbbaa"`.

---

## Background Colors

These override the palette's `Bg` color with something more interesting.

```go
// solid color — three ways to say the same thing
a.SetBackground(proton.RGB(0x1a1b26))
a.SetBackgroundCode("#1a1b26")
a.SetBackgroundRGB(26, 27, 38)

// two-color gradient
a.SetBackgroundGradient("#1a1b26", "#2d1b69", "vertical")
a.SetBackgroundGradient("#0f172a", "#1e1b4b", "horizontal")
a.SetBackgroundGradient("#000000", "#1a1b26", "diagonal")
a.SetBackgroundGradient("#1e1e2e", "#6d28d9", "radial")

// animated full-spectrum rainbow
a.SetBackgroundRainbow()
```

The rainbow option cycles slowly over time and keeps calling `Invalidate()`
automatically to drive the animation.

---

## Font Scale

Make all text bigger or smaller globally.

```go
a.SetFontScale(1.1)  // 10% bigger — good for accessibility
a.SetFontScale(1.2)  // 20% bigger
a.SetFontScale(0.9)  // a bit smaller
```

Call after `proton.New()` and before `a.Run()`. `1.0` is the default.

---

## Live Theme Picker Widget

Let users pick their own theme at runtime. Drop this into any settings window.

```go
type UI struct {
    picker proton.ThemePickerState
}

proton.ThemePicker(ctx, &u.picker, a)
```

The picker shows all 46 built-in palettes with four color swatches each.
Clicking one applies it to the running app immediately.

---

## MakePalette Helper

If you prefer hex integers over the struct literal syntax:

```go
// MakePalette(bg, fg, primary, primaryFg uint32)
p := proton.MakePalette(0x1e1e2e, 0xcdd6f4, 0x89b4fa, 0x1e1e2e)
a.ApplyPalette(p)
```

---

## AllPalettes — Iterate Over Every Built-in Palette

```go
// proton.AllPalettes is []proton.NamedPalette
for i, p := range proton.AllPalettes {
    fmt.Printf("%d: %s\n", i, p.Name)
}
```

```go
type NamedPalette struct {
    Name    string
    Palette Palette
}
```

Useful for building custom theme pickers, palette browsers, or just
printing all 46 names to see what's available.

---

## Copy-Paste Custom Palettes

Some favorites if you don't want to pick from the built-ins:

**GitHub Dark**
```go
a.ThemeBuilder().Bg("#0d1117").Fg("#e6edf3").Primary("#1f6feb").PrimaryFg("#ffffff").Apply()
```

**Hacker Green**
```go
a.ThemeBuilder().Bg("#000000").Fg("#00ff00").Primary("#008f11").PrimaryFg("#000000").Apply()
```

**Midnight Ocean**
```go
a.ThemeBuilder().Bg("#0f172a").Fg("#f8fafc").Primary("#38bdf8").PrimaryFg("#0f172a").Apply()
```

**Warm Paper**
```go
a.ThemeBuilder().Bg("#f5f0e8").Fg("#2c2416").Primary("#8b4513").PrimaryFg("#f5f0e8").Apply()
```

**Cyberpunk**
```go
a.ThemeBuilder().Bg("#1a0b0b").Fg("#ff2a6d").Primary("#d1ff00").PrimaryFg("#000000").Apply()
```
