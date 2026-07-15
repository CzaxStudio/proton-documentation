# Disposición

Los widgets se apilan verticalmente de forma predeterminada. Todo lo demás es voluntaria.

---

## Brecha: ponga espacio entre las cosas

La función de diseño más utilizada. Inserta un espacio vertical en blanco.

```go
proton.H4(ctx, "Section Title")
proton.Gap(ctx, 8)
proton.Label(ctx, "Section content.")
proton.Gap(ctx, 24)
proton.H4(ctx, "Next Section")
```

```go
proton.Gap(ctx proton.Context, dp float32)
```

8dp es una pequeña brecha. 16dp es medio. 24dp es grande. Esos tres cubren la mayoría de los casos.

---

## Fila - Lado a lado

Coloca a los niños horizontalmente, de izquierda a derecha.

```go
proton.Row(ctx,
    func(ctx proton.Context) { proton.Label(ctx, "Name:") },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) { proton.Label(ctx, "Alice") },
)
```

Cada niño es una `func(proton.Context)`. Llama a los widgets que quieras dentro de él.

```go
proton.Row(ctx proton.Context, widgets ...func(proton.Context))
```

---

## Columna: grupo vertical explícito

Apila a los niños verticalmente como un grupo con nombre. Rara vez se necesita en el nivel superior
(los widgets se apilan automáticamente), pero son útiles dentro de `Row` o `Split` cuando el
El lado derecho debe tener varias cosas apiladas.

```go
proton.Row(ctx,
    func(ctx proton.Context) {
        proton.Label(ctx, "Left side")
    },
    func(ctx proton.Context) { proton.Gap(ctx, 16) },
    func(ctx proton.Context) {
        proton.Column(ctx,
            func(ctx proton.Context) { proton.Label(ctx, "Right top") },
            func(ctx proton.Context) { proton.Gap(ctx, 4) },
            func(ctx proton.Context) { proton.Muted(ctx, "Right bottom") },
        )
    },
)
```

```go
proton.Column(ctx proton.Context, widgets ...func(proton.Context))
```

---

## RowSpread — Espacio entre

Como Row pero coloca el espacio horizontal sobrante entre los niños, empujando
el primero hacia el borde izquierdo y el último hacia la derecha.

```go
// title on the left, version on the right
proton.RowSpread(ctx,
    func(ctx proton.Context) { proton.H5(ctx, "My App") },
    func(ctx proton.Context) { proton.Caption(ctx, "v1.2.0") },
)
```

```go
proton.RowSpread(ctx proton.Context, widgets ...func(proton.Context))
```

---

## RowEnd: todo lo que está a la derecha

Empuja a todos los niños hacia el borde derecho.

```go
proton.RowEnd(ctx,
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.OutlineButton(ctx, &u.cancel, "Cancel") { handleCancel() }
        })
    },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.save, "Save") { handleSave() }
        })
    },
)
```

```go
proton.RowEnd(ctx proton.Context, widgets ...func(proton.Context))
```

---

## GrowRow y GrowColumn: diseños elásticos

Cuando un niño necesita llenar todo el espacio restante y los demás permanecen en su lugar
tamaño natural, use `GrowRow` (horizontal) o `GrowColumn` (vertical) con
`GrowItem` y `FixedItem`.

```go
// search bar: label fixed, input stretches, button fixed
proton.GrowRow(ctx,
    proton.FixedItem(ctx, func(ctx proton.Context) {
        proton.Label(ctx, "Search:")
    }),
    proton.GrowItem(ctx, func(ctx proton.Context) {
        proton.Input(ctx, &u.search, "Type to search...")
    }),
    proton.FixedItem(ctx, func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.searchBtn, "Go") { doSearch() }
        })
    }),
)
```

`GrowItem` ocupa todo el espacio restante. `FixedItem` toma solo lo que necesita.
Múltiples `GrowItem`s dividen el espacio restante de manera uniforme.

```go
proton.GrowRow(ctx proton.Context, children ...proton.FlexItem)
proton.GrowColumn(ctx proton.Context, children ...proton.FlexItem)
proton.GrowItem(ctx proton.Context, fn func(proton.Context)) proton.FlexItem
proton.FixedItem(ctx proton.Context, fn func(proton.Context)) proton.FlexItem
```

### FlexSpacer: separa a los hermanos

Un espacio vacío y elástico. Colóquelo entre `FixedItem`s para empujarlos hacia el lado opuesto.
bordes sin usar `RowSpread`.

```go
proton.GrowRow(ctx,
    proton.FixedItem(ctx, func(ctx proton.Context) { proton.Caption(ctx, "left") }),
    proton.FlexSpacer(),
    proton.FixedItem(ctx, func(ctx proton.Context) { proton.Caption(ctx, "right") }),
)
```

```go
proton.FlexSpacer() proton.FlexItem
```

---

## Dividir: paneles uno al lado del otro

Divide el ancho disponible entre dos secciones. `leftFraction` es la proporción
el panel izquierdo obtiene, de 0,0 a 1,0.

```go
proton.Split(ctx, 0.35,
    func(ctx proton.Context) {
        // sidebar — gets 35% of the width
        proton.Label(ctx, "Sidebar")
    },
    func(ctx proton.Context) {
        // content — gets the remaining 65%
        proton.Label(ctx, "Content")
    },
)
```

```go
proton.Split(ctx proton.Context, leftFraction float32, left func(proton.Context), right func(proton.Context))
```

### HSplit: superior e inferior

Misma idea pero vertical.

```go
proton.HSplit(ctx, 0.7,
    func(ctx proton.Context) { proton.Label(ctx, "Main content") },
    func(ctx proton.Context) { proton.Label(ctx, "Status bar") },
)
```

```go
proton.HSplit(ctx proton.Context, topFraction float32, top func(proton.Context), bottom func(proton.Context))
```

### ResizeSplit: el usuario puede arrastrar el divisor

Como Split pero el usuario puede arrastrar el controlador entre los dos paneles para
cambiar su tamaño. La `fracción predeterminada` es la posición inicial.

```go
type UI struct {
    split proton.ResizeSplitState
}

protón.ResizeSplit(ctx, &u.split, 0.30, leftFn, rightFn)
```

`ResizeSplitState.Fraction` comienza en 0 y se establece en `defaultFraction`
en el primer cuadro. Después de eso, se recuerda la posición de arrastre del usuario.

```go
proton.ResizeSplit(ctx proton.Context, state *proton.ResizeSplitState, defaultFraction float32, left func(proton.Context), right func(proton.Context))
proton.ResizeHSplit(ctx proton.Context, state *proton.ResizeSplitState, defaultFraction float32, top func(proton.Context), bottom func(proton.Context))
```

---

## Centro

Coloca el contenido en el centro del espacio disponible. Genial para estados vacíos
y pantallas de carga.

```go
proton.Center(ctx, func(ctx proton.Context) {
    proton.Muted(ctx, "Nothing here yet.")
})
```

```go
proton.Center(ctx proton.Context, fn func(proton.Context))
```

---

## Relleno

### Almohadilla: los cuatro lados

```go
proton.Pad(ctx, 16, func(ctx proton.Context) {
    proton.Label(ctx, "16dp of breathing room on all sides")
})
```

### PadH: solo izquierda y derecha

```go
proton.PadH(ctx, 24, func(ctx proton.Context) {
    proton.Label(ctx, "horizontal padding only")
})
```

### PadV: solo arriba y abajo

```go
proton.PadV(ctx, 12, func(ctx proton.Context) {
    proton.Label(ctx, "vertical padding only")
})
```

### PadSides: cada borde individualmente

Los argumentos son arriba, derecha, abajo, izquierda, en el mismo orden que el margen/relleno de CSS.

```go
proton.PadSides(ctx, 8, 16, 8, 16, func(ctx proton.Context) {
    proton.Label(ctx, "8dp top/bottom, 16dp left/right")
})
```

```go
proton.Pad(ctx proton.Context, dp float32, fn func(proton.Context))
proton.PadH(ctx proton.Context, dp float32, fn func(proton.Context))
proton.PadV(ctx proton.Context, dp float32, fn func(proton.Context))
proton.PadSides(ctx proton.Context, top, right, bottom, left float32, fn func(proton.Context))
```

---

## Cuadrícula: cuadrícula de columnas fijas

Organiza a los niños en una cuadrícula con un número fijo de columnas. cada celda
obtiene una parte igual del ancho disponible.

```go
proton.Grid(ctx, 3, 8,   // 3 columns, 8dp gap
    func(ctx proton.Context) { proton.Label(ctx, "one") },
    func(ctx proton.Context) { proton.Label(ctx, "two") },
    func(ctx proton.Context) { proton.Label(ctx, "three") },
    func(ctx proton.Context) { proton.Label(ctx, "four") },
    func(ctx proton.Context) { proton.Label(ctx, "five") },
)
```

Las celdas se ajustan a nuevas filas automáticamente. Si la última fila tiene menos de
Celdas `cols`, las ranuras restantes están vacías.

```go
proton.Grid(ctx proton.Context, cols int, gapDp float32, cells ...func(proton.Context))
```

---

## ZStack: dibuja cosas una encima de la otra

Coloca múltiples widgets en capas en la misma posición. El primer niño está en el
abajo; el último está arriba.

```go
proton.ZStack(ctx,
    func(ctx proton.Context) {
        // bottom layer — a background shape
        proton.RoundRect(ctx, proton.RGB(0x1e1e2e), 0, 100, 12)
    },
    func(ctx proton.Context) {
        // top layer — text floating over the shape
        proton.Center(ctx, func(ctx proton.Context) {
            proton.Label(ctx, "Text on top")
        })
    },
)
```

```go
proton.ZStack(ctx proton.Context, layers ...func(proton.Context))
```

---

## MinSize y MaxWidth: restricciones de tamaño

```go
// at least 200dp wide and 48dp tall
proton.MinSize(ctx, 200, 48, func(ctx proton.Context) {
    if proton.Button(ctx, &u.btn, "OK") { handleOK() }
})

// no más ancho que 420 dp: mantiene los formularios legibles en ventanas amplias
protón.MaxWidth(ctx, 420, func(ctx protón.Context) {
    proton.Input(ctx, &u.email, "Dirección de correo electrónico")
    protón.Gap(ctx, 8)
    proton.Input(ctx, &u.contraseña, "Contraseña")
})
```

```go
proton.MinSize(ctx proton.Context, widthDp, heightDp float32, fn func(proton.Context))
proton.MaxWidth(ctx proton.Context, widthDp float32, fn func(proton.Context))
```

Pase 0 para cualquier dimensión de `MinSize` para dejar ese eje sin restricciones.

---

## Una aplicación típica de dos columnas

```go
func draw(ctx proton.Context, u *UI) {
    // header
    proton.PadSides(ctx, 0, 0, 12, 0, func(ctx proton.Context) {
        proton.RowSpread(ctx,
            func(ctx proton.Context) { proton.H5(ctx, "My App") },
            func(ctx proton.Context) { proton.Caption(ctx, "v1.0") },
        )
    })
    proton.Divider(ctx)
    proton.Gap(ctx, 16)

// cuerpo
    protón.ResizeSplit(ctx, &u.split, 0.28,
        func(ctx protón.Contexto) {
            dibujarbarra lateral(ctx, u)
        },
        func(ctx protón.Contexto) {
            protón.PadH(ctx, 16, func(ctx protón.Context) {
                dibujar contenido (ctx, u)
            })
        },
    )
}
```