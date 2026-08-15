# Avanzado

Atajos de teclado, rutinas asincrónicas, notificaciones de brindis, modales, pestañas,
acordeón, menús contextuales y todo lo demás que no encaja perfectamente en
las páginas anteriores.

---

## Notificaciones de brindis

A timed message that appears, stays for a few seconds, and disappears on its
own. No dialog, no blocking the user.

```go
type UI struct {
    toast proton.ToastState
}

// trigger from anywhere — goroutine-safe
u.toast.Show("File saved!", 2*time.Second)

// draw it LAST in your draw function so it renders on top of everything
proton.Toast(ctx, &u.toast)
```

If there's no active toast, `Toast` draws nothing. No need to check first.

```go
func (t *ToastState) Show(msg string, duration time.Duration)
proton.Toast(ctx proton.Context, state *proton.ToastState)
```

---

## Superposición/modal

Un fondo atenuado con contenido centrado encima de todo.

```go
type UI struct {
    modal    proton.OverlayState
    openBtn  proton.Clickable
    closeBtn proton.Clickable
}

// open it
proton.Pad(ctx, 4, func(ctx proton.Context) {
    if proton.Button(ctx, &u.openBtn, "Open dialog") {
        u.modal.Show()
    }
})

// draw it — also at the end of your draw function
proton.Overlay(ctx, &u.modal, func(ctx proton.Context) {
    proton.MinSize(ctx, 300, 0, func(ctx proton.Context) {
        proton.Card(ctx, proton.RGB(0x2e3440), 12, 24, func(ctx proton.Context) {
            proton.H5(ctx, "Are you sure?")
            proton.Gap(ctx, 8)
            proton.Label(ctx, "This cannot be undone.")
            proton.Gap(ctx, 20)
            proton.RowEnd(ctx,
                func(ctx proton.Context) {
                    proton.Pad(ctx, 4, func(ctx proton.Context) {
                        if proton.OutlineButton(ctx, &u.closeBtn, "Cancel") {
                            u.modal.Hide()
                        }
                    })
                },
                func(ctx proton.Context) { proton.Gap(ctx, 8) },
                func(ctx proton.Context) {
                    proton.Pad(ctx, 4, func(ctx proton.Context) {
                        if proton.Button(ctx, &u.openBtn, "Confirm") {
                            u.modal.Hide()
                            doThing()
                        }
                    })
                },
            )
        })
    })
})
```

```go
func (o *OverlayState) Show()
func (o *OverlayState) Hide()
func (o *OverlayState) Toggle()

proton.Overlay(ctx proton.Context, state *proton.OverlayState, content func(proton.Context))
```

`Overlay` no dibuja nada cuando `state.Visible` es falso, así que puedes llamarlo
cada cuadro sin ninguna condición de envoltura.

---

## Atajos de teclado

Registre una función para que se active cuando se presiona una combinación de teclas.

```go
proton.OnKey(ctx, proton.ModCtrl, "S", func() { save() })
proton.OnKey(ctx, proton.ModCtrl, "Z", func() { undo() })
proton.OnKey(ctx, proton.ModCtrl|proton.ModShift, "N", func() { newFile() })
proton.OnKey(ctx, proton.ModNone, proton.KeyEscape, func() { closeDialog() })
```

Call `OnKey` inside your draw function. It registers the shortcut for that
frame. Since the draw function runs every frame, shortcuts stay active as
long as the window is open.

```go
proton.OnKey(ctx proton.Context, modifiers proton.Modifier, keyName string, fn func())
```

**Constantes modificadoras:**

```go
proton.ModNone   // no modifier — just the key
proton.ModCtrl   // Ctrl (Cmd on macOS)
proton.ModShift
proton.ModAlt

// combine with |
proton.ModCtrl | proton.ModShift
```

**Constantes de nombre de clave** (para claves que no son letras):

```go
proton.KeyEscape
proton.KeyReturn
proton.KeyBackspace
proton.KeyDelete
proton.KeyTab
proton.KeySpace
proton.KeyUp
proton.KeyDown
proton.KeyLeft
proton.KeyRight
```

Las claves de letras son solo cadenas: `"S"`, `"Z"`, `"N"`, `"A"`.

---

## Pestañas

Una barra de pestañas horizontal con un área de contenido que cambia según el
pestaña seleccionada.

```go
type UI struct {
    tabs    proton.TabState
    tabBtns [3]proton.Clickable
}

proton.Tabs(ctx,
    []string{"Files", "Settings", "About"},
    u.tabBtns[:],
    &u.tabs,
    func(ctx proton.Context, i int) {
        switch i {
        case 0: drawFiles(ctx)
        case 1: drawSettings(ctx)
        case 2: drawAbout(ctx)
        }
    },
)
```

`u.tabs.Selected` contiene el índice de la pestaña activa. Puedes configurarlo programáticamente
para cambiar pestañas del código.

```go
proton.Tabs(ctx proton.Context, labels []string, btns []proton.Clickable, state *proton.TabState, content func(proton.Context, int))
```

El segmento `btns` necesita un `Clickable` por pestaña. Pasar `u.tabBtns[:]` es
de forma idiomática cuando declaras una matriz de tamaño fijo en tu estructura.

---

## acordeón

A collapsible section with a clickable header.

```go
type UI struct {
    sec1    proton.AccordionState
    sec1btn proton.Clickable
}

proton.Accordion(ctx, &u.sec1, &u.sec1btn, "Advanced Options", func(ctx proton.Context) {
    proton.Label(ctx, "These options are hidden until the user expands this.")
    proton.Gap(ctx, 8)
    proton.Toggle(ctx, &u.expertMode, "Expert mode")
})
```

```go
proton.Accordion(ctx proton.Context, state *proton.AccordionState, btn *proton.Clickable, title string, content func(proton.Context))
```

`state.Open` tracks whether it's expanded. You can set it directly to start
an accordion open: `u.sec1.Open = true`.

---

## Menú contextual

Un menú contextual que aparece en la posición del cursor.

```go
type UI struct {
    menu    proton.ContextMenuState
    menuTag proton.FrameTag
}

items := []proton.ContextMenuItem{
    {Label: "Copy"},
    {Label: "Paste"},
    {Label: "Delete"},
    {Label: "Disabled option", Disabled: true},
}

chosen := proton.ContextMenu(ctx, &u.menu, &u.menuTag, items, func(ctx proton.Context) {
    proton.Label(ctx, "Right-click anywhere in this area")
})

if chosen >= 0 {
    fmt.Println("User picked:", items[chosen].Label)
}
```

```go
proton.ContextMenu(ctx proton.Context, state *proton.ContextMenuState, tag *proton.FrameTag, items []proton.ContextMenuItem, content func(proton.Context)) int
```

Returns -1 when nothing was selected, and the item index on the frame
something gets clicked. The menu closes automatically after a selection.

---

## Actualizaciones asincrónicas y rutinas

Su función de dibujo se ejecuta en el hilo principal. Cuando una gorutina termina de funcionar
y cambia de estado, llame a `ctx.Invalidate()` para solicitar un nuevo dibujo.

```go
type UI struct {
    loading bool
    result  string
    fetchBtn proton.Clickable
}

// in your draw function
proton.Pad(ctx, 4, func(ctx proton.Context) {
    if proton.Button(ctx, &u.fetchBtn, "Fetch") && !u.loading {
        u.loading = true
        go func() {
            data := fetchFromAPI()        // takes a while
            u.result = data
            u.loading = false
            ctx.Invalidate()              // wake up the render loop
        }()
    }
})

if u.loading {
    proton.Row(ctx,
        func(ctx proton.Context) { proton.Spinner(ctx, &u.spin, 18) },
        func(ctx proton.Context) { proton.Gap(ctx, 8) },
        func(ctx proton.Context) { proton.Muted(ctx, "Loading...") },
    )
} else if u.result != "" {
    proton.Label(ctx, u.result)
}
```

Sin `ctx.Invalidate()`, la ventana no se volverá a dibujar hasta que el usuario se mueva
el ratón o interactúa con él. Llámelo siempre después de cambiar de estado
una gorutina.

---

## hilandero

Un indicador de carga animado. Llamar a `Spinner` mantiene automáticamente el
Redibujado de la ventana: no se necesita el bucle `Invalidate()`.

```go
type UI struct {
    spin proton.SpinnerState
}

proton.Spinner(ctx, &u.spin, 32)  // 32dp diameter
```

```go
proton.Spinner(ctx proton.Context, state *proton.SpinnerState, sizeDp float32)
```

`SpinnerState` rastrea el tiempo de inicio de la animación. Declarar uno por ruleta
en su estructura estatal.

---

## Seleccionar cuadro (desplegable)

```go
type UI struct {
    langSel proton.SelectBoxState
}

langs := []string{"Go", "Rust", "Zig", "C", "Python"}
i := proton.SelectBox(ctx, &u.langSel, langs)
proton.Caption(ctx, "Selected: "+langs[i])
```

El menú desplegable se abre debajo del botón y se cierra al seleccionarlo o hacer clic fuera del mismo.

```go
proton.SelectBox(ctx proton.Context, state *proton.SelectBoxState, options []string) int
```

---

## If — Conditional Rendering

Presenta contenido solo cuando una condición es verdadera. Guarda un bloque "si" cuando
Sólo quiero mostrar u ocultar un único widget.

```go
proton.If(ctx, user.IsAdmin, func(ctx proton.Context) {
    proton.Pad(ctx, 4, func(ctx proton.Context) {
        if proton.Button(ctx, &u.deleteBtn, "Delete everything") {
            deleteEverything()
        }
    })
})
```

```go
proton.If(ctx proton.Context, cond bool, content func(proton.Context))
```

---

## FocusArea: manejo de claves con alcance

Cuando necesite eventos de teclado activos solo dentro de una región específica de la interfaz de usuario,
no globalmente. Por lo general, `OnKey` es suficiente; utilícelo cuando tenga dos
paneles que deberían tener atajos de teclado independientes.

```go
type UI struct {
    editorTag proton.FrameTag
}

proton.FocusArea(ctx, &u.editorTag, "A", func(ctx proton.Context) {
    proton.TextArea(ctx, &u.text, "Type here...")
})
```

```go
proton.FocusArea(ctx proton.Context, tag *proton.FrameTag, keyName string, content func(proton.Context))
```

---

## Opciones de ventana

```go
// fullscreen
a.WindowEx("App", 800, 600, []proton.WindowOption{
    proton.Fullscreen(),
}, draw)

// maximized
a.WindowEx("App", 800, 600, []proton.WindowOption{
    proton.Maximized(),
}, draw)
```

```go
proton.Fullscreen() proton.WindowOption
proton.Maximized()  proton.WindowOption
```

---

## Keeping Animations Running

Proton only redraws when there's user input or you call `ctx.Invalidate()`.
For animations — progress bars that fill over time, countdowns, anything
time-based — call `Invalidate` at the end of each frame to keep the redraws
going:

```go
func draw(ctx proton.Context, u *UI) {
    if u.animating {
        u.progress += 0.01
        if u.progress >= 1.0 {
            u.progress = 0
            u.animating = false
        }
        proton.ProgressBar(ctx, u.progress)
        ctx.Invalidate()  // draw again next frame
    }
}
```

When `u.animating` goes false, `Invalidate` stops being called and Proton
goes back to redrawing only on user input. The Spinner widget does this
automatically — you don't need to manage it yourself.
