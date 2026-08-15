# Entrées

Champs de texte, cases à cocher, bascules, boutons radio, curseurs, steppers numériques,
des listes déroulantes et un champ de recherche avec un bouton clair.

---

## Entrée — Champ de texte sur une seule ligne

```go
type UI struct {
    email proton.Editor
}

proton.Input(ctx, &u.email, "your@email.com")

// read the value any time
fmt.Println(u.email.Text())
```

Le deuxième argument est le texte d'espace réservé affiché lorsque le champ est vide.

```go
proton.Input(ctx proton.Context, state *proton.Editor, hint string)
```

---

## TextArea — Multi-line Text Field

Identique à Input mais l'utilisateur peut appuyer sur Entrée pour ajouter des lignes. Bon pour les messages,
notes, quelque chose de plus long qu’une seule ligne.

```go
type UI struct {
    bio proton.Editor
}

proton.TextArea(ctx, &u.bio, "Tell us something...")

fmt.Println(u.bio.Text())
```

```go
proton.TextArea(ctx proton.Context, state *proton.Editor, hint string)
```

---

## Entrée de recherche

Un champ de texte avec une icône de recherche à gauche et un bouton d'effacement (×) qui
apparaît quand il y a quelque chose à effacer. Renvoie la chaîne de requête actuelle.

```go
type UI struct {
    search proton.SearchState
}

q := proton.SearchInput(ctx, &u.search, "Search notes...")

// filter your data using q
filtered := filter(items, q)
```

`SearchState` contient à la fois l'éditeur et le bouton d'effacement interne — déclarez
un dans votre structure, ne le construisez pas vous-même.

```go
proton.SearchInput(ctx proton.Context, state *proton.SearchState, placeholder string) string
```

---

## Case à cocher

Renvoie « true » sur le cadre sur lequel l'utilisateur le fait basculer. Lire la valeur actuelle à partir de
`état.Valeur`.

```go
type UI struct {
    agreed proton.Bool
}

if proton.Checkbox(ctx, &u.agreed, "I have read the terms and conditions") {
    // just changed — u.agreed.Value is the new state
    fmt.Println("now:", u.agreed.Value)
}

// read it any time without caring about the change event
if u.agreed.Value {
    proton.SuccessText(ctx, "Thanks for agreeing (we know you didn't read it)")
}
```

```go
proton.Checkbox(ctx proton.Context, state *proton.Bool, label string) bool
```

---

## Basculer

Un interrupteur marche/arrêt de style matériel. Même API que Checkbox, look différent.
À utiliser pour les paramètres qui prennent effet immédiatement plutôt que de nécessiter un bouton Enregistrer.

```go
type UI struct {
    darkMode proton.Bool
}

if proton.Toggle(ctx, &u.darkMode, "Dark mode") {
    if u.darkMode.Value {
        applyDarkTheme()
    } else {
        applyLightTheme()
    }
}
```

```go
proton.Toggle(ctx proton.Context, state *proton.Bool, label string) bool
```

---

## Bouton Radio

Pour choisir exactement une option dans un groupe. Tous les boutons d'un partage de groupe
un champ d'état `proton.Enum`. La « clé » est ce qui est stocké dans « group.Value »
lorsque cette option est sélectionnée.

```go
type UI struct {
    plan proton.Enum
}

proton.RadioButton(ctx, &u.plan, "free", "Free")
proton.Gap(ctx, 4)
proton.RadioButton(ctx, &u.plan, "pro", "Pro — $9/mo")
proton.Gap(ctx, 4)
proton.RadioButton(ctx, &u.plan, "team", "Team — $29/mo")

fmt.Println("selected:", u.plan.Value) // "free", "pro", or "team"
```

Returns `true` on the frame the selection changes.

```go
proton.RadioButton(ctx proton.Context, group *proton.Enum, key string, label string) bool
```

Boutons radio horizontaux — placez-les dans « Row » :

```go
proton.Row(ctx,
    func(ctx proton.Context) { proton.RadioButton(ctx, &u.size, "s", "S") },
    func(ctx proton.Context) { proton.Gap(ctx, 12) },
    func(ctx proton.Context) { proton.RadioButton(ctx, &u.size, "m", "M") },
    func(ctx proton.Context) { proton.Gap(ctx, 12) },
    func(ctx proton.Context) { proton.RadioButton(ctx, &u.size, "l", "L") },
)
```

---

## Curseur

Une poignée de déplacement horizontale pour une valeur comprise entre 0,0 et 1,0. Adaptez-le à
quelle que soit la gamme dont vous avez besoin.

```go
type UI struct {
    vol proton.Float
}

v := proton.Slider(ctx, &u.vol)

// v is 0.0–1.0, scale it
volume := int(v * 100)
proton.Caption(ctx, fmt.Sprintf("Volume: %d%%", volume))
```

Vous pouvez également lire la valeur directement à partir de l'état :

```go
proton.Slider(ctx, &u.vol)
fmt.Println(u.vol.Value) // 0.0 to 1.0
```

```go
proton.Slider(ctx proton.Context, state *proton.Float) float32
```

---

## ProgressBar

Not interactive — just shows progress as a filled bar. Pass a float32
between 0.0 and 1.0.

```go
proton.ProgressBar(ctx, 0.65)    // 65% done
proton.ProgressBar(ctx, 1.0)     // done
proton.ProgressBar(ctx, progress) // from a variable
```

```go
proton.ProgressBar(ctx proton.Context, progress float32)
```

---

##NuméroEntrée

Un stepper avec les boutons − et +. Gère la taille min, max et pas pour vous.
Renvoie la valeur actuelle.

```go
type UI struct {
    qty    proton.NumberState
    rating proton.NumberState
}

// integers
qty := proton.NumberInput(ctx, &u.qty, 1, 99, 1)
proton.Caption(ctx, fmt.Sprintf("%d items", int(qty)))

// floats
rating := proton.NumberInput(ctx, &u.rating, 0, 5, 0.5)
proton.Caption(ctx, fmt.Sprintf("%.1f / 5.0", rating))
```

```go
proton.NumberInput(ctx proton.Context, state *proton.NumberState, min, max, step float64) float64
```

The value starts at `min` on first use. Step >= 1 displays integers;
step < 1 displays two decimal places.

---

## Boîte de sélection

A dropdown selector. Returns the index of the currently selected option.

```go
type UI struct {
    lang proton.SelectBoxState
}

langs := []string{"Go", "Rust", "Zig", "C", "Python"}

i := proton.SelectBox(ctx, &u.lang, langs)
proton.Caption(ctx, "You picked: "+langs[i])
```

La liste déroulante apparaît sous le bouton lorsque vous cliquez dessus. En cliquant n'importe où
à l'extérieur, il le ferme.

```go
proton.SelectBox(ctx proton.Context, state *proton.SelectBoxState, options []string) int
```

`Selected` commence à 0. Cochez `state.Selected >= 0` si vous avez besoin de savoir
si l'utilisateur a explicitement choisi quelque chose.

---

## Exemple de formulaire complet

```go
type SettingsUI struct {
    username proton.Editor
    bio      proton.Editor
    notify   proton.Bool
    dark     proton.Bool
    plan     proton.Enum
    volume   proton.Float
    save     proton.Clickable
}

func drawSettings(ctx proton.Context, s *SettingsUI) {
    proton.H4(ctx, "Settings")
    proton.Gap(ctx, 20)

    proton.Label(ctx, "Username")
    proton.Gap(ctx, 4)
    proton.Input(ctx, &s.username, "your_username")
    proton.Gap(ctx, 14)

    proton.Label(ctx, "Bio")
    proton.Gap(ctx, 4)
    proton.TextArea(ctx, &s.bio, "Tell us something...")
    proton.Gap(ctx, 20)

    proton.Toggle(ctx, &s.dark, "Dark mode")
    proton.Gap(ctx, 8)
    proton.Checkbox(ctx, &s.notify, "Email notifications")
    proton.Gap(ctx, 20)

    proton.Label(ctx, "Plan")
    proton.Gap(ctx, 6)
    proton.RadioButton(ctx, &s.plan, "free", "Free")
    proton.Gap(ctx, 4)
    proton.RadioButton(ctx, &s.plan, "pro", "Pro ($9/mo)")
    proton.Gap(ctx, 4)
    proton.RadioButton(ctx, &s.plan, "team", "Team ($29/mo)")
    proton.Gap(ctx, 20)

    proton.Label(ctx, fmt.Sprintf("Volume: %.0f%%", s.volume.Value*100))
    proton.Gap(ctx, 4)
    proton.Slider(ctx, &s.volume)
    proton.Gap(ctx, 28)

    proton.Pad(ctx, 4, func(ctx proton.Context) {
        if proton.Button(ctx, &s.save, "Save Settings") {
            handleSave(s)
        }
    })
}
```