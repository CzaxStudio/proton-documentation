# 按钮

按钮是用户告诉您的应用程序执行操作的方式。质子有四种，
加上可点击的链接和一种使任何东西都可点击的方法。

---

## 一条规则

每个按钮在状态结构中都需要有自己的“proton.Clickable”字段。

```go
type UI struct {
    save   proton.Clickable
    cancel proton.Clickable
    delete proton.Clickable
}
```

不要在两个按钮之间共用一个按钮。如果这样做，单击任一按钮都会触发
两者都是——这是一个有趣的调试错误，也是一个糟糕的用户体验。

此外，按钮必须位于布局包装器内（“Pad”、“Row”、“Column”等）
点击注册。原因请参见[入门](./00-getting-started.md)。

---

＃＃ 按钮

饱满、扎实、主要动作。用它来做你最想要的东西
用户点击。

```go
var save proton.Clickable

proton.Pad(ctx, 8, func(ctx proton.Context) {
    if proton.Button(ctx, &save, "Save") {
        doSave()
    }
})
```

在被单击的框架上返回“true”。一键点击，一“真”。它
按住时不会继续射击。

```go
proton.Button(ctx proton.Context, state *proton.Clickable, label string) bool
```

---

## 大纲按钮

幽灵/轮廓风格。与 Button 的行为相同，但没有填充
背景。将其用于辅助操作 - 用户可能想要的东西
要做，但这不是主要行动。

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

这里的视觉层次结构——取消的轮廓，保存的填充——告诉我们
用户哪个是主要操作，无需任何解释。

```go
proton.OutlineButton(ctx proton.Context, state *proton.Clickable, label string) bool
```

---

## 图标按钮

仅图标按钮。没有文字，只有一个图标。常见于工具栏。

```go
// icon is a *proton.Icon — load one with widget.NewIcon() from gioui.org/widget
var closeBtn proton.Clickable

if proton.IconButton(ctx, &closeBtn, closeIcon, "Close window") {
    win.Close()
}
```

第四个参数是可访问性描述——什么是屏幕阅读器
会说。不要跳过它。

```go
proton.IconButton(ctx proton.Context, state *proton.Clickable, icon *proton.Icon, desc string) bool
```

---

## 可点击

使任何内容均可点击。您在回调内绘制的整个区域
成为命中目标。将其用于卡片、列表行、自定义按钮或
任何标准按钮标签不是您想要的东西。

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

## Link 和 LinkSmall

带下划线的可点击文本，样式类似于超链接。自己处理点击 -
Proton 不会为您打开 URL，它只是告诉您用户点击了。

```go
var githubLink proton.Clickable

if proton.Link(ctx, &githubLink, "View on GitHub") {
    openBrowser("https://github.com/CzaxStudio/proton")
}
```

`LinkSmall` 是同样的东西，但使用标题大小的文本：

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

## 常见模式

### 确认/取消行（右对齐）

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

`RowEnd` 将所有内容推到右边缘 - 标准位置
确认/取消对。

### 工具栏

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

### 可点击列表行

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