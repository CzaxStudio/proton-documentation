# Οπτικά γραφικά στοιχεία

Σχήματα, κάρτες, εικόνες, σήματα, δαχτυλίδια προόδου, πίνακες, είδωλα — τα πράγματα
που κάνουν την εφαρμογή σας να μοιάζει σαν να έχει σχεδιαστεί επίτηδες.

---

## Διαιρέτης

Ένας λεπτός οριζόντιος κανόνας. Χρησιμοποιήστε το μεταξύ των ενοτήτων.

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

Ίδιο με το Divider αλλά με κεντραρισμένη ετικέτα κειμένου.

```go
proton.LabeledDivider(ctx, "Advanced Settings")
proton.LabeledDivider(ctx, "")   // plain divider — same as Divider
```

```go
proton.LabeledDivider(ctx proton.Context, label string)
```

---

## Rect

Ένα μονόχρωμο ορθογώνιο. Περάστε το 0 για πλάτος ή ύψος για να γεμίσετε το
διαθέσιμο χώρο σε αυτόν τον άξονα.

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

Ίδιο με το Rect αλλά με στρογγυλεμένες γωνίες.

```go
proton.RoundRect(ctx, proton.RGB(0x2a2a3e), 200, 60, 12)  // 12dp corner radius
proton.RoundRect(ctx, proton.RGB(0x4c566a), 0, 40, 20)    // full width, pill shape
```

```go
proton.RoundRect(ctx proton.Context, c color.NRGBA, widthDp, heightDp, radiusDp float32)
```

---

## Κάρτα

Περιεχόμενο μέσα σε ένα παραγεμισμένο, στρογγυλεμένο ορθογώνιο φόντο με μια λεπτή σκιά.
Το κοντέινερ μετάβασης για ομαδοποίηση σχετικού περιεχομένου.

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

- `bg` — χρώμα φόντου
- `cornerDp` — ακτίνα γωνίας (8–12 φαίνεται καλό για τα περισσότερα φύλλα)
- «padDp» — γέμιση μεταξύ της άκρης της κάρτας και του περιεχομένου

### HoverCard

Μια κάρτα που αλλάζει χρώμα φόντου κατά την τοποθέτηση του δείκτη. Επιστρέφει true αν γίνει κλικ.

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

## Σήμα

Ένα μικρό στρογγυλεμένο τσιπ με κείμενο. Για ετικέτες κατάστασης, ετικέτες, μετρήσεις, οτιδήποτε
που χρειάζεται ένα χρωματιστό χάπι.

```go
proton.Badge(ctx, proton.RGB(0x5e81ac), proton.RGB(0xeceff4), "stable")
proton.Badge(ctx, proton.RGB(0xa3be8c), proton.RGB(0x2e3440), "passing")
proton.Badge(ctx, proton.RGB(0xbf616a), proton.RGB(0xeceff4), "failing")
```

```go
proton.Badge(ctx proton.Context, bg, fg color.NRGBA, text string)
```

Σήματα στη σειρά:

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

Ένας μικρός έγχρωμος κύκλος. Ενδείξεις σε απευθείας σύνδεση/εκτός σύνδεσης, κατάσταση κατασκευής, οτιδήποτε
που χρειάζεται μια έγχρωμη κουκκίδα δίπλα σε κάποιο κείμενο.

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

Ένα κυκλικό σήμα που δείχνει τα αρχικά. Για φωτογραφίες προφίλ χρήστη όταν δεν υπάρχει εικόνα
είναι διαθέσιμο — το οποίο είναι τις περισσότερες φορές.

```go
proton.Avatar(ctx, "AJ", proton.RGB(0x5e81ac), proton.RGB(0xeceff4), 40)
proton.Avatar(ctx, "BC", proton.RGB(0xa3be8c), proton.RGB(0x2e3440), 32)
```

```go
proton.Avatar(ctx proton.Context, initials string, bg, fg color.NRGBA, sizeDp float32)
```

---

## Δακτύλιος προόδου

Ένας κυκλικός δείκτης προόδου. Καλό για κάρτες στατιστικών και ταμπλό όπου
το κυκλικό σχήμα επικοινωνεί περισσότερο οπτικά το ποσοστό από μια μπάρα.

```go
proton.ProgressRing(ctx, 0.72, 48, 5, proton.RGB(0x88c0d0))
//                       ^     ^   ^   ^
//                  progress  sz  strokeW  color
```

```go
proton.ProgressRing(ctx proton.Context, progress, sizeDp, strokeDp float32, c color.NRGBA)
```

Η «πρόοδος» είναι 0,0–1,0. Το "sizeDp" είναι η διάμετρος. Το "strokeDp" είναι το δαχτυλίδι
πάχος — 4–6dp φαίνεται καλό για τα περισσότερα μεγέθη.

---

## Πίνακας

Ένας πίνακας δεδομένων με μια σειρά κεφαλίδας και εναλλασσόμενη σκίαση σειρών.

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

Το "proton.TableRow" είναι απλώς "[]string". Οι στήλες είναι εξίσου φαρδιές.

---

## Βήμα

Ένας οριζόντιος δείκτης προόδου βήματος για ροές πολλαπλών βημάτων.

```go
proton.Stepper(ctx, 1, []string{"Account", "Profile", "Payment", "Done"})
//                  ^
//              current step (0-based)
```

```go
proton.Stepper(ctx proton.Context, current int, steps []string)
```

Το βήμα 0 είναι το πρώτο βήμα. Τα ολοκληρωμένα βήματα (ευρετήριο < τρέχον) έχουν συμπληρωθεί
χρώμα έμφασης. Το τρέχον βήμα επισημαίνεται. Τα μελλοντικά βήματα είναι αμυδρά.

---

## Επεξήγηση εργαλείου

Μια μικρή ετικέτα που εμφανίζεται όταν ο χρήστης τοποθετεί τον δείκτη του ποντικιού πάνω από κάτι.

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

Τα κομμάτια "κατάσταση" με δυνατότητα κλικ αιωρούνται για την περιοχή συμβουλών εργαλείων. Είναι ξεχωριστό από
οποιοδήποτε κουμπί μέσα στο περιεχόμενο — δηλώστε ένα αποκλειστικό για κάθε επεξήγηση εργαλείου.

---

## Εικόνες

Φόρτωση μία φορά κατά την εκκίνηση. Σχεδιάστε κάθε πλαίσιο.

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

Υποστηρίζονται και τα δύο PNG και JPEG.

---

## Λογότυπο

Το λογότυπο της εφαρμογής σας, φορτώθηκε μία φορά και σχεδιάστηκε οπουδήποτε. Δείτε το [07-theming.md](./07-theming.md)
για την πλήρη εγκατάσταση. Η σύντομη έκδοση:

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

Monospace κείμενο σε ένα στρογγυλεμένο πλαίσιο με περίγραμμα. Για εμφάνιση εντολών, μονοπατιών αρχείων,
αποσπάσματα — οτιδήποτε είναι πιθανό να αντιγράψει ο χρήστης.

```go
proton.CodeBlock(ctx, "go get github.com/CzaxStudio/proton")
proton.CodeBlock(ctx, `a.Window("App", 480, 300, draw)
a.Run()`)
```

```go
proton.CodeBlock(ctx proton.Context, code string)
```

---

## Συμβουλή συντόμευσης

Ένα μικρό σήμα πληκτρολογίου. Εμφάνιση αυτών δίπλα σε στοιχεία μενού ή ετικέτες κουμπιών
για την επικοινωνία συντομεύσεων πληκτρολογίου.

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

Μια σειρά από έγχρωμους κύκλους στους οποίους ο χρήστης μπορεί να κάνει κλικ για να επιλέξει ένα χρώμα. Επιστροφές
το ευρετήριο του επιλεγμένου ή -1 εάν δεν έχει επιλεγεί ακόμη κανένα.

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

Ο επιλεγμένος κύκλος παίρνει ένα δαχτυλίδι γύρω του.