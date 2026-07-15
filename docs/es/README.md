# Documentos de protones

**Lea la documentación en su idioma:** [Inglés](https://github.com/CzaxStudio/proton-documentation/blob/main/docs/README.md) | [English](https://github.com/CzaxStudio/proton-documentation/blob/main/docs/es/README.md) | [Francés](https://github.com/CzaxStudio/proton-documentation/blob/main/docs/fr/README.md) | [Ελληνικά](https://github.com/CzaxStudio/proton-documentation/blob/main/docs/el/README.md)

Copyright © [CzaxStudio](https://github.com/CzaxStudio/) (Nexus-Proton)

Todo lo que necesitas para crear aplicaciones de escritorio con Proton. 
Elija un tema o léalos en orden; ambos funcionan bien.

---

| Archivo | ¿Qué hay en él?
|---|---|
| [00-empezando-comenzando.md](./00-empezando-md) | instalar, primera ventana, el patrón de estructura de estado |
| [01-texto.md](./01-texto.md) | Etiqueta, H1–H6, Cuerpo2, Título, Texto personalizado |
| [02-botones.md](./02-botones.md) | Botón, Botón de contorno, Botón de icono, Pulsable |
| [03-entradas.md](./03-entradas.md) | Entrada, Área de texto, Casilla de verificación, Alternar, Botón de radio, Control deslizante, Barra de progreso |
| [04-diseño.md](./04-diseño.md) | Fila, Columna, Dividir, Almohadilla, Espacio, Cuadrícula, GrowRow, Centro |
| [05-listas.md](./05-listas.md) | Lista, ListaH, Desplazamiento |
| [06-visuales.md](./06-visuales.md) | Divisor, Rect, RoundRect, Tarjeta, Insignia, Imagen, MinSize, MaxWidth |
| [07-temática.md](./07-temática.md) | paletas, colores personalizados, escala de fuente |
| [08-avanzado.md](./08-avanzado.md) | Toast, OnKey, gorutinas, información sobre herramientas, ventanas múltiples |
| [09-ejemplos.md](./09-ejemplos.md) | ejemplos completos de copiar y pegar |

---

## Lo único que debes saber

El protón es el modo inmediato. Su función de dibujo ejecuta cada cuadro. tu llamas
funciones del widget, aparecen en la pantalla en ese orden. El estado vive en
tu propia estructura. Eso es todo.

```go
type UI struct {
    btn proton.Clickable
}

u := &UI{}

a.Window("App", 400, 300, func(win proton.Context) {
    proton.Label(win, "Click the button.")
    proton.Gap(win, 8)
    proton.Pad(win, 8, func(win proton.Context) {
        if proton.Button(win, &u.btn, "Hello") {
            println("hello!")
        }
    })
})
```

Los widgets se apilan verticalmente. El estado vive en su estructura. Ese es todo el modelo.

**[Proton-Repo](https://github.com/CzaxStudio/Proton)**