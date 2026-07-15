# Θέμα

Τέσσερα χρώματα ελέγχουν την εμφάνιση ολόκληρης της εφαρμογής σας. Αλλάξτε τα, όλα ενημερώνονται.
Χωρίς κυνήγι μέσω φύλλων στυλ συστατικών. Δεν υπάρχουν πόλεμοι ειδικοτήτων CSS.

---

## Η Παλέτα

```go
type Palette struct {
    Bg        color.NRGBA  // window background
    Fg        color.NRGBA  // text and icons
    Primary   color.NRGBA  // buttons, sliders, accents
    PrimaryFg color.NRGBA  // text drawn on top of primary elements
}
```

Εφαρμόστε το μετά το «proton.New()» και πριν το «a.Run()»:

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

## Ενσωματωμένες παλέτες

46 παλέτες. Μία γραμμή το καθένα.

### Σκούρα θέματα

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

### Φωτεινά θέματα

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

Αν κοιτάζοντας επίμονα προθέματα 0x τα μάτια σας γυαλίζουν, χρησιμοποιήστε αντ' αυτού εξάγωνες χορδές.

```go
a.ThemeBuilder().
    Bg("#1e1e2e").
    Fg("#cdd6f4").
    Primary("#89b4fa").
    PrimaryFg("#1e1e2e").
    Apply()
```

Ξεκινήστε από το μηδέν ή χτίστε σε μια υπάρχουσα παλέτα:

```go
// start from Nord, override just the primary color
a.ApplyPalette(proton.NordPalette)
a.ThemeBuilder().Primary("#ff6b6b").Apply()
```

Το `ThemeBuilder()` είναι προφορτωμένο με τα τρέχοντα χρώματα της παλέτας, έτσι καλώντας
μετά το "ApplyPalette" σας επιτρέπει να επιδιορθώσετε μεμονωμένες υποδοχές χωρίς να αγγίξετε τις υπόλοιπες.

### Συντόμευση μονής υποδοχής

```go
a.ColorCode("bg",        "#0d1117")
a.ColorCode("fg",        "#e6edf3")
a.ColorCode("primary",   "#1f6feb")
a.ColorCode("primaryfg", "#ffffff")
```

Έγκυρα ονόματα θέσεων: `"bg"`, `"φόντο"`, `"fg"`, `"προσκηνίου"`, "κείμενο"`,
""κύριο"", ""προφορά"", ""πρωτεύον"", "πρωτεύον κείμενο"".

Αποδεκτές μορφές δεκαεξαδικού: `"#rrggbb"`, `"rrggbb"`, `"#rgb"`, "#rrggbbaa"`.

---

## Χρώματα φόντου

Αυτά αντικαθιστούν το χρώμα «Bg» της παλέτας με κάτι πιο ενδιαφέρον.

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

Η επιλογή του ουράνιου τόξου ανακυκλώνεται αργά με την πάροδο του χρόνου και συνεχίζει να καλεί "Invalidate()".
αυτόματα για να οδηγήσετε το κινούμενο σχέδιο.

---

## Κλίμακα γραμματοσειράς

Κάντε όλο το κείμενο μεγαλύτερο ή μικρότερο παγκοσμίως.

```go
a.SetFontScale(1.1)  // 10% bigger — good for accessibility
a.SetFontScale(1.2)  // 20% bigger
a.SetFontScale(0.9)  // a bit smaller
```

Καλέστε μετά το «proton.New()» και πριν το «a.Run()». Το "1.0" είναι η προεπιλογή.

---

## Γραφικό στοιχείο επιλογής ζωντανού θέματος

Επιτρέψτε στους χρήστες να επιλέξουν το δικό τους θέμα κατά την εκτέλεση. Ρίξτε το σε οποιοδήποτε παράθυρο ρυθμίσεων.

```go
type UI struct {
    picker proton.ThemePickerState
}

proton.ThemePicker(ctx, &u.picker, a)
```

Το εργαλείο επιλογής εμφανίζει και τις 46 ενσωματωμένες παλέτες με τέσσερα δείγματα χρωμάτων η καθεμία.
Κάνοντας κλικ σε ένα, εφαρμόζεται αμέσως στην εφαρμογή που εκτελείται.

---

## Βοηθός MakePalette

Εάν προτιμάτε τους δεκαεξαδικούς ακέραιους από την κυριολεκτική σύνταξη της δομής:

```go
// MakePalette(bg, fg, primary, primaryFg uint32)
p := proton.MakePalette(0x1e1e2e, 0xcdd6f4, 0x89b4fa, 0x1e1e2e)
a.ApplyPalette(p)
```

---

## Όλες οι παλέτες — Επανάληψη σε κάθε ενσωματωμένη παλέτα

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

Χρήσιμο για τη δημιουργία προσαρμοσμένων επιλογέων θεμάτων, προγραμμάτων περιήγησης παλέτας ή απλώς
εκτύπωση και των 46 ονομάτων για να δείτε τι είναι διαθέσιμο.

---

## Αντιγραφή-Επικόλληση προσαρμοσμένων παλετών

Μερικά αγαπημένα αν δεν θέλετε να επιλέξετε από τα ενσωματωμένα:

**GitHub Dark**```go
a.ThemeBuilder().Bg("#0d1117").Fg("#e6edf3").Primary("#1f6feb").PrimaryFg("#ffffff").Apply()
```

**Hacker Green**```go
a.ThemeBuilder().Bg("#000000").Fg("#00ff00").Primary("#008f11").PrimaryFg("#000000").Apply()
```

**Μεσάνυχτα Ωκεανό**```go
a.ThemeBuilder().Bg("#0f172a").Fg("#f8fafc").Primary("#38bdf8").PrimaryFg("#0f172a").Apply()
```

**Ζεστό χαρτί**```go
a.ThemeBuilder().Bg("#f5f0e8").Fg("#2c2416").Primary("#8b4513").PrimaryFg("#f5f0e8").Apply()
```

**Κυμπερπανκ**```go
a.ThemeBuilder().Bg("#1a0b0b").Fg("#ff2a6d").Primary("#d1ff00").PrimaryFg("#000000").Apply()
```