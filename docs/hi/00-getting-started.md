# शुरू करना

आप गो में एक डेस्कटॉप ऐप बनाना चाहते हैं। आप सही जगह पर आए हैं।

---

## पूर्वावश्यकताएँ

1.22 या नये पर जाएँ। के साथ जांच:

```bash
go version
```

यदि आप लिनक्स पर हैं, तो आपको तीन सिस्टम पैकेजों की भी आवश्यकता होगी। macOS और Windows उपयोगकर्ता
इसे छोड़ सकते हैं और आत्मसंतुष्ट महसूस कर सकते हैं:

```bash
sudo apt install libwayland-dev libxkbcommon-dev libvulkan-dev
```

---

## स्थापित करना

आपकी प्रोजेक्ट निर्देशिका में:

```bash
go get github.com/CzaxStudio/proton
go mod tidy
```

`गो मॉड साफ` कदम महत्वपूर्ण है - यह जियो की सकर्मक निर्भरता को खींचता है
और उन्हें `go.sum` पर लिखता है। इसे छोड़ें और आप हर जगह लाल धारियाँ देखेंगे।

---

## आपकी पहली विंडो

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

एक विंडो प्रकट होती है. यह 9 पंक्तियों में एक संपूर्ण, कार्यशील GUI ऐप है। कोई एक्सएमएल नहीं,
कोई `इम्प्लीमेंट्स रननेबल` नहीं, कोई निर्भरता इंजेक्शन ढांचा नहीं, कोई वेबपैक नहीं।

---

## राज्य जोड़ना

विजेट जो कुछ करते हैं - बटन, टेक्स्ट इनपुट, चेकबॉक्स - को एक स्थिति की आवश्यकता होती है
अपनी संरचना में फ़ील्ड। उन्हें एक बार घोषित करें, विजेट्स को पॉइंटर्स पास करें।

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

ड्रा फ़ंक्शन हर फ़्रेम पर चलता है। `बटन` फ्रेम पर `सही` लौटाता है
क्लिक हो जाता है. `if` ब्लॉक चलता है, नाम प्रिंट करता है और बस इतना ही।

---

## राज्य के प्रकार

इन्हें अपनी यूआई संरचना में घोषित करें। वे सभी शून्य-मूल्य के लिए तैयार हैं - कोई कंस्ट्रक्टर नहीं।

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

प्रति विजेट एक फ़ील्ड. दो बटनों के बीच `क्लिक करने योग्य` साझा न करें - वे ऐसा करेंगे
दोनों एक ही क्लिक पर सक्रिय होते हैं, जो लगभग कभी भी वह नहीं होता जो आप चाहते हैं।

---

## लेआउट कैसे काम करता है

बिना किसी लेआउट रैपर के, विजेट ऊपर से नीचे तक लंबवत रूप से ढेर हो जाते हैं। `गैप`
उनके बीच जगह जोड़ता है।

```go
proton.H4(ctx, "Settings")
proton.Gap(ctx, 12)
proton.Label(ctx, "Adjust your preferences below.")
proton.Gap(ctx, 16)
proton.Divider(ctx)
proton.Gap(ctx, 16)
proton.Toggle(ctx, &u.darkMode, "Dark mode")
```

अगल-बगल लेआउट के लिए, `पंक्ति` का उपयोग करें। अधिक नियंत्रण के लिए, [04-लेआउट.एमडी](./04-लेआउट.एमडी) देखें।

---

## बटनों को एक लेआउट रैपर की आवश्यकता होती है

बटन (और अन्य इंटरैक्टिव विजेट) लेआउट हेल्पर के अंदर होने चाहिए
सही ढंग से पंजीकरण करने के लिए क्लिक करें। यह एक जिओ चीज़ है - लेआउट पास क्या है
स्क्रीन पर हिट क्षेत्र स्थापित करता है।

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

यदि आप बिना किसी ड्रा फ़ंक्शन के सबसे ऊपरी स्तर पर एक बटन लगाते हैं
रैपर, यह चित्र तो बनाएगा लेकिन क्लिक पर प्रतिक्रिया नहीं देगा। `Pad(ctx, 0, ...)` है
यदि आप शून्य दृश्य पैडिंग चाहते हैं तो न्यूनतम आवरण।

---

## थीमिंग

```go
a := proton.New("myapp")
a.ApplyPalette(proton.NordPalette)
a.Window("App", 800, 600, draw)
a.Run()
```

46 पैलेट बनाए गए हैं। उन सभी के लिए [07-theming.md](./07-theming.md) देखें
और हेक्स रंग कोड के साथ अपना खुद का निर्माण करने के लिए।

---

## एकाधिक खिड़कियाँ

```go
a := proton.New("app")
a.Window("Main", 800, 600, drawMain)
a.Window("Settings", 400, 300, drawSettings)
a.Run() // opens both
```

सभी विंडो समान `*ऐप` साझा करती हैं। यह प्रक्रिया सभी विंडो तक सक्रिय रहती है
बंद हैं.

---

## अगले कदम

- **[01-text.md](./01-text.md)** — टेक्स्ट विजेट
- **[02-बटन.एमडी](./02-बटन.एमडी)** — बटन और क्लिक करने योग्य क्षेत्र
- **[03-inputs.md](./03-inputs.md)** — टेक्स्ट फ़ील्ड, टॉगल, स्लाइडर
- **[04-layout.md](./04-layout.md)** — स्क्रीन पर चीजों को व्यवस्थित करना
- **[09-examples.md](./09-examples.md)** - कॉपी करने के लिए पूर्ण कार्यशील प्रोग्राम