# Widgets visuels

Formes, cartes, images, badges, anneaux de progression, tableaux, avatars — les choses
qui donnent à votre application l'impression qu'elle a été conçue exprès.

---

## Diviseur

Une fine règle horizontale. Utilisez-le entre les sections.

```go
proton.H5(ctx, "Section One")
proton.Gap(ctx, 8)
proton.Label(ctx, "Some content.")
proton.Gap(ctx, 12)
proton.Divider(ctx)
proton.Gap(ctx, 12)
proton.H5(ctx, "Section Two")
```

```go
proton.Divider(ctx proton.Context)
```

### Diviseur étiqueté

Identique à Divider mais avec une étiquette de texte centrée.

```go
proton.LabeledDivider(ctx, "Advanced Settings")
proton.LabeledDivider(ctx, "")   // plain divider — same as Divider
```

```go
proton.LabeledDivider(ctx proton.Context, label string)
```

---

## Rectifier

Un rectangle de couleur unie. Passez 0 pour la largeur ou la hauteur pour remplir le
espace disponible sur cet axe.

```go
// 100dp wide, 4dp tall accent bar
proton.Rect(ctx, proton.RGB(0x89b4fa), 100, 4)

// full width, 2dp tall separator
proton.Rect(ctx, proton.RGB(0x333344), 0, 2)

// fill all available space
proton.Rect(ctx, proton.RGB(0x1a1a2e), 0, 0)
```

```go
proton.Rect(ctx proton.Context, c color.NRGBA, widthDp, heightDp float32)
```

### RondRect

Identique à Rect mais avec des coins arrondis.

```go
proton.RoundRect(ctx, proton.RGB(0x2a2a3e), 200, 60, 12)  // 12dp corner radius
proton.RoundRect(ctx, proton.RGB(0x4c566a), 0, 40, 20)    // full width, pill shape
```

```go
proton.RoundRect(ctx proton.Context, c color.NRGBA, widthDp, heightDp, radiusDp float32)
```

---

## Carte

Contenu à l’intérieur d’un fond rectangulaire rembourré avec une ombre subtile.
Le conteneur incontournable pour regrouper le contenu associé.

```go
proton.Card(ctx, proton.RGB(0x2a2a3e), 12, 16, func(ctx proton.Context) {
    proton.H6(ctx, "Card Title")
    proton.Gap(ctx, 4)
    proton.Label(ctx, "Card content goes here.")
    proton.Gap(ctx, 12)
    proton.Pad(ctx, 4, func(ctx proton.Context) {
        if proton.Button(ctx, &u.btn, "Action") { doThing() }
    })
})
```

```go
proton.Card(ctx proton.Context, bg color.NRGBA, cornerDp, padDp float32, content func(proton.Context))
```

- `bg` — couleur d'arrière-plan
- `cornerDp` — rayon de coin (8 à 12 semble bon pour la plupart des cartes)
- `padDp` — remplissage entre le bord de la carte et le contenu

### HoverCard

Une carte qui change la couleur d’arrière-plan au survol. Renvoie vrai si vous cliquez dessus.

```go
if proton.HoverCard(ctx, &u.cardBtn,
    proton.RGB(0x2e3440),  // normal background
    proton.RGB(0x3b4252),  // hover background
    8,                     // corner radius dp
    func(ctx proton.Context) {
        proton.PadV(ctx, 10, func(ctx proton.Context) {
            proton.PadH(ctx, 12, func(ctx proton.Context) {
                proton.Label(ctx, "Click this card")
            })
        })
    },
) {
    println("card clicked")
}
```

```go
proton.HoverCard(ctx proton.Context, state *proton.Clickable, bg, hover color.NRGBA, cornerDp float32, content func(proton.Context)) bool
```

---

## Insigne

Un petit éclat arrondi avec texte. Pour les étiquettes d'état, les balises, les décomptes, tout
cela a besoin d'une pilule colorée.

```go
proton.Badge(ctx, proton.RGB(0x5e81ac), proton.RGB(0xeceff4), "stable")
proton.Badge(ctx, proton.RGB(0xa3be8c), proton.RGB(0x2e3440), "passing")
proton.Badge(ctx, proton.RGB(0xbf616a), proton.RGB(0xeceff4), "failing")
```

```go
proton.Badge(ctx proton.Context, bg, fg color.NRGBA, text string)
```

Badges d'affilée :

```go
proton.Row(ctx,
    func(ctx proton.Context) { proton.Badge(ctx, proton.RGB(0x5e81ac), proton.RGB(0xeceff4), "Go") },
    func(ctx proton.Context) { proton.Gap(ctx, 5) },
    func(ctx proton.Context) { proton.Badge(ctx, proton.RGB(0xa3be8c), proton.RGB(0x2e3440), "v1.0") },
    func(ctx proton.Context) { proton.Gap(ctx, 5) },
    func(ctx proton.Context) { proton.Badge(ctx, proton.RGB(0xebcb8b), proton.RGB(0x2e3440), "MIT") },
)
```

---

## Point d'état

Un petit cercle coloré. Indicateurs en ligne/hors ligne, statut de build, tout
qui a besoin d'un point coloré à côté d'un texte.

```go
proton.Row(ctx,
    func(ctx proton.Context) { proton.StatusDot(ctx, proton.RGB(0x4ade80), 9) },
    func(ctx proton.Context) { proton.Gap(ctx, 6) },
    func(ctx proton.Context) { proton.Caption(ctx, "Connected") },
)
```

```go
proton.StatusDot(ctx proton.Context, c color.NRGBA, sizeDp float32)
```

---

## Avatar

Un insigne circulaire portant des initiales. Pour les photos de profil utilisateur lorsqu'il n'y a pas d'image
est disponible – ce qui est la plupart du temps.

```go
proton.Avatar(ctx, "AJ", proton.RGB(0x5e81ac), proton.RGB(0xeceff4), 40)
proton.Avatar(ctx, "BC", proton.RGB(0xa3be8c), proton.RGB(0x2e3440), 32)
```

```go
proton.Avatar(ctx proton.Context, initials string, bg, fg color.NRGBA, sizeDp float32)
```

---

## ProgressRing

Un indicateur de progrès circulaire. Idéal pour les cartes de statistiques et les tableaux de bord où
la forme circulaire communique le pourcentage plus visuellement qu'une barre.

```go
proton.ProgressRing(ctx, 0.72, 48, 5, proton.RGB(0x88c0d0))
//                       ^     ^   ^   ^
//                  progress  sz  strokeW  color
```

```go
proton.ProgressRing(ctx proton.Context, progress, sizeDp, strokeDp float32, c color.NRGBA)
```

Le « progrès » est compris entre 0,0 et 1,0. `sizeDp` est le diamètre. `StrokeDp` est l'anneau
épaisseur – 4 à 6 dp semble bon pour la plupart des tailles.

---

## Tableau

Un tableau de données avec une ligne d'en-tête et un ombrage de ligne alterné.

```go
proton.Table(ctx,
    []string{"Name", "Role", "Status"},
    []proton.TableRow{
        {"Alice", "Engineer", "Active"},
        {"Bob",   "Designer", "Away"},
        {"Carol", "PM",       "Active"},
    },
)
```

```go
proton.Table(ctx proton.Context, columns []string, rows []proton.TableRow)
```

`proton.TableRow` est juste `[]string`. Les colonnes sont également larges.

---

## Pas à pas

Un indicateur de progression par étapes horizontales pour les flux à plusieurs étapes.

```go
proton.Stepper(ctx, 1, []string{"Account", "Profile", "Payment", "Done"})
//                  ^
//              current step (0-based)
```

```go
proton.Stepper(ctx proton.Context, current int, steps []string)
```

L'étape 0 est la première étape. Les étapes terminées (index <actuel) obtiennent un remplissage
couleur d'accent. L'étape en cours est mise en surbrillance. Les prochaines étapes sont floues.

---

## Info-bulle

Une petite étiquette qui apparaît lorsque l'utilisateur survole quelque chose.

```go
type UI struct {
    saveHover proton.Clickable  // for tracking hover — separate from the button's Clickable
    saveBtn   proton.Clickable
}

proton.Tooltip(ctx, &u.saveHover, "Saves your work to disk (Ctrl+S)", func(ctx proton.Context) {
    proton.Pad(ctx, 4, func(ctx proton.Context) {
        if proton.Button(ctx, &u.saveBtn, "Save") {
            save()
        }
    })
})
```

```go
proton.Tooltip(ctx proton.Context, state *proton.Clickable, tip string, content func(proton.Context))
```

Les pistes cliquables « état » survolent la zone d'info-bulle. C'est séparé de
n’importe quel bouton à l’intérieur du contenu – déclarez-en un dédié pour chaque info-bulle.

---

## Images

Chargez une fois au démarrage. Dessinez chaque image.

```go
// load at startup — not in the draw function
img, err := proton.LoadImage("photo.png")
if err != nil {
    log.Fatal(err)
}

// in the draw function
proton.Image(ctx, img, 200, 150)  // 200dp wide, 150dp tall
proton.Image(ctx, img, 0, 0)      // natural pixel size
```

```go
proton.LoadImage(path string) (proton.ImageOp, error)
proton.Image(ctx proton.Context, img proton.ImageOp, widthDp, heightDp float32)
```

PNG et JPEG sont tous deux pris en charge.

---

##Logo

Le logo de votre application, chargé une seule fois et dessiné n'importe où. Voir [07-theming.md](./07-theming.md)
pour la configuration complète. La version courte :

```go
//go:embed logo.png
var logoBytes []byte

// at startup
a.SetLogoBytes(logoBytes)

// in the draw function
proton.Logo(ctx, 48, 48)
```

```go
proton.Logo(ctx proton.Context, widthDp, heightDp float32)
proton.HasLogo(ctx proton.Context) bool
```

---

## CodeBlock

Texte à espacement fixe dans une zone à bordure arrondie. Pour afficher les commandes, les chemins de fichiers,
extraits - tout ce que l'utilisateur est susceptible de copier.

```go
proton.CodeBlock(ctx, "go get github.com/CzaxStudio/proton")
proton.CodeBlock(ctx, `a.Window("App", 480, 300, draw)
a.Run()`)
```

```go
proton.CodeBlock(ctx proton.Context, code string)
```

---

## Indice de raccourci

Un petit badge clavier. Afficher-les à côté des éléments de menu ou des étiquettes de boutons
pour communiquer les raccourcis clavier.

```go
proton.Row(ctx,
    func(ctx proton.Context) { proton.Label(ctx, "Save") },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) { proton.ShortcutHint(ctx, "Ctrl+S") },
)
```

```go
proton.ShortcutHint(ctx proton.Context, keys string)
```

---

## Échantillon de couleurs

Une rangée de cercles colorés sur lesquels l'utilisateur peut cliquer pour sélectionner une couleur. Retours
l'index de celui sélectionné, ou -1 si aucun n'est encore sélectionné.

```go
type UI struct {
    swatches     [6]proton.Clickable
    chosenColor  int
}

palette := []color.NRGBA{
    proton.RGB(0xf87171),
    proton.RGB(0xfbbf24),
    proton.RGB(0x4ade80),
    proton.RGB(0x60a5fa),
    proton.RGB(0xa78bfa),
    proton.RGB(0xf472b6),
}

i := proton.ColorSwatch(ctx, u.swatches[:], palette, u.chosenColor, 26)
if i >= 0 {
    u.chosenColor = i
}
```

```go
proton.ColorSwatch(ctx proton.Context, btns []proton.Clickable, colors []color.NRGBA, selected int, sizeDp float32) int
```

Le cercle sélectionné est entouré d'un anneau.