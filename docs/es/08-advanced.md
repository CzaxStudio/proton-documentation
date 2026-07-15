# Avanzado

Atajos de teclado, rutinas asincrónicas, notificaciones de brindis, modales, pestañas,
acordeón, menús contextuales y todo lo demás que no encaja perfectamente en
las páginas anteriores.

---

## Notificaciones de brindis

Un mensaje cronometrado que aparece, permanece durante unos segundos y desaparece
propio. Sin diálogo, sin bloquear al usuario.

```go
type UI struct {
    toast proton.ToastState
}

// disparador desde cualquier lugar - goroutine-safe
u.toast.Show("¡Archivo guardado!", 2*tiempo.Segundo)

// dibujarlo ÚLTIMO en tu función de dibujo para que se muestre encima de todo
proton.Toast(ctx, &u.tost)
```

Si no hay ningún brindis activo, "Toast" no genera nada. No es necesario comprobarlo primero.

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

// abrirlo
protón.Pad(ctx, 4, func(ctx protón.Context) {
    if proton.Button(ctx, &u.openBtn, "Abrir diálogo") {
        u.modal.Mostrar()
    }
})

// dibujarlo - también al final de tu función de dibujo
protón.Overlay(ctx, &u.modal, func(ctx proton.Context) {
    protón.MinSize(ctx, 300, 0, func(ctx protón.Context) {
        protón.Card(ctx, protón.RGB(0x2e3440), 12, 24, func(ctx protón.Context) {
            protón.H5(ctx, "¿Estás seguro?")
            protón.Gap(ctx, 8)
            proton.Label(ctx, "Esto no se puede deshacer.")
            protón.Gap(ctx, 20)
            protón.RowEnd(ctx,
                func(ctx protón.Contexto) {
                    protón.Pad(ctx, 4, func(ctx protón.Context) {
                        if proton.OutlineButton(ctx, &u.closeBtn, "Cancelar") {
                            u.modal.Ocultar()
                        }
                    })
                },
                func(ctx protón.Context) { protón.Gap(ctx, 8) },
                func(ctx protón.Contexto) {
                    protón.Pad(ctx, 4, func(ctx protón.Context) {
                        if proton.Button(ctx, &u.openBtn, "Confirmar") {
                            u.modal.Ocultar()
                            hacer cosas()
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

proton.Overlay(ctx proton.Context, estado *proton.OverlayState, contenido func(proton.Context))
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

Llame a `OnKey` dentro de su función de dibujo. Registra el acceso directo para eso.
marco. Dado que la función de dibujo se ejecuta en cada cuadro, los atajos permanecen activos como
mientras la ventana esté abierta.

```go
proton.OnKey(ctx proton.Context, modifiers proton.Modifier, keyName string, fn func())
```

**Constantes modificadoras:**

```go
proton.ModNone   // no modifier — just the key
proton.ModCtrl   // Ctrl (Cmd on macOS)
proton.ModShift
proton.ModAlt

// combinar con |
protón.ModCtrl | protón.ModShift
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

protón.Tabs(ctx,
    []cadena{"Archivos", "Configuración", "Acerca de"},
    u.tabBtns[:],
    &u.pestañas,
    func(ctx protón.Contexto, i int) {
        cambiar yo {
        caso 0: dibujar archivos (ctx)
        caso 1: dibujarConfiguración(ctx)
        caso 2: dibujarAcerca de(ctx)
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

Una sección plegable con un encabezado en el que se puede hacer clic.

```go
type UI struct {
    sec1    proton.AccordionState
    sec1btn proton.Clickable
}

proton.Accordion(ctx, &u.sec1, &u.sec1btn, "Opciones avanzadas", func(ctx proton.Context) {
    proton.Label(ctx, "Estas opciones están ocultas hasta que el usuario las expanda.")
    protón.Gap(ctx, 8)
    proton.Toggle(ctx, &u.expertMode, "modo experto")
})
```

```go
proton.Accordion(ctx proton.Context, state *proton.AccordionState, btn *proton.Clickable, title string, content func(proton.Context))
```

`state.Open` rastrea si está expandido. Puedes configurarlo directamente para comenzar
un acordeón abierto: `u.sec1.Open = true`.

---

## Menú contextual

Un menú contextual que aparece en la posición del cursor.

```go
type UI struct {
    menu    proton.ContextMenuState
    menuTag proton.FrameTag
}

elementos: = []protón.ContextMenuItem{
    {Etiqueta: "Copiar"},
    {Etiqueta: "Pegar"},
    {Etiqueta: "Eliminar"},
    {Etiqueta: "Opción deshabilitada", Deshabilitado: verdadero},
}

elegido := proton.ContextMenu(ctx, &u.menu, &u.menuTag, items, func(ctx proton.Context) {
    proton.Label(ctx, "Haga clic derecho en cualquier lugar de esta área")
})

si se elige >= 0 {
    fmt.Println("Usuario elegido:", elementos[elegidos].Etiqueta)
}
```

```go
proton.ContextMenu(ctx proton.Context, state *proton.ContextMenuState, tag *proton.FrameTag, items []proton.ContextMenuItem, content func(proton.Context)) int
```

Devuelve -1 cuando no se seleccionó nada y el índice del elemento en el marco
se hace clic en algo. El menú se cierra automáticamente después de una selección.

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

// en tu función de dibujo
protón.Pad(ctx, 4, func(ctx protón.Context) {
    si proton.Button(ctx, &u.fetchBtn, "Fetch") && !u.loading {
        u.cargando = verdadero
        ir función() {
            datos := fetchFromAPI() // lleva un tiempo
            u.resultado = datos
            u.cargando = falso
            ctx.Invalidate() // activa el bucle de renderizado
        }()
    }
})

si estás cargando {
    protón.Fila(ctx,
        func(ctx proton.Context) { proton.Spinner(ctx, &u.spin, 18) },
        func(ctx protón.Context) { protón.Gap(ctx, 8) },
        func(ctx proton.Context) { proton.Muted(ctx, "Cargando...") },
    )
} si no, si u.resultado! = "" {
    protón.Label(ctx, u.resultado)
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

proton.Spinner(ctx, &u.spin, 32) // 32dp de diámetro
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

idiomas := []cadena{"Ir", "Rust", "Zig", "C", "Python"}
i := protón.SelectBox(ctx, &u.langSel, idiomas)
proton.Caption(ctx, "Seleccionado: "+idiomas[i])
```

El menú desplegable se abre debajo del botón y se cierra al seleccionarlo o hacer clic fuera del mismo.

```go
proton.SelectBox(ctx proton.Context, state *proton.SelectBoxState, options []string) int
```

---

## Si - Representación condicional

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
    proton.TextArea(ctx, &u.text, "Escriba aquí...")
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

// maximizado
a.WindowEx("Aplicación", 800, 600, []proton.WindowOption{
    protón.Maximizado(),
}, dibujar)
```

```go
proton.Fullscreen() proton.WindowOption
proton.Maximized()  proton.WindowOption
```

---

## Mantener las animaciones en ejecución

Proton solo se vuelve a dibujar cuando hay entrada del usuario o usted llama a `ctx.Invalidate()`.
Para animaciones: barras de progreso que se van llenando con el tiempo, cuentas atrás, cualquier cosa.
basado en el tiempo: llame a "Invalidar" al final de cada cuadro para mantener los redibujados
yendo:

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

Cuando `u.animating` se vuelve falso, `Invalidate` deja de llamarse y Proton
vuelve a volver a dibujar solo según la entrada del usuario. El widget Spinner hace esto
automáticamente: no es necesario que lo administres tú mismo.