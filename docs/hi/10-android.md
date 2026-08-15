#एंड्रॉइड

प्रोटॉन का उपयोग करके एंड्रॉइड ऐप्स बनाएं!

प्रोटोन ऐप्स जियो के नेटिव एंड्रॉइड सपोर्ट के जरिए एंड्रॉइड पर चलते हैं।
आपके डेस्कटॉप पर चलने वाला वही कोड एंड्रॉइड पर चलता है - कोई पुनर्लेखन नहीं,
कोई अलग यूआई परत नहीं।

---

## क्या कार्य करता है

Every Proton widget, layout, and theme works on Android exactly as it
does on desktop. Touch events map to pointer events. The soft keyboard
integrates with `Input` and `TextArea`. `Invalidate()` works correctly
on mobile. The one restriction from Gio's side: Android supports only
one window per app.

---

## बिल्ड टूल इंस्टॉल करें

आपको `गोगियो` की आवश्यकता है, जियो का क्रॉस-संकलन उपकरण:

```bash
go install gioui.org/cmd/gogio@latest
```

आपको एंड्रॉइड एसडीके और एनडीके की भी आवश्यकता है। सबसे आसान रास्ता है Android Studio:
[developer.android.com/studio](https://developer.android.com/studio)

पर्यावरण चर सेट करें ताकि गोगियो एसडीके ढूंढ सके:

```bash
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/<version>
```

---

## एक एपीके बनाएं

आपके प्रोजेक्ट रूट से:

```bash
gogio -target android -appid com.yourname.yourapp .
```

यह `yourapp.apk` उत्पन्न करता है। इसे किसी कनेक्टेड डिवाइस पर इंस्टॉल करें:

```bash
adb install yourapp.apk
```

या किसी कनेक्टेड डिवाइस पर सीधे चलाएं:

```bash
gogio -target android -appid com.yourname.yourapp -run .
```

---

## एक एएआर बनाएं (मौजूदा एंड्रॉइड प्रोजेक्ट में एम्बेड करें)

```bash
gogio -target android -buildmode archive -appid com.yourname.yourapp .
```

फिर अपने एंड्रॉइड प्रोजेक्ट के `libs/` फ़ोल्डर में `.aar` शामिल करें और
इसे `build.gradle` में जोड़ें:

```groovy
dependencies {
    implementation fileTree(dir: 'libs', include: ['*.aar'])
}
```

`AndroidManifest.xml` में Gio गतिविधि घोषित करें:

```xml
<activity
    android:name="org.gioui.GioActivity"
    android:theme="@style/Theme.GioApp"
    android:configChanges="orientation|keyboardHidden"
    android:windowSoftInputMode="adjustResize">
</activity>
```

---

## Android 15+ (16kB page sizes)

Google Play को नवंबर 2025 से 16kB पेज-आकार के संगत APK की आवश्यकता है।
`गोगियो` इसे स्वचालित रूप से संभालता है - बस इसे अद्यतित रखें:

```bash
go install gioui.org/cmd/gogio@latest
```

---

## लोगो/ऐप आइकन

मानक एंड्रॉइड तंत्र के माध्यम से अपना ऐप आइकन सेट करें (अपने में)।
`AndroidManifest.xml` `android:icon` के माध्यम से), या प्रोटॉन के लोगो सुविधा का उपयोग करें
इसे यूआई के अंदर ही खींचने के लिए:

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

## न्यूनतम एसडीके

जियो एंड्रॉइड एसडीके 16+ (एंड्रॉइड 4.1, जेली बीन) को सपोर्ट करता है। व्यवहार में,
एसडीके 21 (एंड्रॉइड 5.0) से नीचे कुछ भी सक्रिय डिवाइस 1% से कम है,
इसलिए 21 को लक्षित करना एक उचित न्यूनतम है।

इसे अपने `AndroidManifest.xml` में सेट करें:

```xml
<uses-sdk
    android:minSdkVersion="21"
    android:targetSdkVersion="35" />
```

---

## एक पूरा उदाहरण

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

Android के लिए बनाएँ:

```bash
gogio -target android -appid com.example.counter .
adb install counter.apk
```

That's it. The same binary you run with `go run .` on your laptop becomes
an Android APK with one command.
