＃ 文本

十种文本功能，涵盖“我希望人们阅读此内容”中的各种尺寸
房间对面”到“请没人阅读此细则”

---

## 标题

```go
proton.H1(ctx, "I am enormous")
proton.H2(ctx, "Large")
proton.H3(ctx, "Medium-large")
proton.H4(ctx, "Medium — good for section titles")
proton.H5(ctx, "Medium-small")
proton.H6(ctx, "Small heading with dignity")
```

与 HTML 相同的尺寸比例。 H1 适合当你确实想发表声明时。
H4 和 H5 是您实际最常使用的。

**签名**（六个签名相同）：```go
proton.H1(ctx proton.Context, text string)
```

---

＃＃ 标签

常规正文。这就是您的应用程序中的大多数单词。

```go
proton.Label(ctx, "This is a label.")
```

```go
proton.Label(ctx proton.Context, text string)
```

---

## 正文2

比标签稍小。对于重要的次要信息，但
不应与主要内容竞争。

```go
proton.Label(ctx, "Price: $29.99")
proton.Body2(ctx, "Excluding taxes and the general unfairness of life.")
```

```go
proton.Body2(ctx proton.Context, text string)
```

---

＃＃ 标题

最小的文字。提示、时间戳、细则、您需要说的话
但并不真正希望人们阅读。

```go
proton.Caption(ctx, "Last synced 3 years ago")
```

```go
proton.Caption(ctx proton.Context, text string)
```

---

## 静音

Body2 大小的文本，颜色较暗。对于辅助标签、辅助文本、
支持主要内容而不与之竞争的描述。

```go
proton.Label(ctx, "Alice Johnson")
proton.Muted(ctx, "alice@example.com — last seen Tuesday")
```

```go
proton.Muted(ctx proton.Context, text string)
```

---

## 文本 — 自定义样式

当预设尺寸不起作用时，“文本”可让您控制尺寸、颜色、
并直接称重。

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

大小以“sp”（缩放像素）为单位。默认主体尺寸约为 14sp。

---

## 语义颜色助手

常见状态文本的快捷方式。如果字符串为空，则每个都不会执行任何操作，
这使得它们可以安全地有条件地使用，而无需额外的“if”。

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

空字符串行为对于验证很有用：

```go
proton.ErrorText(ctx, validationErr) // draws nothing when validationErr == ""
```

---

## 彩色文本

具有特定颜色的标签的单行，没有完整的“文本”调用。

```go
proton.ColoredText(ctx, "Connected", proton.RGB(0x4ade80))
proton.ColoredText(ctx, "Disconnected", proton.RGB(0xf87171))
```

```go
proton.ColoredText(ctx proton.Context, text string, c color.NRGBA)
```

---

＃＃ 颜色

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

## 文本换行

长文本会在任何可用宽度内自动换行。
你不需要做任何特别的事情。

```go
proton.Label(ctx, "This is a very long sentence that will wrap gracefully "+
    "onto multiple lines when the window is too narrow to fit it all in one.")
```

---

## 典型的内容部分

```go
proton.H4(ctx, "Account Settings")
proton.Gap(ctx, 4)
proton.Muted(ctx, "Manage your profile and notification preferences.")
proton.Gap(ctx, 16)
proton.Divider(ctx)
proton.Gap(ctx, 16)
```