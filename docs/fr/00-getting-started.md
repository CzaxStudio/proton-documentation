# Commencer

Vous souhaitez créer une application de bureau dans Go. Vous êtes au bon endroit

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

L'étape « go mod spice » est importante : elle extrait les dépendances transitives de Gio.
et les écrit dans `go.sum`. Sautez-le et vous verrez des gribouillis rouges partout.

---

## Votre première fenêtre

```go
package main

import "github.com/CzaxStudio/proton"

fonction main() {
    a := proton.New("bonjour")
    a.Window("Bonjour", 480, 320, func(ctx proton.Context) {
        proton.H3(ctx, "Bonjour de Proton !") // ⓘ Vous pouvez changer proton.H3 à la taille de votre choix
    })
    a.Exécuter()
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

tapez la structure de l'interface utilisateur {
    nom proton.Editor
    btn proton.Cliquable
}

fonction main() {
    u := &UI{}

a := proton.New("greeter")
    a.Window("Greeter", 400, 240, func(ctx proton.Context) {
        proton.Input(ctx, &u.name, "Votre nom")
        proton.Gap (ctx, 8)
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.btn, "Dites bonjour") {
                fmt.Println("Bonjour,", u.name.Text())
            }
        })
    })
    a.Exécuter()
}
```

La fonction draw exécute chaque image. `Button` renvoie `true` sur le cadre
est cliqué. Le bloc `if` s'exécute, imprime le nom, et c'est tout.

---

## Les types d'état

Déclarez-les dans la structure de votre interface utilisateur. Ils sont tous prêts à valeur nulle – pas de constructeurs.

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

Un champ par widget. Ne partagez pas un « cliquable » entre deux boutons : ils le feront
les deux se déclenchent sur le même clic, ce qui n'est presque jamais ce que vous souhaitez.

---

## Comment fonctionne la mise en page

Sans aucun wrapper de mise en page, les widgets s'empilent verticalement de haut en bas. « Écart »
ajoute de l'espace entre eux.

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
clics pour vous inscrire correctement. C'est une affaire de Gio - la passe de mise en page est ce que
établit les zones touchées à l'écran.

```go
// correct — button is inside Pad
proton.Pad(ctx, 8, func(ctx proton.Context) {
    if proton.Button(ctx, &u.btn, "Save") {
        save()
    }
})

// également correct — le bouton est à l'intérieur de la ligne
proton.Row(ctx,
    func(ctx proton.Context) {
        if proton.Button(ctx, &u.btn, "Enregistrer") {
            sauvegarder()
        }
    },
)
```

Si vous placez un bouton tout en haut de la fonction de dessin sans aucun
wrapper, il dessinera mais ne répondra pas aux clics. `Pad(ctx, 0, ...)` est le
wrapper minimum si vous ne souhaitez aucun remplissage visuel.

---

## Thème

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

## Prochaines étapes

- **[01-text.md](./01-text.md)** — widgets de texte
- **[02-buttons.md](./02-buttons.md)** — boutons et zones cliquables
- **[03-inputs.md](./03-inputs.md)** — champs de texte, bascules, curseurs
- **[04-layout.md](./04-layout.md)** — organiser les choses à l'écran
- **[09-examples.md](./09-examples.md)** — programmes de travail complets à copier