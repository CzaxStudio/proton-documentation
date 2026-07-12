# Text

Ten text functions covering every size from "I want people to read this from
across the room" to "please nobody read this fine print"

---

## Headings

```go
proton.H1(ctx, "I am enormous")
proton.H2(ctx, "Large")
proton.H3(ctx, "Medium-large")
proton.H4(ctx, "Medium — good for section titles")
proton.H5(ctx, "Medium-small")
proton.H6(ctx, "Small heading with dignity")
```

Same size scale as HTML. H1 is for when you really want to make a statement.
H4 and H5 are the ones you'll actually use most often.

**Signature** (same for all six):
```go
proton.H1(ctx proton.Context, text string)
```

---

## Label

Regular body text. This is what most of the words in your app are.

```go
proton.Label(ctx, "This is a label.")
```

```go
proton.Label(ctx proton.Context, text string)
```

---

## Body2

Slightly smaller than Label. For secondary information that matters but
shouldn't compete with the main content.

```go
proton.Label(ctx, "Price: $29.99")
proton.Body2(ctx, "Excluding taxes and the general unfairness of life.")
```

```go
proton.Body2(ctx proton.Context, text string)
```

---

## Caption

The smallest text. Hints, timestamps, fine print, things you need to say
but don't really want people to read.

```go
proton.Caption(ctx, "Last synced 3 years ago")
```

```go
proton.Caption(ctx proton.Context, text string)
```

---

## Muted

Body2-sized text in a dimmer color. For secondary labels, helper text,
descriptions that support the main content without competing with it.

```go
proton.Label(ctx, "Alice Johnson")
proton.Muted(ctx, "alice@example.com — last seen Tuesday")
```

```go
proton.Muted(ctx proton.Context, text string)
```

---

## Text — Custom Styling

When the preset sizes don't work, `Text` lets you control size, color,
and weight directly.

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

Size is in `sp` (scaled pixels). The default body size is around 14sp.

---

## Semantic Color Helpers

Shortcuts for common status text. Each one does nothing if the string is empty,
which makes them safe to use conditionally without an extra `if`.

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

The empty-string behavior is useful for validation:

```go
proton.ErrorText(ctx, validationErr) // draws nothing when validationErr == ""
```

---

## ColoredText

One-liner for a label with a specific color, without the full `Text` call.

```go
proton.ColoredText(ctx, "Connected", proton.RGB(0x4ade80))
proton.ColoredText(ctx, "Disconnected", proton.RGB(0xf87171))
```

```go
proton.ColoredText(ctx proton.Context, text string, c color.NRGBA)
```

---

## Colors

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

## Text Wrapping

Long text wraps automatically within whatever width is available.
You don't need to do anything special.

```go
proton.Label(ctx, "This is a very long sentence that will wrap gracefully "+
    "onto multiple lines when the window is too narrow to fit it all in one.")
```

---

## A Typical Content Section

```go
proton.H4(ctx, "Account Settings")
proton.Gap(ctx, 4)
proton.Muted(ctx, "Manage your profile and notification preferences.")
proton.Gap(ctx, 16)
proton.Divider(ctx)
proton.Gap(ctx, 16)
```
