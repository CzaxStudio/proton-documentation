# Entradas

Campos de texto, casillas de verificación, conmutadores, botones de opción, controles deslizantes, pasos numéricos,
menús desplegables y un campo de búsqueda con un botón de borrar.

---

## Entrada: campo de texto de una sola línea

```go
type UI struct {
    email proton.Editor
}

proton.Input(ctx, &u.email, "tu@correo electrónico.com")

// lee el valor en cualquier momento
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

proton.TextArea(ctx, &u.bio, "Cuéntanos algo...")

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

q := proton.SearchInput(ctx, &u.search, "Buscar notas...")

//filtra tus datos usando q
filtrado: = filtro (elementos, q)
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

if proton.Checkbox(ctx, &u.agreed, "He leído los términos y condiciones") {
    // acaba de cambiar: u.agreed.Value es el nuevo estado
    fmt.Println("ahora:", u.agreed.Value)
}

// leerlo en cualquier momento sin importar el evento de cambio
si está de acuerdo.Valor {
    proton.SuccessText(ctx, "Gracias por aceptar (sabemos que no lo leíste)")
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

if proton.Toggle(ctx, &u.darkMode, "Modo oscuro") {
    si u.darkMode.Value {
        aplicarDarkTheme()
    } más {
        aplicarLightTheme()
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

protón.RadioButton(ctx, &u.plan, "gratis", "Gratis")
protón.Gap(ctx, 4)
proton.RadioButton(ctx, &u.plan, "pro", "Pro — $9/mes")
protón.Gap(ctx, 4)
proton.RadioButton(ctx, &u.plan, "equipo", "Equipo — $29/mes")

fmt.Println("seleccionado:", u.plan.Value) // "gratis", "pro" o "equipo"
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

v := protón.Slider(ctx, &u.vol)

// v es 0,0–1,0, escalarlo
volumen := int(v * 100)
proton.Caption(ctx, fmt.Sprintf("Volumen: %d%%", volumen))
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

// números enteros
cantidad: = protón.NumberInput(ctx, &u.qty, 1, 99, 1)
proton.Caption(ctx, fmt.Sprintf("%d elementos", int(cantidad)))

// flota
calificación: = protón.NumberInput(ctx, &u.rating, 0, 5, 0.5)
proton.Caption(ctx, fmt.Sprintf("%.1f / 5.0", clasificación))
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

idiomas := []cadena{"Ir", "Rust", "Zig", "C", "Python"}

i := protón.SelectBox(ctx, &u.lang, idiomas)
proton.Caption(ctx, "Elegiste: "+idiomas[i])
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

func dibujarConfiguración(ctx proton.Context, s *ConfiguraciónUI) {
    protón.H4(ctx, "Configuración")
    protón.Gap(ctx, 20)

proton.Label(ctx, "Nombre de usuario")
    protón.Gap(ctx, 4)
    proton.Input(ctx, &s.nombre de usuario, "tu_nombre de usuario")
    protón.Gap(ctx, 14)

protón.Label(ctx, "Bio")
    protón.Gap(ctx, 4)
    proton.TextArea(ctx, &s.bio, "Cuéntanos algo...")
    protón.Gap(ctx, 20)

proton.Toggle(ctx, &s.dark, "modo oscuro")
    protón.Gap(ctx, 8)
    proton.Checkbox(ctx, &s.notify, "Notificaciones por correo electrónico")
    protón.Gap(ctx, 20)

protón.Label(ctx, "Plan")
    protón.Gap(ctx, 6)
    protón.RadioButton(ctx, &s.plan, "gratis", "Gratis")
    protón.Gap(ctx, 4)
    proton.RadioButton(ctx, &s.plan, "pro", "Pro ($9/mes)")
    protón.Gap(ctx, 4)
    proton.RadioButton(ctx, &s.plan, "equipo", "Equipo ($29/mes)")
    protón.Gap(ctx, 20)

proton.Label(ctx, fmt.Sprintf("Volumen: %.0f%%", s.volume.Value*100))
    protón.Gap(ctx, 4)
    protón.Control deslizante (ctx, &s.volumen)
    protón.Gap(ctx, 28)

protón.Pad(ctx, 4, func(ctx protón.Context) {
        if proton.Button(ctx, &s.save, "Guardar configuración") {
            manejarGuardar(es)
        }
    })
}
```