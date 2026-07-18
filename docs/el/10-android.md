# Android

Δημιουργήστε εφαρμογές Android χρησιμοποιώντας Proton!

Οι εφαρμογές Proton εκτελούνται σε Android μέσω της εγγενούς υποστήριξης Android του Gio.
Ο ίδιος κώδικας που εκτελείται στον επιτραπέζιο υπολογιστή σας εκτελείται σε Android — χωρίς επανεγγραφή,
δεν υπάρχει ξεχωριστό επίπεδο διεπαφής χρήστη.

---

## Τι λειτουργεί

Κάθε γραφικό στοιχείο Proton, διάταξη και θέμα λειτουργεί στο Android ακριβώς όπως είναι
κάνει στην επιφάνεια εργασίας. Αγγίξτε το χάρτη συμβάντων σε συμβάντα δείκτη. Το μαλακό πληκτρολόγιο
ενσωματώνεται με «Input» και «TextArea». Το "Invalidate()" λειτουργεί σωστά
στο κινητό. Ο ένας περιορισμός από την πλευρά του Gio: Το Android υποστηρίζει μόνο
ένα παράθυρο ανά εφαρμογή.

---

## Εγκαταστήστε το εργαλείο δημιουργίας

Χρειάζεστε το «gogio», το εργαλείο πολλαπλής μεταγλώττισης του Gio:

```bash
go install gioui.org/cmd/gogio@latest
```

Χρειάζεστε επίσης το Android SDK και NDK. Η πιο εύκολη διαδρομή είναι το Android Studio:
[developer.android.com/studio](https://developer.android.com/studio)

Ορίστε τις μεταβλητές περιβάλλοντος ώστε το gogio να μπορεί να βρει το SDK:

```bash
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/<version>
```

---

## Δημιουργήστε ένα APK

Από τη ρίζα του έργου σας:

```bash
gogio -target android -appid com.yourname.yourapp .
```

Αυτό παράγει το "yourapp.apk". Εγκαταστήστε το σε μια συνδεδεμένη συσκευή:

```bash
adb install yourapp.apk
```

Ή εκτελέστε απευθείας σε μια συνδεδεμένη συσκευή:

```bash
gogio -target android -appid com.yourname.yourapp -run .
```

---

## Δημιουργία AAR (ενσωμάτωση σε υπάρχον έργο Android)

```bash
gogio -target android -buildmode archive -appid com.yourname.yourapp .
```

Στη συνέχεια, συμπεριλάβετε το «.aar» στον φάκελο «libs/» του έργου Android και
προσθέστε το στο `build.gradle`:

```groovy
dependencies {
    implementation fileTree(dir: 'libs', include: ['*.aar'])
}
```

Δηλώστε τη δραστηριότητα Gio στο `AndroidManifest.xml`:

```xml
<activity
    android:name="org.gioui.GioActivity"
    android:theme="@style/Theme.GioApp"
    android:configChanges="orientation|keyboardHidden"
    android:windowSoftInputMode="adjustResize">
</activity>
```

---

## Android 15+ (μεγέθη σελίδας 16 kB)

Το Google Play απαιτεί APK 16 kB συμβατά με μέγεθος σελίδας από τον Νοέμβριο του 2025.
Το "gogio" το χειρίζεται αυτόματα — απλώς κρατήστε το ενημερωμένο:

```bash
go install gioui.org/cmd/gogio@latest
```

---

## Λογότυπο / εικονίδιο εφαρμογής

Ρυθμίστε το εικονίδιο της εφαρμογής σας μέσω του τυπικού μηχανισμού Android (στο δικό σας
«AndroidManifest.xml» μέσω «android:icon») ή χρησιμοποιήστε τη λειτουργία λογότυπου της Proton
για να το σχεδιάσετε μέσα στο ίδιο το UI:

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

## Ελάχιστο SDK

Το Gio υποστηρίζει Android SDK 16+ (Android 4.1, Jelly Bean). Στην πράξη,
οτιδήποτε κάτω από το SDK 21 (Android 5.0) είναι κάτω από το 1% των ενεργών συσκευών,
οπότε η στόχευση 21 είναι ένα εύλογο ελάχιστο.

Ρυθμίστε το στο «AndroidManifest.xml»:

```xml
<uses-sdk
    android:minSdkVersion="21"
    android:targetSdkVersion="35" />
```

---

## Ένα πλήρες παράδειγμα

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

Κατασκευή για Android:

```bash
gogio -target android -appid com.example.counter .
adb install counter.apk
```

Αυτό είναι όλο. Γίνεται το ίδιο δυαδικό αρχείο που τρέχετε με το «go run .» στον φορητό υπολογιστή σας
ένα Android APK με μία εντολή.