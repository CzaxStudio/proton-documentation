# Κείμενο

Δέκα συναρτήσεις κειμένου που καλύπτουν κάθε μέγεθος από το "Θέλω οι άνθρωποι να το διαβάσουν αυτό από
απέναντι από το δωμάτιο" για να "παρακαλώ κανείς να μην διαβάσει αυτά τα ψιλά γράμματα"

---

## Επικεφαλίδες

```go
proton.H1(ctx, "I am enormous")
proton.H2(ctx, "Large")
proton.H3(ctx, "Medium-large")
proton.H4(ctx, "Medium — good for section titles")
proton.H5(ctx, "Medium-small")
proton.H6(ctx, "Small heading with dignity")
```

Ίδια κλίμακα μεγέθους με την HTML. Το H1 είναι για όταν θέλετε πραγματικά να κάνετε μια δήλωση.
Τα H4 και H5 είναι αυτά που θα χρησιμοποιείτε πιο συχνά.

**Υπογραφή** (το ίδιο και για τα έξι):```go
proton.H1(ctx proton.Context, text string)
```

---

## Ετικέτα

Κανονικό κείμενο σώματος. Αυτές είναι οι περισσότερες λέξεις στην εφαρμογή σας.

```go
proton.Label(ctx, "This is a label.")
```

```go
proton.Label(ctx proton.Context, text string)
```

---

## Σώμα 2

Ελαφρώς μικρότερο από το Label. Για δευτερεύουσες πληροφορίες που έχουν σημασία αλλά
δεν πρέπει να ανταγωνίζεται το κύριο περιεχόμενο.

```go
proton.Label(ctx, "Price: $29.99")
proton.Body2(ctx, "Excluding taxes and the general unfairness of life.")
```

```go
proton.Body2(ctx proton.Context, text string)
```

---

## Λεζάντα

Το πιο μικρό κείμενο. Συμβουλές, χρονικές σημάνσεις, ψιλά γράμματα, πράγματα που πρέπει να πείτε
αλλά δεν θέλω πραγματικά οι άνθρωποι να διαβάζουν.

```go
proton.Caption(ctx, "Last synced 3 years ago")
```

```go
proton.Caption(ctx proton.Context, text string)
```

---

## Σίγαση

Κείμενο μεγέθους 2 σε πιο αμυδρό χρώμα. Για δευτερεύουσες ετικέτες, βοηθητικό κείμενο,
περιγραφές που υποστηρίζουν το κύριο περιεχόμενο χωρίς να το ανταγωνίζονται.

```go
proton.Label(ctx, "Alice Johnson")
proton.Muted(ctx, "alice@example.com — last seen Tuesday")
```

```go
proton.Muted(ctx proton.Context, text string)
```

---

## Κείμενο — Προσαρμοσμένο στυλ

Όταν τα προκαθορισμένα μεγέθη δεν λειτουργούν, το «Κείμενο» σάς επιτρέπει να ελέγχετε το μέγεθος, το χρώμα,
και βάρος άμεσα.

```go
// 28sp, coral red, bold
proton.Text(ctx, "Warning!", 28, proton.RGB(0xf87171), true)

// 16sp, custom blue, not bold
proton.Text(ctx, "Note", 16, proton.RGB(0x60a5fa), false)

// pass color.NRGBA{} to use the theme's default text color
proton.Text(ctx, "Normal weight, bigger", 20, proton.NRGBA{}, false)
```

```go
proton.Text(ctx proton.Context, s string, size float32, c color.NRGBA, bold bool)
```

Το μέγεθος είναι σε `sp` (κλιμακωμένα εικονοστοιχεία). Το προεπιλεγμένο μέγεθος σώματος είναι περίπου 14sp.

---

## Βοηθοί σημασιολογικών χρωμάτων

Συντομεύσεις για κείμενο κοινής κατάστασης. Καθένας δεν κάνει τίποτα αν η συμβολοσειρά είναι άδεια,
που τα καθιστά ασφαλή για χρήση υπό όρους χωρίς επιπλέον «αν».

```go
proton.ErrorText(ctx, "Invalid email address.")     // red
proton.SuccessText(ctx, "Changes saved.")           // green
proton.WarningText(ctx, "This cannot be undone.")   // yellow
```

```go
proton.ErrorText(ctx proton.Context, text string)
proton.SuccessText(ctx proton.Context, text string)
proton.WarningText(ctx proton.Context, text string)
```

Η συμπεριφορά κενού συμβολοσειράς είναι χρήσιμη για επικύρωση:

```go
proton.ErrorText(ctx, validationErr) // draws nothing when validationErr == ""
```

---

## Έγχρωμο κείμενο

Ενιαία γραμμή για ετικέτα με συγκεκριμένο χρώμα, χωρίς την κλήση πλήρους «Κείμενο».

```go
proton.ColoredText(ctx, "Connected", proton.RGB(0x4ade80))
proton.ColoredText(ctx, "Disconnected", proton.RGB(0xf87171))
```

```go
proton.ColoredText(ctx proton.Context, text string, c color.NRGBA)
```

---

## Χρώματα

```go
// from a 24-bit hex value
proton.RGB(0xff6b6b)   // coral red
proton.RGB(0x4ecdc4)   // teal
proton.RGB(0xffffff)   // white
proton.RGB(0x000000)   // black

// with explicit alpha (0 = transparent, 255 = fully opaque)
proton.RGBA(255, 107, 107, 255)  // same coral, fully opaque
proton.RGBA(0, 0, 0, 128)        // 50% transparent black

// from a CSS hex string
proton.HexColor("#ff6b6b")
proton.HexColor("ff6b6b")   // hash is optional
proton.HexColor("#f66")     // shorthand also works
```

---

## Αναδίπλωση κειμένου

Το μεγάλο κείμενο αναδιπλώνεται αυτόματα σε όποιο πλάτος είναι διαθέσιμο.
Δεν χρειάζεται να κάνετε κάτι ιδιαίτερο.

```go
proton.Label(ctx, "This is a very long sentence that will wrap gracefully "+
    "onto multiple lines when the window is too narrow to fit it all in one.")
```

---

## Μια τυπική ενότητα περιεχομένου

```go
proton.H4(ctx, "Account Settings")
proton.Gap(ctx, 4)
proton.Muted(ctx, "Manage your profile and notification preferences.")
proton.Gap(ctx, 16)
proton.Divider(ctx)
proton.Gap(ctx, 16)
```