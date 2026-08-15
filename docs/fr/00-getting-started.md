# Commencer

Vous souhaitez créer une application de bureau dans Go. Vous êtes au bon endroit.

---

## Prérequis

Passez à la version 1.22 ou plus récente. Vérifiez auprès de :

```bash
go version
```

Si vous utilisez Linux, vous avez également besoin de trois packages système. Utilisateurs macOS et Windows
je peux sauter ça et me sentir suffisant :

```bash
sudo apt install libwayland-dev libxkbcommon-dev libvulkan-dev
```

---

## Installer

Dans le répertoire de votre projet :

```bash
go get github.com/CzaxStudio/proton
go mod tidy
```

The `go mod tidy` step is important — it pulls Gio's transitive dependencies
and writes them to `go.sum`. Skip it and you'll see red squiggles everywhere.

---

## Votre première fenêtre

```go
package main

import "github.com/CzaxStudio/proton"

func main() {
    a := proton.New("hello")
    a.Window("Hello", 480, 320, func(ctx proton.Context) {
        proton.H3(ctx, "Hello from Proton!") // ⓘ You can change proton.H3 to any size you want
    })
    a.Run()
}
```

```bash
go run .
```

Une fenêtre apparaît. Il s'agit d'une application GUI complète et fonctionnelle en 9 lignes. Pas de XML,
pas d'impléments Runnable, pas de framework d'injection de dépendances, pas de webpack.

---

## Ajout d'un état

Les widgets qui font quelque chose (boutons, saisies de texte, cases à cocher) ont besoin d'un état
champ dans votre propre structure. Déclarez-les une fois, transmettez les pointeurs vers les widgets.

```go
package main

import (
    "fmt"
    "github.com/CzaxStudio/proton"
)

type UI struct {
    name proton.Editor
    btn  proton.Clickable
}

func main() {
    u := &UI{}

    a := proton.New("greeter")
    a.Window("Greeter", 400, 240, func(ctx proton.Context) {
        proton.Input(ctx, &u.name, "Your name")
        proton.Gap(ctx, 8)
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.btn, "Say hello") {
                fmt.Println("Hello,", u.name.Text())
            }
        })
    })
    a.Run()
}
```

La fonction draw exécute chaque image. `Button` renvoie `true` sur le cadre
est cliqué. Le bloc `if` s'exécute, imprime le nom, et c'est tout.

---

## Les types d'état

Declare these in your UI struct. They're all zero-value ready — no constructors.

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

One field per widget. Don't share a `Clickable` between two buttons — they'll
both fire on the same click, which is almost never what you want.

---

## Comment fonctionne la mise en page

Without any layout wrappers, widgets stack vertically top to bottom. `Gap`
adds space between them.

```go
proton.H4(ctx, "Settings")
proton.Gap(ctx, 12)
proton.Label(ctx, "Adjust your preferences below.")
proton.Gap(ctx, 16)
proton.Divider(ctx)
proton.Gap(ctx, 16)
proton.Toggle(ctx, &u.darkMode, "Dark mode")
```

Pour une disposition côte à côte, utilisez « Row ». Pour plus de contrôle, voir [04-layout.md](./04-layout.md).

---

## Les boutons nécessitent un wrapper de mise en page

Les boutons (et autres widgets interactifs) doivent se trouver dans un assistant de mise en page pour
clique pour s’inscrire correctement. C'est une affaire de Gio - la passe de mise en page est ce que
établit les zones touchées à l'écran.

```go
// correct — button is inside Pad
proton.Pad(ctx, 8, func(ctx proton.Context) {
    if proton.Button(ctx, &u.btn, "Save") {
        save()
    }
})

// also correct — button is inside Row
proton.Row(ctx,
    func(ctx proton.Context) {
        if proton.Button(ctx, &u.btn, "Save") {
            save()
        }
    },
)
```

Si vous placez un bouton tout en haut de la fonction de dessin sans aucun
wrapper, il dessinera mais ne répondra pas aux clics. `Pad(ctx, 0, ...)` est le
wrapper minimum si vous ne souhaitez aucun remplissage visuel.

---

## Theming

```go
a := proton.New("myapp")
a.ApplyPalette(proton.NordPalette)
a.Window("App", 800, 600, draw)
a.Run()
```

46 palettes sont intégrées. Voir [07-theming.md](./07-theming.md) pour toutes
et pour construire le vôtre avec des codes de couleur hexadécimaux.

---

## Plusieurs fenêtres

```go
a := proton.New("app")
a.Window("Main", 800, 600, drawMain)
a.Window("Settings", 400, 300, drawSettings)
a.Run() // opens both
```

Toutes les fenêtres partagent la même « *Application ». Le processus reste actif jusqu'à ce que toutes les fenêtres
sont fermés.

---

## Next Steps

- **[01-text.md](./01-text.md)** — text widgets
- **[02-buttons.md](./02-buttons.md)** — buttons and clickable areas
- **[03-inputs.md](./03-inputs.md)** — text fields, toggles, sliders
- **[04-layout.md](./04-layout.md)** — arranging things on screen
- **[09-examples.md](./09-examples.md)** — complete working programs to copy
