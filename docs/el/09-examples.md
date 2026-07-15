# Παραδείγματα

Ολοκληρώστε προγράμματα που μπορείτε να αντιγράψετε, να επικολλήσετε και να εκτελέσετε. Κάθε μία από αυτές τις μεταγλωττίσεις
και λειτουργεί ως έχει.

---

## Γεια Κόσμε

Το απόλυτο ελάχιστο. Ανοίξτε ένα παράθυρο, εμφανίστε λίγο κείμενο.

```go
package main

import "github.com/CzaxStudio/proton"

func main() {
    a := proton.New("hello")
    a.Window("Hello", 400, 200, func(ctx proton.Context) {
        proton.H3(ctx, "Hello from Proton!")
    })
    a.Run()
}
```

---

## Μετρητής

Ένας αριθμός που ανεβαίνει και κατεβαίνει όταν κάνετε κλικ στα κουμπιά. επιδεικνύει
το θεμελιώδες μοτίβο: κατάσταση σε μια δομή, κουμπιά μέσα στα περιτυλίγματα διάταξης.

```go
package main

import (
    "fmt"
    "github.com/CzaxStudio/proton"
)

type UI struct {
    count int
    inc   proton.Clickable
    dec   proton.Clickable
    reset proton.Clickable
}

func main() {
    u := &UI{}
    a := proton.New("counter")
    a.ApplyPalette(proton.NordPalette)
    a.Window("Counter", 320, 240, func(ctx proton.Context) {
        proton.Center(ctx, func(ctx proton.Context) {
            proton.H1(ctx, fmt.Sprintf("%d", u.count))
            proton.Gap(ctx, 20)
            proton.Row(ctx,
                func(ctx proton.Context) {
                    proton.Pad(ctx, 4, func(ctx proton.Context) {
                        if proton.OutlineButton(ctx, &u.dec, "−") {
                            u.count--
                        }
                    })
                },
                func(ctx proton.Context) { proton.Gap(ctx, 8) },
                func(ctx proton.Context) {
                    proton.Pad(ctx, 4, func(ctx proton.Context) {
                        if proton.Button(ctx, &u.inc, "+") {
                            u.count++
                        }
                    })
                },
                func(ctx proton.Context) { proton.Gap(ctx, 8) },
                func(ctx proton.Context) {
                    proton.Pad(ctx, 4, func(ctx proton.Context) {
                        if proton.OutlineButton(ctx, &u.reset, "Reset") {
                            u.count = 0
                        }
                    })
                },
            )
        })
    })
    a.Run()
}
```

---

## Λίστα εργασιών

Το demo που κάθε πλαίσιο διεπαφής χρήστη υποχρεούται να έχει από το νόμο.

```go
package main

import "github.com/CzaxStudio/proton"

type item struct {
    text string
    done proton.Bool
}

type UI struct {
    input  proton.Editor
    addBtn proton.Clickable
    items  []item
    scroll proton.Scrollable
}

func main() {
    u := &UI{}
    a := proton.New("todo")
    a.ApplyPalette(proton.CatppuccinPalette)
    a.Window("Todo", 420, 560, func(ctx proton.Context) {
        proton.H4(ctx, "Todo")
        proton.Gap(ctx, 12)

        // add row
        proton.GrowRow(ctx,
            proton.GrowItem(ctx, func(ctx proton.Context) {
                proton.Input(ctx, &u.input, "What needs doing?")
            }),
            proton.FixedItem(ctx, func(ctx proton.Context) { proton.Gap(ctx, 8) }),
            proton.FixedItem(ctx, func(ctx proton.Context) {
                proton.Pad(ctx, 4, func(ctx proton.Context) {
                    if proton.Button(ctx, &u.addBtn, "Add") {
                        if t := u.input.Text(); t != "" {
                            u.items = append(u.items, item{text: t})
                            u.input.SetText("")
                        }
                    }
                })
            }),
        )

        proton.Gap(ctx, 8)
        proton.Divider(ctx)
        proton.Gap(ctx, 8)

        if len(u.items) == 0 {
            proton.Center(ctx, func(ctx proton.Context) {
                proton.Muted(ctx, "Nothing here. Add something above.")
            })
            return
        }

        proton.List(ctx, &u.scroll, len(u.items), func(ctx proton.Context, i int) {
            proton.PadV(ctx, 6, func(ctx proton.Context) {
                proton.Checkbox(ctx, &u.items[i].done, u.items[i].text)
            })
        })
    })
    a.Run()
}
```

---

## Φόρμα σύνδεσης

Μια φόρμα με πεδία email/κωδικού πρόσβασης και ενσωματωμένη επικύρωση.

```go
package main

import (
    "strings"
    "github.com/CzaxStudio/proton"
)

type UI struct {
    email    proton.Editor
    password proton.Editor
    submit   proton.Clickable
    errMsg   string
    success  bool
}

func main() {
    u := &UI{}
    a := proton.New("login")
    a.ApplyPalette(proton.MidnightPalette)
    a.Window("Sign In", 400, 360, func(ctx proton.Context) {
        proton.Center(ctx, func(ctx proton.Context) {
            proton.MaxWidth(ctx, 300, func(ctx proton.Context) {
                proton.H4(ctx, "Sign In")
                proton.Gap(ctx, 24)

                proton.Label(ctx, "Email")
                proton.Gap(ctx, 4)
                proton.Input(ctx, &u.email, "you@example.com")
                proton.Gap(ctx, 12)

                proton.Label(ctx, "Password")
                proton.Gap(ctx, 4)
                proton.Input(ctx, &u.password, "password")
                proton.Gap(ctx, 8)

                proton.ErrorText(ctx, u.errMsg)
                if u.errMsg != "" {
                    proton.Gap(ctx, 6)
                }

                if u.success {
                    proton.SuccessText(ctx, "Signed in successfully!")
                    return
                }

                proton.Pad(ctx, 4, func(ctx proton.Context) {
                    if proton.Button(ctx, &u.submit, "Sign In") {
                        u.errMsg = validate(u.email.Text(), u.password.Text())
                        if u.errMsg == "" {
                            u.success = true
                        }
                    }
                })
            })
        })
    })
    a.Run()
}

func validate(email, password string) string {
    if !strings.Contains(email, "@") {
        return "Enter a valid email address."
    }
    if len(password) < 8 {
        return "Password must be at least 8 characters."
    }
    return ""
}
```

---

## Πίνακας ρυθμίσεων

Εναλλαγή, κουμπιά επιλογής, ρυθμιστικό και κουμπί αποθήκευσης. Το είδος του πάνελ
που ζει σε κάθε εφαρμογή.

```go
package main

import (
    "fmt"
    "github.com/CzaxStudio/proton"
)

type Settings struct {
    notifications proton.Bool
    darkMode      proton.Bool
    language      proton.Enum
    fontSize      proton.Float
    saveBtn       proton.Clickable
    toast         proton.ToastState
}

import "time"

func main() {
    s := &Settings{}
    s.fontSize.Value = 0.5

    a := proton.New("settings")
    a.ApplyPalette(proton.DraculaPalette)
    a.Window("Settings", 480, 520, func(ctx proton.Context) {
        proton.H4(ctx, "Settings")
        proton.Gap(ctx, 24)

        proton.H6(ctx, "Appearance")
        proton.Gap(ctx, 10)
        proton.Toggle(ctx, &s.darkMode, "Dark mode")
        proton.Gap(ctx, 8)
        proton.Label(ctx, fmt.Sprintf("Font size: %.0f%%", 80+s.fontSize.Value*40))
        proton.Gap(ctx, 4)
        proton.Slider(ctx, &s.fontSize)
        proton.Gap(ctx, 24)

        proton.H6(ctx, "Notifications")
        proton.Gap(ctx, 10)
        proton.Checkbox(ctx, &s.notifications, "Email notifications")
        proton.Gap(ctx, 24)

        proton.H6(ctx, "Language")
        proton.Gap(ctx, 10)
        proton.RadioButton(ctx, &s.language, "en", "English")
        proton.Gap(ctx, 6)
        proton.RadioButton(ctx, &s.language, "es", "Español")
        proton.Gap(ctx, 6)
        proton.RadioButton(ctx, &s.language, "fr", "Français")
        proton.Gap(ctx, 28)

        proton.RowEnd(ctx,
            func(ctx proton.Context) {
                proton.Pad(ctx, 4, func(ctx proton.Context) {
                    if proton.Button(ctx, &s.saveBtn, "Save Settings") {
                        s.toast.Show("Settings saved.", 2*time.Second)
                    }
                })
            },
        )

        proton.Toast(ctx, &s.toast)
    })
    a.Run()
}
```

---

## Εφαρμογή με λογότυπο

Φορτώστε ένα λογότυπο από ένα ενσωματωμένο αρχείο και εμφανίστε το στην κεφαλίδα.

```go
package main

import (
    _ "embed"
    "fmt"
    "time"
    "github.com/CzaxStudio/proton"
)

//go:embed logo.png
var logoBytes []byte

type UI struct {
    count int
    btn   proton.Clickable
    toast proton.ToastState
}

func main() {
    u := &UI{}

    a := proton.New("logoapp")
    a.ApplyPalette(proton.NordPalette)
    a.SetLogoBytes(logoBytes)

    a.Window("My App", 420, 300, func(ctx proton.Context) {
        // header with logo
        proton.Row(ctx,
            func(ctx proton.Context) { proton.Logo(ctx, 36, 36) },
            func(ctx proton.Context) { proton.Gap(ctx, 10) },
            func(ctx proton.Context) { proton.H5(ctx, "My App") },
        )
        proton.Gap(ctx, 16)
        proton.Divider(ctx)
        proton.Gap(ctx, 16)

        proton.Label(ctx, fmt.Sprintf("Button clicked %d times", u.count))
        proton.Gap(ctx, 10)
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.btn, "Click me") {
                u.count++
                if u.count%5 == 0 {
                    u.toast.Show(fmt.Sprintf("%d clicks!", u.count), 2*time.Second)
                }
            }
        })

        proton.Toast(ctx, &u.toast)
    })
    a.Run()
}
```

Τοποθετήστε το "logo.png" στον ίδιο κατάλογο με το "main.go" πριν από την εκτέλεση.

---

## Εφαρμογή δύο παραθύρων

Ένας διαχωρισμός πλαϊνής γραμμής/περιεχομένου με δυνατότητα αλλαγής μεγέθους — το μοτίβο διάταξης πίσω από τις περισσότερες εφαρμογές επιφάνειας εργασίας.

```go
package main

import "github.com/CzaxStudio/proton"

type UI struct {
    split    proton.ResizeSplitState
    scroll   proton.Scrollable
    rowBtns  [10]proton.Clickable
    selected int
    saveBtn  proton.Clickable
    editor   proton.Editor
    toast    proton.ToastState
}

var items = []string{
    "Project Alpha", "Project Beta", "Project Gamma",
    "Meeting Notes", "Ideas", "Backlog",
}

import "time"

func main() {
    u := &UI{selected: 0}
    u.editor.SetText("Select an item on the left to edit it.")

    a := proton.New("twopane")
    a.ApplyPalette(proton.TokyoNightPalette)
    a.Window("Two-Pane App", 700, 500, func(ctx proton.Context) {
        proton.ResizeSplit(ctx, &u.split, 0.30,
            func(ctx proton.Context) {
                proton.H6(ctx, "Items")
                proton.Gap(ctx, 8)
                proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
                    bg  := proton.RGB(0x1a1b26)
                    hov := proton.RGB(0x24283b)
                    if u.selected == i {
                        bg  = proton.RGB(0x364a82)
                        hov = bg
                    }
                    proton.PadV(ctx, 2, func(ctx proton.Context) {
                        if proton.HoverCard(ctx, &u.rowBtns[i], bg, hov, 5, func(ctx proton.Context) {
                            proton.PadV(ctx, 8, func(ctx proton.Context) {
                                proton.PadH(ctx, 10, func(ctx proton.Context) {
                                    proton.Label(ctx, items[i])
                                })
                            })
                        }) {
                            u.selected = i
                        }
                    })
                })
            },
            func(ctx proton.Context) {
                proton.PadH(ctx, 14, func(ctx proton.Context) {
                    proton.RowSpread(ctx,
                        func(ctx proton.Context) { proton.H6(ctx, items[u.selected]) },
                        func(ctx proton.Context) {
                            proton.Pad(ctx, 4, func(ctx proton.Context) {
                                if proton.Button(ctx, &u.saveBtn, "Save") {
                                    u.toast.Show("Saved.", 2*time.Second)
                                }
                            })
                        },
                    )
                    proton.Gap(ctx, 12)
                    proton.GrowColumn(ctx,
                        proton.GrowItem(ctx, func(ctx proton.Context) {
                            proton.TextArea(ctx, &u.editor, "Write something...")
                        }),
                    )
                })
            },
        )
        proton.Toast(ctx, &u.toast)
    })
    a.Run()
}
```

---

## Εκτέλεση των ενσωματωμένων παραδειγμάτων

Το repo αποστέλλεται με 9 ολοκληρωμένα παραδείγματα εφαρμογών:

```bash
go run ./examples/hello        # one window, one label
go run ./examples/todo         # todo list
go run ./examples/calculator   # grid of buttons, math
go run ./examples/notes        # note-taking with search and modal delete
go run ./examples/dashboard    # dev dashboard: charts, logs, tables
go run ./examples/showcase     # every widget in 5 tabs
go run ./examples/themes       # live palette picker + preview
go run ./examples/logoapp      # custom logo with go:embed
go run ./examples/kitchen      # stress test for all features
```

Εκτελέστε πρώτα το "showcase" — είναι η πιο ολοκληρωμένη οπτική επίδειξη του τι
Το πρωτόνιο μπορεί να κάνει.