# Exemples

Programmes complets que vous pouvez copier, coller et exécuter. Chacune de ces compilations
et fonctionne tel quel.

---

## Bonjour le monde

Le minimum absolu. Ouvrez une fenêtre, affichez du texte.

```go
package main

import "github.com/CzaxStudio/proton"

fonction main() {
    a := proton.New("bonjour")
    a.Window("Bonjour", 400, 200, func(ctx proton.Context) {
        proton.H3(ctx, "Bonjour de Proton !")
    })
    a.Exécuter()
}
```

---

## Comptoir

Un nombre qui monte et descend lorsque vous cliquez sur des boutons. Démontre
le modèle fondamental : état dans une structure, boutons à l'intérieur des wrappers de mise en page.

```go
package main

import (
    "fmt"
    "github.com/CzaxStudio/proton"
)

tapez la structure de l'interface utilisateur {
    compte entier
    inc proton.Cliquable
    déc proton.Cliquable
    réinitialiser le proton.Cliquable
}

fonction main() {
    u := &UI{}
    a := proton.New("compteur")
    a.ApplyPalette(proton.NordPalette)
    a.Window("Compteur", 320, 240, func(ctx proton.Context) {
        proton.Center(ctx, func(ctx proton.Context) {
            proton.H1(ctx, fmt.Sprintf("%d", u.count))
            proton.Gap (ctx, 20)
            proton.Row(ctx,
                func(ctx proton.Context) {
                    proton.Pad(ctx, 4, func(ctx proton.Context) {
                        si proton.OutlineButton(ctx, &u.dec, "−") {
                            u.count--
                        }
                    })
                },
                func(ctx proton.Context) { proton.Gap(ctx, 8) },
                func(ctx proton.Context) {
                    proton.Pad(ctx, 4, func(ctx proton.Context) {
                        si proton.Button(ctx, &u.inc, "+") {
                            u.count++
                        }
                    })
                },
                func(ctx proton.Context) { proton.Gap(ctx, 8) },
                func(ctx proton.Context) {
                    proton.Pad(ctx, 4, func(ctx proton.Context) {
                        if proton.OutlineButton(ctx, &u.reset, "Reset") {
                            u.count = 0
                        }
                    })
                },
            )
        })
    })
    a.Exécuter()
}
```

---

## Liste de tâches

La démo que chaque framework d'interface utilisateur doit avoir par la loi.

```go
package main

import "github.com/CzaxStudio/proton"

tapez la structure de l'élément {
    chaîne de texte
    fait proton.Bool
}

tapez la structure de l'interface utilisateur {
    proton d'entrée.Editeur
    addBtn proton.Cliquable
    articles []article
    proton de défilement.Scrollable
}

fonction main() {
    u := &UI{}
    a := proton.New("todo")
    a.ApplyPalette(proton.CatppuccinPalette)
    a.Window("Todo", 420, 560, func(ctx proton.Context) {
        proton.H4(ctx, "Todo")
        proton.Gap (ctx, 12)

// ajoute une ligne
        proton.GrowRow(ctx,
            proton.GrowItem(ctx, func(ctx proton.Context) {
                proton.Input(ctx, &u.input, "Que faut-il faire ?")
            }),
            proton.FixedItem(ctx, func(ctx proton.Context) { proton.Gap(ctx, 8) }),
            proton.FixedItem(ctx, func(ctx proton.Context) {
                proton.Pad(ctx, 4, func(ctx proton.Context) {
                    if proton.Button(ctx, &u.addBtn, "Ajouter") {
                        si t := u.input.Text(); t != "" {
                            u.items = append(u.items, item{texte : t})
                            u.input.SetText("")
                        }
                    }
                })
            }),
        )

proton.Gap (ctx, 8)
        proton.Diviseur (ctx)
        proton.Gap (ctx, 8)

si len(u.items) == 0 {
            proton.Center(ctx, func(ctx proton.Context) {
                proton.Muted(ctx, "Rien ici. Ajoutez quelque chose ci-dessus.")
            })
            retour
        }

proton.List(ctx, &u.scroll, len(u.items), func(ctx proton.Context, i int) {
            proton.PadV(ctx, 6, func(ctx proton.Context) {
                proton.Checkbox(ctx, &u.items[i].done, u.items[i].text)
            })
        })
    })
    a.Exécuter()
}
```

---

## Formulaire de connexion

Un formulaire avec des champs email/mot de passe et une validation en ligne.

```go
package main

import (
    "strings"
    "github.com/CzaxStudio/proton"
)

tapez la structure de l'interface utilisateur {
    email proton.Editeur
    mot de passe proton.Editeur
    soumettre un proton.Cliquable
    chaîne errMsg
    succès booléen
}

fonction main() {
    u := &UI{}
    a := proton.New("connexion")
    a.ApplyPalette(proton.MidnightPalette)
    a.Window("Connexion", 400, 360, func(ctx proton.Context) {
        proton.Center(ctx, func(ctx proton.Context) {
            proton.MaxWidth(ctx, 300, func(ctx proton.Context) {
                proton.H4(ctx, "Connexion")
                proton.Gap (ctx, 24)

proton.Label(ctx, "Email")
                proton.Gap (ctx, 4)
                proton.Input(ctx, &u.email, "vous@exemple.com")
                proton.Gap (ctx, 12)

proton.Label(ctx, "Mot de passe")
                proton.Gap (ctx, 4)
                proton.Input(ctx, &u.password, "mot de passe")
                proton.Gap (ctx, 8)

proton.ErrorText(ctx, u.errMsg)
                si u.errMsg != "" {
                    proton.Gap (ctx, 6)
                }

si tu réussis {
                    proton.SuccessText(ctx, "Connecté avec succès !")
                    retour
                }

proton.Pad(ctx, 4, func(ctx proton.Context) {
                    if proton.Button(ctx, &u.submit, "Connexion") {
                        u.errMsg = valider(u.email.Text(), u.password.Text())
                        si u.errMsg == "" {
                            u.succès = vrai
                        }
                    }
                })
            })
        })
    })
    a.Exécuter()
}

func validate (e-mail, chaîne de mot de passe) chaîne {
    si !strings.Contains(email, "@") {
        return "Entrez une adresse e-mail valide."
    }
    si len(mot de passe) < 8 {
        return "Le mot de passe doit comporter au moins 8 caractères."
    }
    retourner ""
}
```

---

## Panneau de paramètres

Des bascules, des boutons radio, un curseur et un bouton Enregistrer. Le genre de panneau
qui vit dans chaque application.

```go
package main

import (
    "fmt"
    "github.com/CzaxStudio/proton"
)

tapez Paramètres struct {
    notifications proton.Bool
    proton DarkMode.Bool
    langage proton.Enum
    fontSize proton.Float
    saveBtn proton.Cliquable
    proton grillé.ToastState
}

import "time"

fonction main() {
    s := &Paramètres{}
    s.fontSize.Value = 0,5

a := proton.New("paramètres")
    a.ApplyPalette(proton.DraculaPalette)
    a.Window("Paramètres", 480, 520, func(ctx proton.Context) {
        proton.H4(ctx, "Paramètres")
        proton.Gap (ctx, 24)

proton.H6(ctx, "Apparence")
        proton.Gap (ctx, 10)
        proton.Toggle(ctx, &s.darkMode, "Mode sombre")
        proton.Gap (ctx, 8)
        proton.Label(ctx, fmt.Sprintf("Taille de police : %.0f%%", 80+s.fontSize.Value*40))
        proton.Gap (ctx, 4)
        proton.Slider(ctx, &s.fontSize)
        proton.Gap (ctx, 24)

proton.H6(ctx, "Notifications")
        proton.Gap (ctx, 10)
        proton.Checkbox(ctx, &s.notifications, "Notifications par e-mail")
        proton.Gap (ctx, 24)

proton.H6(ctx, "Langage")
        proton.Gap (ctx, 10)
        proton.RadioButton(ctx, &s.langue, "en", "anglais")
        proton.Gap (ctx, 6)
        proton.RadioButton(ctx, &s.langue, "es", "Español")
        proton.Gap (ctx, 6)
        proton.RadioButton(ctx, &s.langue, "fr", "Français")
        proton.Gap (ctx, 28)

proton.RowEnd(ctx,
            func(ctx proton.Context) {
                proton.Pad(ctx, 4, func(ctx proton.Context) {
                    if proton.Button(ctx, &s.saveBtn, "Enregistrer les paramètres") {
                        s.toast.Show("Paramètres enregistrés.", 2*time.Second)
                    }
                })
            },
        )

proton.Toast(ctx, &s.toast)
    })
    a.Exécuter()
}
```

---

## Application avec logo

Chargez un logo à partir d'un fichier intégré et affichez-le dans l'en-tête.

```go
package main

import (
    _ "embed"
    "fmt"
    "time"
    "github.com/CzaxStudio/proton"
)

//go:intégrer le logo.png
var logoOctets []octet

tapez la structure de l'interface utilisateur {
    compte entier
    btn proton.Cliquable
    proton grillé.ToastState
}

fonction main() {
    u := &UI{}

a := proton.New("logoapp")
    a.ApplyPalette(proton.NordPalette)
    a.SetLogoBytes(logoBytes)

a.Window("Mon application", 420, 300, func(ctx proton.Context) {
        // en-tête avec logo
        proton.Row(ctx,
            func(ctx proton.Context) { proton.Logo(ctx, 36, 36) },
            func(ctx proton.Context) { proton.Gap(ctx, 10) },
            func(ctx proton.Context) { proton.H5(ctx, "Mon application") },
        )
        proton.Gap (ctx, 16)
        proton.Diviseur (ctx)
        proton.Gap (ctx, 16)

proton.Label(ctx, fmt.Sprintf("Bouton cliqué %d fois", u.count))
        proton.Gap (ctx, 10)
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.btn, "Cliquez sur moi") {
                u.count++
                si u.count%5 == 0 {
                    u.toast.Show(fmt.Sprintf("%d clics!", u.count), 2*time.Second)
                }
            }
        })

proton.Toast(ctx, &u.toast)
    })
    a.Exécuter()
}
```

Placez `logo.png` dans le même répertoire que `main.go` avant d'exécuter.

---

## Application à deux volets

Une répartition barre latérale/contenu redimensionnable – le modèle de mise en page derrière la plupart des applications de bureau.

```go
package main

import "github.com/CzaxStudio/proton"

tapez la structure de l'interface utilisateur {
    proton divisé.ResizeSplitState
    proton de défilement.Scrollable
    rowBtns [10]proton.Clickable
    entier sélectionné
    saveBtn proton.Cliquable
    éditeur proton.Editor
    proton grillé.ToastState
}

var éléments = []chaîne{
    "Projet Alpha", "Projet Bêta", "Projet Gamma",
    « Notes de réunion », « Idées », « Carnet de retard »,
}

import "time"

fonction main() {
    u := &UI{sélectionné : 0}
    u.editor.SetText("Sélectionnez un élément à gauche pour le modifier.")

a := proton.New("deux volets")
    a.ApplyPalette(proton.TokyoNightPalette)
    a.Window("Application à deux volets", 700, 500, func(ctx proton.Context) {
        proton.ResizeSplit(ctx, &u.split, 0,30,
            func(ctx proton.Context) {
                proton.H6(ctx, "Articles")
                proton.Gap (ctx, 8)
                proton.List(ctx, &u.scroll, len(articles), func(ctx proton.Context, i int) {
                    bg := proton.RGB(0x1a1b26)
                    hov := proton.RGB(0x24283b)
                    si u.selected == je {
                        bg = proton.RGB(0x364a82)
                        hov = bg
                    }
                    proton.PadV(ctx, 2, func(ctx proton.Context) {
                        si proton.HoverCard(ctx, &u.rowBtns[i], bg, hov, 5, func(ctx proton.Context) {
                            proton.PadV(ctx, 8, func(ctx proton.Context) {
                                proton.PadH(ctx, 10, func(ctx proton.Context) {
                                    proton.Label(ctx, éléments[i])
                                })
                            })
                        }) {
                            u.selected = je
                        }
                    })
                })
            },
            func(ctx proton.Context) {
                proton.PadH(ctx, 14, func(ctx proton.Context) {
                    proton.RowSpread(ctx,
                        func(ctx proton.Context) { proton.H6(ctx, items[u.selected]) },
                        func(ctx proton.Context) {
                            proton.Pad(ctx, 4, func(ctx proton.Context) {
                                if proton.Button(ctx, &u.saveBtn, "Enregistrer") {
                                    u.toast.Show("Enregistré.", 2*time.Second)
                                }
                            })
                        },
                    )
                    proton.Gap (ctx, 12)
                    proton.GrowColumn(ctx,
                        proton.GrowItem(ctx, func(ctx proton.Context) {
                            proton.TextArea(ctx, &u.editor, "Écrivez quelque chose...")
                        }),
                    )
                })
            },
        )
        proton.Toast(ctx, &u.toast)
    })
    a.Exécuter()
}
```

---

## Exécution des exemples intégrés

Le dépôt est livré avec 9 exemples d'applications complets :

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

Exécutez d'abord `showcase` — c'est la démonstration visuelle la plus complète de ce que
Proton peut le faire.