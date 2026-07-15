# Thématisation

Quatre couleurs contrôlent l’apparence de l’ensemble de votre application. Changez-les, tout est mis à jour.
Pas de recherche dans les feuilles de style des composants. Pas de guerre de spécificité CSS.

---

## La palette

```go
type Palette struct {
    Bg        color.NRGBA  // window background
    Fg        color.NRGBA  // text and icons
    Primary   color.NRGBA  // buttons, sliders, accents
    PrimaryFg color.NRGBA  // text drawn on top of primary elements
}
```

Appliquez-le après `proton.New()` et avant `a.Run()` :

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

## Palettes intégrées

46 palettes. Une ligne chacun.

### Thèmes sombres

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

### Thèmes légers

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

## Codes de couleur hexadécimaux

Si regarder les préfixes 0x vous fait émerveiller, utilisez plutôt des chaînes hexagonales.

```go
a.ThemeBuilder().
    Bg("#1e1e2e").
    Fg("#cdd6f4").
    Primary("#89b4fa").
    PrimaryFg("#1e1e2e").
    Apply()
```

Partez de zéro ou construisez sur une palette existante :

```go
// start from Nord, override just the primary color
a.ApplyPalette(proton.NordPalette)
a.ThemeBuilder().Primary("#ff6b6b").Apply()
```

`ThemeBuilder()` est préchargé avec les couleurs de la palette actuelle, appelant ainsi
il après `ApplyPalette` vous permet de patcher des emplacements individuels sans toucher au reste.

### Raccourci à un seul emplacement

```go
a.ColorCode("bg",        "#0d1117")
a.ColorCode("fg",        "#e6edf3")
a.ColorCode("primary",   "#1f6feb")
a.ColorCode("primaryfg", "#ffffff")
```

Noms d'emplacement valides : `"bg"`, `"background"`, `"fg"`, `"foreground"`, `"text"`,
`"primary"`, `"accent"`, `"primaryfg"`, `"primarytext"`.

Formats hexadécimaux acceptés : `"#rrggbb"`, `"rrggbb"`, `"#rgb"`, `"#rrggbbaa"`.

---

## Couleurs d'arrière-plan

Ceux-ci remplacent la couleur « Bg » de la palette par quelque chose de plus intéressant.

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

L'option arc-en-ciel cycle lentement au fil du temps et continue d'appeler `Invalidate()`
automatiquement pour piloter l'animation.

---

## Échelle de police

Agrandissez ou réduisez globalement tout le texte.

```go
a.SetFontScale(1.1)  // 10% bigger — good for accessibility
a.SetFontScale(1.2)  // 20% bigger
a.SetFontScale(0.9)  // a bit smaller
```

Appelez après `proton.New()` et avant `a.Run()`. « 1.0 » est la valeur par défaut.

---

## Widget de sélection de thèmes en direct

Laissez les utilisateurs choisir leur propre thème au moment de l’exécution. Déposez-le dans n’importe quelle fenêtre de paramètres.

```go
type UI struct {
    picker proton.ThemePickerState
}

proton.ThemePicker(ctx, &u.picker, a)
```

Le sélecteur affiche les 46 palettes intégrées avec chacune quatre échantillons de couleurs.
En cliquant sur l’un d’eux, vous l’appliquez immédiatement à l’application en cours d’exécution.

---

## Aide MakePalette

Si vous préférez les entiers hexadécimaux à la syntaxe littérale struct :

```go
// MakePalette(bg, fg, primary, primaryFg uint32)
p := proton.MakePalette(0x1e1e2e, 0xcdd6f4, 0x89b4fa, 0x1e1e2e)
a.ApplyPalette(p)
```

---

## AllPalettes — Itérer sur chaque palette intégrée

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

Utile pour créer des sélecteurs de thèmes personnalisés, des navigateurs de palettes ou simplement
imprimer les 46 noms pour voir ce qui est disponible.

---

## Copier-Coller des palettes personnalisées

Quelques favoris si vous ne souhaitez pas choisir parmi les éléments intégrés :

**GitHub sombre**```go
a.ThemeBuilder().Bg("#0d1117").Fg("#e6edf3").Primary("#1f6feb").PrimaryFg("#ffffff").Apply()
```

**Hacker Vert**```go
a.ThemeBuilder().Bg("#000000").Fg("#00ff00").Primary("#008f11").PrimaryFg("#000000").Apply()
```

**Océan de minuit**```go
a.ThemeBuilder().Bg("#0f172a").Fg("#f8fafc").Primary("#38bdf8").PrimaryFg("#0f172a").Apply()
```

**Papier chaud**```go
a.ThemeBuilder().Bg("#f5f0e8").Fg("#2c2416").Primary("#8b4513").PrimaryFg("#f5f0e8").Apply()
```

**Cyberpunk**```go
a.ThemeBuilder().Bg("#1a0b0b").Fg("#ff2a6d").Primary("#d1ff00").PrimaryFg("#000000").Apply()
```