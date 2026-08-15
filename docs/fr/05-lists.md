# Listes et défilement

Pour afficher des collections d'éléments et pour rendre les zones de contenu défilables.

---

## List — Vertical Scrollable List

La liste standard. Dessine uniquement les éléments actuellement visibles à l'écran, donc
10 000 articles, c'est bien.

```go
type UI struct {
    scroll proton.Scrollable
}

items := []string{"Apples", "Bananas", "Cherries", "Durian (why)"}

proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
    proton.Label(ctx, items[i])
})
```

Le rappel reçoit l'index `i`. Dessinez ce que vous voulez pour chaque ligne.

```go
proton.List(ctx proton.Context, state *proton.Scrollable, length int, draw func(proton.Context, int))
```

Déclarez un « proton.Scrollable » par liste. Il suit la position de défilement.
N'en partagez pas une entre deux listes : elles se disputeront la position de défilement et
les deux perdent.

---

## HList — Liste à défilement horizontal

Identique à List mais les éléments vont de gauche à droite.

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

## Scroll – Zone de contenu déroulante

For arbitrary content that might overflow, not indexed items. The content
function can call as many widgets as it wants.

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

Utilisez « Liste » lorsque vous avez indexé des données. Utilisez « Scroll » pour une page de contenu mixte.

---

## TextView — Read-Only Scrollable Text

Affiche un grand bloc de texte dans une vue défilante et monospace.
Idéal pour le contenu des fichiers, le texte d'aide, la prévisualisation du code.

```go
type UI struct {
    scroll proton.Scrollable
}

proton.TextView(ctx, &u.scroll, longText)
```

```go
proton.TextView(ctx proton.Context, state *proton.Scrollable, text string)
```

The text is split on newlines and each line is a virtual list item, so it
handles very long documents without issue.

---

## LogView — Sortie du journal à défilement automatique

Comme TextView mais défile automatiquement vers le bas chaque fois qu'un nouveau contenu est ajouté.
Code couleur automatiquement les préfixes de journaux courants.

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

Le codage couleur s'effectue automatiquement en fonction du préfixe de ligne :

| Préfixe | Couleur |
|---|---|
| `[OK]`, `TERMINÉ`, `SUCCÈS` | Vert |
| `[AVERTIR]`, `AVERTIR` | Jaune |
| `[ERREUR]`, `ERREUR` | Rouge |
| Autre chose | En sourdine |

---

## Making List Rows Look Good

Un simple « proton.Label » dans une ligne de liste fonctionne mais n'a pas fière allure. Ajoutez-en
rembourrage et structure.

### Lignes rembourrées

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

### Deux colonnes de texte

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

### Lignes cliquables avec surbrillance au survol

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

### Liste à l'intérieur d'une carte

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

## Performance

`List` and `HList` use virtual rendering — only visible items get their
draw function called. A slice of 50,000 items scrolls at 60fps without
breaking a sweat.

`Scroll` restitue tout dans la fonction de contenu à chaque image. Utilisez-le pour
des pages avec un nombre raisonnable de widgets, pas pour d'énormes ensembles de données dynamiques.