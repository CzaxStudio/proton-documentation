# Boutons

Les boutons permettent aux utilisateurs de demander à votre application de faire des choses. Proton a quatre sortes,
ainsi que des liens cliquables et un moyen de rendre littéralement tout exploitable.

---

## La seule règle

Chaque bouton a besoin de son propre champ « proton.Clickable » dans votre structure d'état.

```go
type UI struct {
    save   proton.Clickable
    cancel proton.Clickable
    delete proton.Clickable
}
```

N'en partagez pas un entre deux boutons. Si vous le faites, cliquer sur l'un ou l'autre déclenche
les deux – ce qui est un bug amusant à déboguer et une terrible UX.

De plus, les boutons doivent être à l'intérieur d'un wrapper de mise en page (`Pad`, `Row`, `Column`, etc.)
pour des clics pour vous inscrire. Voir [Mise en route](./00-getting-started.md) pour savoir pourquoi.

---

## Bouton

Action primaire, pleine et solide. Utilisez-le pour ce que vous voulez le plus
l'utilisateur à cliquer.

```go
var save proton.Clickable

proton.Pad(ctx, 8, func(ctx proton.Context) {
    if proton.Button(ctx, &save, "Save") {
        doSave()
    }
})
```

Renvoie « true » sur l'image sur laquelle on clique. Un clic, un « vrai ». Il
ne continue pas à tirer lorsqu'il est maintenu enfoncé.

```go
proton.Button(ctx proton.Context, state *proton.Clickable, label string) bool
```

---

## Bouton de contour

Style fantôme/contour. Même comportement que Button mais sans le remplissage
arrière-plan. Utilisez-le pour des actions secondaires – des choses que l'utilisateur pourrait souhaiter
faire, mais ce n'est pas l'action principale.

```go
var save   proton.Clickable
var cancel proton.Clickable

proton.Row(ctx,
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.OutlineButton(ctx, &cancel, "Cancel") {
                handleCancel()
            }
        })
    },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &save, "Save") {
                handleSave()
            }
        })
    },
)
```

La hiérarchie visuelle ici – aperçu pour Annuler, remplie pour Enregistrer – indique
utilisateurs quelle est l’action principale sans un seul mot d’explication.

```go
proton.OutlineButton(ctx proton.Context, state *proton.Clickable, label string) bool
```

---

## IcôneBouton

Un bouton contenant uniquement une icône. Pas de texte, juste une icône. Commun dans les barres d'outils.

```go
// icon is a *proton.Icon — load one with widget.NewIcon() from gioui.org/widget
var closeBtn proton.Clickable

if proton.IconButton(ctx, &closeBtn, closeIcon, "Close window") {
    win.Close()
}
```

Le quatrième argument est la description de l'accessibilité - quel lecteur d'écran
dirait. Ne le sautez pas.

```go
proton.IconButton(ctx proton.Context, state *proton.Clickable, icon *proton.Icon, desc string) bool
```

---

## Exploitable

Rend n'importe quel contenu cliquable. La zone entière que vous dessinez à l'intérieur du rappel
devient la cible touchée. Utilisez-le pour les cartes, les lignes de liste, les boutons personnalisés ou
tout ce où une étiquette de bouton standard n'est pas ce que vous voulez.

```go
var rowClick proton.Clickable

if proton.Tappable(ctx, &rowClick, func(ctx proton.Context) {
    proton.Card(ctx, proton.RGB(0x2a2a3e), 8, 12, func(ctx proton.Context) {
        proton.Label(ctx, "Click anywhere on this card")
        proton.Gap(ctx, 4)
        proton.Muted(ctx, "The whole thing is a button")
    })
}) {
    println("card clicked")
}
```

```go
proton.Tappable(ctx proton.Context, state *proton.Clickable, content func(proton.Context)) bool
```

---

## Lien et LinkSmall

Texte cliquable souligné ressemblant à un lien hypertexte. Gérez le clic vous-même –
Proton n'ouvre pas les URL pour vous, il vous indique simplement que l'utilisateur a cliqué.

```go
var githubLink proton.Clickable

if proton.Link(ctx, &githubLink, "View on GitHub") {
    openBrowser("https://github.com/CzaxStudio/proton")
}
```

`LinkSmall` est la même chose mais utilise un texte de la taille d'une légende :

```go
var termsLink proton.Clickable

if proton.LinkSmall(ctx, &termsLink, "Terms of service") {
    showTerms()
}
```

```go
proton.Link(ctx proton.Context, state *proton.Clickable, text string) bool
proton.LinkSmall(ctx proton.Context, state *proton.Clickable, text string) bool
```

---

## Modèles courants

### Confirmer / Annuler la ligne (aligné à droite)

```go
type UI struct {
    save   proton.Clickable
    cancel proton.Clickable
}

proton.RowEnd(ctx,
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.OutlineButton(ctx, &u.cancel, "Cancel") {
                handleCancel()
            }
        })
    },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.save, "Save changes") {
                handleSave()
            }
        })
    },
)
```

`RowEnd` pousse tout vers le bord droit — placement standard pour
confirmer/annuler les paires.

### Barre d'outils

```go
type UI struct {
    newFile  proton.Clickable
    openFile proton.Clickable
    saveFile proton.Clickable
}

proton.Row(ctx,
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.newFile, "New") { handleNew() }
        })
    },
    func(ctx proton.Context) { proton.Gap(ctx, 4) },
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.OutlineButton(ctx, &u.openFile, "Open") { handleOpen() }
        })
    },
    func(ctx proton.Context) { proton.Gap(ctx, 4) },
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.OutlineButton(ctx, &u.saveFile, "Save") { handleSave() }
        })
    },
)
```

### Lignes de liste cliquables

```go
type UI struct {
    rows   [100]proton.Clickable
    chosen int
}

items := []string{"Alpha", "Beta", "Gamma", "Delta"}

proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
    if proton.Tappable(ctx, &u.rows[i], func(ctx proton.Context) {
        proton.PadV(ctx, 10, func(ctx proton.Context) {
            proton.PadH(ctx, 12, func(ctx proton.Context) {
                proton.Label(ctx, items[i])
            })
        })
    }) {
        u.chosen = i
    }
    proton.Divider(ctx)
})
```