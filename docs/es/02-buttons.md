# Botones

Los botones son la forma en que los usuarios le dicen a su aplicación que haga cosas. El protón tiene cuatro tipos,
además de enlaces en los que se puede hacer clic y una forma de hacer que, literalmente, se pueda tocar cualquier cosa.

---

## La única regla

Cada botón necesita su propio campo `proton.Clickable` en su estructura de estado.

```go
type UI struct {
    save   proton.Clickable
    cancel proton.Clickable
    delete proton.Clickable
}
```

No compartas uno entre dos botones. Si lo hace, al hacer clic en cualquiera de ellos se activa
ambos, lo cual es un error divertido de depurar y una experiencia de usuario terrible.

Además, los botones deben estar dentro de un contenedor de diseño (`Pad`, `Fila`, `Columna`, etc.)
para hacer clic para registrarse. Consulte [Cómo comenzar](./00-getting-started.md) para saber por qué.

---

## Botón

Acción primaria, sólida y llena. Úselo para lo que más desea
usuario haga clic.

```go
var save proton.Clickable

proton.Pad(ctx, 8, func(ctx proton.Context) {
    if proton.Button(ctx, &save, "Save") {
        doSave()
    }
})
```

Devuelve "verdadero" en el marco en el que se hace clic. Un clic, un "verdadero". eso
no sigue disparando mientras se mantiene presionado.

```go
proton.Button(ctx proton.Context, state *proton.Clickable, label string) bool
```

---

## Botón de esquema

Estilo fantasma/contorno. Mismo comportamiento que Button pero sin el relleno
fondo. Úselo para acciones secundarias: cosas que el usuario podría querer.
hacer, pero esa no es la acción principal.

```go
var save   proton.Clickable
var cancel proton.Clickable

proton.Row(ctx,
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.OutlineButton(ctx, &cancel, "Cancel") {
                handleCancel()
            }
        })
    },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &save, "Save") {
                handleSave()
            }
        })
    },
)
```

La jerarquía visual aquí (esquema para Cancelar, completa para Guardar) indica
usuarios cuál es la acción principal sin una sola palabra de explicación.

```go
proton.OutlineButton(ctx proton.Context, state *proton.Clickable, label string) bool
```

---

## Botón de icono

Un botón de solo ícono. Sin texto, solo un ícono. Común en barras de herramientas.

```go
// icon is a *proton.Icon — load one with widget.NewIcon() from gioui.org/widget
var closeBtn proton.Clickable

if proton.IconButton(ctx, &closeBtn, closeIcon, "Close window") {
    win.Close()
}
```

El cuarto argumento es la descripción de accesibilidad: ¡qué lector de pantalla!
diría. No te lo saltes.

```go
proton.IconButton(ctx proton.Context, state *proton.Clickable, icon *proton.Icon, desc string) bool
```

---

## Tocable

Hace que se pueda hacer clic en cualquier contenido. Toda el área que dibujas dentro de la devolución de llamada.
se convierte en el objetivo del golpe. Úselo para tarjetas, filas de listas, botones personalizados o
cualquier cosa donde una etiqueta de botón estándar no sea lo que desea.

```go
var rowClick proton.Clickable

if proton.Tappable(ctx, &rowClick, func(ctx proton.Context) {
    proton.Card(ctx, proton.RGB(0x2a2a3e), 8, 12, func(ctx proton.Context) {
        proton.Label(ctx, "Click anywhere on this card")
        proton.Gap(ctx, 4)
        proton.Muted(ctx, "The whole thing is a button")
    })
}) {
    println("card clicked")
}
```

```go
proton.Tappable(ctx proton.Context, state *proton.Clickable, content func(proton.Context)) bool
```

---

## Enlace y EnlacePequeño

Texto subrayado en el que se puede hacer clic con el estilo de un hipervínculo. Maneja el clic tú mismo.
Proton no abre las URL, solo le dice que el usuario hizo clic.

```go
var githubLink proton.Clickable

if proton.Link(ctx, &githubLink, "View on GitHub") {
    openBrowser("https://github.com/CzaxStudio/proton")
}
```

`LinkSmall` es lo mismo pero usa texto del tamaño de un título:

```go
var termsLink proton.Clickable

if proton.LinkSmall(ctx, &termsLink, "Terms of service") {
    showTerms()
}
```

```go
proton.Link(ctx proton.Context, state *proton.Clickable, text string) bool
proton.LinkSmall(ctx proton.Context, state *proton.Clickable, text string) bool
```

---

## Patrones comunes

### Confirmar/Cancelar fila (alineada a la derecha)

```go
type UI struct {
    save   proton.Clickable
    cancel proton.Clickable
}

proton.RowEnd(ctx,
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.OutlineButton(ctx, &u.cancel, "Cancel") {
                handleCancel()
            }
        })
    },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.save, "Save changes") {
                handleSave()
            }
        })
    },
)
```

`RowEnd` empuja todo hacia el borde derecho: ubicación estándar para
confirmar/cancelar pares.

### Barra de herramientas

```go
type UI struct {
    newFile  proton.Clickable
    openFile proton.Clickable
    saveFile proton.Clickable
}

proton.Row(ctx,
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.newFile, "New") { handleNew() }
        })
    },
    func(ctx proton.Context) { proton.Gap(ctx, 4) },
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.OutlineButton(ctx, &u.openFile, "Open") { handleOpen() }
        })
    },
    func(ctx proton.Context) { proton.Gap(ctx, 4) },
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.OutlineButton(ctx, &u.saveFile, "Save") { handleSave() }
        })
    },
)
```

### Filas de lista en las que se puede hacer clic

```go
type UI struct {
    rows   [100]proton.Clickable
    chosen int
}

items := []string{"Alpha", "Beta", "Gamma", "Delta"}

proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
    if proton.Tappable(ctx, &u.rows[i], func(ctx proton.Context) {
        proton.PadV(ctx, 10, func(ctx proton.Context) {
            proton.PadH(ctx, 12, func(ctx proton.Context) {
                proton.Label(ctx, items[i])
            })
        })
    }) {
        u.chosen = i
    }
    proton.Divider(ctx)
})
```