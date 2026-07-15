# Listas y desplazamiento

Para mostrar colecciones de cosas y hacer que las áreas de contenido sean desplazables.

---

## Lista: lista desplazable vertical

La lista estándar. Sólo dibuja los elementos actualmente visibles en la pantalla, por lo que
10.000 artículos está bien.

```go
type UI struct {
    scroll proton.Scrollable
}

items := []string{"Apples", "Bananas", "Cherries", "Durian (why)"}

proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
    proton.Label(ctx, items[i])
})
```

La devolución de llamada recibe el índice "i". Dibuja lo que quieras para cada fila.

```go
proton.List(ctx proton.Context, state *proton.Scrollable, length int, draw func(proton.Context, int))
```

Declare un `proton.Scrollable` por lista. Realiza un seguimiento de la posición de desplazamiento.
No comparta uno entre dos listas: se pelearán por la posición de desplazamiento y
ambos pierden.

---

## HList — Lista desplazable horizontal

Igual que Lista pero los elementos van de izquierda a derecha.

```go
proton.HList(ctx, &u.hscroll, len(items), func(ctx proton.Context, i int) {
    proton.PadH(ctx, 8, func(ctx proton.Context) {
        proton.Label(ctx, items[i])
    })
})
```

```go
proton.HList(ctx proton.Context, state *proton.Scrollable, length int, draw func(proton.Context, int))
```

---

## Desplazamiento: área de contenido desplazable

Para contenido arbitrario que podría desbordarse, no para elementos indexados. el contenido
La función puede llamar a tantos widgets como quiera.

```go
type UI struct {
    scroll proton.Scrollable
}

proton.Scroll(ctx, &u.scroll, func(ctx proton.Context) {
    proton.H5(ctx, "A very long page")
    proton.Gap(ctx, 8)
    proton.Label(ctx, "Paragraph one...")
    proton.Gap(ctx, 8)
    proton.Label(ctx, "Paragraph two...")
    proton.Gap(ctx, 8)
    // as many widgets as you need
})
```

```go
proton.Scroll(ctx proton.Context, state *proton.Scrollable, content func(proton.Context))
```

Utilice `List` cuando tenga datos indexados. Utilice `Scroll` para una página de contenido mixto.

---

## TextView: texto desplazable de solo lectura

Muestra un gran bloque de texto en una vista monoespaciada desplazable.
Bueno para contenidos de archivos, texto de ayuda y vista previa de código.

```go
type UI struct {
    scroll proton.Scrollable
}

proton.TextView(ctx, &u.scroll, longText)
```

```go
proton.TextView(ctx proton.Context, state *proton.Scrollable, text string)
```

El texto se divide en nuevas líneas y cada línea es un elemento de lista virtual, por lo que
Maneja documentos muy largos sin problemas.

---

## LogView — Salida de registro con desplazamiento automático

Como TextView pero se desplaza automáticamente hacia la parte inferior cada vez que se agrega contenido nuevo.
Codifica con colores los prefijos de registro comunes automáticamente.

```go
type UI struct {
    logScroll proton.Scrollable
    logText   string
}

// append to logText from anywhere
u.logText += fmt.Sprintf("[OK] Step completed at %s\n", time.Now().Format("15:04:05"))

// draw it — auto-scrolls to the latest line
proton.LogView(ctx, &u.logScroll, u.logText)
```

```go
proton.LogView(ctx proton.Context, state *proton.Scrollable, text string)
```

La codificación de colores se produce automáticamente según el prefijo de línea:

| Prefijo | Color |
|---|---|
| `[OK]`, `HECHO`, `ÉXITO` | Verde |
| `[ADVERTENCIA]`, `ADVERTENCIA` | Amarillo |
| `[ERROR]`, `ERROR` | Rojo |
| Cualquier otra cosa | Silenciado |

---

## Hacer que las filas de la lista se vean bien

Un `proton.Label` simple en una fila de la lista funciona pero no se ve muy bien. Agrega algunos
acolchado y estructura.

### Filas acolchadas

```go
proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
    proton.PadV(ctx, 8, func(ctx proton.Context) {
        proton.PadH(ctx, 12, func(ctx proton.Context) {
            proton.Label(ctx, items[i].Name)
            proton.Gap(ctx, 2)
            proton.Muted(ctx, items[i].Description)
        })
    })
    proton.Divider(ctx)
})
```

### Dos columnas de texto

```go
type Contact struct {
    Name  string
    Email string
}

proton.List(ctx, &u.scroll, len(contacts), func(ctx proton.Context, i int) {
    c := contacts[i]
    proton.PadV(ctx, 10, func(ctx proton.Context) {
        proton.PadH(ctx, 12, func(ctx proton.Context) {
            proton.Label(ctx, c.Name)
            proton.Gap(ctx, 3)
            proton.Muted(ctx, c.Email)
        })
    })
    proton.Divider(ctx)
})
```

### Filas en las que se puede hacer clic con resaltado al pasar el mouse

```go
type UI struct {
    rows     [256]proton.Clickable
    selected int
    scroll   proton.Scrollable
}

proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
    bg  := proton.RGB(0x2e3440)
    hov := proton.RGB(0x3b4252)
    if u.selected == i {
        bg  = proton.RGB(0x4c566a)
        hov = bg
    }
    proton.PadV(ctx, 2, func(ctx proton.Context) {
        if proton.HoverCard(ctx, &u.rows[i], bg, hov, 6, func(ctx proton.Context) {
            proton.PadV(ctx, 10, func(ctx proton.Context) {
                proton.PadH(ctx, 12, func(ctx proton.Context) {
                    proton.Label(ctx, items[i].Name)
                    proton.Gap(ctx, 2)
                    proton.Muted(ctx, items[i].Sub)
                })
            })
        }) {
            u.selected = i
        }
    })
})
```

### Lista dentro de una tarjeta

```go
proton.Card(ctx, proton.RGB(0x1e1e2e), 10, 0, func(ctx proton.Context) {
    proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
        proton.PadV(ctx, 8, func(ctx proton.Context) {
            proton.PadH(ctx, 12, func(ctx proton.Context) {
                proton.Label(ctx, items[i])
            })
        })
        if i < len(items)-1 {
            proton.Divider(ctx)
        }
    })
})
```

---

## Actuación

`List` y `HList` usan representación virtual: solo los elementos visibles obtienen su
función de dibujo llamada. Una porción de 50.000 elementos se desplaza a 60 fps sin
rompiendo a sudar.

`Scroll` representa todo en la función de contenido en cada cuadro. Úselo para
páginas con una cantidad razonable de widgets, no para grandes conjuntos de datos dinámicos.