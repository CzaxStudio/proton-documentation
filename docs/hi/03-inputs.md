# इनपुट

टेक्स्ट फ़ील्ड, चेकबॉक्स, टॉगल, रेडियो बटन, स्लाइडर, नंबर स्टेपर,
ड्रॉपडाउन, और एक स्पष्ट बटन के साथ एक खोज फ़ील्ड।

---

## इनपुट - सिंगल-लाइन टेक्स्ट फ़ील्ड

```go
type UI struct {
    email proton.Editor
}

proton.Input(ctx, &u.email, "your@email.com")

// read the value any time
fmt.Println(u.email.Text())
```

दूसरा तर्क प्लेसहोल्डर टेक्स्ट है जो फ़ील्ड खाली होने पर दिखाया जाता है।

```go
proton.Input(ctx proton.Context, state *proton.Editor, hint string)
```

---

## टेक्स्टएरिया - मल्टी-लाइन टेक्स्ट फ़ील्ड

इनपुट के समान लेकिन उपयोगकर्ता लाइनें जोड़ने के लिए Enter दबा सकता है। संदेशों के लिए अच्छा है,
नोट्स, एक पंक्ति से अधिक लंबी कोई भी चीज़।

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

## सर्चइनपुट

बाईं ओर एक खोज आइकन वाला एक टेक्स्ट फ़ील्ड और एक स्पष्ट (×) बटन
तब प्रकट होता है जब कुछ साफ़ करना होता है। वर्तमान क्वेरी स्ट्रिंग लौटाता है.

```go
type UI struct {
    search proton.SearchState
}

q := proton.SearchInput(ctx, &u.search, "Search notes...")

// filter your data using q
filtered := filter(items, q)
```

`SearchState` में `Editor` और आंतरिक स्पष्ट बटन - घोषित करें दोनों हैं
आपकी संरचना में से एक, इसे स्वयं न बनाएं।

```go
proton.SearchInput(ctx proton.Context, state *proton.SearchState, placeholder string) string
```

---

## चेकबॉक्स

उपयोगकर्ता द्वारा टॉगल किए गए फ़्रेम पर `सही` लौटाता है। से वर्तमान मूल्य पढ़ें
`राज्य.मूल्य`.

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

## टॉगल करें

एक सामग्री-शैली चालू/बंद स्विच। चेकबॉक्स के समान एपीआई, अलग लुक।
उन सेटिंग्स के लिए उपयोग करें जो सेव बटन की आवश्यकता के बजाय तुरंत प्रभावी होती हैं।

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

## रेडियो की बटन

किसी समूह से बिल्कुल एक विकल्प चुनने के लिए। समूह के सभी बटन साझा करते हैं
एक `proton.Enum` राज्य फ़ील्ड। `कुंजी` वह है जो `group.Value` में संग्रहीत होती है
जब वह विकल्प चुना जाता है.

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

चयन परिवर्तन के फ़्रेम पर `सही` लौटाता है।

```go
proton.RadioButton(ctx proton.Context, group *proton.Enum, key string, label string) bool
```

क्षैतिज रेडियो बटन - उन्हें `पंक्ति` में लपेटें:

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

## स्लाइडर

0.0 और 1.0 के बीच मान के लिए एक क्षैतिज ड्रैग हैंडल। इसे स्केल करें
आपको जो भी रेंज चाहिए।

```go
type UI struct {
    vol proton.Float
}

v := proton.Slider(ctx, &u.vol)

// v is 0.0–1.0, scale it
volume := int(v * 100)
proton.Caption(ctx, fmt.Sprintf("Volume: %d%%", volume))
```

आप सीधे राज्य से भी मूल्य पढ़ सकते हैं:

```go
proton.Slider(ctx, &u.vol)
fmt.Println(u.vol.Value) // 0.0 to 1.0
```

```go
proton.Slider(ctx proton.Context, state *proton.Float) float32
```

---

## प्रोगेस बार

इंटरैक्टिव नहीं - बस प्रगति को एक भरे हुए बार के रूप में दिखाता है। एक फ़्लोट32 पास करें
0.0 और 1.0 के बीच.

```go
proton.ProgressBar(ctx, 0.65)    // 65% done
proton.ProgressBar(ctx, 1.0)     // done
proton.ProgressBar(ctx, progress) // from a variable
```

```go
proton.ProgressBar(ctx proton.Context, progress float32)
```

---

## नंबरइन्पुट

- और + बटन वाला एक स्टेपर। आपके लिए न्यूनतम, अधिकतम और चरण आकार संभालता है।
वर्तमान मान लौटाता है.

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

पहली बार उपयोग करने पर मान `मिनट` से शुरू होता है। चरण >= 1 पूर्णांक प्रदर्शित करता है;
चरण <1 दो दशमलव स्थान प्रदर्शित करता है।

---

## चयन बॉक्स

एक ड्रॉपडाउन चयनकर्ता. वर्तमान में चयनित विकल्प का सूचकांक लौटाता है।

```go
type UI struct {
    lang proton.SelectBoxState
}

langs := []string{"Go", "Rust", "Zig", "C", "Python"}

i := proton.SelectBox(ctx, &u.lang, langs)
proton.Caption(ctx, "You picked: "+langs[i])
```

क्लिक करने पर बटन के नीचे ड्रॉपडाउन दिखाई देता है। कहीं भी क्लिक करना
बाहर यह इसे बंद कर देता है।

```go
proton.SelectBox(ctx proton.Context, state *proton.SelectBoxState, options []string) int
```

`चयनित` 0 से शुरू होता है। यदि आपको जानना है तो `state.Selected >= 0` जांचें
क्या उपयोगकर्ता ने स्पष्ट रूप से कुछ चुना है।

---

## फुल फॉर्म उदाहरण

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