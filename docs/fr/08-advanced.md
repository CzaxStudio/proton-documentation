# Avancé

Raccourcis clavier, goroutines asynchrones, notifications toast, modaux, onglets,
accordéon, menus contextuels et tout ce qui ne rentre pas parfaitement dans
les pages précédentes.

---

## Notifications Toast

Un message chronométré qui apparaît, reste quelques secondes et disparaît sur son
propre. Pas de dialogue, pas de blocage de l'utilisateur.

```go
type UI struct {
    toast proton.ToastState
}

// trigger from anywhere — goroutine-safe
u.toast.Show("File saved!", 2*time.Second)

// draw it LAST in your draw function so it renders on top of everything
proton.Toast(ctx, &u.toast)
```

S'il n'y a pas de toast actif, « Toast » ne dessine rien. Pas besoin de vérifier au préalable.

```go
func (t *ToastState) Show(msg string, duration time.Duration)
proton.Toast(ctx proton.Context, state *proton.ToastState)
```

---

## Superposition / Modal

Une toile de fond grisée avec un contenu centré au-dessus de tout.

```go
type UI struct {
    modal    proton.OverlayState
    openBtn  proton.Clickable
    closeBtn proton.Clickable
}

// open it
proton.Pad(ctx, 4, func(ctx proton.Context) {
    if proton.Button(ctx, &u.openBtn, "Open dialog") {
        u.modal.Show()
    }
})

// draw it — also at the end of your draw function
proton.Overlay(ctx, &u.modal, func(ctx proton.Context) {
    proton.MinSize(ctx, 300, 0, func(ctx proton.Context) {
        proton.Card(ctx, proton.RGB(0x2e3440), 12, 24, func(ctx proton.Context) {
            proton.H5(ctx, "Are you sure?")
            proton.Gap(ctx, 8)
            proton.Label(ctx, "This cannot be undone.")
            proton.Gap(ctx, 20)
            proton.RowEnd(ctx,
                func(ctx proton.Context) {
                    proton.Pad(ctx, 4, func(ctx proton.Context) {
                        if proton.OutlineButton(ctx, &u.closeBtn, "Cancel") {
                            u.modal.Hide()
                        }
                    })
                },
                func(ctx proton.Context) { proton.Gap(ctx, 8) },
                func(ctx proton.Context) {
                    proton.Pad(ctx, 4, func(ctx proton.Context) {
                        if proton.Button(ctx, &u.openBtn, "Confirm") {
                            u.modal.Hide()
                            doThing()
                        }
                    })
                },
            )
        })
    })
})
```

```go
func (o *OverlayState) Show()
func (o *OverlayState) Hide()
func (o *OverlayState) Toggle()

proton.Overlay(ctx proton.Context, state *proton.OverlayState, content func(proton.Context))
```

`Overlay` ne dessine rien lorsque `state.Visible` est faux, vous pouvez donc l'appeler
chaque image sans aucune condition d'emballage.

---

## Raccourcis clavier

Enregistrez une fonction à déclencher lorsqu'une combinaison de touches est enfoncée.

```go
proton.OnKey(ctx, proton.ModCtrl, "S", func() { save() })
proton.OnKey(ctx, proton.ModCtrl, "Z", func() { undo() })
proton.OnKey(ctx, proton.ModCtrl|proton.ModShift, "N", func() { newFile() })
proton.OnKey(ctx, proton.ModNone, proton.KeyEscape, func() { closeDialog() })
```

Appelez « OnKey » dans votre fonction de dessin. Il enregistre le raccourci pour cela
cadre. Puisque la fonction de dessin exécute chaque image, les raccourcis restent actifs
tant que la fenêtre est ouverte.

```go
proton.OnKey(ctx proton.Context, modifiers proton.Modifier, keyName string, fn func())
```

**Constantes du modificateur :**

```go
proton.ModNone   // no modifier — just the key
proton.ModCtrl   // Ctrl (Cmd on macOS)
proton.ModShift
proton.ModAlt

// combine with |
proton.ModCtrl | proton.ModShift
```

**Constantes du nom de clé** (pour les clés autres que des lettres) :

```go
proton.KeyEscape
proton.KeyReturn
proton.KeyBackspace
proton.KeyDelete
proton.KeyTab
proton.KeySpace
proton.KeyUp
proton.KeyDown
proton.KeyLeft
proton.KeyRight
```

Les clés alphabétiques ne sont que des chaînes : `"S"`, `"Z"`, `"N"`, `"A"`.

---

## Onglets

Une barre d'onglets horizontale avec une zone de contenu qui change en fonction du
onglet sélectionné.

```go
type UI struct {
    tabs    proton.TabState
    tabBtns [3]proton.Clickable
}

proton.Tabs(ctx,
    []string{"Files", "Settings", "About"},
    u.tabBtns[:],
    &u.tabs,
    func(ctx proton.Context, i int) {
        switch i {
        case 0: drawFiles(ctx)
        case 1: drawSettings(ctx)
        case 2: drawAbout(ctx)
        }
    },
)
```

`u.tabs.Selected` contient l'index de l'onglet actif. Vous pouvez le définir par programme
pour changer d'onglet à partir du code.

```go
proton.Tabs(ctx proton.Context, labels []string, btns []proton.Clickable, state *proton.TabState, content func(proton.Context, int))
```

La tranche `btns` a besoin d'un `Clickable` par onglet. Passer `u.tabBtns[:]` est
la manière idiomatique lorsque vous déclarez un tableau de taille fixe dans votre structure.

---

## Accordéon

Une section pliable avec un en-tête cliquable.

```go
type UI struct {
    sec1    proton.AccordionState
    sec1btn proton.Clickable
}

proton.Accordion(ctx, &u.sec1, &u.sec1btn, "Advanced Options", func(ctx proton.Context) {
    proton.Label(ctx, "These options are hidden until the user expands this.")
    proton.Gap(ctx, 8)
    proton.Toggle(ctx, &u.expertMode, "Expert mode")
})
```

```go
proton.Accordion(ctx proton.Context, state *proton.AccordionState, btn *proton.Clickable, title string, content func(proton.Context))
```

`state.Open` suit s'il est développé. Vous pouvez le configurer directement pour démarrer
un accordéon ouvert : `u.sec1.Open = true`.

---

## Menu contextuel

Un menu contextuel qui apparaît à la position du curseur.

```go
type UI struct {
    menu    proton.ContextMenuState
    menuTag proton.FrameTag
}

items := []proton.ContextMenuItem{
    {Label: "Copy"},
    {Label: "Paste"},
    {Label: "Delete"},
    {Label: "Disabled option", Disabled: true},
}

chosen := proton.ContextMenu(ctx, &u.menu, &u.menuTag, items, func(ctx proton.Context) {
    proton.Label(ctx, "Right-click anywhere in this area")
})

if chosen >= 0 {
    fmt.Println("User picked:", items[chosen].Label)
}
```

```go
proton.ContextMenu(ctx proton.Context, state *proton.ContextMenuState, tag *proton.FrameTag, items []proton.ContextMenuItem, content func(proton.Context)) int
```

Renvoie -1 lorsque rien n'a été sélectionné et l'index de l'élément sur le cadre
quelque chose clique. Le menu se ferme automatiquement après une sélection.

---

## Mises à jour asynchrones et Goroutines

Votre fonction draw s’exécute sur le thread principal. Quand une goroutine termine son travail
et change d'état, appelez `ctx.Invalidate()` pour demander un redessin.

```go
type UI struct {
    loading bool
    result  string
    fetchBtn proton.Clickable
}

// in your draw function
proton.Pad(ctx, 4, func(ctx proton.Context) {
    if proton.Button(ctx, &u.fetchBtn, "Fetch") && !u.loading {
        u.loading = true
        go func() {
            data := fetchFromAPI()        // takes a while
            u.result = data
            u.loading = false
            ctx.Invalidate()              // wake up the render loop
        }()
    }
})

if u.loading {
    proton.Row(ctx,
        func(ctx proton.Context) { proton.Spinner(ctx, &u.spin, 18) },
        func(ctx proton.Context) { proton.Gap(ctx, 8) },
        func(ctx proton.Context) { proton.Muted(ctx, "Loading...") },
    )
} else if u.result != "" {
    proton.Label(ctx, u.result)
}
```

Sans `ctx.Invalidate()`, la fenêtre ne sera pas redessinée jusqu'à ce que l'utilisateur bouge
la souris ou interagit avec elle. Appelez-le toujours après avoir changé d'état de
une goroutine.

---

## Tourneur

Un indicateur de chargement animé. L'appel de `Spinner` conserve automatiquement le
redessinage de la fenêtre — aucune boucle `Invalidate()` nécessaire.

```go
type UI struct {
    spin proton.SpinnerState
}

proton.Spinner(ctx, &u.spin, 32)  // 32dp diameter
```

```go
proton.Spinner(ctx proton.Context, state *proton.SpinnerState, sizeDp float32)
```

`SpinnerState` suit l'heure de début de l'animation. Déclarez-en un par spinner
dans votre structure d'état.

---

## SelectBox (liste déroulante)

```go
type UI struct {
    langSel proton.SelectBoxState
}

langs := []string{"Go", "Rust", "Zig", "C", "Python"}
i := proton.SelectBox(ctx, &u.langSel, langs)
proton.Caption(ctx, "Selected: "+langs[i])
```

La liste déroulante s'ouvre sous le bouton et se ferme lors d'une sélection ou d'un clic extérieur.

```go
proton.SelectBox(ctx proton.Context, state *proton.SelectBoxState, options []string) int
```

---

## If — Rendu conditionnel

Rend le contenu uniquement lorsqu'une condition est vraie. Enregistre un bloc `if` lorsque vous
je veux juste afficher ou masquer un seul widget.

```go
proton.If(ctx, user.IsAdmin, func(ctx proton.Context) {
    proton.Pad(ctx, 4, func(ctx proton.Context) {
        if proton.Button(ctx, &u.deleteBtn, "Delete everything") {
            deleteEverything()
        }
    })
})
```

```go
proton.If(ctx proton.Context, cond bool, content func(proton.Context))
```

---

## FocusArea — Gestion des clés étendues

Lorsque vous avez besoin d'événements de clavier actifs uniquement dans une région spécifique de l'interface utilisateur,
pas globalement. Habituellement, « OnKey » suffit – utilisez-le lorsque vous en avez deux
panneaux qui doivent avoir des raccourcis clavier indépendants.

```go
type UI struct {
    editorTag proton.FrameTag
}

proton.FocusArea(ctx, &u.editorTag, "A", func(ctx proton.Context) {
    proton.TextArea(ctx, &u.text, "Type here...")
})
```

```go
proton.FocusArea(ctx proton.Context, tag *proton.FrameTag, keyName string, content func(proton.Context))
```

---

## Options de la fenêtre

```go
// fullscreen
a.WindowEx("App", 800, 600, []proton.WindowOption{
    proton.Fullscreen(),
}, draw)

// maximized
a.WindowEx("App", 800, 600, []proton.WindowOption{
    proton.Maximized(),
}, draw)
```

```go
proton.Fullscreen() proton.WindowOption
proton.Maximized()  proton.WindowOption
```

---

## Maintenir les animations en cours d'exécution

Proton ne se redessine que lorsqu'il y a une entrée de l'utilisateur ou que vous appelez `ctx.Invalidate()`.
Pour les animations : barres de progression qui se remplissent au fil du temps, comptes à rebours, n'importe quoi
basé sur le temps — appelez « Invalidate » à la fin de chaque image pour conserver les redessins
va:

```go
func draw(ctx proton.Context, u *UI) {
    if u.animating {
        u.progress += 0.01
        if u.progress >= 1.0 {
            u.progress = 0
            u.animating = false
        }
        proton.ProgressBar(ctx, u.progress)
        ctx.Invalidate()  // draw again next frame
    }
}
```

Lorsque `u.animating` devient faux, `Invalidate` cesse d'être appelé et Proton
revient au redessin uniquement sur la saisie de l'utilisateur. Le widget Spinner fait cela
automatiquement — vous n'avez pas besoin de le gérer vous-même.