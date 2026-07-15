# Documents sur les protons

Copyright © [CzaxStudio](https://github.com/CzaxStudio/) (Nexus-Proton)

Tout ce dont vous avez besoin pour créer des applications de bureau avec Proton. 
Choisissez un sujet ou lisez-les dans l’ordre : les deux fonctionnent bien.

---

| Fichier | Qu'est-ce qu'il y a dedans |
|---|---|
| [00-getting-started.md](./00-getting-started.md) | installer, première fenêtre, le modèle de structure d'état |
| [01-texte.md](./01-texte.md) | Étiquette, H1–H6, Corps2, Légende, Texte personnalisé |
| [02-boutons.md](./02-boutons.md) | Bouton, OutlineButton, IconButton, Tapable |
| [03-entrées.md](./03-entrées.md) | Entrée, TextArea, Case à cocher, Toggle, RadioButton, Slider, ProgressBar |
| [04-layout.md](./04-layout.md) | Rangée, Colonne, Fractionné, Pad, Espace, Grille, GrowRow, Centre |
| [05-listes.md](./05-lists.md) | Liste, HListe, Défilement |
| [06-visuals.md](./06-visuals.md) | Diviseur, Rect, RoundRect, Carte, Badge, Image, MinSize, MaxWidth |
| [07-theming.md](./07-theming.md) | palettes, couleurs personnalisées, échelle de police |
| [08-advanced.md](./08-advanced.md) | Toast, OnKey, goroutines, info-bulle, plusieurs fenêtres |
| [09-exemples.md](./09-exemples.md) | exemples complets de copier-coller |

---

## La seule chose à savoir

Proton est en mode immédiat. Votre fonction de dessin exécute chaque image. Tu appelles
fonctions du widget, elles apparaissent à l’écran dans cet ordre. L'État vit dans
votre propre structure. C'est ça.

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

Les widgets s'empilent verticalement. L'état vit dans votre structure. C'est tout le modèle.

**[Proton-Repo](https://github.com/CzaxStudio/Proton)**