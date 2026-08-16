＃ 安卓

使用 Proton 构建 Android 应用程序！

Proton 应用程序通过 Gio 的原生 Android 支持在 Android 上运行。
在桌面上运行的相同代码也可以在 Android 上运行 - 无需重写，
没有单独的 UI 层。

---

## 什么有效

每个 Proton 小部件、布局和主题在 Android 上的工作方式都与它完全相同
在桌面上执行。触摸事件映射到指针事件。软键盘
与“Input”和“TextArea”集成。 `Invalidate()` 工作正常
在手机上。 Gio 方面的一个限制：Android 仅支持
每个应用程序一个窗口。

---

## 安装构建工具

你需要`gogio`，Gio的交叉编译工具：

```bash
go install gioui.org/cmd/gogio@latest
```

您还需要 Android SDK 和 NDK。最简单的路径是 Android Studio：
[developer.android.com/studio](https://developer.android.com/studio)

设置环境变量以便gogio可以找到SDK：

```bash
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/<version>
```

---

## 构建 APK

从您的项目根目录：

```bash
gogio -target android -appid com.yourname.yourapp .
```

这会生成“yourapp.apk”。将其安装在连接的设备上：

```bash
adb install yourapp.apk
```

或者直接在连接的设备上运行：

```bash
gogio -target android -appid com.yourname.yourapp -run .
```

---

## 构建 AAR（嵌入现有 Android 项目）

```bash
gogio -target android -buildmode archive -appid com.yourname.yourapp .
```

然后将“.aar”包含在 Android 项目的“libs/”文件夹中，并
将其添加到“build.gradle”：

```groovy
dependencies {
    implementation fileTree(dir: 'libs', include: ['*.aar'])
}
```

在`AndroidManifest.xml`中声明Gio活动：

```xml
<activity
    android:name="org.gioui.GioActivity"
    android:theme="@style/Theme.GioApp"
    android:configChanges="orientation|keyboardHidden"
    android:windowSoftInputMode="adjustResize">
</activity>
```

---

## Android 15+（16kB 页面大小）

从 2025 年 11 月起，Google Play 要求页面大小兼容的 APK 为 16kB。
`gogio` 会自动处理这个问题——只需保持最新：

```bash
go install gioui.org/cmd/gogio@latest
```

---

## 徽标/应用程序图标

通过标准 Android 机制设置您的应用程序图标（在您的
`AndroidManifest.xml` 通过 `android:icon`)，或使用 Proton 的徽标功能
将其绘制在 UI 本身内部：

```go
//go:embed assets/logo.png
var logoBytes []byte

func main() {
    a := proton.New("myapp")
    a.SetLogoBytes(logoBytes) // load once

    a.Window("My App", 480, 800, func(ctx proton.Context) {
        proton.Logo(ctx, 64, 64) // draw it in the layout
        proton.H4(ctx, "My App")
    })
    a.Run()
}
```

---

## 最低 SDK

Gio 支持 Android SDK 16+（Android 4.1、Jelly Bean）。在实践中，
SDK 21 (Android 5.0) 以下的任何设备均低于活跃设备的 1%，
因此，目标 21 是一个合理的最小值。

在你的`AndroidManifest.xml`中设置它：

```xml
<uses-sdk
    android:minSdkVersion="21"
    android:targetSdkVersion="35" />
```

---

## 一个完整的例子

```go
package main

import "github.com/CzaxStudio/proton"

type UI struct {
    btn proton.Clickable
    count int
}

func main() {
    u := &UI{}
    a := proton.New("counter")
    a.ApplyPalette(proton.NordPalette)
    a.Window("Counter", 480, 800, func(ctx proton.Context) {
        proton.Center(ctx, func(ctx proton.Context) {
            proton.H2(ctx, fmt.Sprintf("%d", u.count))
            proton.Gap(ctx, 24)
            proton.Pad(ctx, 8, func(ctx proton.Context) {
                if proton.Button(ctx, &u.btn, "Tap me") {
                    u.count++
                }
            })
        })
    })
    a.Run()
}
```

为 Android 构建：

```bash
gogio -target android -appid com.example.counter .
adb install counter.apk
```

就是这样。您在笔记本电脑上使用“go run .”运行的相同二进制文件将变为
带有一个命令的 Android APK。