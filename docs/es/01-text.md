# Texto

Diez funciones de texto que cubren todos los tamaños, desde "Quiero que la gente lea esto desde
al otro lado de la habitación" a "por favor, que nadie lea esta letra pequeña"

---

## Encabezados

```go
proton.H1(ctx, "I am enormous")
proton.H2(ctx, "Large")
proton.H3(ctx, "Medium-large")
proton.H4(ctx, "Medium — good for section titles")
proton.H5(ctx, "Medium-small")
proton.H6(ctx, "Small heading with dignity")
```

Escala del mismo tamaño que HTML. H1 es para cuando realmente quieres hacer una declaración.
H4 y H5 son los que utilizarás con más frecuencia.

**Firma** (igual para los seis):```go
proton.H1(ctx proton.Context, text string)
```

---

## Etiqueta

Texto del cuerpo normal. Esto es lo que son la mayoría de las palabras en su aplicación.

```go
proton.Label(ctx, "This is a label.")
```

```go
proton.Label(ctx proton.Context, text string)
```

---

## Cuerpo2

Ligeramente más pequeño que Label. Para información secundaria que importa pero
No debería competir con el contenido principal.

```go
proton.Label(ctx, "Price: $29.99")
proton.Body2(ctx, "Excluding taxes and the general unfairness of life.")
```

```go
proton.Body2(ctx proton.Context, text string)
```

---

## Subtítulo

El texto más pequeño. Consejos, marcas de tiempo, letra pequeña, cosas que debes decir
pero realmente no quiero que la gente lea.

```go
proton.Caption(ctx, "Last synced 3 years ago")
```

```go
proton.Caption(ctx proton.Context, text string)
```

---

## Silenciado

Texto de tamaño Body2 en un color más tenue. Para etiquetas secundarias, texto de ayuda,
descripciones que respalden el contenido principal sin competir con él.

```go
proton.Label(ctx, "Alice Johnson")
proton.Muted(ctx, "alice@example.com — last seen Tuesday")
```

```go
proton.Muted(ctx proton.Context, text string)
```

---

## Texto: estilo personalizado

Cuando los tamaños preestablecidos no funcionan, "Texto" le permite controlar el tamaño, el color,
y peso directamente.

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

El tamaño está en `sp` (píxeles escalados). El tamaño del cuerpo predeterminado es de alrededor de 14 sp.

---

## Ayudantes de color semántico

Accesos directos para texto de estado común. Cada uno no hace nada si la cadena está vacía,
lo que los hace seguros de usar condicionalmente sin un "if" adicional.

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

El comportamiento de cadena vacía es útil para la validación:

```go
proton.ErrorText(ctx, validationErr) // draws nothing when validationErr == ""
```

---

## Texto coloreado

Una línea para una etiqueta con un color específico, sin la llamada "Texto" completa.

```go
proton.ColoredText(ctx, "Connected", proton.RGB(0x4ade80))
proton.ColoredText(ctx, "Disconnected", proton.RGB(0xf87171))
```

```go
proton.ColoredText(ctx proton.Context, text string, c color.NRGBA)
```

---

## Colores

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

## Ajuste de texto

El texto largo se ajusta automáticamente dentro del ancho disponible.
No necesitas hacer nada especial.

```go
proton.Label(ctx, "This is a very long sentence that will wrap gracefully "+
    "onto multiple lines when the window is too narrow to fit it all in one.")
```

---

## Una sección de contenido típica

```go
proton.H4(ctx, "Account Settings")
proton.Gap(ctx, 4)
proton.Muted(ctx, "Manage your profile and notification preferences.")
proton.Gap(ctx, 16)
proton.Divider(ctx)
proton.Gap(ctx, 16)
```