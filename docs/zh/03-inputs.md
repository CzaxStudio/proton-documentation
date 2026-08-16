# 输入

文本字段、复选框、切换开关、单选按钮、滑块、数字步进器、
下拉菜单和带有清除按钮的搜索字段。

---

## 输入 — 单行文本字段

```go
type UI struct {
    email proton.Editor
}

proton.Input(ctx, &u.email, "your@email.com")

// read the value any time
fmt.Println(u.email.Text())
```

第二个参数是字段为空时显示的占位符文本。

```go
proton.Input(ctx proton.Context, state *proton.Editor, hint string)
```

---

## TextArea — 多行文本字段

与输入相同，但用户可以按 Enter 键添加行。适合留言，
注释，任何比单行更长的东西。

```go
type UI struct {
    bio proton.Editor
}

proton.TextArea(ctx, &u.bio, "Tell us something...")

fmt.Println(u.bio.Text())
```

```go
proton.TextArea(ctx proton.Context, state *proton.Editor, hint string)
```

---

## 搜索输入

左侧带有搜索图标和一个清除 (×) 按钮的文本字段
当有东西需要清除时出现。返回当前的查询字符串。

```go
type UI struct {
    search proton.SearchState
}

q := proton.SearchInput(ctx, &u.search, "Search notes...")

// filter your data using q
filtered := filter(items, q)
```

“SearchState”同时包含“Editor”和内部清除按钮 - 声明
一个在你的结构中，不要自己构建它。

```go
proton.SearchInput(ctx proton.Context, state *proton.SearchState, placeholder string) string
```

---

## 复选框

在用户切换的框架上返回“true”。读取当前值
`状态.值`。

```go
type UI struct {
    agreed proton.Bool
}

if proton.Checkbox(ctx, &u.agreed, "I have read the terms and conditions") {
    // just changed — u.agreed.Value is the new state
    fmt.Println("now:", u.agreed.Value)
}

// read it any time without caring about the change event
if u.agreed.Value {
    proton.SuccessText(ctx, "Thanks for agreeing (we know you didn't read it)")
}
```

```go
proton.Checkbox(ctx proton.Context, state *proton.Bool, label string) bool
```

---

## 切换

材质风格的开关。与 Checkbox 相同的 API，但外观不同。
用于立即生效而不需要“保存”按钮的设置。

```go
type UI struct {
    darkMode proton.Bool
}

if proton.Toggle(ctx, &u.darkMode, "Dark mode") {
    if u.darkMode.Value {
        applyDarkTheme()
    } else {
        applyLightTheme()
    }
}
```

```go
proton.Toggle(ctx proton.Context, state *proton.Bool, label string) bool
```

---

## 单选按钮

用于从一组中准确选择一个选项。组中的所有按钮共享
一个“proton.Enum”状态字段。 “key”是存储在“group.Value”中的内容
当选择该选项时。

```go
type UI struct {
    plan proton.Enum
}

proton.RadioButton(ctx, &u.plan, "free", "Free")
proton.Gap(ctx, 4)
proton.RadioButton(ctx, &u.plan, "pro", "Pro — $9/mo")
proton.Gap(ctx, 4)
proton.RadioButton(ctx, &u.plan, "team", "Team — $29/mo")

fmt.Println("selected:", u.plan.Value) // "free", "pro", or "team"
```

在选择更改的框架上返回“true”。

```go
proton.RadioButton(ctx proton.Context, group *proton.Enum, key string, label string) bool
```

水平单选按钮 - 将它们包裹在“Row”中：

```go
proton.Row(ctx,
    func(ctx proton.Context) { proton.RadioButton(ctx, &u.size, "s", "S") },
    func(ctx proton.Context) { proton.Gap(ctx, 12) },
    func(ctx proton.Context) { proton.RadioButton(ctx, &u.size, "m", "M") },
    func(ctx proton.Context) { proton.Gap(ctx, 12) },
    func(ctx proton.Context) { proton.RadioButton(ctx, &u.size, "l", "L") },
)
```

---

＃＃ 滑块

水平拖动手柄的值介于 0.0 和 1.0 之间。将其缩放至
无论您需要什么范围。

```go
type UI struct {
    vol proton.Float
}

v := proton.Slider(ctx, &u.vol)

// v is 0.0–1.0, scale it
volume := int(v * 100)
proton.Caption(ctx, fmt.Sprintf("Volume: %d%%", volume))
```

您还可以直接从状态读取值：

```go
proton.Slider(ctx, &u.vol)
fmt.Println(u.vol.Value) // 0.0 to 1.0
```

```go
proton.Slider(ctx proton.Context, state *proton.Float) float32
```

---

## 进度条

不是交互式的——只是将进度显示为填充条。传递一个 float32
0.0 到 1.0 之间。

```go
proton.ProgressBar(ctx, 0.65)    // 65% done
proton.ProgressBar(ctx, 1.0)     // done
proton.ProgressBar(ctx, progress) // from a variable
```

```go
proton.ProgressBar(ctx proton.Context, progress float32)
```

---

## 数字输入

带有 - 和 + 按钮的步进器。为您处理最小、最大和步长。
返回当前值。

```go
type UI struct {
    qty    proton.NumberState
    rating proton.NumberState
}

// integers
qty := proton.NumberInput(ctx, &u.qty, 1, 99, 1)
proton.Caption(ctx, fmt.Sprintf("%d items", int(qty)))

// floats
rating := proton.NumberInput(ctx, &u.rating, 0, 5, 0.5)
proton.Caption(ctx, fmt.Sprintf("%.1f / 5.0", rating))
```

```go
proton.NumberInput(ctx proton.Context, state *proton.NumberState, min, max, step float64) float64
```

第一次使用时该值从“min”开始。 Step >= 1 显示整数；
步骤 < 1 显示两位小数。

---

## 选择框

下拉选择器。返回当前选定选项的索引。

```go
type UI struct {
    lang proton.SelectBoxState
}

langs := []string{"Go", "Rust", "Zig", "C", "Python"}

i := proton.SelectBox(ctx, &u.lang, langs)
proton.Caption(ctx, "You picked: "+langs[i])
```

单击时，下拉菜单将出现在按钮下方。单击任意位置
外面它关闭它。

```go
proton.SelectBox(ctx proton.Context, state *proton.SelectBoxState, options []string) int
```

`Selected` 从 0 开始。如果需要知道，请检查 `state.Selected >= 0`
用户是否明确选择了某些内容。

---

## 完整表格示例

```go
type SettingsUI struct {
    username proton.Editor
    bio      proton.Editor
    notify   proton.Bool
    dark     proton.Bool
    plan     proton.Enum
    volume   proton.Float
    save     proton.Clickable
}

func drawSettings(ctx proton.Context, s *SettingsUI) {
    proton.H4(ctx, "Settings")
    proton.Gap(ctx, 20)

    proton.Label(ctx, "Username")
    proton.Gap(ctx, 4)
    proton.Input(ctx, &s.username, "your_username")
    proton.Gap(ctx, 14)

    proton.Label(ctx, "Bio")
    proton.Gap(ctx, 4)
    proton.TextArea(ctx, &s.bio, "Tell us something...")
    proton.Gap(ctx, 20)

    proton.Toggle(ctx, &s.dark, "Dark mode")
    proton.Gap(ctx, 8)
    proton.Checkbox(ctx, &s.notify, "Email notifications")
    proton.Gap(ctx, 20)

    proton.Label(ctx, "Plan")
    proton.Gap(ctx, 6)
    proton.RadioButton(ctx, &s.plan, "free", "Free")
    proton.Gap(ctx, 4)
    proton.RadioButton(ctx, &s.plan, "pro", "Pro ($9/mo)")
    proton.Gap(ctx, 4)
    proton.RadioButton(ctx, &s.plan, "team", "Team ($29/mo)")
    proton.Gap(ctx, 20)

    proton.Label(ctx, fmt.Sprintf("Volume: %.0f%%", s.volume.Value*100))
    proton.Gap(ctx, 4)
    proton.Slider(ctx, &s.volume)
    proton.Gap(ctx, 28)

    proton.Pad(ctx, 4, func(ctx proton.Context) {
        if proton.Button(ctx, &s.save, "Save Settings") {
            handleSave(s)
        }
    })
}
```