# Για προχωρημένους

Συντομεύσεις πληκτρολογίου, ασύγχρονες γορουτίνες, ειδοποιήσεις τοστ, modals, καρτέλες,
ακορντεόν, μενού περιβάλλοντος και οτιδήποτε άλλο δεν ταιριάζει
τις προηγούμενες σελίδες.

---

## Ειδοποιήσεις τοστ

Ένα χρονομετρημένο μήνυμα που εμφανίζεται, παραμένει για λίγα δευτερόλεπτα και εξαφανίζεται πάνω του
δικός. Χωρίς διάλογο, χωρίς αποκλεισμό του χρήστη.

```go
type UI struct {
    toast proton.ToastState
}

// trigger from anywhere — goroutine-safe
u.toast.Show("File saved!", 2*time.Second)

// draw it LAST in your draw function so it renders on top of everything
proton.Toast(ctx, &u.toast)
```

Εάν δεν υπάρχει ενεργό τοστ, το «Τοστ» δεν αντλεί τίποτα. Δεν χρειάζεται να ελέγξετε πρώτα.

```go
func (t *ToastState) Show(msg string, duration time.Duration)
proton.Toast(ctx proton.Context, state *proton.ToastState)
```

---

## Overlay / Modal

Ένα σκοτεινό φόντο με κεντρικό περιεχόμενο πάνω από όλα.

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

Η "Επικάλυψη" δεν αντλεί τίποτα όταν το "state.Visible" είναι ψευδές, επομένως μπορείτε να το καλέσετε
κάθε πλαίσιο χωρίς καμία συνθήκη περιτυλίγματος.

---

## Συντομεύσεις πληκτρολογίου

Καταχωρίστε μια λειτουργία για ενεργοποίηση όταν πατηθεί ένας συνδυασμός πλήκτρων.

```go
proton.OnKey(ctx, proton.ModCtrl, "S", func() { save() })
proton.OnKey(ctx, proton.ModCtrl, "Z", func() { undo() })
proton.OnKey(ctx, proton.ModCtrl|proton.ModShift, "N", func() { newFile() })
proton.OnKey(ctx, proton.ModNone, proton.KeyEscape, func() { closeDialog() })
```

Καλέστε «OnKey» μέσα στη συνάρτηση κλήρωσης. Καταγράφει τη συντόμευση για αυτό
πλαίσιο. Εφόσον η συνάρτηση σχεδίασης εκτελεί κάθε καρέ, οι συντομεύσεις παραμένουν ενεργές ως
όσο το παράθυρο είναι ανοιχτό.

```go
proton.OnKey(ctx proton.Context, modifiers proton.Modifier, keyName string, fn func())
```

**Σταθερές τροποποιητή:**

```go
proton.ModNone   // no modifier — just the key
proton.ModCtrl   // Ctrl (Cmd on macOS)
proton.ModShift
proton.ModAlt

// combine with |
proton.ModCtrl | proton.ModShift
```

**Σταθερές ονόματος κλειδιού** (για κλειδιά χωρίς γράμματα):

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

Τα πλήκτρα γραμμάτων είναι απλώς συμβολοσειρές: `"S"`, "Z"`, "N"`, ""A"".

---

## Καρτέλες

Μια οριζόντια γραμμή καρτελών με μία περιοχή περιεχομένου που αλλάζει με βάση το
επιλεγμένη καρτέλα.

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

Το "u.tabs.Selected" διατηρεί το ευρετήριο της ενεργής καρτέλας. Μπορείτε να το ρυθμίσετε μέσω προγραμματισμού
για εναλλαγή καρτελών από κώδικα.

```go
proton.Tabs(ctx proton.Context, labels []string, btns []proton.Clickable, state *proton.TabState, content func(proton.Context, int))
```

Το τμήμα `btns` χρειάζεται ένα «με δυνατότητα κλικ» ανά καρτέλα. Το πέρασμα του "u.tabBtns[:]" είναι
ο ιδιωματικός τρόπος όταν δηλώνετε έναν πίνακα σταθερού μεγέθους στη δομή σας.

---

## Ακορντεόν

Μια πτυσσόμενη ενότητα με κεφαλίδα με δυνατότητα κλικ.

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

Το "state.Open" παρακολουθεί εάν έχει επεκταθεί. Μπορείτε να το ρυθμίσετε απευθείας για να ξεκινήσει
ένα ακορντεόν ανοιχτό: `u.sec1.Open = true`.

---

## Μενού περιβάλλοντος

Ένα μενού με δεξί κλικ που εμφανίζεται στη θέση του δρομέα.

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

Επιστρέφει -1 όταν δεν έχει επιλεγεί τίποτα και το ευρετήριο του στοιχείου στο πλαίσιο
κάτι γίνεται κλικ. Το μενού κλείνει αυτόματα μετά από μια επιλογή.

---

## Ασύγχρονες ενημερώσεις και γορουτίνες

Η συνάρτηση σχεδίασης εκτελείται στο κύριο νήμα. Όταν μια γορουτίνα τελειώνει τη δουλειά
και αλλάζει κατάσταση, καλέστε «ctx.Invalidate()» για να ζητήσετε επανασχεδιασμό.

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

Χωρίς το "ctx.Invalidate()", το παράθυρο δεν θα επανασχεδιαστεί μέχρι να μετακινηθεί ο χρήστης
το ποντίκι ή αλληλεπιδρά με αυτό. Καλέστε το πάντα μετά την αλλαγή κατάστασης από
μια γορουτίνα.

---

## Spinner

Μια κινούμενη ένδειξη φόρτωσης. Η κλήση του 'Spinner' διατηρεί αυτόματα το
επανασχεδιασμός παραθύρου — δεν απαιτείται βρόχος «Invalidate()».

```go
type UI struct {
    spin proton.SpinnerState
}

proton.Spinner(ctx, &u.spin, 32)  // 32dp diameter
```

```go
proton.Spinner(ctx proton.Context, state *proton.SpinnerState, sizeDp float32)
```

Το "SpinnerState" παρακολουθεί την ώρα έναρξης της κινούμενης εικόνας. Δηλώστε ένα ανά κλώστη
στην κρατική σας δομή.

---

## SelectBox (αναπτυσσόμενο)

```go
type UI struct {
    langSel proton.SelectBoxState
}

langs := []string{"Go", "Rust", "Zig", "C", "Python"}
i := proton.SelectBox(ctx, &u.langSel, langs)
proton.Caption(ctx, "Selected: "+langs[i])
```

Το αναπτυσσόμενο μενού ανοίγει κάτω από το κουμπί και κλείνει με επιλογή ή εξωτερικό κλικ.

```go
proton.SelectBox(ctx proton.Context, state *proton.SelectBoxState, options []string) int
```

---

## Εάν — Απόδοση υπό όρους

Αποδίδει περιεχόμενο μόνο όταν μια συνθήκη είναι αληθής. Αποθηκεύει ένα μπλοκ "if" όταν εσείς
απλά θέλετε να εμφανίσετε ή να αποκρύψετε ένα γραφικό στοιχείο.

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

## Περιοχή εστίασης — Χειρισμός κλειδιού εμβέλειας

Όταν χρειάζεστε ενεργά συμβάντα πληκτρολογίου μόνο σε μια συγκεκριμένη περιοχή της διεπαφής χρήστη,
όχι σε παγκόσμιο επίπεδο. Συνήθως το "OnKey" είναι αρκετό — προσεγγίστε αυτό όταν έχετε δύο
πάνελ που θα πρέπει να έχουν ανεξάρτητες συντομεύσεις πληκτρολογίου.

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

## Επιλογές παραθύρου

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

## Διατήρηση κινούμενων εικόνων σε λειτουργία

Το Proton επανασχεδιάζεται μόνο όταν υπάρχει είσοδος χρήστη ή καλείτε το "ctx.Invalidate()".
Για κινούμενα σχέδια — γραμμές προόδου που γεμίζουν με την πάροδο του χρόνου, αντίστροφες μετρήσεις, οτιδήποτε
βάσει χρόνου — καλέστε «Invalidate» στο τέλος κάθε καρέ για να διατηρήσετε τις επανασχεδιάσεις
πηγαίνοντας:

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

Όταν το "u.animating" είναι ψευδές, το "Invalidate" σταματά να καλείται και το Proton
επιστρέφει στην επανασχεδίαση μόνο με την εισαγωγή του χρήστη. Το γραφικό στοιχείο Spinner το κάνει αυτό
αυτόματα — δεν χρειάζεται να το διαχειριστείτε μόνοι σας.