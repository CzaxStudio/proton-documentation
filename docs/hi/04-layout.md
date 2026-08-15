# लेआउट

विजेट डिफ़ॉल्ट रूप से लंबवत रूप से स्टैक होते हैं। बाकी सब कुछ ऑप्ट-इन है।

---

## गैप - चीजों के बीच में जगह रखें

सबसे अधिक उपयोग किया जाने वाला लेआउट फ़ंक्शन. रिक्त ऊर्ध्वाधर स्थान सम्मिलित करता है.

```go
proton.H4(ctx, "Section Title")
proton.Gap(ctx, 8)
proton.Label(ctx, "Section content.")
proton.Gap(ctx, 24)
proton.H4(ctx, "Next Section")
```

```go
proton.Gap(ctx proton.Context, dp float32)
```

8dp एक छोटा सा अंतर है. 16dp मध्यम है. 24dp बड़ा है. वे तीन अधिकांश मामलों को कवर करते हैं।

---

## पंक्ति - अगल-बगल

बच्चों को क्षैतिज रूप से बाएँ से दाएँ रखें।

```go
proton.Row(ctx,
    func(ctx proton.Context) { proton.Label(ctx, "Name:") },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) { proton.Label(ctx, "Alice") },
)
```

प्रत्येक बच्चा एक `func(proton.Context)` है। इसके अंदर आपको जो भी विजेट चाहिए उसे कॉल करें।

```go
proton.Row(ctx proton.Context, widgets ...func(proton.Context))
```

---

## कॉलम - स्पष्ट लंबवत समूह

नामित समूह के रूप में बच्चों को लंबवत रूप से ढेर करें। शीर्ष स्तर पर शायद ही इसकी आवश्यकता हो
(विजेट स्वचालित रूप से स्टैक हो जाते हैं), लेकिन 'पंक्ति' या 'स्प्लिट' के अंदर उपयोगी होते हैं
दाहिनी ओर अनेक वस्तुओं का ढेर होना आवश्यक है।

```go
proton.Row(ctx,
    func(ctx proton.Context) {
        proton.Label(ctx, "Left side")
    },
    func(ctx proton.Context) { proton.Gap(ctx, 16) },
    func(ctx proton.Context) {
        proton.Column(ctx,
            func(ctx proton.Context) { proton.Label(ctx, "Right top") },
            func(ctx proton.Context) { proton.Gap(ctx, 4) },
            func(ctx proton.Context) { proton.Muted(ctx, "Right bottom") },
        )
    },
)
```

```go
proton.Column(ctx proton.Context, widgets ...func(proton.Context))
```

---

## रोस्प्रेड - बीच में जगह

पंक्ति की तरह, लेकिन बच्चों के बीच बचे हुए क्षैतिज स्थान को धक्का देकर डालता है
पहला बाएँ किनारे से और अंतिम दाएँ किनारे से।

```go
// title on the left, version on the right
proton.RowSpread(ctx,
    func(ctx proton.Context) { proton.H5(ctx, "My App") },
    func(ctx proton.Context) { proton.Caption(ctx, "v1.2.0") },
)
```

```go
proton.RowSpread(ctx proton.Context, widgets ...func(proton.Context))
```

---

## रोएंड - सब कुछ दाहिनी ओर

सभी बच्चों को दाहिनी ओर धकेलता है।

```go
proton.RowEnd(ctx,
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.OutlineButton(ctx, &u.cancel, "Cancel") { handleCancel() }
        })
    },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.save, "Save") { handleSave() }
        })
    },
)
```

```go
proton.RowEnd(ctx proton.Context, widgets ...func(proton.Context))
```

---

## GrowRow and GrowColumn — Stretchy Layouts

जब एक बच्चे को बची हुई सारी जगह भरने की ज़रूरत होती है और दूसरे बच्चे उनके बने रहते हैं
प्राकृतिक आकार, `GrowRow` (क्षैतिज) या `GrowColumn` (ऊर्ध्वाधर) का उपयोग करें
`ग्रोआइटम` और `फिक्स्डआइटम`।

```go
// search bar: label fixed, input stretches, button fixed
proton.GrowRow(ctx,
    proton.FixedItem(ctx, func(ctx proton.Context) {
        proton.Label(ctx, "Search:")
    }),
    proton.GrowItem(ctx, func(ctx proton.Context) {
        proton.Input(ctx, &u.search, "Type to search...")
    }),
    proton.FixedItem(ctx, func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.searchBtn, "Go") { doSearch() }
        })
    }),
)
```

`GrowItem` शेष सारी जगह ले लेता है। `FixedItem` केवल वही लेता है जिसकी उसे आवश्यकता है।
एकाधिक `GrowItem` ने शेष स्थान को समान रूप से विभाजित किया।

```go
proton.GrowRow(ctx proton.Context, children ...proton.FlexItem)
proton.GrowColumn(ctx proton.Context, children ...proton.FlexItem)
proton.GrowItem(ctx proton.Context, fn func(proton.Context)) proton.FlexItem
proton.FixedItem(ctx proton.Context, fn func(proton.Context)) proton.FlexItem
```

### फ्लेक्सस्पेसर - भाई-बहनों को अलग करें

एक खिंचावदार खाली स्थान. उन्हें विपरीत दिशा में धकेलने के लिए इसे `FixedItem` के बीच रखें
`RowSpread` का उपयोग किए बिना किनारे।

```go
proton.GrowRow(ctx,
    proton.FixedItem(ctx, func(ctx proton.Context) { proton.Caption(ctx, "left") }),
    proton.FlexSpacer(),
    proton.FixedItem(ctx, func(ctx proton.Context) { proton.Caption(ctx, "right") }),
)
```

```go
proton.FlexSpacer() proton.FlexItem
```

---

## Split — Side-by-Side Panes

Divides available width between two sections. `leftFraction` is the proportion
the left pane gets, from 0.0 to 1.0.

```go
proton.Split(ctx, 0.35,
    func(ctx proton.Context) {
        // sidebar — gets 35% of the width
        proton.Label(ctx, "Sidebar")
    },
    func(ctx proton.Context) {
        // content — gets the remaining 65%
        proton.Label(ctx, "Content")
    },
)
```

```go
proton.Split(ctx proton.Context, leftFraction float32, left func(proton.Context), right func(proton.Context))
```

### एचएसप्लिट - ऊपर और नीचे

वही विचार लेकिन लंबवत.

```go
proton.HSplit(ctx, 0.7,
    func(ctx proton.Context) { proton.Label(ctx, "Main content") },
    func(ctx proton.Context) { proton.Label(ctx, "Status bar") },
)
```

```go
proton.HSplit(ctx proton.Context, topFraction float32, top func(proton.Context), bottom func(proton.Context))
```

### ResizeSplit - उपयोगकर्ता डिवाइडर को खींच सकता है

स्प्लिट की तरह लेकिन उपयोगकर्ता दो पैन के बीच हैंडल को खींच सकता है
उनका आकार बदलें. `डिफ़ॉल्टफ़्रैक्शन` प्रारंभिक स्थिति है।

```go
type UI struct {
    split proton.ResizeSplitState
}

proton.ResizeSplit(ctx, &u.split, 0.30, leftFn, rightFn)
```

`ResizeSplitState.Fraction` 0 से शुरू होता है और `defaultFraction` पर सेट हो जाता है
पहले फ्रेम पर. इसके बाद यूजर की ड्रैग पोजीशन याद आ जाती है.

```go
proton.ResizeSplit(ctx proton.Context, state *proton.ResizeSplitState, defaultFraction float32, left func(proton.Context), right func(proton.Context))
proton.ResizeHSplit(ctx proton.Context, state *proton.ResizeSplitState, defaultFraction float32, top func(proton.Context), bottom func(proton.Context))
```

---

## केंद्र

सामग्री को उपलब्ध स्थान के केंद्र में रखें। खाली राज्यों के लिए बढ़िया
और स्क्रीन लोड हो रही है।

```go
proton.Center(ctx, func(ctx proton.Context) {
    proton.Muted(ctx, "Nothing here yet.")
})
```

```go
proton.Center(ctx proton.Context, fn func(proton.Context))
```

---

## Padding

### पैड - सभी चार भुजाएँ

```go
proton.Pad(ctx, 16, func(ctx proton.Context) {
    proton.Label(ctx, "16dp of breathing room on all sides")
})
```

### PadH - केवल बाएँ और दाएँ

```go
proton.PadH(ctx, 24, func(ctx proton.Context) {
    proton.Label(ctx, "horizontal padding only")
})
```

### पैडवी - केवल ऊपर और नीचे

```go
proton.PadV(ctx, 12, func(ctx proton.Context) {
    proton.Label(ctx, "vertical padding only")
})
```

### पैडसाइड्स - प्रत्येक किनारा व्यक्तिगत रूप से

तर्क ऊपर, दाएँ, नीचे, बाएँ हैं - सीएसएस मार्जिन/पैडिंग के समान क्रम।

```go
proton.PadSides(ctx, 8, 16, 8, 16, func(ctx proton.Context) {
    proton.Label(ctx, "8dp top/bottom, 16dp left/right")
})
```

```go
proton.Pad(ctx proton.Context, dp float32, fn func(proton.Context))
proton.PadH(ctx proton.Context, dp float32, fn func(proton.Context))
proton.PadV(ctx proton.Context, dp float32, fn func(proton.Context))
proton.PadSides(ctx proton.Context, top, right, bottom, left float32, fn func(proton.Context))
```

---

## ग्रिड - फिक्स्ड-कॉलम ग्रिड

बच्चों को निश्चित संख्या में कॉलम वाले ग्रिड में व्यवस्थित करता है। प्रत्येक कोशिका
उपलब्ध चौड़ाई का बराबर हिस्सा मिलता है।

```go
proton.Grid(ctx, 3, 8,   // 3 columns, 8dp gap
    func(ctx proton.Context) { proton.Label(ctx, "one") },
    func(ctx proton.Context) { proton.Label(ctx, "two") },
    func(ctx proton.Context) { proton.Label(ctx, "three") },
    func(ctx proton.Context) { proton.Label(ctx, "four") },
    func(ctx proton.Context) { proton.Label(ctx, "five") },
)
```

कोशिकाएँ स्वचालित रूप से नई पंक्तियों में लपेट जाती हैं। यदि अंतिम पंक्ति में इससे कम है
`cols` सेल, शेष स्लॉट खाली हैं।

```go
proton.Grid(ctx proton.Context, cols int, gapDp float32, cells ...func(proton.Context))
```

---

## ZStack - चीज़ों को एक-दूसरे के ऊपर बनाएँ

एक ही स्थान पर एकाधिक विजेट परतें। पहला बच्चा है
तल; अंतिम शीर्ष पर है.

```go
proton.ZStack(ctx,
    func(ctx proton.Context) {
        // bottom layer — a background shape
        proton.RoundRect(ctx, proton.RGB(0x1e1e2e), 0, 100, 12)
    },
    func(ctx proton.Context) {
        // top layer — text floating over the shape
        proton.Center(ctx, func(ctx proton.Context) {
            proton.Label(ctx, "Text on top")
        })
    },
)
```

```go
proton.ZStack(ctx proton.Context, layers ...func(proton.Context))
```

---

## MinSize and MaxWidth — Size Constraints

```go
// at least 200dp wide and 48dp tall
proton.MinSize(ctx, 200, 48, func(ctx proton.Context) {
    if proton.Button(ctx, &u.btn, "OK") { handleOK() }
})

// no wider than 420dp — keeps forms readable on wide windows
proton.MaxWidth(ctx, 420, func(ctx proton.Context) {
    proton.Input(ctx, &u.email, "Email address")
    proton.Gap(ctx, 8)
    proton.Input(ctx, &u.password, "Password")
})
```

```go
proton.MinSize(ctx proton.Context, widthDp, heightDp float32, fn func(proton.Context))
proton.MaxWidth(ctx proton.Context, widthDp float32, fn func(proton.Context))
```

उस अक्ष को अप्रतिबंधित छोड़ने के लिए `MinSize` के किसी भी आयाम के लिए 0 पास करें।

---

## A Typical Two-Column App

```go
func draw(ctx proton.Context, u *UI) {
    // header
    proton.PadSides(ctx, 0, 0, 12, 0, func(ctx proton.Context) {
        proton.RowSpread(ctx,
            func(ctx proton.Context) { proton.H5(ctx, "My App") },
            func(ctx proton.Context) { proton.Caption(ctx, "v1.0") },
        )
    })
    proton.Divider(ctx)
    proton.Gap(ctx, 16)

    // body
    proton.ResizeSplit(ctx, &u.split, 0.28,
        func(ctx proton.Context) {
            drawSidebar(ctx, u)
        },
        func(ctx proton.Context) {
            proton.PadH(ctx, 16, func(ctx proton.Context) {
                drawContent(ctx, u)
            })
        },
    )
}
```