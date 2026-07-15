# Λίστες και κύλιση

Για εμφάνιση συλλογών πραγμάτων και για δυνατότητα κύλισης περιοχών περιεχομένου.

---

## Λίστα — Κατακόρυφη λίστα με δυνατότητα κύλισης

Η τυπική λίστα. Σχεδιάζει μόνο τα στοιχεία που είναι ορατά αυτήν τη στιγμή στην οθόνη, έτσι
10.000 αντικείμενα είναι μια χαρά.

```go
type UI struct {
    scroll proton.Scrollable
}

items := []string{"Apples", "Bananas", "Cherries", "Durian (why)"}

proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
    proton.Label(ctx, items[i])
})
```

Η επανάκληση λαμβάνει το ευρετήριο «i». Σχεδιάστε ό,τι θέλετε για κάθε σειρά.

```go
proton.List(ctx proton.Context, state *proton.Scrollable, length int, draw func(proton.Context, int))
```

Δηλώστε ένα «proton.Scrollable» ανά λίστα. Παρακολουθεί τη θέση κύλισης.
Μην μοιράζεστε μία μεταξύ δύο λιστών — θα τσακωθούν για τη θέση κύλισης και
χάνουν και οι δύο.

---

## HList — Οριζόντια λίστα με δυνατότητα κύλισης

Ίδιο με τη Λίστα, αλλά τα στοιχεία πηγαίνουν από αριστερά προς τα δεξιά.

```go
proton.HList(ctx, &u.hscroll, len(items), func(ctx proton.Context, i int) {
    proton.PadH(ctx, 8, func(ctx proton.Context) {
        proton.Label(ctx, items[i])
    })
})
```

```go
proton.HList(ctx proton.Context, state *proton.Scrollable, length int, draw func(proton.Context, int))
```

---

## Κύλιση — Περιοχή περιεχομένου με δυνατότητα κύλισης

Για αυθαίρετο περιεχόμενο που μπορεί να υπερχειλίσει, όχι στοιχεία ευρετηρίου. Το περιεχόμενο
η λειτουργία μπορεί να καλέσει όσα widget θέλει.

```go
type UI struct {
    scroll proton.Scrollable
}

proton.Scroll(ctx, &u.scroll, func(ctx proton.Context) {
    proton.H5(ctx, "A very long page")
    proton.Gap(ctx, 8)
    proton.Label(ctx, "Paragraph one...")
    proton.Gap(ctx, 8)
    proton.Label(ctx, "Paragraph two...")
    proton.Gap(ctx, 8)
    // as many widgets as you need
})
```

```go
proton.Scroll(ctx proton.Context, state *proton.Scrollable, content func(proton.Context))
```

Χρησιμοποιήστε τη «Λίστα» όταν έχετε ευρετηριάσει δεδομένα. Χρησιμοποιήστε «κύλιση» για μια σελίδα μικτού περιεχομένου.

---

## TextView — Κείμενο με δυνατότητα κύλισης μόνο για ανάγνωση

Εμφανίζει ένα μεγάλο μπλοκ κειμένου σε κύλιση, μονοδιάστατη προβολή.
Καλό για περιεχόμενα αρχείων, κείμενο βοήθειας, προεπισκόπηση κώδικα.

```go
type UI struct {
    scroll proton.Scrollable
}

proton.TextView(ctx, &u.scroll, longText)
```

```go
proton.TextView(ctx proton.Context, state *proton.Scrollable, text string)
```

Το κείμενο χωρίζεται σε νέες γραμμές και κάθε γραμμή είναι ένα εικονικό στοιχείο λίστας, έτσι
χειρίζεται πολύ μεγάλα έγγραφα χωρίς πρόβλημα.

---

## LogView — Έξοδος καταγραφής αυτόματης κύλισης

Όπως το TextView, αλλά πραγματοποιεί αυτόματη κύλιση προς τα κάτω κάθε φορά που προστίθεται νέο περιεχόμενο.
Τα κοινά προθέματα ημερολογίου κωδικοποιεί αυτόματα τα χρώματα.

```go
type UI struct {
    logScroll proton.Scrollable
    logText   string
}

// append to logText from anywhere
u.logText += fmt.Sprintf("[OK] Step completed at %s\n", time.Now().Format("15:04:05"))

// draw it — auto-scrolls to the latest line
proton.LogView(ctx, &u.logScroll, u.logText)
```

```go
proton.LogView(ctx proton.Context, state *proton.Scrollable, text string)
```

Η χρωματική κωδικοποίηση γίνεται αυτόματα με βάση το πρόθεμα γραμμής:

| Πρόθεμα | Χρώμα |
|---|---|
| "[OK]", "ΤΕΛΟΣ", "ΕΠΙΤΥΧΙΑ" | Πράσινο |
| "[ΠΡΟΕΙΔΟΠΟΙΗΣΗ]", "ΠΡΟΕΙΔΟΠΟΙΗΣΗ" | Κίτρινο |
| "[ΣΦΑΛΜΑ]", "ΣΦΑΛΜΑ" | Κόκκινο |
| Οτιδήποτε άλλο | Σίγαση |

---

## Κάνοντας τις γραμμές λίστας να φαίνονται καλές

Ένα γυμνό "proton.Label" σε μια σειρά λίστας λειτουργεί αλλά δεν φαίνεται υπέροχο. Προσθέστε μερικά
επένδυση και δομή.

### Σειρές με επένδυση

```go
proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
    proton.PadV(ctx, 8, func(ctx proton.Context) {
        proton.PadH(ctx, 12, func(ctx proton.Context) {
            proton.Label(ctx, items[i].Name)
            proton.Gap(ctx, 2)
            proton.Muted(ctx, items[i].Description)
        })
    })
    proton.Divider(ctx)
})
```

### Δύο στήλες κειμένου

```go
type Contact struct {
    Name  string
    Email string
}

proton.List(ctx, &u.scroll, len(contacts), func(ctx proton.Context, i int) {
    c := contacts[i]
    proton.PadV(ctx, 10, func(ctx proton.Context) {
        proton.PadH(ctx, 12, func(ctx proton.Context) {
            proton.Label(ctx, c.Name)
            proton.Gap(ctx, 3)
            proton.Muted(ctx, c.Email)
        })
    })
    proton.Divider(ctx)
})
```

### Σειρές με δυνατότητα κλικ με επισήμανση του δείκτη του ποντικιού

```go
type UI struct {
    rows     [256]proton.Clickable
    selected int
    scroll   proton.Scrollable
}

proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
    bg  := proton.RGB(0x2e3440)
    hov := proton.RGB(0x3b4252)
    if u.selected == i {
        bg  = proton.RGB(0x4c566a)
        hov = bg
    }
    proton.PadV(ctx, 2, func(ctx proton.Context) {
        if proton.HoverCard(ctx, &u.rows[i], bg, hov, 6, func(ctx proton.Context) {
            proton.PadV(ctx, 10, func(ctx proton.Context) {
                proton.PadH(ctx, 12, func(ctx proton.Context) {
                    proton.Label(ctx, items[i].Name)
                    proton.Gap(ctx, 2)
                    proton.Muted(ctx, items[i].Sub)
                })
            })
        }) {
            u.selected = i
        }
    })
})
```

### Λίστα μέσα σε μια κάρτα

```go
proton.Card(ctx, proton.RGB(0x1e1e2e), 10, 0, func(ctx proton.Context) {
    proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
        proton.PadV(ctx, 8, func(ctx proton.Context) {
            proton.PadH(ctx, 12, func(ctx proton.Context) {
                proton.Label(ctx, items[i])
            })
        })
        if i < len(items)-1 {
            proton.Divider(ctx)
        }
    })
})
```

---

## Απόδοση

Το "List" και το "HList" χρησιμοποιούν εικονική απόδοση — μόνο τα ορατά στοιχεία έχουν τη δική τους
καλείται η συνάρτηση σχεδίασης. Ένα κομμάτι 50.000 στοιχείων κύλισης στα 60 fps χωρίς
σπάζοντας τον ιδρώτα.

Η "κύλιση" αποδίδει τα πάντα στη λειτουργία περιεχομένου σε κάθε πλαίσιο. Χρησιμοποιήστε το για
σελίδες με λογικό αριθμό γραφικών στοιχείων, όχι για τεράστια δυναμικά σύνολα δεδομένων.