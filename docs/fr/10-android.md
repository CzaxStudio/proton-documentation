#Androïde

Créez des applications Android à l'aide de Proton !

Les applications Proton fonctionnent sur Android via la prise en charge Android native de Gio.
Le même code qui s'exécute sur votre bureau s'exécute sur Android — pas de réécriture,
pas de couche d'interface utilisateur distincte.

---

## Ce qui fonctionne

Chaque widget, mise en page et thème Proton fonctionne sur Android exactement comme il
fait sur le bureau. Touchez la carte des événements pour pointer les événements. Le clavier logiciel
s'intègre à `Input` et `TextArea`. `Invalidate()` fonctionne correctement
sur mobile. La seule restriction du côté de Gio : Android ne prend en charge que
une fenêtre par application.

---

## Installer l'outil de build

Vous avez besoin de `gogio`, l'outil de compilation croisée de Gio :

```bash
go install gioui.org/cmd/gogio@latest
```

Vous avez également besoin du SDK Android et du NDK. Le chemin le plus simple est Android Studio :
[developer.android.com/studio](https://developer.android.com/studio)

Définissez les variables d'environnement pour que gogio puisse trouver le SDK :

```bash
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/<version>
```

---

## Créer un APK

Depuis la racine de votre projet :

```bash
gogio -target android -appid com.yourname.yourapp .
```

Cela produit `yourapp.apk`. Installez-le sur un appareil connecté :

```bash
adb install yourapp.apk
```

Ou exécutez directement sur un appareil connecté :

```bash
gogio -target android -appid com.yourname.yourapp -run .
```

---

## Créer un AAR (intégrer dans un projet Android existant)

```bash
gogio -target android -buildmode archive -appid com.yourname.yourapp .
```

Incluez ensuite le `.aar` dans le dossier `libs/` de votre projet Android et
ajoutez-le à `build.gradle` :

```groovy
dependencies {
    implementation fileTree(dir: 'libs', include: ['*.aar'])
}
```

Déclarez l'activité Gio dans `AndroidManifest.xml` :

```xml
<activity
    android:name="org.gioui.GioActivity"
    android:theme="@style/Theme.GioApp"
    android:configChanges="orientation|keyboardHidden"
    android:windowSoftInputMode="adjustResize">
</activity>
```

---

## Android 15+ (taille de page de 16 Ko)

Google Play nécessite des APK compatibles avec une taille de page de 16 Ko à partir de novembre 2025.
`gogio` gère cela automatiquement — il suffit de le garder à jour :

```bash
go install gioui.org/cmd/gogio@latest
```

---

## Logo / icône de l'application

Définissez l'icône de votre application via le mécanisme Android standard (dans votre
`AndroidManifest.xml` via `android:icon`), ou utilisez la fonction de logo de Proton
pour le dessiner dans l'interface utilisateur elle-même :

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

## SDK minimal

Gio prend en charge Android SDK 16+ (Android 4.1, Jelly Bean). En pratique,
tout ce qui est inférieur au SDK 21 (Android 5.0) représente moins de 1 % des appareils actifs,
donc cibler 21 est un minimum raisonnable.

Définissez-le dans votre `AndroidManifest.xml` :

```xml
<uses-sdk
    android:minSdkVersion="21"
    android:targetSdkVersion="35" />
```

---

## Un exemple complet

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

Construire pour Android :

```bash
gogio -target android -appid com.example.counter .
adb install counter.apk
```

C'est ça. Le même binaire que vous exécutez avec « go run . » sur votre ordinateur portable devient
un APK Android avec une seule commande.