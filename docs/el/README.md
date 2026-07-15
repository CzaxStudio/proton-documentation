# Έγγραφα Proton

**Διαβάστε την τεκμηρίωση στη γλώσσα σας:** [Αγγλικά](https://github.com/CzaxStudio/proton-documentation/blob/main/docs/README.md) | [Español](https://github.com/CzaxStudio/proton-documentation/blob/main/docs/es/README.md) | [Français](https://github.com/CzaxStudio/proton-documentation/blob/main/docs/fr/README.md) | [Ελληνικά](https://github.com/CzaxStudio/proton-documentation/blob/main/docs/el/README.md)

Πνευματικά δικαιώματα © [CzaxStudio](https://github.com/CzaxStudio/) (Nexus-Proton)

Όλα όσα χρειάζεστε για να δημιουργήσετε εφαρμογές για υπολογιστές με το Proton. 
Επιλέξτε ένα θέμα ή διαβάστε το με τη σειρά — και τα δύο λειτουργούν μια χαρά.

---

| Αρχείο | Τι έχει |
|---|---|
| [00-getting-started.md](./00-getting-started.md) | εγκατάσταση, πρώτο παράθυρο, το πρότυπο κατασκευής κατάστασης |
| [01-text.md](./01-text.md) | Ετικέτα, H1–H6, Body2, Λεζάντα, προσαρμοσμένο κείμενο |
| [02-buttons.md](./02-buttons.md) | Κουμπί, OutlineButton, IconButton, Tappable |
| [03-inputs.md](./03-inputs.md) | Εισαγωγή, Περιοχή κειμένου, Πλαίσιο ελέγχου, Εναλλαγή, Ραδιόφωνο, Ρυθμιστικό, Γραμμή προόδου |
| [04-layout.md](./04-layout.md) | Σειρά, Στήλη, Διαίρεση, Μπλοκ, Κενό, Πλέγμα, Μεγέθυνση, Κέντρο |
| [05-lists.md](./05-lists.md) | List, HList, Scroll |
| [06-visuals.md](./06-visuals.md) | Divider, Rect, RoundRect, Card, Badge, Image, MinSize, MaxWidth |
| [07-theming.md](./07-theming.md) | παλέτες, προσαρμοσμένα χρώματα, κλίμακα γραμματοσειράς |
| [08-advanced.md](./08-advanced.md) | Τοστ, OnKey, γορουτίνες, Επεξήγηση εργαλείου, πολλά παράθυρα |
| [09-παραδείγματα.md](./09-παραδείγματα.md) | πλήρη παραδείγματα αντιγραφής-επικόλλησης |

---

## Το ένα πράγμα που πρέπει να γνωρίζετε

Το Proton είναι άμεση λειτουργία. Η συνάρτηση σχεδίασης εκτελεί κάθε καρέ. Εσύ καλείς
λειτουργίες widget, εμφανίζονται στην οθόνη με αυτή τη σειρά. Κράτος ζει μέσα
τη δική σας κατασκευή. Αυτό είναι όλο.

```go
type UI struct {
    btn proton.Clickable
}

u := &UI{}

a.Window("App", 400, 300, func(win proton.Context) {
    proton.Label(win, "Click the button.")
    proton.Gap(win, 8)
    proton.Pad(win, 8, func(win proton.Context) {
        if proton.Button(win, &u.btn, "Hello") {
            println("hello!")
        }
    })
})
```

Τα γραφικά στοιχεία στοιβάζονται κάθετα. Το κράτος ζει στη δομή σας. Αυτό είναι όλο το μοντέλο.

**[Proton-Repo](https://github.com/CzaxStudio/Proton)**