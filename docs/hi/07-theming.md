# थीमिंग

चार रंग आपके संपूर्ण ऐप के स्वरूप को नियंत्रित करते हैं। उन्हें बदलो, सब कुछ अपडेट हो जाता है।
घटक स्टाइलशीट के माध्यम से कोई शिकार नहीं। कोई सीएसएस विशिष्टता युद्ध नहीं।

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

इसे `proton.New()` के बाद और `a.Run()` से पहले लागू करें:

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

## अंतर्निर्मित पैलेट्स

46 पैलेट. एक-एक पंक्ति.

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

### प्रकाश थीम

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

## हेक्स रंग कोड

यदि 0x उपसर्गों को घूरने से आपकी आँखें चौंधिया जाती हैं, तो इसके बजाय हेक्स स्ट्रिंग्स का उपयोग करें।

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

`ThemeBuilder()` वर्तमान पैलेट रंगों के साथ पहले से लोड किया गया है, इसलिए कॉलिंग
`ApplyPalette` के बाद यह आपको बाकी को छुए बिना अलग-अलग स्लॉट को पैच करने की सुविधा देता है।

### सिंगल-स्लॉट शॉर्टकट

```go
a.ColorCode("bg",        "#0d1117")
a.ColorCode("fg",        "#e6edf3")
a.ColorCode("primary",   "#1f6feb")
a.ColorCode("primaryfg", "#ffffff")
```

मान्य स्लॉट नाम: `"बीजी"`, `"बैकग्राउंड"`, `"एफजी"`, `"फोरग्राउंड"`, `"टेक्स्ट"`,
`"प्राथमिक"`, `"उच्चारण"`, `"प्राथमिकfg"`, `"प्राथमिकपाठ"`।

Accepted hex formats: `"#rrggbb"`, `"rrggbb"`, `"#rgb"`, `"#rrggbbaa"`.

---

## पृष्ठभूमि के रंग

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

इंद्रधनुष विकल्प समय के साथ धीरे-धीरे चक्रित होता है और `अमान्य()` कहता रहता है
एनीमेशन को स्वचालित रूप से चलाने के लिए।

---

## फ़ॉन्ट स्केल

विश्व स्तर पर सभी टेक्स्ट को बड़ा या छोटा करें।

```go
a.SetFontScale(1.1)  // 10% bigger — good for accessibility
a.SetFontScale(1.2)  // 20% bigger
a.SetFontScale(0.9)  // a bit smaller
```

`proton.New()` के बाद और `a.Run()` से पहले कॉल करें। `1.0` डिफ़ॉल्ट है.

---

## लाइव थीम पिकर विजेट

उपयोगकर्ताओं को रनटाइम पर अपनी थीम चुनने दें। इसे किसी भी सेटिंग विंडो में छोड़ें।

```go
type UI struct {
    picker proton.ThemePickerState
}

proton.ThemePicker(ctx, &u.picker, a)
```

पिकर सभी 46 अंतर्निर्मित पैलेट दिखाता है जिनमें से प्रत्येक में चार रंग के नमूने होते हैं।
किसी एक पर क्लिक करने से वह तुरंत चल रहे ऐप पर लागू हो जाता है।

---

## मेकपैलेट हेल्पर

यदि आप संरचनात्मक शाब्दिक वाक्यविन्यास पर हेक्स पूर्णांक पसंद करते हैं:

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

कस्टम थीम पिकर, पैलेट ब्राउज़र या बस निर्माण के लिए उपयोगी
यह देखने के लिए कि क्या उपलब्ध है, सभी 46 नाम प्रिंट कर रहा हूँ।

---

## कस्टम पैलेट कॉपी-पेस्ट करें

यदि आप बिल्ट-इन से नहीं चुनना चाहते तो कुछ पसंदीदा:

**गिटहब डार्क**```go
a.ThemeBuilder().Bg("#0d1117").Fg("#e6edf3").Primary("#1f6feb").PrimaryFg("#ffffff").Apply()
```

**Hacker Green**
```go
a.ThemeBuilder().Bg("#000000").Fg("#00ff00").Primary("#008f11").PrimaryFg("#000000").Apply()
```

**आधी रात का महासागर**```go
a.ThemeBuilder().Bg("#0f172a").Fg("#f8fafc").Primary("#38bdf8").PrimaryFg("#0f172a").Apply()
```

**गर्म कागज**```go
a.ThemeBuilder().Bg("#f5f0e8").Fg("#2c2416").Primary("#8b4513").PrimaryFg("#f5f0e8").Apply()
```

**साइबरपंक**```go
a.ThemeBuilder().Bg("#1a0b0b").Fg("#ff2a6d").Primary("#d1ff00").PrimaryFg("#000000").Apply()
```