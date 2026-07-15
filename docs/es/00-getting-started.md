# Empezando

Quieres crear una aplicación de escritorio en Go. Has venido al lugar correcto

---

## Requisitos previos

Vaya a 1.22 o más reciente. Consulta con:

```bash
go version
```

Si estás en Linux, también necesitas tres paquetes de sistema. Usuarios de macOS y Windows
Puedes saltarte esto y sentirte engreído:

```bash
sudo apt install libwayland-dev libxkbcommon-dev libvulkan-dev
```

---

## Instalar

En el directorio de su proyecto:

```bash
go get github.com/CzaxStudio/proton
go mod tidy
```

El paso "go mod tidy" es importante: elimina las dependencias transitivas de Gio
y los escribe en `go.sum`. Sáltelo y verá garabatos rojos por todas partes.

---

## Tu primera ventana

```go
package main

import "github.com/CzaxStudio/proton"

función principal() {
    a := protón.Nuevo("hola")
    a.Window("Hola", 480, 320, func(ctx proton.Context) {
        proton.H3(ctx, "¡Hola desde Proton!") // ⓘ Puedes cambiar proton.H3 al tamaño que desees
    })
    a.Ejecutar()
}
```

```bash
go run .
```

Aparece una ventana. Es una aplicación GUI completa y funcional en 9 líneas. sin XML,
sin "implementos Runnable", sin marco de inyección de dependencia, sin paquete web.

---

## Agregar estado

Los widgets que hacen algo (botones, entradas de texto, casillas de verificación) necesitan un estado
campo en su propia estructura. Declarelos una vez, pase punteros a los widgets.

```go
package main

import (
    "fmt"
    "github.com/CzaxStudio/proton"
)

escriba estructura de interfaz de usuario {
    nombre protón.Editor
    btn protón. Se puede hacer clic
}

función principal() {
    tu := &UI{}

a := protón.Nuevo("saludador")
    a.Window("Saludador", 400, 240, func(ctx proton.Context) {
        proton.Input(ctx, &u.name, "Tu nombre")
        protón.Gap(ctx, 8)
        protón.Pad(ctx, 4, func(ctx protón.Context) {
            if proton.Button(ctx, &u.btn, "Saluda") {
                fmt.Println("Hola", u.nombre.Texto())
            }
        })
    })
    a.Ejecutar()
}
```

La función de dibujo ejecuta cada cuadro. `Button` devuelve `true` en el marco que
se hace clic. El bloque `if` se ejecuta, imprime el nombre y listo.

---

## Los tipos de estado

Declarelos en su estructura de interfaz de usuario. Todos están preparados para valor cero, sin constructores.

```go
type UI struct {
    btn     proton.Clickable    // Button, OutlineButton, Tappable, Link
    name    proton.Editor       // Input, TextArea
    checked proton.Bool         // Checkbox, Toggle
    choice  proton.Enum         // RadioButton group
    vol     proton.Float        // Slider
    scroll  proton.Scrollable   // List, HList, Scroll, TextView, LogView
}
```

Un campo por widget. No comparta un elemento "Clicable" entre dos botones: lo harán.
Ambos se disparan con el mismo clic, que casi nunca es lo que deseas.

---

## Cómo funciona el diseño

Sin envoltorios de diseño, los widgets se apilan verticalmente de arriba a abajo. `Brecha`
añade espacio entre ellos.

```go
proton.H4(ctx, "Settings")
proton.Gap(ctx, 12)
proton.Label(ctx, "Adjust your preferences below.")
proton.Gap(ctx, 16)
proton.Divider(ctx)
proton.Gap(ctx, 16)
proton.Toggle(ctx, &u.darkMode, "Dark mode")
```

Para el diseño de lado a lado, utilice "Fila". Para obtener más control, consulte [04-layout.md](./04-layout.md).

---

## Los botones necesitan un contenedor de diseño

Los botones (y otros widgets interactivos) deben estar dentro de un asistente de diseño para
clics para registrarse correctamente. Esto es cosa de Gio: el pase de diseño es lo que
establece áreas de impacto en la pantalla.

```go
// correct — button is inside Pad
proton.Pad(ctx, 8, func(ctx proton.Context) {
    if proton.Button(ctx, &u.btn, "Save") {
        save()
    }
})

// también correcto: el botón está dentro de la fila
protón.Fila(ctx,
    func(ctx protón.Contexto) {
        if proton.Button(ctx, &u.btn, "Guardar") {
            guardar()
        }
    },
)
```

Si coloca un botón en el nivel superior de la función de dibujo sin ningún
contenedor, se dibujará pero no responderá a los clics. `Pad(ctx, 0, ...)` es el
contenedor mínimo si desea cero relleno visual.

---

## Tematización

```go
a := proton.New("myapp")
a.ApplyPalette(proton.NordPalette)
a.Window("App", 800, 600, draw)
a.Run()
```

Hay 46 paletas integradas. Consulte [07-theming.md](./07-theming.md) para verlas todas.
y para construir el tuyo propio con códigos de colores hexadecimales.

---

## Varias ventanas

```go
a := proton.New("app")
a.Window("Main", 800, 600, drawMain)
a.Window("Settings", 400, 300, drawSettings)
a.Run() // opens both
```

Todas las ventanas comparten la misma `*Aplicación`. El proceso permanece vivo hasta que todas las ventanas
están cerrados.

---

## Próximos pasos

- **[01-text.md](./01-text.md)** — widgets de texto
- **[02-buttons.md](./02-buttons.md)** — botones y áreas en las que se puede hacer clic
- **[03-inputs.md](./03-inputs.md)** — campos de texto, alternadores, controles deslizantes
- **[04-layout.md](./04-layout.md)** — organizar cosas en la pantalla
- **[09-examples.md](./09-examples.md)** — programas de trabajo completos para copiar