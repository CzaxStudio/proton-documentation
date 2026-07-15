# Texte

Dix fonctions de texte couvrant toutes les tailles, de "Je veux que les gens lisent ceci depuis
à travers la pièce" pour "s'il vous plaît, personne ne lit ces petits caractères"

---

## Titres

```go
proton.H1(ctx, "I am enormous")
proton.H2(ctx, "Large")
proton.H3(ctx, "Medium-large")
proton.H4(ctx, "Medium — good for section titles")
proton.H5(ctx, "Medium-small")
proton.H6(ctx, "Small heading with dignity")
```

Même échelle de taille que HTML. H1 est destiné lorsque vous voulez vraiment faire une déclaration.
H4 et H5 sont ceux que vous utiliserez le plus souvent.

**Signature** (identique pour les six) :```go
proton.H1(ctx proton.Context, text string)
```

---

## Étiquette

Corps de texte régulier. C'est ce que sont la plupart des mots de votre application.

```go
proton.Label(ctx, "This is a label.")
```

```go
proton.Label(ctx proton.Context, text string)
```

---

## Corps2

Légèrement plus petit que Label. Pour les informations secondaires qui comptent mais
ne devrait pas rivaliser avec le contenu principal.

```go
proton.Label(ctx, "Price: $29.99")
proton.Body2(ctx, "Excluding taxes and the general unfairness of life.")
```

```go
proton.Body2(ctx proton.Context, text string)
```

---

## Légende

Le plus petit texte. Conseils, horodatages, petits caractères, choses que vous devez dire
mais je ne veux pas vraiment que les gens lisent.

```go
proton.Caption(ctx, "Last synced 3 years ago")
```

```go
proton.Caption(ctx proton.Context, text string)
```

---

## Muet

Texte de taille Body2 dans une couleur plus pâle. Pour les étiquettes secondaires, le texte d'assistance,
des descriptions qui prennent en charge le contenu principal sans le concurrencer.

```go
proton.Label(ctx, "Alice Johnson")
proton.Muted(ctx, "alice@example.com — last seen Tuesday")
```

```go
proton.Muted(ctx proton.Context, text string)
```

---

## Texte — Style personnalisé

Lorsque les tailles prédéfinies ne fonctionnent pas, « Texte » vous permet de contrôler la taille, la couleur,
et le poids directement.

```go
// 28sp, coral red, bold
proton.Text(ctx, "Warning!", 28, proton.RGB(0xf87171), true)

// 16sp, custom blue, not bold
proton.Text(ctx, "Note", 16, proton.RGB(0x60a5fa), false)

// pass color.NRGBA{} to use the theme's default text color
proton.Text(ctx, "Normal weight, bigger", 20, proton.NRGBA{}, false)
```

```go
proton.Text(ctx proton.Context, s string, size float32, c color.NRGBA, bold bool)
```

La taille est en `sp` (pixels mis à l'échelle). La taille du corps par défaut est d'environ 14sp.

---

## Aides aux couleurs sémantiques

Raccourcis pour le texte d’état commun. Chacun ne fait rien si la chaîne est vide,
ce qui les rend sûrs à utiliser sous condition sans « si » supplémentaire.

```go
proton.ErrorText(ctx, "Invalid email address.")     // red
proton.SuccessText(ctx, "Changes saved.")           // green
proton.WarningText(ctx, "This cannot be undone.")   // yellow
```

```go
proton.ErrorText(ctx proton.Context, text string)
proton.SuccessText(ctx proton.Context, text string)
proton.WarningText(ctx proton.Context, text string)
```

Le comportement de chaîne vide est utile pour la validation :

```go
proton.ErrorText(ctx, validationErr) // draws nothing when validationErr == ""
```

---

## Texte coloré

Une seule ligne pour une étiquette avec une couleur spécifique, sans l'appel « Texte » complet.

```go
proton.ColoredText(ctx, "Connected", proton.RGB(0x4ade80))
proton.ColoredText(ctx, "Disconnected", proton.RGB(0xf87171))
```

```go
proton.ColoredText(ctx proton.Context, text string, c color.NRGBA)
```

---

## Couleurs

```go
// from a 24-bit hex value
proton.RGB(0xff6b6b)   // coral red
proton.RGB(0x4ecdc4)   // teal
proton.RGB(0xffffff)   // white
proton.RGB(0x000000)   // black

// with explicit alpha (0 = transparent, 255 = fully opaque)
proton.RGBA(255, 107, 107, 255)  // same coral, fully opaque
proton.RGBA(0, 0, 0, 128)        // 50% transparent black

// from a CSS hex string
proton.HexColor("#ff6b6b")
proton.HexColor("ff6b6b")   // hash is optional
proton.HexColor("#f66")     // shorthand also works
```

---

## Habillage du texte

Le texte long s'enroule automatiquement dans la largeur disponible.
Vous n'avez rien de spécial à faire.

```go
proton.Label(ctx, "This is a very long sentence that will wrap gracefully "+
    "onto multiple lines when the window is too narrow to fit it all in one.")
```

---

## Une section de contenu typique

```go
proton.H4(ctx, "Account Settings")
proton.Gap(ctx, 4)
proton.Muted(ctx, "Manage your profile and notification preferences.")
proton.Gap(ctx, 16)
proton.Divider(ctx)
proton.Gap(ctx, 16)
```