# 质子文档

**阅读您语言的文档：** [英语](https://github.com/CzaxStudio/proton-documentation/blob/main/docs/README.md) | [西班牙语](https://github.com/CzaxStudio/proton-documentation/blob/main/docs/es/README.md) | [法语](https://github.com/CzaxStudio/proton-documentation/blob/main/docs/fr/README.md) | [Ελλνικά](https://github.com/CzaxStudio/proton-documentation/blob/main/docs/el/README.md)

版权所有 © [CzaxStudio](https://github.com/CzaxStudio/) (Nexus-Proton)

使用 Proton 构建桌面应用程序所需的一切。 
选择一个主题或按顺序阅读它们——两者都很好。

---

|文件 |里面有什么 |
|---|---|
| [00-getting-started.md](./00-getting-started.md) |安装，第一个窗口，状态结构模式 |
| [01-text.md](./01-text.md) |标签、H1–H6、正文2、标题、自定义文本 |
| [02-buttons.md](./02-buttons.md) |按钮、大纲按钮、图标按钮、可点击|
| [03-输入.md](./03-输入.md) |输入、文本区域、复选框、切换、单选按钮、滑块、进度条 |
| [04-layout.md](./04-layout.md) |行、列、分割、填充、间隙、网格、行增长、中心 |
| [05-lists.md](./05-lists.md) |列表、HList、滚动 |
| [06-视觉.md](./06-视觉.md) |分隔线、矩形、圆形矩形、卡片、徽章、图像、最小尺寸、最大宽度 |
| [07-主题.md](./07-主题.md) |调色板、自定义颜色、字体比例 |
| [08-advanced.md](./08-advanced.md) | Toast、OnKey、goroutines、Tooltip、多个窗口 |
| [09-examples.md](./09-examples.md) |完整的复制粘贴示例 |

---

## 一件事要知道

Proton 是即时模式。您的绘制函数会在每一帧运行。你打电话
小部件功能，它们按该顺序出现在屏幕上。状态住在
你自己的结构。就是这样。

```go
type UI struct {
    btn proton.Clickable
}

u := &UI{}

a.Window("App", 400, 300, func(win proton.Context) {
    proton.Label(win, "Click the button.")
    proton.Gap(win, 8)
    proton.Pad(win, 8, func(win proton.Context) {
        if proton.Button(win, &u.btn, "Hello") {
            println("hello!")
        }
    })
})
```

小部件垂直堆叠。状态存在于你的结构中。这就是整个模型。

**[Proton-Repo](https://github.com/CzaxStudio/Proton)**