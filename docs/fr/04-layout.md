# Mise en page

Les widgets s'empilent verticalement par défaut. Tout le reste est opt-in.

---

## Gap – Mettez de l'espace entre les choses

La fonction de mise en page la plus utilisée. Insère un espace vertical vide.

```go
proton.H4(ctx, "Section Title")
proton.Gap(ctx, 8)
proton.Label(ctx, "Section content.")
proton.Gap(ctx, 24)
proton.H4(ctx, "Next Section")
```

```go
proton.Gap(ctx proton.Context, dp float32)
```

8dp est un petit écart. 16dp est moyen. 24dp est grand. Ces trois couvrent la plupart des cas.

---

## Rangée — Côte à côte

Place les enfants horizontalement, de gauche à droite.

```go
proton.Row(ctx,
    func(ctx proton.Context) { proton.Label(ctx, "Name:") },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) { proton.Label(ctx, "Alice") },
)
```

Chaque enfant est un « func(proton.Context) ». Appelez les widgets que vous voulez à l'intérieur.

```go
proton.Row(ctx proton.Context, widgets ...func(proton.Context))
```

---

Colonne ## — Groupe vertical explicite

Empile les enfants verticalement en tant que groupe nommé. Rarement nécessaire au plus haut niveau
(les widgets s'empilent automatiquement), mais utile à l'intérieur de `Row` ou `Split` lorsque le
le côté droit doit être composé de plusieurs éléments empilés.

```go
proton.Row(ctx,
    func(ctx proton.Context) {
        proton.Label(ctx, "Left side")
    },
    func(ctx proton.Context) { proton.Gap(ctx, 16) },
    func(ctx proton.Context) {
        proton.Column(ctx,
            func(ctx proton.Context) { proton.Label(ctx, "Right top") },
            func(ctx proton.Context) { proton.Gap(ctx, 4) },
            func(ctx proton.Context) { proton.Muted(ctx, "Right bottom") },
        )
    },
)
```

```go
proton.Column(ctx proton.Context, widgets ...func(proton.Context))
```

---

## RowSpread — Espace entre

Comme Row mais met un espace horizontal restant entre les enfants, en poussant
le premier vers le bord gauche et le dernier vers la droite.

```go
// title on the left, version on the right
proton.RowSpread(ctx,
    func(ctx proton.Context) { proton.H5(ctx, "My App") },
    func(ctx proton.Context) { proton.Caption(ctx, "v1.2.0") },
)
```

```go
proton.RowSpread(ctx proton.Context, widgets ...func(proton.Context))
```

---

## RowEnd — Tout à droite

Pousse tous les enfants vers le bord droit.

```go
proton.RowEnd(ctx,
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.OutlineButton(ctx, &u.cancel, "Cancel") { handleCancel() }
        })
    },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.save, "Save") { handleSave() }
        })
    },
)
```

```go
proton.RowEnd(ctx proton.Context, widgets ...func(proton.Context))
```

---

## GrowRow et GrowColumn — Dispositions extensibles

Lorsqu'un enfant doit remplir tout l'espace restant et que les autres restent leur
taille naturelle, utilisez `GrowRow` (horizontal) ou `GrowColumn` (vertical) avec
« GrowItem » et « FixedItem ».

```go
// search bar: label fixed, input stretches, button fixed
proton.GrowRow(ctx,
    proton.FixedItem(ctx, func(ctx proton.Context) {
        proton.Label(ctx, "Search:")
    }),
    proton.GrowItem(ctx, func(ctx proton.Context) {
        proton.Input(ctx, &u.search, "Type to search...")
    }),
    proton.FixedItem(ctx, func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.searchBtn, "Go") { doSearch() }
        })
    }),
)
```

`GrowItem` prend tout l'espace restant. `FixedItem` ne prend que ce dont il a besoin.
Plusieurs « GrowItem » répartissent l'espace restant de manière égale.

```go
proton.GrowRow(ctx proton.Context, children ...proton.FlexItem)
proton.GrowColumn(ctx proton.Context, children ...proton.FlexItem)
proton.GrowItem(ctx proton.Context, fn func(proton.Context)) proton.FlexItem
proton.FixedItem(ctx proton.Context, fn func(proton.Context)) proton.FlexItem
```

### FlexSpacer — Séparez les frères et sœurs

Un espace vide extensible. Mettez-le entre les `FixedItem` pour les pousser en face
bords sans utiliser `RowSpread`.

```go
proton.GrowRow(ctx,
    proton.FixedItem(ctx, func(ctx proton.Context) { proton.Caption(ctx, "left") }),
    proton.FlexSpacer(),
    proton.FixedItem(ctx, func(ctx proton.Context) { proton.Caption(ctx, "right") }),
)
```

```go
proton.FlexSpacer() proton.FlexItem
```

---

## Split — Volets côte à côte

Divise la largeur disponible entre deux sections. `leftFraction` est la proportion
le volet de gauche obtient, de 0,0 à 1,0.

```go
proton.Split(ctx, 0.35,
    func(ctx proton.Context) {
        // sidebar — gets 35% of the width
        proton.Label(ctx, "Sidebar")
    },
    func(ctx proton.Context) {
        // content — gets the remaining 65%
        proton.Label(ctx, "Content")
    },
)
```

```go
proton.Split(ctx proton.Context, leftFraction float32, left func(proton.Context), right func(proton.Context))
```

### HSplit — Haut et bas

Même idée mais verticale.

```go
proton.HSplit(ctx, 0.7,
    func(ctx proton.Context) { proton.Label(ctx, "Main content") },
    func(ctx proton.Context) { proton.Label(ctx, "Status bar") },
)
```

```go
proton.HSplit(ctx proton.Context, topFraction float32, top func(proton.Context), bottom func(proton.Context))
```

### ResizeSplit — L'utilisateur peut faire glisser le séparateur

Comme Split mais l'utilisateur peut faire glisser la poignée entre les deux volets pour
redimensionnez-les. Le `defaultFraction` est la position initiale.

```go
type UI struct {
    split proton.ResizeSplitState
}

proton.ResizeSplit(ctx, &u.split, 0.30, leftFn, rightFn)
```

`ResizeSplitState.Fraction` commence à 0 et est défini sur `defaultFraction`
sur la première image. Après cela, la position de déplacement de l'utilisateur est mémorisée.

```go
proton.ResizeSplit(ctx proton.Context, state *proton.ResizeSplitState, defaultFraction float32, left func(proton.Context), right func(proton.Context))
proton.ResizeHSplit(ctx proton.Context, state *proton.ResizeSplitState, defaultFraction float32, top func(proton.Context), bottom func(proton.Context))
```

---

## Centre

Place le contenu au centre de l'espace disponible. Idéal pour les états vides
et écrans de chargement.

```go
proton.Center(ctx, func(ctx proton.Context) {
    proton.Muted(ctx, "Nothing here yet.")
})
```

```go
proton.Center(ctx proton.Context, fn func(proton.Context))
```

---

## Rembourrage

### Pad — Les quatre côtés

```go
proton.Pad(ctx, 16, func(ctx proton.Context) {
    proton.Label(ctx, "16dp of breathing room on all sides")
})
```

### PadH — Gauche et droite uniquement

```go
proton.PadH(ctx, 24, func(ctx proton.Context) {
    proton.Label(ctx, "horizontal padding only")
})
```

### PadV — Haut et bas uniquement

```go
proton.PadV(ctx, 12, func(ctx proton.Context) {
    proton.Label(ctx, "vertical padding only")
})
```

### PadSides — Chaque bord individuellement

Les arguments sont en haut, à droite, en bas, à gauche – dans le même ordre que la marge/remplissage CSS.

```go
proton.PadSides(ctx, 8, 16, 8, 16, func(ctx proton.Context) {
    proton.Label(ctx, "8dp top/bottom, 16dp left/right")
})
```

```go
proton.Pad(ctx proton.Context, dp float32, fn func(proton.Context))
proton.PadH(ctx proton.Context, dp float32, fn func(proton.Context))
proton.PadV(ctx proton.Context, dp float32, fn func(proton.Context))
proton.PadSides(ctx proton.Context, top, right, bottom, left float32, fn func(proton.Context))
```

---

## Grid — Grille à colonnes fixes

Dispose les enfants dans une grille avec un nombre fixe de colonnes. Chaque cellule
obtient une part égale de la largeur disponible.

```go
proton.Grid(ctx, 3, 8,   // 3 columns, 8dp gap
    func(ctx proton.Context) { proton.Label(ctx, "one") },
    func(ctx proton.Context) { proton.Label(ctx, "two") },
    func(ctx proton.Context) { proton.Label(ctx, "three") },
    func(ctx proton.Context) { proton.Label(ctx, "four") },
    func(ctx proton.Context) { proton.Label(ctx, "five") },
)
```

Les cellules s'enroulent automatiquement sur de nouvelles lignes. Si la dernière ligne contient moins de
cellules `cols`, les emplacements restants sont vides.

```go
proton.Grid(ctx proton.Context, cols int, gapDp float32, cells ...func(proton.Context))
```

---

## ZStack — Dessinez des objets les uns sur les autres

Superpose plusieurs widgets à la même position. Le premier enfant est sur le
en bas ; le dernier est au dessus.

```go
proton.ZStack(ctx,
    func(ctx proton.Context) {
        // bottom layer — a background shape
        proton.RoundRect(ctx, proton.RGB(0x1e1e2e), 0, 100, 12)
    },
    func(ctx proton.Context) {
        // top layer — text floating over the shape
        proton.Center(ctx, func(ctx proton.Context) {
            proton.Label(ctx, "Text on top")
        })
    },
)
```

```go
proton.ZStack(ctx proton.Context, layers ...func(proton.Context))
```

---

## MinSize et MaxWidth — Contraintes de taille

```go
// at least 200dp wide and 48dp tall
proton.MinSize(ctx, 200, 48, func(ctx proton.Context) {
    if proton.Button(ctx, &u.btn, "OK") { handleOK() }
})

// no wider than 420dp — keeps forms readable on wide windows
proton.MaxWidth(ctx, 420, func(ctx proton.Context) {
    proton.Input(ctx, &u.email, "Email address")
    proton.Gap(ctx, 8)
    proton.Input(ctx, &u.password, "Password")
})
```

```go
proton.MinSize(ctx proton.Context, widthDp, heightDp float32, fn func(proton.Context))
proton.MaxWidth(ctx proton.Context, widthDp float32, fn func(proton.Context))
```

Passez 0 pour l'une ou l'autre dimension de « MinSize » pour laisser cet axe sans contrainte.

---

## Une application typique à deux colonnes

```go
func draw(ctx proton.Context, u *UI) {
    // header
    proton.PadSides(ctx, 0, 0, 12, 0, func(ctx proton.Context) {
        proton.RowSpread(ctx,
            func(ctx proton.Context) { proton.H5(ctx, "My App") },
            func(ctx proton.Context) { proton.Caption(ctx, "v1.0") },
        )
    })
    proton.Divider(ctx)
    proton.Gap(ctx, 16)

    // body
    proton.ResizeSplit(ctx, &u.split, 0.28,
        func(ctx proton.Context) {
            drawSidebar(ctx, u)
        },
        func(ctx proton.Context) {
            proton.PadH(ctx, 16, func(ctx proton.Context) {
                drawContent(ctx, u)
            })
        },
    )
}
```