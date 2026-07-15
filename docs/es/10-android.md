#Androide

¡Crea aplicaciones para Android usando Proton!

Las aplicaciones de Proton se ejecutan en Android a través del soporte nativo de Android de Gio.
El mismo código que se ejecuta en su escritorio se ejecuta en Android, sin reescrituras.
sin capa de interfaz de usuario separada.

---

## ¿Qué funciona?

Cada widget, diseño y tema de Proton funciona en Android exactamente como
lo hace en el escritorio. Toque el mapa de eventos para señalar eventos. El teclado suave
se integra con `Input` y `TextArea`. `Invalidar()` funciona correctamente
en el móvil. La única restricción por parte de Gio: Android sólo admite
una ventana por aplicación.

---

## Instalar la herramienta de compilación

Necesitas `gogio`, la herramienta de compilación cruzada de Gio:

```bash
go install gioui.org/cmd/gogio@latest
```

También necesitas el SDK y el NDK de Android. El camino más sencillo es Android Studio:
[desarrollador.android.com/studio](https://developer.android.com/studio)

Configure las variables de entorno para que gogio pueda encontrar el SDK:

```bash
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/<version>
```

---

## Construir un APK

Desde la raíz de su proyecto:

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

## Construir un AAR (insertar en un proyecto de Android existente)

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

## Logotipo/icono de aplicación

Configure el ícono de su aplicación a través del mecanismo estándar de Android (en su
`AndroidManifest.xml` a través de `android:icon`), o use la función del logotipo de Proton
para dibujarlo dentro de la propia interfaz de usuario:

```go
//go:embed assets/logo.png
var logoBytes []byte

función principal() {
    a := protón.Nuevo("miaplicación")
    a.SetLogoBytes(logoBytes) // cargar una vez

a.Window("Mi aplicación", 480, 800, func(ctx proton.Context) {
        proton.Logo(ctx, 64, 64) // dibujarlo en el diseño
        protón.H4(ctx, "Mi aplicación")
    })
    a.Ejecutar()
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

escriba estructura de interfaz de usuario {
    btn protón. Se puede hacer clic
    contar entero
}

función principal() {
    tu := &UI{}
    a := protón.Nuevo("contador")
    a.ApplyPalette (protón.NordPalette)
    a.Window("Contador", 480, 800, func(ctx proton.Context) {
        protón.Centro(ctx, func(ctx protón.Contexto) {
            protón.H2(ctx, fmt.Sprintf("%d", u.count))
            protón.Gap(ctx, 24)
            protón.Pad(ctx, 8, func(ctx protón.Context) {
                if proton.Button(ctx, &u.btn, "Tocame") {
                    u.count++
                }
            })
        })
    })
    a.Ejecutar()
}
```

Construir para Android:

```bash
gogio -target android -appid com.example.counter .
adb install counter.apk
```

Eso es todo. El mismo binario que ejecutas con `go run.` en tu computadora portátil se convierte en
un APK de Android con un comando.