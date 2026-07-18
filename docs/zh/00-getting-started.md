＃ 入门

您想用 Go 构建一个桌面应用程序。你来对地方了

---

## 先决条件

转到 1.22 或更高版本。检查：

```bash
go version
```

如果您使用的是 Linux，则还需要三个系统软件包。 macOS 和 Windows 用户
可以跳过这个并感到沾沾自喜：

```bash
sudo apt install libwayland-dev libxkbcommon-dev libvulkan-dev
```

---

＃＃ 安装

在您的项目目录中：

```bash
go get github.com/CzaxStudio/proton
go mod tidy
```

“go mod tidy”步骤很重要——它拉动了 Gio 的传递依赖
并将它们写入“go.sum”。跳过它，你会看到到处都是红色的曲线。

---

## 你的第一个窗口

```go
package main

import "github.com/CzaxStudio/proton"

func main() {
    a := proton.New("hello")
    a.Window("Hello", 480, 320, func(ctx proton.Context) {
        proton.H3(ctx, "Hello from Proton!") // ⓘ You can change proton.H3 to any size you want
    })
    a.Run()
}
```

```bash
go run .
```

出现一个窗口。这是一个完整的、可运行的 GUI 应用程序，只有 9 行。没有 XML，
没有“implements Runnable”，没有依赖注入框架，没有 webpack。

---

## 添加状态

执行某些操作的小部件（按钮、文本输入、复选框）需要一个状态
您自己的结构中的字段。声明它们一次，将指针传递给小部件。

```go
package main

import (
    "fmt"
    "github.com/CzaxStudio/proton"
)

type UI struct {
    name proton.Editor
    btn  proton.Clickable
}

func main() {
    u := &UI{}

    a := proton.New("greeter")
    a.Window("Greeter", 400, 240, func(ctx proton.Context) {
        proton.Input(ctx, &u.name, "Your name")
        proton.Gap(ctx, 8)
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.btn, "Say hello") {
                fmt.Println("Hello,", u.name.Text())
            }
        })
    })
    a.Run()
}
```

绘制函数每帧运行。 `Button` 在框架上返回 `true`
被点击。 “if”块运行，打印名称，仅此而已。

---

## 状态类型

在您的 UI 结构中声明这些。它们都是零值准备的——没有构造函数。

```go
type UI struct {
    btn     proton.Clickable    // Button, OutlineButton, Tappable, Link
    name    proton.Editor       // Input, TextArea
    checked proton.Bool         // Checkbox, Toggle
    choice  proton.Enum         // RadioButton group
    vol     proton.Float        // Slider
    scroll  proton.Scrollable   // List, HList, Scroll, TextView, LogView
}
```

每个小部件一个字段。不要在两个按钮之间共享“Clickable”——它们会
两者都会在同一次点击时触发，这几乎不是您想要的。

---

## 布局如何工作

没有任何布局包装器，小部件从上到下垂直堆叠。 `差距`
添加它们之间的空间。

```go
proton.H4(ctx, "Settings")
proton.Gap(ctx, 12)
proton.Label(ctx, "Adjust your preferences below.")
proton.Gap(ctx, 16)
proton.Divider(ctx)
proton.Gap(ctx, 16)
proton.Toggle(ctx, &u.darkMode, "Dark mode")
```

对于并排布局，请使用“行”。更多控制请参见[04-layout.md](./04-layout.md)。

---

## 按钮需要布局包装器

按钮（和其他交互式小部件）必须位于布局助手内
点击正确注册。这是 Gio 的事情——布局过程就是这样
在屏幕上建立命中区域。

```go
// correct — button is inside Pad
proton.Pad(ctx, 8, func(ctx proton.Context) {
    if proton.Button(ctx, &u.btn, "Save") {
        save()
    }
})

// also correct — button is inside Row
proton.Row(ctx,
    func(ctx proton.Context) {
        if proton.Button(ctx, &u.btn, "Save") {
            save()
        }
    },
)
```

如果您将一个按钮放在绘图函数的最顶层，而没有任何
包装器，它会绘制但不会响应点击。 `Pad(ctx, 0, ...)` 是
如果您想要零视觉填充，则使用最小包装器。

---

## 主题化

```go
a := proton.New("myapp")
a.ApplyPalette(proton.NordPalette)
a.Window("App", 800, 600, draw)
a.Run()
```

内置 46 个调色板。请参阅 [07-theming.md](./07-theming.md) 了解所有调色板
以及使用十六进制颜色代码构建您自己的颜色代码。

---

## 多个窗口

```go
a := proton.New("app")
a.Window("Main", 800, 600, drawMain)
a.Window("Settings", 400, 300, drawSettings)
a.Run() // opens both
```

所有窗口共享相同的“*App”。该进程一直保持活动状态，直到所有窗口
已关闭。

---

## 后续步骤

- **[01-text.md](./01-text.md)** — 文本小部件
- **[02-buttons.md](./02-buttons.md)** — 按钮和可点击区域
- **[03-inputs.md](./03-inputs.md)** — 文本字段、切换开关、滑块
- **[04-layout.md](./04-layout.md)** — 在屏幕上排列内容
- **[09-examples.md](./09-examples.md)** — 要复制的完整工作程序