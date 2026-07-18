# 列表和滚动

用于显示事物的集合，并使内容区域可滚动。

---

## List — 垂直滚动列表

标准清单。只绘制当前在屏幕上可见的项目，所以
10,000 个项目就可以了。

```go
type UI struct {
    scroll proton.Scrollable
}

items := []string{"Apples", "Bananas", "Cherries", "Durian (why)"}

proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
    proton.Label(ctx, items[i])
})
```

回调接收索引“i”。为每一行画出你想要的任何东西。

```go
proton.List(ctx proton.Context, state *proton.Scrollable, length int, draw func(proton.Context, int))
```

每个列表声明一个“proton.Scrollable”。它跟踪滚动位置。
不要在两个列表之间共享一个——它们会争夺滚动位置并且
双方都输了。

---

## HList — 水平滚动列表

与列表相同，但项目从左到右排列。

```go
proton.HList(ctx, &u.hscroll, len(items), func(ctx proton.Context, i int) {
    proton.PadH(ctx, 8, func(ctx proton.Context) {
        proton.Label(ctx, items[i])
    })
})
```

```go
proton.HList(ctx proton.Context, state *proton.Scrollable, length int, draw func(proton.Context, int))
```

---

## Scroll — 可滚动的内容区域

对于可能溢出的任意内容，而不是索引项目。内容
函数可以调用任意数量的小部件。

```go
type UI struct {
    scroll proton.Scrollable
}

proton.Scroll(ctx, &u.scroll, func(ctx proton.Context) {
    proton.H5(ctx, "A very long page")
    proton.Gap(ctx, 8)
    proton.Label(ctx, "Paragraph one...")
    proton.Gap(ctx, 8)
    proton.Label(ctx, "Paragraph two...")
    proton.Gap(ctx, 8)
    // as many widgets as you need
})
```

```go
proton.Scroll(ctx proton.Context, state *proton.Scrollable, content func(proton.Context))
```

当您有索引数据时，请使用“List”。对混合内容的页面使用“滚动”。

---

## TextView — 只读可滚动文本

在可滚动的等宽视图中显示大文本块。
适用于文件内容、帮助文本、预览代码。

```go
type UI struct {
    scroll proton.Scrollable
}

proton.TextView(ctx, &u.scroll, longText)
```

```go
proton.TextView(ctx proton.Context, state *proton.Scrollable, text string)
```

文本按换行符分割，每行都是一个虚拟列表项，因此它
处理很长的文档没有问题。

---

## LogView — 自动滚动日志输出

与 TextView 类似，但每当添加新内容时就会自动滚动到底部。
自动对常见日志前缀进行颜色编码。

```go
type UI struct {
    logScroll proton.Scrollable
    logText   string
}

// append to logText from anywhere
u.logText += fmt.Sprintf("[OK] Step completed at %s\n", time.Now().Format("15:04:05"))

// draw it — auto-scrolls to the latest line
proton.LogView(ctx, &u.logScroll, u.logText)
```

```go
proton.LogView(ctx proton.Context, state *proton.Scrollable, text string)
```

颜色编码根据行前缀自动发生：

|前缀|颜色 |
|---|---|
| `[确定]`、`完成`、`成功` |绿色|
| `[警告]`、`警告` |黄色|
| `[错误]`、`错误` |红色|
|还有什么吗|静音 |

---

## 让列表行看起来不错

列表行中的裸露“proton.Label”可以工作，但看起来不太好。添加一些
填充和结构。

### 填充行

```go
proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
    proton.PadV(ctx, 8, func(ctx proton.Context) {
        proton.PadH(ctx, 12, func(ctx proton.Context) {
            proton.Label(ctx, items[i].Name)
            proton.Gap(ctx, 2)
            proton.Muted(ctx, items[i].Description)
        })
    })
    proton.Divider(ctx)
})
```

### 两列文本

```go
type Contact struct {
    Name  string
    Email string
}

proton.List(ctx, &u.scroll, len(contacts), func(ctx proton.Context, i int) {
    c := contacts[i]
    proton.PadV(ctx, 10, func(ctx proton.Context) {
        proton.PadH(ctx, 12, func(ctx proton.Context) {
            proton.Label(ctx, c.Name)
            proton.Gap(ctx, 3)
            proton.Muted(ctx, c.Email)
        })
    })
    proton.Divider(ctx)
})
```

### 带有悬停突出显示的可点击行

```go
type UI struct {
    rows     [256]proton.Clickable
    selected int
    scroll   proton.Scrollable
}

proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
    bg  := proton.RGB(0x2e3440)
    hov := proton.RGB(0x3b4252)
    if u.selected == i {
        bg  = proton.RGB(0x4c566a)
        hov = bg
    }
    proton.PadV(ctx, 2, func(ctx proton.Context) {
        if proton.HoverCard(ctx, &u.rows[i], bg, hov, 6, func(ctx proton.Context) {
            proton.PadV(ctx, 10, func(ctx proton.Context) {
                proton.PadH(ctx, 12, func(ctx proton.Context) {
                    proton.Label(ctx, items[i].Name)
                    proton.Gap(ctx, 2)
                    proton.Muted(ctx, items[i].Sub)
                })
            })
        }) {
            u.selected = i
        }
    })
})
```

### 卡片内的列表

```go
proton.Card(ctx, proton.RGB(0x1e1e2e), 10, 0, func(ctx proton.Context) {
    proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
        proton.PadV(ctx, 8, func(ctx proton.Context) {
            proton.PadH(ctx, 12, func(ctx proton.Context) {
                proton.Label(ctx, items[i])
            })
        })
        if i < len(items)-1 {
            proton.Divider(ctx)
        }
    })
})
```

---

＃＃ 表现

`List` 和 `HList` 使用虚拟渲染——只有可见的项目才会获得它们的
调用绘制函数。 50,000 个项目的切片以 60 fps 的速度滚动，无需
出了一身汗。

`Scroll` 每帧渲染内容函数中的所有内容。用它来
具有合理数量的小部件的页面，不适用于巨大的动态数据集。