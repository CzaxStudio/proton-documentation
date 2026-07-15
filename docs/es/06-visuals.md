#Aparatos visuales

Formas, tarjetas, imágenes, insignias, anillos de progreso, tablas, avatares: las cosas
que hacen que su aplicación parezca diseñada específicamente.

---

## Divisor

Una delgada regla horizontal. Úselo entre secciones.

```go
proton.H5(ctx, "Section One")
proton.Gap(ctx, 8)
proton.Label(ctx, "Some content.")
proton.Gap(ctx, 12)
proton.Divider(ctx)
proton.Gap(ctx, 12)
proton.H5(ctx, "Section Two")
```

```go
proton.Divider(ctx proton.Context)
```

###Divisor etiquetado

Igual que Divisor pero con una etiqueta de texto centrada.

```go
proton.LabeledDivider(ctx, "Advanced Settings")
proton.LabeledDivider(ctx, "")   // plain divider — same as Divider
```

```go
proton.LabeledDivider(ctx proton.Context, label string)
```

---

## Rectificado

Un rectángulo de color sólido. Pase 0 para ancho o alto para llenar el
espacio disponible en ese eje.

```go
// 100dp wide, 4dp tall accent bar
proton.Rect(ctx, proton.RGB(0x89b4fa), 100, 4)

// ancho completo, separador alto 2dp
protón.Rect(ctx, protón.RGB(0x333344), 0, 2)

// llenar todo el espacio disponible
protón.Rect(ctx, protón.RGB(0x1a1a2e), 0, 0)
```

```go
proton.Rect(ctx proton.Context, c color.NRGBA, widthDp, heightDp float32)
```

### RedondoRecto

Igual que Rect pero con esquinas redondeadas.

```go
proton.RoundRect(ctx, proton.RGB(0x2a2a3e), 200, 60, 12)  // 12dp corner radius
proton.RoundRect(ctx, proton.RGB(0x4c566a), 0, 40, 20)    // full width, pill shape
```

```go
proton.RoundRect(ctx proton.Context, c color.NRGBA, widthDp, heightDp, radiusDp float32)
```

---

## Tarjeta

Contenido dentro de un fondo acolchado de rectángulo redondeado con una sombra sutil.
El contenedor de referencia para agrupar contenido relacionado.

```go
proton.Card(ctx, proton.RGB(0x2a2a3e), 12, 16, func(ctx proton.Context) {
    proton.H6(ctx, "Card Title")
    proton.Gap(ctx, 4)
    proton.Label(ctx, "Card content goes here.")
    proton.Gap(ctx, 12)
    proton.Pad(ctx, 4, func(ctx proton.Context) {
        if proton.Button(ctx, &u.btn, "Action") { doThing() }
    })
})
```

```go
proton.Card(ctx proton.Context, bg color.NRGBA, cornerDp, padDp float32, content func(proton.Context))
```

- `bg` — color de fondo
- `cornerDp` — radio de esquina (8–12 se ve bien para la mayoría de las tarjetas)
- `padDp` — relleno entre el borde de la tarjeta y el contenido

### Tarjeta flotante

Una tarjeta que cambia el color de fondo al pasar el mouse. Devuelve verdadero si se hace clic.

```go
if proton.HoverCard(ctx, &u.cardBtn,
    proton.RGB(0x2e3440),  // normal background
    proton.RGB(0x3b4252),  // hover background
    8,                     // corner radius dp
    func(ctx proton.Context) {
        proton.PadV(ctx, 10, func(ctx proton.Context) {
            proton.PadH(ctx, 12, func(ctx proton.Context) {
                proton.Label(ctx, "Click this card")
            })
        })
    },
) {
    println("card clicked")
}
```

```go
proton.HoverCard(ctx proton.Context, state *proton.Clickable, bg, hover color.NRGBA, cornerDp float32, content func(proton.Context)) bool
```

---

## Insignia

Un pequeño chip redondeado con texto. Para etiquetas de estado, etiquetas, recuentos, cualquier cosa
eso necesita una pastilla de color.

```go
proton.Badge(ctx, proton.RGB(0x5e81ac), proton.RGB(0xeceff4), "stable")
proton.Badge(ctx, proton.RGB(0xa3be8c), proton.RGB(0x2e3440), "passing")
proton.Badge(ctx, proton.RGB(0xbf616a), proton.RGB(0xeceff4), "failing")
```

```go
proton.Badge(ctx proton.Context, bg, fg color.NRGBA, text string)
```

Insignias seguidas:

```go
proton.Row(ctx,
    func(ctx proton.Context) { proton.Badge(ctx, proton.RGB(0x5e81ac), proton.RGB(0xeceff4), "Go") },
    func(ctx proton.Context) { proton.Gap(ctx, 5) },
    func(ctx proton.Context) { proton.Badge(ctx, proton.RGB(0xa3be8c), proton.RGB(0x2e3440), "v1.0") },
    func(ctx proton.Context) { proton.Gap(ctx, 5) },
    func(ctx proton.Context) { proton.Badge(ctx, proton.RGB(0xebcb8b), proton.RGB(0x2e3440), "MIT") },
)
```

---

## Punto de estado

Un pequeño círculo de color. Indicadores en línea/fuera de línea, estado de compilación, cualquier cosa
eso necesita un punto de color al lado de algún texto.

```go
proton.Row(ctx,
    func(ctx proton.Context) { proton.StatusDot(ctx, proton.RGB(0x4ade80), 9) },
    func(ctx proton.Context) { proton.Gap(ctx, 6) },
    func(ctx proton.Context) { proton.Caption(ctx, "Connected") },
)
```

```go
proton.StatusDot(ctx proton.Context, c color.NRGBA, sizeDp float32)
```

---

##Avatar

Una insignia circular que muestra las iniciales. Para imágenes de perfil de usuario cuando no hay imagen
está disponible, que es la mayor parte del tiempo.

```go
proton.Avatar(ctx, "AJ", proton.RGB(0x5e81ac), proton.RGB(0xeceff4), 40)
proton.Avatar(ctx, "BC", proton.RGB(0xa3be8c), proton.RGB(0x2e3440), 32)
```

```go
proton.Avatar(ctx proton.Context, initials string, bg, fg color.NRGBA, sizeDp float32)
```

---

## Anillo de progreso

Un indicador de progreso circular. Bueno para tarjetas de estadísticas y paneles donde
la forma circular comunica el porcentaje de forma más visual que una barra.

```go
proton.ProgressRing(ctx, 0.72, 48, 5, proton.RGB(0x88c0d0))
//                       ^     ^   ^   ^
//                  progress  sz  strokeW  color
```

```go
proton.ProgressRing(ctx proton.Context, progress, sizeDp, strokeDp float32, c color.NRGBA)
```

El "progreso" es 0,0–1,0. `sizeDp` es el diámetro. `strokeDp` es el anillo
espesor: 4 a 6 dp se ve bien para la mayoría de los tamaños.

---

## Mesa

Una tabla de datos con una fila de encabezado y filas sombreadas alternas.

```go
proton.Table(ctx,
    []string{"Name", "Role", "Status"},
    []proton.TableRow{
        {"Alice", "Engineer", "Active"},
        {"Bob",   "Designer", "Away"},
        {"Carol", "PM",       "Active"},
    },
)
```

```go
proton.Table(ctx proton.Context, columns []string, rows []proton.TableRow)
```

`proton.TableRow` es simplemente `[]cadena`. Las columnas son igualmente anchas.

---

## paso a paso

Un indicador horizontal de progreso escalonado para flujos de varios pasos.

```go
proton.Stepper(ctx, 1, []string{"Account", "Profile", "Payment", "Done"})
//                  ^
//              current step (0-based)
```

```go
proton.Stepper(ctx proton.Context, current int, steps []string)
```

El paso 0 es el primer paso. Los pasos completados (índice <actual) se completan
color de acento. El paso actual está resaltado. Los pasos futuros son oscuros.

---

## Información sobre herramientas

Una pequeña etiqueta que aparece cuando el usuario pasa el cursor sobre algo.

```go
type UI struct {
    saveHover proton.Clickable  // for tracking hover — separate from the button's Clickable
    saveBtn   proton.Clickable
}

proton.Tooltip(ctx, &u.saveHover, "Guarda tu trabajo en el disco (Ctrl+S)", func(ctx proton.Context) {
    protón.Pad(ctx, 4, func(ctx protón.Context) {
        si proton.Button(ctx, &u.saveBtn, "Guardar") {
            guardar()
        }
    })
})
```

```go
proton.Tooltip(ctx proton.Context, state *proton.Clickable, tip string, content func(proton.Context))
```

Las pistas en las que se puede hacer clic en "estado" se desplazan sobre el área de información sobre herramientas. esta separado de
cualquier botón dentro del contenido: declare uno dedicado para cada información sobre herramientas.

---

## Imágenes

Cargue una vez al inicio. Dibuja cada cuadro.

```go
// load at startup — not in the draw function
img, err := proton.LoadImage("photo.png")
if err != nil {
    log.Fatal(err)
}

// en la función de dibujo
proton.Image(ctx, img, 200, 150) // 200dp de ancho, 150dp de alto
proton.Image(ctx, img, 0, 0) // tamaño de píxel natural
```

```go
proton.LoadImage(path string) (proton.ImageOp, error)
proton.Image(ctx proton.Context, img proton.ImageOp, widthDp, heightDp float32)
```

Se admiten PNG y JPEG.

---

## Logotipo

El logotipo de tu aplicación, cargado una vez y dibujado en cualquier lugar. Ver [07-theming.md](./07-theming.md)
para la configuración completa. La versión corta:

```go
//go:embed logo.png
var logoBytes []byte

// al inicio
a.SetLogoBytes(logoBytes)

// en la función de dibujo
protón.Logo(ctx, 48, 48)
```

```go
proton.Logo(ctx proton.Context, widthDp, heightDp float32)
proton.HasLogo(ctx proton.Context) bool
```

---

## Bloque de código

Texto monoespaciado en un cuadro con borde redondeado. Para mostrar comandos, rutas de archivos,
fragmentos: cualquier cosa que el usuario pueda copiar.

```go
proton.CodeBlock(ctx, "go get github.com/CzaxStudio/proton")
proton.CodeBlock(ctx, `a.Window("App", 480, 300, draw)
a.Run()`)
```

```go
proton.CodeBlock(ctx proton.Context, code string)
```

---

## Sugerencia de acceso directo

Una pequeña insignia de teclado. Mostrarlos junto a los elementos del menú o las etiquetas de los botones.
para comunicar atajos de teclado.

```go
proton.Row(ctx,
    func(ctx proton.Context) { proton.Label(ctx, "Save") },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) { proton.ShortcutHint(ctx, "Ctrl+S") },
)
```

```go
proton.ShortcutHint(ctx proton.Context, keys string)
```

---

## Muestra de color

Una fila de círculos de colores en los que el usuario puede hacer clic para seleccionar un color. Devoluciones
el índice del seleccionado, o -1 si aún no se ha seleccionado ninguno.

```go
type UI struct {
    swatches     [6]proton.Clickable
    chosenColor  int
}

paleta := []color.NRGBA{
    protón.RGB(0xf87171),
    protón.RGB(0xfbbf24),
    protón.RGB(0x4ade80),
    protón.RGB(0x60a5fa),
    protón.RGB(0xa78bfa),
    protón.RGB(0xf472b6),
}

i := proton.ColorSwatch(ctx, u.swatches[:], paleta, u.chosenColor, 26)
si yo >= 0 {
    u.color elegido = i
}
```

```go
proton.ColorSwatch(ctx proton.Context, btns []proton.Clickable, colors []color.NRGBA, selected int, sizeDp float32) int
```

El círculo seleccionado recibe un anillo alrededor.