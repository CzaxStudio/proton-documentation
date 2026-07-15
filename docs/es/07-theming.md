# Tematización

Cuatro colores controlan el aspecto de toda tu aplicación. Cambialos, todo se actualiza.
No se permite buscar en las hojas de estilo de los componentes. No hay guerras de especificidad de CSS.

---

## La paleta

```go
type Palette struct {
    Bg        color.NRGBA  // window background
    Fg        color.NRGBA  // text and icons
    Primary   color.NRGBA  // buttons, sliders, accents
    PrimaryFg color.NRGBA  // text drawn on top of primary elements
}
```

Aplíquelo después de `proton.New()` y antes de `a.Run()`:

```go
a := proton.New("myapp")

a.ApplyPalette(protón.Palette{
    Bg: protón.RGB(0x1e1e2e),
    Fg: protón.RGB(0xcdd6f4),
    Primario: protón.RGB(0x89b4fa),
    PrimaryFg: protón.RGB(0x1e1e2e),
})

a.Window("Aplicación", 800, 600, sorteo)
a.Ejecutar()
```

---

## Paletas integradas

46 paletas. Una línea cada uno.

### Temas oscuros

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

### Temas ligeros

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

## Códigos de colores hexadecimales

Si mirar los prefijos 0x hace que tus ojos se pongan vidriosos, usa cadenas hexadecimales en su lugar.

```go
a.ThemeBuilder().
    Bg("#1e1e2e").
    Fg("#cdd6f4").
    Primary("#89b4fa").
    PrimaryFg("#1e1e2e").
    Apply()
```

Comience desde cero o desarrolle una paleta existente:

```go
// start from Nord, override just the primary color
a.ApplyPalette(proton.NordPalette)
a.ThemeBuilder().Primary("#ff6b6b").Apply()
```

`ThemeBuilder()` está precargado con los colores de la paleta actual, por lo que llamar
después de "ApplyPalette" le permite parchear ranuras individuales sin tocar el resto.

### Acceso directo de una sola ranura

```go
a.ColorCode("bg",        "#0d1117")
a.ColorCode("fg",        "#e6edf3")
a.ColorCode("primary",   "#1f6feb")
a.ColorCode("primaryfg", "#ffffff")
```

Nombres de ranura válidos: `"bg"`, `"fondo"`, `"fg"`, `"primer plano"`, `"texto"`,
`"primario"`, `"acento"`, `"primariofg"`, `"textoprimario"`.

Formatos hexadecimales aceptados: `"#rrggbb"`, `"rrggbb"`, `"#rgb"`, `"#rrggbbaa"`.

---

## Colores de fondo

Estos anulan el color "Bg" de la paleta con algo más interesante.

```go
// solid color — three ways to say the same thing
a.SetBackground(proton.RGB(0x1a1b26))
a.SetBackgroundCode("#1a1b26")
a.SetBackgroundRGB(26, 27, 38)

// degradado de dos colores
a.SetBackgroundGradient("#1a1b26", "#2d1b69", "vertical")
a.SetBackgroundGradient("#0f172a", "#1e1b4b", "horizontal")
a.SetBackgroundGradient("#000000", "#1a1b26", "diagonal")
a.SetBackgroundGradient("#1e1e2e", "#6d28d9", "radial")

// arcoíris animado de espectro completo
a.SetBackgroundRainbow()
```

La opción del arco iris circula lentamente con el tiempo y sigue llamando a `Invalidate()`
automáticamente para controlar la animación.

---

## Escala de fuente

Haz que todo el texto sea más grande o más pequeño globalmente.

```go
a.SetFontScale(1.1)  // 10% bigger — good for accessibility
a.SetFontScale(1.2)  // 20% bigger
a.SetFontScale(0.9)  // a bit smaller
```

Llame después de `proton.New()` y antes de `a.Run()`. `1.0` es el valor predeterminado.

---

## Widget de selección de temas en vivo

Permita que los usuarios elijan su propio tema en tiempo de ejecución. Suelte esto en cualquier ventana de configuración.

```go
type UI struct {
    picker proton.ThemePickerState
}

protón.ThemePicker(ctx, &u.picker, a)
```

El selector muestra las 46 paletas integradas con cuatro muestras de color cada una.
Al hacer clic en uno, se aplica inmediatamente a la aplicación en ejecución.

---

## Ayudante de creación de paleta

Si prefiere los enteros hexadecimales a la sintaxis literal de estructura:

```go
// MakePalette(bg, fg, primary, primaryFg uint32)
p := proton.MakePalette(0x1e1e2e, 0xcdd6f4, 0x89b4fa, 0x1e1e2e)
a.ApplyPalette(p)
```

---

## AllPalettes: iterar sobre cada paleta incorporada

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

Útil para crear selectores de temas personalizados, navegadores de paletas o simplemente
imprimiendo los 46 nombres para ver qué hay disponible.

---

## Copiar y pegar paletas personalizadas

Algunos favoritos si no quieres elegir entre los integrados:

**GitHub Oscuro**
```ir
a.ThemeBuilder().Bg("#0d1117").Fg("#e6edf3").Primary("#1f6feb").PrimaryFg("#ffffff").Apply()
```

**Hacker verde**
```ir
a.ThemeBuilder().Bg("#000000").Fg("#00ff00").Primary("#008f11").PrimaryFg("#000000").Apply()
```

**Océano de medianoche**
```ir
a.ThemeBuilder().Bg("#0f172a").Fg("#f8fafc").Primary("#38bdf8").PrimaryFg("#0f172a").Apply()
```

**Papel caliente**
```ir
a.ThemeBuilder().Bg("#f5f0e8").Fg("#2c2416").Primary("#8b4513").PrimaryFg("#f5f0e8").Apply()
```

**Ciberpunk**
```ir
a.ThemeBuilder().Bg("#1a0b0b").Fg("#ff2a6d").Primary("#d1ff00").PrimaryFg("#000000").Apply()
```