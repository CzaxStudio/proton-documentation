# Κουμπιά

Τα κουμπιά είναι πώς οι χρήστες λένε στην εφαρμογή σας να κάνει πράγματα. Το πρωτόνιο έχει τέσσερα είδη,
συν συνδέσμους με δυνατότητα κλικ και έναν τρόπο να κάνετε κυριολεκτικά οτιδήποτε πατήσιμο.

---

## Ο ένας κανόνας

Κάθε κουμπί χρειάζεται το δικό του πεδίο «proton.Clickable» στη δομή κατάστασης σας.

```go
type UI struct {
    save   proton.Clickable
    cancel proton.Clickable
    delete proton.Clickable
}
```

Μην μοιράζεστε ένα ανάμεσα σε δύο κουμπιά. Εάν το κάνετε, κάνοντας κλικ σε ένα από τα δύο ενεργοποιείται
και τα δύο — που είναι ένα διασκεδαστικό σφάλμα για εντοπισμό σφαλμάτων και ένα τρομερό UX.

Επίσης, τα κουμπιά πρέπει να βρίσκονται μέσα σε ένα περιτύλιγμα διάταξης ("Pad", "Row", "Column" κ.λπ.)
για κλικ για εγγραφή. Δείτε το [Getting Started](./00-getting-started.md) για το γιατί.

---

## Κουμπί

Γεμάτη, συμπαγή, πρωταρχική δράση. Χρησιμοποιήστε το για αυτό που θέλετε περισσότερο
χρήστη να κάνει κλικ.

```go
var save proton.Clickable

proton.Pad(ctx, 8, func(ctx proton.Context) {
    if proton.Button(ctx, &save, "Save") {
        doSave()
    }
})
```

Επιστρέφει "true" στο πλαίσιο στο οποίο γίνεται κλικ. Ένα κλικ, ένα «αληθινό». Αυτό
δεν συνεχίζει να πυροβολεί ενώ κρατιέται πατημένο.

```go
proton.Button(ctx proton.Context, state *proton.Clickable, label string) bool
```

---

## OutlineButton

Στυλ φάντασμα/περιγράμματος. Ίδια συμπεριφορά με το Button αλλά χωρίς το γεμάτο
φόντο. Χρησιμοποιήστε το για δευτερεύουσες ενέργειες — πράγματα που μπορεί να θέλει ο χρήστης
να κάνουμε, αλλά αυτή δεν είναι η κύρια ενέργεια.

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

Η οπτική ιεραρχία εδώ — περίγραμμα για Ακύρωση, συμπληρωμένη για Αποθήκευση — λέει
χρήστες ποια είναι η κύρια ενέργεια χωρίς ούτε μια λέξη εξήγησης.

```go
proton.OutlineButton(ctx proton.Context, state *proton.Clickable, label string) bool
```

---

## Κουμπί εικονιδίου

Ένα κουμπί μόνο για εικονίδιο. Χωρίς κείμενο, μόνο ένα εικονίδιο. Κοινό στις γραμμές εργαλείων.

```go
// icon is a *proton.Icon — load one with widget.NewIcon() from gioui.org/widget
var closeBtn proton.Clickable

if proton.IconButton(ctx, &closeBtn, closeIcon, "Close window") {
    win.Close()
}
```

Το τέταρτο επιχείρημα είναι η περιγραφή προσβασιμότητας — τι είναι ένα πρόγραμμα ανάγνωσης οθόνης
θα έλεγε. Μην το παραλείψετε.

```go
proton.IconButton(ctx proton.Context, state *proton.Clickable, icon *proton.Icon, desc string) bool
```

---

## Αγγίξτε

Κάνει οποιοδήποτε περιεχόμενο με δυνατότητα κλικ. Ολόκληρη η περιοχή που σχεδιάζετε μέσα στην επανάκληση
γίνεται ο στόχος του χτυπήματος. Χρησιμοποιήστε το για κάρτες, σειρές λιστών, προσαρμοσμένα κουμπιά ή
οτιδήποτε όπου μια τυπική ετικέτα κουμπιού δεν είναι αυτό που θέλετε.

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

## Link και LinkSmall

Υπογραμμισμένο κείμενο με δυνατότητα κλικ με στυλ υπερσύνδεσμου. Διαχειριστείτε μόνοι σας το κλικ —
Το Proton δεν ανοίγει διευθύνσεις URL για εσάς, απλώς σας λέει ότι ο χρήστης έκανε κλικ.

```go
var githubLink proton.Clickable

if proton.Link(ctx, &githubLink, "View on GitHub") {
    openBrowser("https://github.com/CzaxStudio/proton")
}
```

Το "LinkSmall" είναι το ίδιο πράγμα, αλλά χρησιμοποιεί κείμενο σε μέγεθος λεζάντα:

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

## Κοινά μοτίβα

### Επιβεβαίωση / Ακύρωση σειράς (δεξιά στοίχιση)

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

Το "RowEnd" ωθεί τα πάντα στη δεξιά άκρη — τυπική τοποθέτηση για
επιβεβαίωση/ακύρωση ζευγών.

### Γραμμή εργαλείων

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

### Σειρές λίστας με δυνατότητα κλικ

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