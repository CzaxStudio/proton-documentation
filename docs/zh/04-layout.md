＃ 布局

默认情况下，小部件垂直堆叠。其他一切都是选择加入。

---

## 间隙——在事物之间放置空间

最常用的布局功能。插入空白垂直空间。

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

8dp是一个很小的差距。 16dp 是中等。 24dp很大。这三个涵盖了大多数情况。

---

## 行 — 并排

从左到右水平放置子项。

```go
proton.Row(ctx,
    func(ctx proton.Context) { proton.Label(ctx, "Name:") },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) { proton.Label(ctx, "Alice") },
)
```

每个孩子都是一个“func(proton.Context)”。在其中调用您想要的任何小部件。

```go
proton.Row(ctx proton.Context, widgets ...func(proton.Context))
```

---

## 列 — 显式垂直组

将子项垂直堆叠为命名组。高层很少需要
（小部件自动堆叠），但在“Row”或“Split”中很有用
右侧需要是多个堆叠的东西。

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

## RowSpread — 间距

与 Row 类似，但在子级之间放置剩余的水平空间，推动
第一个位于左边缘，最后一个位于右边缘。

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

## RowEnd — 一切都在右边

将所有子项推到右边缘。

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

## GrowRow 和 GrowColumn — 弹性布局

当一个孩子需要填满所有剩余空间而其他孩子则留在自己的位置时
自然大小，使用“GrowRow”（水平）或“GrowColumn”（垂直）
“GrowItem”和“FixedItem”。

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

`GrowItem` 占用所有剩余空间。 `FixedItem` 只获取它需要的内容。
多个“GrowItem”均匀分割剩余空间。

```go
proton.GrowRow(ctx proton.Context, children ...proton.FlexItem)
proton.GrowColumn(ctx proton.Context, children ...proton.FlexItem)
proton.GrowItem(ctx proton.Context, fn func(proton.Context)) proton.FlexItem
proton.FixedItem(ctx proton.Context, fn func(proton.Context)) proton.FlexItem
```

### FlexSpacer — 将兄弟姐妹推开

一个有弹性的空旷空间。将其放在“FixedItem”之间以将它们推向相反的位置
不使用“RowSpread”的边缘。

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

## 拆分 — 并排窗格

划分两个部分之间的可用宽度。 `leftFraction` 是比例
左窗格的值从 0.0 到 1.0。

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

### HSplit — 顶部和底部

相同的想法，但垂直。

```go
proton.HSplit(ctx, 0.7,
    func(ctx proton.Context) { proton.Label(ctx, "Main content") },
    func(ctx proton.Context) { proton.Label(ctx, "Status bar") },
)
```

```go
proton.HSplit(ctx proton.Context, topFraction float32, top func(proton.Context), bottom func(proton.Context))
```

### ResizeSplit — 用户可以拖动分隔线

与“拆分”类似，但用户可以拖动两个窗格之间的手柄来
调整它们的大小。 `defaultFraction` 是初始位置。

```go
type UI struct {
    split proton.ResizeSplitState
}

proton.ResizeSplit(ctx, &u.split, 0.30, leftFn, rightFn)
```

`ResizeSplitState.Fraction` 从 0 开始并设置为 `defaultFraction`
在第一帧上。之后用户的拖动位置就会被记住。

```go
proton.ResizeSplit(ctx proton.Context, state *proton.ResizeSplitState, defaultFraction float32, left func(proton.Context), right func(proton.Context))
proton.ResizeHSplit(ctx proton.Context, state *proton.ResizeSplitState, defaultFraction float32, top func(proton.Context), bottom func(proton.Context))
```

---

＃＃ 中心

将内容放置在可用空间的中心。非常适合空状态
和加载屏幕。

```go
proton.Center(ctx, func(ctx proton.Context) {
    proton.Muted(ctx, "Nothing here yet.")
})
```

```go
proton.Center(ctx proton.Context, fn func(proton.Context))
```

---

## 填充

### 垫 — 所有四个面

```go
proton.Pad(ctx, 16, func(ctx proton.Context) {
    proton.Label(ctx, "16dp of breathing room on all sides")
})
```

### PadH — 仅左和右

```go
proton.PadH(ctx, 24, func(ctx proton.Context) {
    proton.Label(ctx, "horizontal padding only")
})
```

### PadV — 仅顶部和底部

```go
proton.PadV(ctx, 12, func(ctx proton.Context) {
    proton.Label(ctx, "vertical padding only")
})
```

### PadSides — 每条边单独

参数是上、右、下、左——与 CSS 边距/填充的顺序相同。

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

## 网格 — 固定列网格

将子项排列在具有固定列数的网格中。每个细胞
获得相等份额的可用宽度。

```go
proton.Grid(ctx, 3, 8,   // 3 columns, 8dp gap
    func(ctx proton.Context) { proton.Label(ctx, "one") },
    func(ctx proton.Context) { proton.Label(ctx, "two") },
    func(ctx proton.Context) { proton.Label(ctx, "three") },
    func(ctx proton.Context) { proton.Label(ctx, "four") },
    func(ctx proton.Context) { proton.Label(ctx, "five") },
)
```

单元格自动换行到新行。如果最后一行少于
`cols` 单元格，剩余槽位为空。

```go
proton.Grid(ctx proton.Context, cols int, gapDp float32, cells ...func(proton.Context))
```

---

## ZStack — 在彼此之上绘制东西

在同一位置分层多个小部件。第一个孩子是在
底部；最后一个在上面。

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

## MinSize 和 MaxWidth — 尺寸约束

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

为“MinSize”的任一维度传递 0 以使该轴不受约束。

---

## 典型的两栏应用程序

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