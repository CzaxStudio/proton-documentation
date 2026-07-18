# 视觉小部件

形状、卡片、图像、徽章、进度环、表格、头像——这些东西
让您的应用程序看起来像是专门设计的。

---

## 分频器

A thin horizontal rule. Use it between sections.

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

### 标签分隔符

与分隔符相同，但具有居中的文本标签。

```go
proton.LabeledDivider(ctx, "Advanced Settings")
proton.LabeledDivider(ctx, "")   // plain divider — same as Divider
```

```go
proton.LabeledDivider(ctx proton.Context, label string)
```

---

## 矩形

一个纯色矩形。传递 0 作为宽度或高度来填充
该轴上的可用空间。

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

### 圆角矩形

与 Rect 相同，但具有圆角。

```go
proton.RoundRect(ctx, proton.RGB(0x2a2a3e), 200, 60, 12)  // 12dp corner radius
proton.RoundRect(ctx, proton.RGB(0x4c566a), 0, 40, 20)    // full width, pill shape
```

```go
proton.RoundRect(ctx proton.Context, c color.NRGBA, widthDp, heightDp, radiusDp float32)
```

---

＃＃ 卡片

带衬垫的圆角矩形背景内的内容带有微妙的阴影。
用于对相关内容进行分组的首选容器。

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

- `bg` — 背景颜色
- `cornerDp` — 角半径（8-12 对于大多数卡片来说看起来不错）
- `padDp` — 卡边缘和内容之间的填充

### 悬停卡

悬停时更改背景颜色的卡片。如果单击则返回 true。

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

＃＃ 徽章

带有文字的小圆形芯片。用于状态标签、标记、计数等任何内容
需要一颗彩色药丸。

```go
proton.Badge(ctx, proton.RGB(0x5e81ac), proton.RGB(0xeceff4), "stable")
proton.Badge(ctx, proton.RGB(0xa3be8c), proton.RGB(0x2e3440), "passing")
proton.Badge(ctx, proton.RGB(0xbf616a), proton.RGB(0xeceff4), "failing")
```

```go
proton.Badge(ctx proton.Context, bg, fg color.NRGBA, text string)
```

连续徽章：

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

## 状态点

一个小彩色圆圈。在线/离线指示器、构建状态等等
需要在某些文本旁边有一个彩色点。

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

## 头像

显示姓名缩写的圆形徽章。对于没有图像时的用户个人资料图片
是可用的——这是大多数时候。

```go
proton.Avatar(ctx, "AJ", proton.RGB(0x5e81ac), proton.RGB(0xeceff4), 40)
proton.Avatar(ctx, "BC", proton.RGB(0xa3be8c), proton.RGB(0x2e3440), 32)
```

```go
proton.Avatar(ctx proton.Context, initials string, bg, fg color.NRGBA, sizeDp float32)
```

---

## 进度环

圆形进度指示器。适用于统计卡和仪表板
圆形比条形更能直观地传达百分比。

```go
proton.ProgressRing(ctx, 0.72, 48, 5, proton.RGB(0x88c0d0))
//                       ^     ^   ^   ^
//                  progress  sz  strokeW  color
```

```go
proton.ProgressRing(ctx proton.Context, progress, sizeDp, strokeDp float32, c color.NRGBA)
```

`progress` is 0.0–1.0. `sizeDp` 是直径。 `strokeDp` is the ring
厚度 — 4-6dp 适合大多数尺寸。

---

＃＃ 桌子

具有标题行和交替行阴影的数据表。

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

`proton.TableRow` 只是 `[]string`。列同样宽。

---

## 步进器

多步骤流程的水平步骤进度指示器。

```go
proton.Stepper(ctx, 1, []string{"Account", "Profile", "Payment", "Done"})
//                  ^
//              current step (0-based)
```

```go
proton.Stepper(ctx proton.Context, current int, steps []string)
```

步骤 0 是第一步。已完成的步骤（索引<当前）得到填充
强调色。当前步骤突出显示。未来的脚步是黯淡的。

---

## 工具提示

当用户将鼠标悬停在某物上时出现的小标签。

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

“状态”可点击轨道悬停在工具提示区域。它是独立于
内容内的任何按钮 - 为每个工具提示声明一个专用按钮。

---

## 图片

启动时加载一次。绘制每一帧。

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

PNG 和 JPEG 均受支持。

---

＃＃ 标识

您的应用程序徽标，加载一次并在任何地方绘制。参见[07-theming.md](./07-theming.md)
进行完整设置。 The short version:

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

## 代码块

圆角边框框中的等宽文本。用于显示命令、文件路径、
片段——用户可能复制的任何内容。

```go
proton.CodeBlock(ctx, "go get github.com/CzaxStudio/proton")
proton.CodeBlock(ctx, `a.Window("App", 480, 300, draw)
a.Run()`)
```

```go
proton.CodeBlock(ctx proton.Context, code string)
```

---

## 快捷方式提示

一个小键盘徽章。在菜单项或按钮标签旁边显示这些内容
传达键盘快捷键。

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

## 色样

用户可以单击一行彩色圆圈来选择颜色。退货
所选索引的索引，如果尚未选择，则为 -1。

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

选定的圆周围会出现一个圆环。