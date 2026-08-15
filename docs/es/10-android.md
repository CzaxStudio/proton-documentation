# Android

¡Crea aplicaciones para Android usando Proton!

Proton apps run on Android through Gio's native Android support.
The same code that runs on your desktop runs on Android — no rewrites,
no separate UI layer.

---

## ¿Qué funciona?

Every Proton widget, layout, and theme works on Android exactly as it
does on desktop. Touch events map to pointer events. The soft keyboard
integrates with `Input` and `TextArea`. `Invalidate()` works correctly
on mobile. The one restriction from Gio's side: Android supports only
one window per app.

---

## Instalar la herramienta de compilación

Necesitas `gogio`, la herramienta de compilación cruzada de Gio:

```bash
go install gioui.org/cmd/gogio@latest
```

También necesitas el SDK y el NDK de Android. El camino más sencillo es Android Studio:
[desarrollador.android.com/studio](https://developer.android.com/studio)

Set the environment variables so gogio can find the SDK:

```bash
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/<version>
```

---

## Construir un APK

From your project root:

```bash
gogio -target android -appid com.yourname.yourapp .
```

Esto produce `yourapp.apk`. Instálelo en un dispositivo conectado:

```bash
adb install yourapp.apk
```

O ejecútelo directamente en un dispositivo conectado:

```bash
gogio -target android -appid com.yourname.yourapp -run .
```

---

## Build an AAR (embed in an existing Android project)

```bash
gogio -target android -buildmode archive -appid com.yourname.yourapp .
```

Luego incluya el `.aar` en la carpeta `libs/` de su proyecto de Android y
agréguelo a `build.gradle`:

```groovy
dependencies {
    implementation fileTree(dir: 'libs', include: ['*.aar'])
}
```

Declare la actividad Gio en `AndroidManifest.xml`:

```xml
<activity
    android:name="org.gioui.GioActivity"
    android:theme="@style/Theme.GioApp"
    android:configChanges="orientation|keyboardHidden"
    android:windowSoftInputMode="adjustResize">
</activity>
```

---

## Android 15+ (tamaños de página de 16 kB)

Google Play requiere APK compatibles con un tamaño de página de 16 kB a partir de noviembre de 2025.
`gogio` maneja esto automáticamente; solo mantenlo actualizado:

```bash
go install gioui.org/cmd/gogio@latest
```

---

## Logo / app icon

Configure el ícono de su aplicación a través del mecanismo estándar de Android (en su
`AndroidManifest.xml` a través de `android:icon`), o use la función del logotipo de Proton
para dibujarlo dentro de la propia interfaz de usuario:

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

## SDK mínimo

Gio es compatible con Android SDK 16+ (Android 4.1, Jelly Bean). En la práctica,
cualquier cosa por debajo del SDK 21 (Android 5.0) está por debajo del 1% de los dispositivos activos,
por lo que apuntar a 21 es un mínimo razonable.

Configúrelo en su `AndroidManifest.xml`:

```xml
<uses-sdk
    android:minSdkVersion="21"
    android:targetSdkVersion="35" />
```

---

## Un ejemplo completo

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

Build for Android:

```bash
gogio -target android -appid com.example.counter .
adb install counter.apk
```

That's it. The same binary you run with `go run .` on your laptop becomes
an Android APK with one command.
