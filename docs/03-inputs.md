# Inputs

Text fields, checkboxes, toggles, radio buttons, sliders, number steppers,
dropdowns, and a search field with a clear button.

---

## Input — Single-line Text Field

```go
type UI struct {
    email proton.Editor
}

proton.Input(ctx, &u.email, "your@email.com")

// read the value any time
fmt.Println(u.email.Text())
```

The second argument is the placeholder text shown when the field is empty.

```go
proton.Input(ctx proton.Context, state *proton.Editor, hint string)
```

---

## TextArea — Multi-line Text Field

Same as Input but the user can press Enter to add lines. Good for messages,
notes, anything longer than a single line.

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

## SearchInput

A text field with a search icon on the left and a clear (×) button that
appears when there's something to clear. Returns the current query string.

```go
type UI struct {
    search proton.SearchState
}

q := proton.SearchInput(ctx, &u.search, "Search notes...")

// filter your data using q
filtered := filter(items, q)
```

`SearchState` holds both the `Editor` and the internal clear button — declare
one in your struct, don't construct it yourself.

```go
proton.SearchInput(ctx proton.Context, state *proton.SearchState, placeholder string) string
```

---

## Checkbox

Returns `true` on the frame the user toggles it. Read the current value from
`state.Value`.

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

## Toggle

A material-style on/off switch. Same API as Checkbox, different look.
Use for settings that take effect immediately rather than needing a Save button.

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

## RadioButton

For picking exactly one option from a group. All buttons in a group share
one `proton.Enum` state field. The `key` is what gets stored in `group.Value`
when that option is selected.

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

Horizontal radio buttons — wrap them in `Row`:

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

## Slider

A horizontal drag handle for a value between 0.0 and 1.0. Scale it to
whatever range you need.

```go
type UI struct {
    vol proton.Float
}

v := proton.Slider(ctx, &u.vol)

// v is 0.0–1.0, scale it
volume := int(v * 100)
proton.Caption(ctx, fmt.Sprintf("Volume: %d%%", volume))
```

You can also read the value directly from the state:

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

## NumberInput

A stepper with − and + buttons. Handles min, max, and step size for you.
Returns the current value.

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

## SelectBox

A dropdown selector. Returns the index of the currently selected option.

```go
type UI struct {
    lang proton.SelectBoxState
}

langs := []string{"Go", "Rust", "Zig", "C", "Python"}

i := proton.SelectBox(ctx, &u.lang, langs)
proton.Caption(ctx, "You picked: "+langs[i])
```

The dropdown appears below the button when clicked. Clicking anywhere
outside it closes it.

```go
proton.SelectBox(ctx proton.Context, state *proton.SelectBoxState, options []string) int
```

`Selected` starts at 0. Check `state.Selected >= 0` if you need to know
whether the user has explicitly picked something.

---

## Full Form Example

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
