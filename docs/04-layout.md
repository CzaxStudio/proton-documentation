# Layout

Widgets stack vertically by default. Everything else is opt-in.

---

## Gap — Put Space Between Things

The most-used layout function. Inserts blank vertical space.

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

8dp is a small gap. 16dp is medium. 24dp is large. Those three cover most cases.

---

## Row — Side by Side

Places children horizontally, left to right.

```go
proton.Row(ctx,
    func(ctx proton.Context) { proton.Label(ctx, "Name:") },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) { proton.Label(ctx, "Alice") },
)
```

Each child is a `func(proton.Context)`. Call whatever widgets you want inside it.

```go
proton.Row(ctx proton.Context, widgets ...func(proton.Context))
```

---

## Column — Explicit Vertical Group

Stacks children vertically as a named group. Rarely needed at the top level
(widgets stack automatically), but useful inside `Row` or `Split` when the
right side needs to be multiple stacked things.

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

## RowSpread — Space Between

Like Row but puts leftover horizontal space between the children, pushing
the first to the left edge and the last to the right.

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

## RowEnd — Everything on the Right

Pushes all children to the right edge.

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

## GrowRow and GrowColumn — Stretchy Layouts

When one child needs to fill all remaining space and the others stay their
natural size, use `GrowRow` (horizontal) or `GrowColumn` (vertical) with
`GrowItem` and `FixedItem`.

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

`GrowItem` takes all remaining space. `FixedItem` takes only what it needs.
Multiple `GrowItem`s split remaining space evenly.

```go
proton.GrowRow(ctx proton.Context, children ...proton.FlexItem)
proton.GrowColumn(ctx proton.Context, children ...proton.FlexItem)
proton.GrowItem(ctx proton.Context, fn func(proton.Context)) proton.FlexItem
proton.FixedItem(ctx proton.Context, fn func(proton.Context)) proton.FlexItem
```

### FlexSpacer — Push siblings apart

A stretchy empty space. Put it between `FixedItem`s to push them to opposite
edges without using `RowSpread`.

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

## Split — Side-by-Side Panes

Divides available width between two sections. `leftFraction` is the proportion
the left pane gets, from 0.0 to 1.0.

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

### HSplit — Top and Bottom

Same idea but vertical.

```go
proton.HSplit(ctx, 0.7,
    func(ctx proton.Context) { proton.Label(ctx, "Main content") },
    func(ctx proton.Context) { proton.Label(ctx, "Status bar") },
)
```

```go
proton.HSplit(ctx proton.Context, topFraction float32, top func(proton.Context), bottom func(proton.Context))
```

### ResizeSplit — User Can Drag the Divider

Like Split but the user can drag the handle between the two panes to
resize them. The `defaultFraction` is the initial position.

```go
type UI struct {
    split proton.ResizeSplitState
}

proton.ResizeSplit(ctx, &u.split, 0.30, leftFn, rightFn)
```

`ResizeSplitState.Fraction` starts at 0 and gets set to `defaultFraction`
on the first frame. After that the user's drag position is remembered.

```go
proton.ResizeSplit(ctx proton.Context, state *proton.ResizeSplitState, defaultFraction float32, left func(proton.Context), right func(proton.Context))
proton.ResizeHSplit(ctx proton.Context, state *proton.ResizeSplitState, defaultFraction float32, top func(proton.Context), bottom func(proton.Context))
```

---

## Center

Places content in the center of available space. Great for empty states
and loading screens.

```go
proton.Center(ctx, func(ctx proton.Context) {
    proton.Muted(ctx, "Nothing here yet.")
})
```

```go
proton.Center(ctx proton.Context, fn func(proton.Context))
```

---

## Padding

### Pad — All Four Sides

```go
proton.Pad(ctx, 16, func(ctx proton.Context) {
    proton.Label(ctx, "16dp of breathing room on all sides")
})
```

### PadH — Left and Right Only

```go
proton.PadH(ctx, 24, func(ctx proton.Context) {
    proton.Label(ctx, "horizontal padding only")
})
```

### PadV — Top and Bottom Only

```go
proton.PadV(ctx, 12, func(ctx proton.Context) {
    proton.Label(ctx, "vertical padding only")
})
```

### PadSides — Each Edge Individually

Arguments are top, right, bottom, left — same order as CSS margin/padding.

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

## Grid — Fixed-Column Grid

Arranges children in a grid with a fixed number of columns. Each cell
gets an equal share of the available width.

```go
proton.Grid(ctx, 3, 8,   // 3 columns, 8dp gap
    func(ctx proton.Context) { proton.Label(ctx, "one") },
    func(ctx proton.Context) { proton.Label(ctx, "two") },
    func(ctx proton.Context) { proton.Label(ctx, "three") },
    func(ctx proton.Context) { proton.Label(ctx, "four") },
    func(ctx proton.Context) { proton.Label(ctx, "five") },
)
```

Cells wrap onto new rows automatically. If the last row has fewer than
`cols` cells, the remaining slots are empty.

```go
proton.Grid(ctx proton.Context, cols int, gapDp float32, cells ...func(proton.Context))
```

---

## ZStack — Draw Things on Top of Each Other

Layers multiple widgets at the same position. The first child is on the
bottom; the last is on top.

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

## MinSize and MaxWidth — Size Constraints

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

Pass 0 for either dimension of `MinSize` to leave that axis unconstrained.

---

## A Typical Two-Column App

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
