# Ejemplos

Programas completos que puedes copiar, pegar y ejecutar. Cada uno de estos compila
y funciona como está.

---

## Hola Mundo

El mínimo absoluto. Abra una ventana, muestre algo de texto.

```go
package main

import "github.com/CzaxStudio/proton"

función principal() {
    a := protón.Nuevo("hola")
    a.Window("Hola", 400, 200, func(ctx proton.Context) {
        proton.H3(ctx, "¡Hola desde Proton!")
    })
    a.Ejecutar()
}
```

---

## Encimera

Un número que sube y baja cuando haces clic en los botones. Demuestra
el patrón fundamental: estado en una estructura, botones dentro de envoltorios de diseño.

```go
package main

import (
    "fmt"
    "github.com/CzaxStudio/proton"
)

escriba estructura de interfaz de usuario {
    contar entero
    inc protón. Se puede hacer clic
    dec protón. Se puede hacer clic
    restablecer protón. Se puede hacer clic
}

función principal() {
    tu := &UI{}
    a := protón.Nuevo("contador")
    a.ApplyPalette (protón.NordPalette)
    a.Window("Contador", 320, 240, func(ctx proton.Context) {
        protón.Centro(ctx, func(ctx protón.Contexto) {
            protón.H1(ctx, fmt.Sprintf("%d", u.count))
            protón.Gap(ctx, 20)
            protón.Fila(ctx,
                func(ctx protón.Contexto) {
                    protón.Pad(ctx, 4, func(ctx protón.Context) {
                        si protón.OutlineButton(ctx, &u.dec, "-") {
                            u.count--
                        }
                    })
                },
                func(ctx protón.Context) { protón.Gap(ctx, 8) },
                func(ctx protón.Contexto) {
                    protón.Pad(ctx, 4, func(ctx protón.Context) {
                        si protón.Botón(ctx, &u.inc, "+") {
                            u.count++
                        }
                    })
                },
                func(ctx protón.Context) { protón.Gap(ctx, 8) },
                func(ctx protón.Contexto) {
                    protón.Pad(ctx, 4, func(ctx protón.Context) {
                        if proton.OutlineButton(ctx, &u.reset, "Restablecer") {
                            u.cuenta = 0
                        }
                    })
                },
            )
        })
    })
    a.Ejecutar()
}
```

---

## Lista de tareas pendientes

La demostración que todo marco de UI debe tener por ley.

```go
package main

import "github.com/CzaxStudio/proton"

escriba la estructura del elemento {
    cadena de texto
    hecho protón.Bool
}

escriba estructura de interfaz de usuario {
    protón de entrada.Editor
    addBtn protón. Se puede hacer clic
    elementos [] elemento
    protón de desplazamiento. Desplazable
}

función principal() {
    tu := &UI{}
    a := protón.Nuevo("todo")
    a.ApplyPalette(protón.CatppuccinPalette)
    a.Window("Todo", 420, 560, func(ctx proton.Context) {
        protón.H4(ctx, "Todo")
        protón.Gap(ctx, 12)

// agregar fila
        protón.GrowRow(ctx,
            protón.GrowItem(ctx, func(ctx protón.Context) {
                proton.Input(ctx, &u.input, "¿Qué hay que hacer?")
            }),
            protón.FixedItem(ctx, func(ctx protón.Context) { protón.Gap(ctx, 8) }),
            protón.FixedItem(ctx, func(ctx protón.Context) {
                protón.Pad(ctx, 4, func(ctx protón.Context) {
                    si proton.Button(ctx, &u.addBtn, "Agregar") {
                        si t := u.input.Text(); t != "" {
                            u.items = agregar(u.items, elemento{texto: t})
                            u.entrada.SetText("")
                        }
                    }
                })
            }),
        )

protón.Gap(ctx, 8)
        protón.Divisor(ctx)
        protón.Gap(ctx, 8)

si len(u.elementos) == 0 {
            protón.Centro(ctx, func(ctx protón.Contexto) {
                proton.Muted(ctx, "Aquí no hay nada. Agrega algo arriba.")
            })
            volver
        }

proton.List(ctx, &u.scroll, len(u.items), func(ctx proton.Context, i int) {
            protón.PadV(ctx, 6, func(ctx protón.Context) {
                proton.Checkbox(ctx, &u.items[i].done, u.items[i].text)
            })
        })
    })
    a.Ejecutar()
}
```

---

## Formulario de inicio de sesión

Un formulario con campos de correo electrónico/contraseña y validación en línea.

```go
package main

import (
    "strings"
    "github.com/CzaxStudio/proton"
)

escriba estructura de interfaz de usuario {
    protón de correo electrónico.Editor
    contraseña proton.Editor
    enviar protón. Se puede hacer clic
    cadena de mensaje de error
    éxito booleano
}

función principal() {
    tu := &UI{}
    a := protón.Nuevo("iniciar sesión")
    a.ApplyPalette(proton.MidnightPalette)
    a.Window("Iniciar sesión", 400, 360, func(ctx proton.Context) {
        protón.Centro(ctx, func(ctx protón.Contexto) {
            protón.MaxWidth(ctx, 300, func(ctx protón.Context) {
                proton.H4(ctx, "Iniciar sesión")
                protón.Gap(ctx, 24)

proton.Label(ctx, "Correo electrónico")
                protón.Gap(ctx, 4)
                proton.Input(ctx, &u.email, "usted@ejemplo.com")
                protón.Gap(ctx, 12)

proton.Label(ctx, "Contraseña")
                protón.Gap(ctx, 4)
                proton.Input(ctx, &u.contraseña, "contraseña")
                protón.Gap(ctx, 8)

protón.ErrorText(ctx, u.errMsg)
                si u.errMsg! = "" {
                    protón.Gap(ctx, 6)
                }

si tu éxito {
                    proton.SuccessText(ctx, "¡Inicié sesión correctamente!")
                    volver
                }

protón.Pad(ctx, 4, func(ctx protón.Context) {
                    if proton.Button(ctx, &u.submit, "Iniciar sesión") {
                        u.errMsg = validar(u.email.Text(), u.contraseña.Text())
                        si u.errMsg == "" {
                            u.éxito = verdadero
                        }
                    }
                })
            })
        })
    })
    a.Ejecutar()
}

func validar (correo electrónico, cadena de contraseña) cadena {
    if !strings.Contains(correo electrónico, "@") {
        devolver "Ingrese una dirección de correo electrónico válida".
    }
    si len(contraseña) < 8 {
        devuelve "La contraseña debe tener al menos 8 caracteres".
    }
    devolver ""
}
```

---

## Panel de configuración

Alternadores, botones de opción, un control deslizante y un botón para guardar. El tipo de panel
que vive en cada aplicación.

```go
package main

import (
    "fmt"
    "github.com/CzaxStudio/proton"
)

escriba Configuración de estructura {
    notificaciones protón.Bool
    protón modo oscuro.Bool
    lenguaje proton.Enum
    fontSize proton.Float
    saveBtn proton.Se puede hacer clic
    protón tostado.ToastState
}

import "time"

función principal() {
    s := &Configuración{}
    s.fontSize.Value = 0,5

a := protón.Nuevo("configuración")
    a.ApplyPalette (protón.DraculaPalette)
    a.Window("Configuración", 480, 520, func(ctx proton.Context) {
        protón.H4(ctx, "Configuración")
        protón.Gap(ctx, 24)

protón.H6(ctx, "Apariencia")
        protón.Gap(ctx, 10)
        proton.Toggle(ctx, &s.darkMode, "Modo oscuro")
        protón.Gap(ctx, 8)
        proton.Label(ctx, fmt.Sprintf("Tamaño de fuente: %.0f%%", 80+s.fontSize.Value*40))
        protón.Gap(ctx, 4)
        protón.Slider(ctx, &s.fontSize)
        protón.Gap(ctx, 24)

proton.H6(ctx, "Notificaciones")
        protón.Gap(ctx, 10)
        proton.Checkbox(ctx, &s.notificaciones, "Notificaciones por correo electrónico")
        protón.Gap(ctx, 24)

protón.H6(ctx, "Idioma")
        protón.Gap(ctx, 10)
        proton.RadioButton(ctx, &s.language, "en", "English")
        protón.Gap(ctx, 6)
        protón.RadioButton(ctx, &s.language, "es", "Español")
        protón.Gap(ctx, 6)
        protón.RadioButton(ctx, &s.language, "fr", "Français")
        protón.Gap(ctx, 28)

protón.RowEnd(ctx,
            func(ctx protón.Contexto) {
                protón.Pad(ctx, 4, func(ctx protón.Context) {
                    if proton.Button(ctx, &s.saveBtn, "Guardar configuración") {
                        s.toast.Show("Configuración guardada.", 2*tiempo. Segundo)
                    }
                })
            },
        )

protón.tostada(ctx, &s.tostada)
    })
    a.Ejecutar()
}
```

---

## Aplicación con logotipo

Cargue un logotipo desde un archivo incrustado y muéstrelo en el encabezado.

```go
package main

import (
    _ "embed"
    "fmt"
    "time"
    "github.com/CzaxStudio/proton"
)

//ir:incrustar logo.png
var logoBytes []byte

escriba estructura de interfaz de usuario {
    contar entero
    btn protón. Se puede hacer clic
    protón tostado.ToastState
}

función principal() {
    tu := &UI{}

a := protón.Nuevo("logoapp")
    a.ApplyPalette (protón.NordPalette)
    a.SetLogoBytes(logoBytes)

a.Window("Mi aplicación", 420, 300, func(ctx proton.Context) {
        // encabezado con logo
        protón.Fila(ctx,
            func(ctx protón.Context) { protón.Logo(ctx, 36, 36) },
            func(ctx protón.Context) { protón.Gap(ctx, 10) },
            func(ctx proton.Context) { proton.H5(ctx, "Mi aplicación") },
        )
        protón.Gap(ctx, 16)
        protón.Divisor(ctx)
        protón.Gap(ctx, 16)

proton.Label(ctx, fmt.Sprintf("Se hizo clic en el botón %d veces", u.count))
        protón.Gap(ctx, 10)
        protón.Pad(ctx, 4, func(ctx protón.Context) {
            if proton.Button(ctx, &u.btn, "Haz clic en mí") {
                u.count++
                si u.count%5 == 0 {
                    u.toast.Show(fmt.Sprintf("%d clics!", u.count), 2*time.Second)
                }
            }
        })

proton.Toast(ctx, &u.tost)
    })
    a.Ejecutar()
}
```

Coloque `logo.png` en el mismo directorio que `main.go` antes de ejecutar.

---

## Aplicación de dos paneles

Una división de contenido y barra lateral de tamaño variable: el patrón de diseño detrás de la mayoría de las aplicaciones de escritorio.

```go
package main

import "github.com/CzaxStudio/proton"

escriba estructura de interfaz de usuario {
    dividir protón.ResizeSplitState
    protón de desplazamiento. Desplazable
    filaBtns [10]protón.Se puede hacer clic
    seleccionado int
    saveBtn proton.Se puede hacer clic
    editor de protones.Editor
    protón tostado.ToastState
}

var elementos = []cadena{
    "Proyecto Alfa", "Proyecto Beta", "Proyecto Gamma",
    "Notas de la reunión", "Ideas", "Atrasos",
}

import "time"

función principal() {
    u := &UI{seleccionado: 0}
    u.editor.SetText("Seleccione un elemento de la izquierda para editarlo.")

a := protón.Nuevo("dos paneles")
    a.ApplyPalette (protón.TokyoNightPalette)
    a.Window("Aplicación de dos paneles", 700, 500, func(ctx proton.Context) {
        protón.ResizeSplit(ctx, &u.split, 0.30,
            func(ctx protón.Contexto) {
                protón.H6(ctx, "Artículos")
                protón.Gap(ctx, 8)
                proton.List(ctx, &u.scroll, len(elementos), func(ctx proton.Context, i int) {
                    bg := protón.RGB(0x1a1b26)
                    hov := protón.RGB(0x24283b)
                    si u.seleccionado == i {
                        bg = protón.RGB(0x364a82)
                        hov = bg
                    }
                    protón.PadV(ctx, 2, func(ctx protón.Context) {
                        si proton.HoverCard(ctx, &u.rowBtns[i], bg, hov, 5, func(ctx proton.Context) {
                            protón.PadV(ctx, 8, func(ctx protón.Context) {
                                protón.PadH(ctx, 10, func(ctx protón.Context) {
                                    protón.Label(ctx, elementos[i])
                                })
                            })
                        }) {
                            u.seleccionado = i
                        }
                    })
                })
            },
            func(ctx protón.Contexto) {
                protón.PadH(ctx, 14, func(ctx protón.Context) {
                    protón.RowSpread(ctx,
                        func(ctx proton.Context) { proton.H6(ctx, elementos[u.seleccionados]) },
                        func(ctx protón.Contexto) {
                            protón.Pad(ctx, 4, func(ctx protón.Context) {
                                si proton.Button(ctx, &u.saveBtn, "Guardar") {
                                    u.toast.Show("Guardado.", 2*tiempo.Segundo)
                                }
                            })
                        },
                    )
                    protón.Gap(ctx, 12)
                    protón.GrowColumn(ctx,
                        protón.GrowItem(ctx, func(ctx protón.Context) {
                            proton.TextArea(ctx, &u.editor, "Escribe algo...")
                        }),
                    )
                })
            },
        )
        proton.Toast(ctx, &u.tost)
    })
    a.Ejecutar()
}
```

---

## Ejecutando los ejemplos integrados

El repositorio viene con 9 aplicaciones de ejemplo completas:

```bash
go run ./examples/hello        # one window, one label
go run ./examples/todo         # todo list
go run ./examples/calculator   # grid of buttons, math
go run ./examples/notes        # note-taking with search and modal delete
go run ./examples/dashboard    # dev dashboard: charts, logs, tables
go run ./examples/showcase     # every widget in 5 tabs
go run ./examples/themes       # live palette picker + preview
go run ./examples/logoapp      # custom logo with go:embed
go run ./examples/kitchen      # stress test for all features
```

Primero ejecute "showcase": es la demostración visual más completa de lo que
El protón puede hacerlo.