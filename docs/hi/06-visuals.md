# दृश्य विजेट

आकृतियाँ, कार्ड, छवियाँ, बैज, प्रगति रिंग, टेबल, अवतार - चीज़ें
इससे आपका ऐप ऐसा दिखता है जैसे इसे किसी उद्देश्य से डिज़ाइन किया गया हो।

---

##विभाजक

एक पतला क्षैतिज नियम. इसे अनुभागों के बीच प्रयोग करें.

```go
proton.H5(ctx, "Section One")
proton.Gap(ctx, 8)
proton.Label(ctx, "Some content.")
proton.Gap(ctx, 12)
proton.Divider(ctx)
proton.Gap(ctx, 12)
proton.H5(ctx, "Section Two")
```

```go
proton.Divider(ctx proton.Context)
```

### लेबल डिवाइडर

डिवाइडर के समान लेकिन एक केंद्रित टेक्स्ट लेबल के साथ।

```go
proton.LabeledDivider(ctx, "Advanced Settings")
proton.LabeledDivider(ctx, "")   // plain divider — same as Divider
```

```go
proton.LabeledDivider(ctx proton.Context, label string)
```

---

## रेक्ट

एक ठोस रंग का आयत. भरने के लिए चौड़ाई या ऊंचाई के लिए 0 पास करें
उस अक्ष पर उपलब्ध स्थान.

```go
// 100dp wide, 4dp tall accent bar
proton.Rect(ctx, proton.RGB(0x89b4fa), 100, 4)

// full width, 2dp tall separator
proton.Rect(ctx, proton.RGB(0x333344), 0, 2)

// fill all available space
proton.Rect(ctx, proton.RGB(0x1a1a2e), 0, 0)
```

```go
proton.Rect(ctx proton.Context, c color.NRGBA, widthDp, heightDp float32)
```

### राउंडरेक्ट

रेक्ट के समान लेकिन गोल कोनों के साथ।

```go
proton.RoundRect(ctx, proton.RGB(0x2a2a3e), 200, 60, 12)  // 12dp corner radius
proton.RoundRect(ctx, proton.RGB(0x4c566a), 0, 40, 20)    // full width, pill shape
```

```go
proton.RoundRect(ctx proton.Context, c color.NRGBA, widthDp, heightDp, radiusDp float32)
```

---

## कार्ड

सूक्ष्म छाया के साथ गद्देदार, गोल-आयताकार पृष्ठभूमि के अंदर सामग्री।
संबंधित सामग्री को समूहीकृत करने के लिए गो-टू कंटेनर।

```go
proton.Card(ctx, proton.RGB(0x2a2a3e), 12, 16, func(ctx proton.Context) {
    proton.H6(ctx, "Card Title")
    proton.Gap(ctx, 4)
    proton.Label(ctx, "Card content goes here.")
    proton.Gap(ctx, 12)
    proton.Pad(ctx, 4, func(ctx proton.Context) {
        if proton.Button(ctx, &u.btn, "Action") { doThing() }
    })
})
```

```go
proton.Card(ctx proton.Context, bg color.NRGBA, cornerDp, padDp float32, content func(proton.Context))
```

- `बीजी` - पृष्ठभूमि रंग
- `कॉर्नरडीपी` - कोने का त्रिज्या (अधिकांश कार्डों के लिए 8-12 अच्छा लगता है)
- `पैडडीपी` - कार्ड किनारे और सामग्री के बीच पैडिंग

### HoverCard

एक कार्ड जो होवर पर पृष्ठभूमि का रंग बदलता है। क्लिक करने पर सत्य लौटाता है।

```go
if proton.HoverCard(ctx, &u.cardBtn,
    proton.RGB(0x2e3440),  // normal background
    proton.RGB(0x3b4252),  // hover background
    8,                     // corner radius dp
    func(ctx proton.Context) {
        proton.PadV(ctx, 10, func(ctx proton.Context) {
            proton.PadH(ctx, 12, func(ctx proton.Context) {
                proton.Label(ctx, "Click this card")
            })
        })
    },
) {
    println("card clicked")
}
```

```go
proton.HoverCard(ctx proton.Context, state *proton.Clickable, bg, hover color.NRGBA, cornerDp float32, content func(proton.Context)) bool
```

---

## बिल्ला

पाठ के साथ एक छोटी गोल चिप. स्थिति लेबल, टैग, गिनती, किसी भी चीज़ के लिए
इसके लिए रंगीन गोली की जरूरत है.

```go
proton.Badge(ctx, proton.RGB(0x5e81ac), proton.RGB(0xeceff4), "stable")
proton.Badge(ctx, proton.RGB(0xa3be8c), proton.RGB(0x2e3440), "passing")
proton.Badge(ctx, proton.RGB(0xbf616a), proton.RGB(0xeceff4), "failing")
```

```go
proton.Badge(ctx proton.Context, bg, fg color.NRGBA, text string)
```

एक पंक्ति में बैज:

```go
proton.Row(ctx,
    func(ctx proton.Context) { proton.Badge(ctx, proton.RGB(0x5e81ac), proton.RGB(0xeceff4), "Go") },
    func(ctx proton.Context) { proton.Gap(ctx, 5) },
    func(ctx proton.Context) { proton.Badge(ctx, proton.RGB(0xa3be8c), proton.RGB(0x2e3440), "v1.0") },
    func(ctx proton.Context) { proton.Gap(ctx, 5) },
    func(ctx proton.Context) { proton.Badge(ctx, proton.RGB(0xebcb8b), proton.RGB(0x2e3440), "MIT") },
)
```

---

## StatusDot

एक छोटा सा रंगीन घेरा. ऑनलाइन/ऑफ़लाइन संकेतक, निर्माण स्थिति, कुछ भी
इसके लिए किसी पाठ के आगे एक रंगीन बिंदु की आवश्यकता होती है।

```go
proton.Row(ctx,
    func(ctx proton.Context) { proton.StatusDot(ctx, proton.RGB(0x4ade80), 9) },
    func(ctx proton.Context) { proton.Gap(ctx, 6) },
    func(ctx proton.Context) { proton.Caption(ctx, "Connected") },
)
```

```go
proton.StatusDot(ctx proton.Context, c color.NRGBA, sizeDp float32)
```

---

## अवतार

प्रथमाक्षर दर्शाने वाला गोलाकार बैज। जब कोई छवि न हो तो उपयोगकर्ता प्रोफ़ाइल चित्रों के लिए
उपलब्ध है - जो अधिकांश समय उपलब्ध है।

```go
proton.Avatar(ctx, "AJ", proton.RGB(0x5e81ac), proton.RGB(0xeceff4), 40)
proton.Avatar(ctx, "BC", proton.RGB(0xa3be8c), proton.RGB(0x2e3440), 32)
```

```go
proton.Avatar(ctx proton.Context, initials string, bg, fg color.NRGBA, sizeDp float32)
```

---

## प्रोग्रेसरिंग

एक गोलाकार प्रगति सूचक. स्टेट कार्ड और डैशबोर्ड के लिए अच्छा है
गोलाकार आकृति एक बार की तुलना में प्रतिशत अधिक दृष्टि से संचार करती है।

```go
proton.ProgressRing(ctx, 0.72, 48, 5, proton.RGB(0x88c0d0))
//                       ^     ^   ^   ^
//                  progress  sz  strokeW  color
```

```go
proton.ProgressRing(ctx proton.Context, progress, sizeDp, strokeDp float32, c color.NRGBA)
```

`प्रगति` 0.0-1.0 है। `sizeDp` व्यास है। `strokeDp` रिंग है
मोटाई - 4-6डीपी अधिकांश आकारों के लिए अच्छी लगती है।

---

## मेज़

A data table with a header row and alternating row shading.

```go
proton.Table(ctx,
    []string{"Name", "Role", "Status"},
    []proton.TableRow{
        {"Alice", "Engineer", "Active"},
        {"Bob",   "Designer", "Away"},
        {"Carol", "PM",       "Active"},
    },
)
```

```go
proton.Table(ctx proton.Context, columns []string, rows []proton.TableRow)
```

`proton.TableRow` is just `[]string`. Columns are equally wide.

---

## Stepper

बहु-चरणीय प्रवाह के लिए एक क्षैतिज चरण-प्रगति संकेतक।

```go
proton.Stepper(ctx, 1, []string{"Account", "Profile", "Payment", "Done"})
//                  ^
//              current step (0-based)
```

```go
proton.Stepper(ctx proton.Context, current int, steps []string)
```

चरण 0 पहला चरण है. पूर्ण किए गए चरण (सूचकांक <वर्तमान) भरे हुए मिलते हैं
उच्चारण रंग. वर्तमान चरण पर प्रकाश डाला गया है. भविष्य के कदम धुंधले हैं.

---

## Tooltip

एक छोटा लेबल जो तब दिखाई देता है जब उपयोगकर्ता किसी चीज़ पर घूमता है।

```go
type UI struct {
    saveHover proton.Clickable  // for tracking hover — separate from the button's Clickable
    saveBtn   proton.Clickable
}

proton.Tooltip(ctx, &u.saveHover, "Saves your work to disk (Ctrl+S)", func(ctx proton.Context) {
    proton.Pad(ctx, 4, func(ctx proton.Context) {
        if proton.Button(ctx, &u.saveBtn, "Save") {
            save()
        }
    })
})
```

```go
proton.Tooltip(ctx proton.Context, state *proton.Clickable, tip string, content func(proton.Context))
```

`स्टेट` क्लिक करने योग्य ट्रैक टूलटिप क्षेत्र के लिए होवर करते हैं। यह से अलग है
सामग्री के अंदर कोई भी बटन - प्रत्येक टूलटिप के लिए एक समर्पित घोषित करें।

---

## इमेजिस

स्टार्टअप पर एक बार लोड करें. प्रत्येक फ़्रेम को ड्रा करें.

```go
// load at startup — not in the draw function
img, err := proton.LoadImage("photo.png")
if err != nil {
    log.Fatal(err)
}

// in the draw function
proton.Image(ctx, img, 200, 150)  // 200dp wide, 150dp tall
proton.Image(ctx, img, 0, 0)      // natural pixel size
```

```go
proton.LoadImage(path string) (proton.ImageOp, error)
proton.Image(ctx proton.Context, img proton.ImageOp, widthDp, heightDp float32)
```

पीएनजी और जेपीईजी दोनों समर्थित हैं।

---

## प्रतीक चिन्ह

आपके ऐप का लोगो, एक बार लोड किया गया और कहीं भी खींचा गया। देखें [07-theming.md](./07-theming.md)
पूर्ण सेटअप के लिए. संक्षिप्त संस्करण:

```go
//go:embed logo.png
var logoBytes []byte

// at startup
a.SetLogoBytes(logoBytes)

// in the draw function
proton.Logo(ctx, 48, 48)
```

```go
proton.Logo(ctx proton.Context, widthDp, heightDp float32)
proton.HasLogo(ctx proton.Context) bool
```

---

## कोडब्लॉक

Monospace text in a rounded bordered box. For showing commands, file paths,
snippets — anything the user is likely to copy.

```go
proton.CodeBlock(ctx, "go get github.com/CzaxStudio/proton")
proton.CodeBlock(ctx, `a.Window("App", 480, 300, draw)
a.Run()`)
```

```go
proton.CodeBlock(ctx proton.Context, code string)
```

---

## ShortcutHint

एक छोटा कीबोर्ड बैज. इन्हें मेनू आइटम या बटन लेबल के बगल में दिखाएं
कुंजीपटल शॉर्टकट संचार करने के लिए.

```go
proton.Row(ctx,
    func(ctx proton.Context) { proton.Label(ctx, "Save") },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) { proton.ShortcutHint(ctx, "Ctrl+S") },
)
```

```go
proton.ShortcutHint(ctx proton.Context, keys string)
```

---

## रंग आदर्श

A row of colored circles the user can click to select a color. Returns
the index of the selected one, or -1 if none selected yet.

```go
type UI struct {
    swatches     [6]proton.Clickable
    chosenColor  int
}

palette := []color.NRGBA{
    proton.RGB(0xf87171),
    proton.RGB(0xfbbf24),
    proton.RGB(0x4ade80),
    proton.RGB(0x60a5fa),
    proton.RGB(0xa78bfa),
    proton.RGB(0xf472b6),
}

i := proton.ColorSwatch(ctx, u.swatches[:], palette, u.chosenColor, 26)
if i >= 0 {
    u.chosenColor = i
}
```

```go
proton.ColorSwatch(ctx proton.Context, btns []proton.Clickable, colors []color.NRGBA, selected int, sizeDp float32) int
```

चयनित वृत्त के चारों ओर एक वलय बन जाता है।