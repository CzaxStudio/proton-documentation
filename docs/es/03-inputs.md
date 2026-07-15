# Entradas

Campos de texto, casillas de verificación, conmutadores, botones de opción, controles deslizantes, pasos numéricos,
menús desplegables y un campo de búsqueda con un botón de borrar.

---

## Entrada: campo de texto de una sola línea

```go
type UI struct {
    email proton.Editor
}

proton.Input(ctx, &u.email, "your@email.com")

// read the value any time
fmt.Println(u.email.Text())
```

El segundo argumento es el texto del marcador de posición que se muestra cuando el campo está vacío.

```go
proton.Input(ctx proton.Context, state *proton.Editor, hint string)
```

---

## TextArea — Campo de texto de varias líneas

Igual que Entrada, pero el usuario puede presionar Enter para agregar líneas. Bueno para mensajes,
notas, algo más largo que una sola línea.

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

## Entrada de búsqueda

Un campo de texto con un icono de búsqueda a la izquierda y un botón claro (×) que
Aparece cuando hay algo que aclarar. Devuelve la cadena de consulta actual.

```go
type UI struct {
    search proton.SearchState
}

q := proton.SearchInput(ctx, &u.search, "Search notes...")

// filter your data using q
filtered := filter(items, q)
```

`SearchState` contiene tanto el `Editor` como el botón interno de borrar: declarar
uno en su estructura, no lo construya usted mismo.

```go
proton.SearchInput(ctx proton.Context, state *proton.SearchState, placeholder string) string
```

---

## Casilla de verificación

Devuelve "verdadero" en el marco en el que el usuario lo alterna. Leer el valor actual de
`estado.Valor`.

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

## Alternar

Un interruptor de encendido/apagado estilo material. Misma API que Checkbox, aspecto diferente.
Úselo para configuraciones que surten efecto inmediatamente en lugar de necesitar un botón Guardar.

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

## Botón de radio

Para elegir exactamente una opción de un grupo. Todos los botones de un grupo comparten
un campo de estado `proton.Enum`. La "clave" es lo que se almacena en "grupo.Valor".
cuando se selecciona esa opción.

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

Devuelve "verdadero" en el marco en el que cambia la selección.

```go
proton.RadioButton(ctx proton.Context, group *proton.Enum, key string, label string) bool
```

Botones de opción horizontales: envuélvalos en "Fila":

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

## control deslizante

Un controlador de arrastre horizontal para un valor entre 0,0 y 1,0. Escalarlo a
cualquier rango que necesites.

```go
type UI struct {
    vol proton.Float
}

v := proton.Slider(ctx, &u.vol)

// v is 0.0–1.0, scale it
volume := int(v * 100)
proton.Caption(ctx, fmt.Sprintf("Volume: %d%%", volume))
```

También puedes leer el valor directamente del estado:

```go
proton.Slider(ctx, &u.vol)
fmt.Println(u.vol.Value) // 0.0 to 1.0
```

```go
proton.Slider(ctx proton.Context, state *proton.Float) float32
```

---

## Barra de progreso

No es interactivo: solo muestra el progreso como una barra llena. Pasar un flotador32
entre 0,0 y 1,0.

```go
proton.ProgressBar(ctx, 0.65)    // 65% done
proton.ProgressBar(ctx, 1.0)     // done
proton.ProgressBar(ctx, progress) // from a variable
```

```go
proton.ProgressBar(ctx proton.Context, progress float32)
```

---

## Entrada numérica

Un paso a paso con botones − y +. Maneja el tamaño mínimo, máximo y de paso por usted.
Devuelve el valor actual.

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

El valor comienza en "min" en el primer uso. El paso >= 1 muestra números enteros;
el paso < 1 muestra dos decimales.

---

## Seleccionar cuadro

Un selector desplegable. Devuelve el índice de la opción actualmente seleccionada.

```go
type UI struct {
    lang proton.SelectBoxState
}

langs := []string{"Go", "Rust", "Zig", "C", "Python"}

i := proton.SelectBox(ctx, &u.lang, langs)
proton.Caption(ctx, "You picked: "+langs[i])
```

El menú desplegable aparece debajo del botón cuando se hace clic. Haciendo clic en cualquier lugar
afuera lo cierra.

```go
proton.SelectBox(ctx proton.Context, state *proton.SelectBoxState, options []string) int
```

`Selected` comienza en 0. Marque `state.Selected >= 0` si necesita saberlo.
si el usuario ha elegido algo explícitamente.

---

## Ejemplo de formulario completo

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