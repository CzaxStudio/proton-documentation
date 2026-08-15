# बटन

Buttons are how users tell your app to do things. Proton has four kinds,
plus clickable links and a way to make literally anything tappable.

---

## एक नियम

आपकी राज्य संरचना में प्रत्येक बटन को अपने स्वयं के `proton.Clickable` फ़ील्ड की आवश्यकता होती है।

```go
type UI struct {
    save   proton.Clickable
    cancel proton.Clickable
    delete proton.Clickable
}
```

दो बटनों के बीच एक को साझा न करें। यदि आप ऐसा करते हैं, तो दोनों में से किसी एक पर क्लिक करने से आग लग जाती है
दोनों - जो डिबग करने के लिए एक मज़ेदार बग और एक भयानक UX है।

साथ ही, बटन एक लेआउट रैपर ('पैड', 'पंक्ति', 'कॉलम', आदि) के अंदर होने चाहिए।
रजिस्टर करने के लिए क्लिक के लिए। इसका कारण जानने के लिए [आरंभ करना](./00-getting-started.md) देखें।

---

## बटन

भरी हुई, ठोस, प्राथमिक क्रिया। इसका उपयोग उस चीज़ के लिए करें जिसे आप सबसे अधिक चाहते हैं
उपयोगकर्ता को क्लिक करना है.

```go
var save proton.Clickable

proton.Pad(ctx, 8, func(ctx proton.Context) {
    if proton.Button(ctx, &save, "Save") {
        doSave()
    }
})
```

जिस फ़्रेम पर क्लिक किया जाता है उस पर `सही` लौटाता है। एक क्लिक, एक `सत्य`। यह
दबाए जाने पर फायरिंग नहीं करता है।

```go
proton.Button(ctx proton.Context, state *proton.Clickable, label string) bool
```

---

## आउटलाइनबटन

भूत/रूपरेखा शैली. बटन जैसा ही व्यवहार लेकिन भरे बिना
पृष्ठभूमि. इसका उपयोग द्वितीयक कार्यों के लिए करें - ऐसी चीज़ें जो उपयोगकर्ता चाहता हो
करना है, लेकिन यह प्राथमिक कार्रवाई नहीं है।

```go
var save   proton.Clickable
var cancel proton.Clickable

proton.Row(ctx,
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.OutlineButton(ctx, &cancel, "Cancel") {
                handleCancel()
            }
        })
    },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &save, "Save") {
                handleSave()
            }
        })
    },
)
```

यहां दृश्य पदानुक्रम - रद्द करने के लिए रूपरेखा, सहेजें के लिए भरा हुआ - बताता है
उपयोगकर्ताओं को स्पष्टीकरण के एक भी शब्द के बिना प्राथमिक कार्रवाई कौन सी है।

```go
proton.OutlineButton(ctx proton.Context, state *proton.Clickable, label string) bool
```

---

## आइकनबटन

केवल-आइकन बटन. कोई पाठ नहीं, बस एक चिह्न. टूलबार में सामान्य.

```go
// icon is a *proton.Icon — load one with widget.NewIcon() from gioui.org/widget
var closeBtn proton.Clickable

if proton.IconButton(ctx, &closeBtn, closeIcon, "Close window") {
    win.Close()
}
```

चौथा तर्क पहुंच-योग्यता विवरण है - एक स्क्रीन रीडर क्या है
कहूँगा. इसे छोड़ें मत.

```go
proton.IconButton(ctx proton.Context, state *proton.Clickable, icon *proton.Icon, desc string) bool
```

---

## टैप करने योग्य

Makes any content clickable. The entire area you draw inside the callback
becomes the hit target. Use it for cards, list rows, custom buttons, or
anything where a standard button label isn't what you want.

```go
var rowClick proton.Clickable

if proton.Tappable(ctx, &rowClick, func(ctx proton.Context) {
    proton.Card(ctx, proton.RGB(0x2a2a3e), 8, 12, func(ctx proton.Context) {
        proton.Label(ctx, "Click anywhere on this card")
        proton.Gap(ctx, 4)
        proton.Muted(ctx, "The whole thing is a button")
    })
}) {
    println("card clicked")
}
```

```go
proton.Tappable(ctx proton.Context, state *proton.Clickable, content func(proton.Context)) bool
```

---

## लिंक और लिंकस्मॉल

Underlined clickable text styled like a hyperlink. Handle the click yourself —
Proton doesn't open URLs for you, it just tells you the user clicked.

```go
var githubLink proton.Clickable

if proton.Link(ctx, &githubLink, "View on GitHub") {
    openBrowser("https://github.com/CzaxStudio/proton")
}
```

`LinkSmall` is the same thing but uses caption-sized text:

```go
var termsLink proton.Clickable

if proton.LinkSmall(ctx, &termsLink, "Terms of service") {
    showTerms()
}
```

```go
proton.Link(ctx proton.Context, state *proton.Clickable, text string) bool
proton.LinkSmall(ctx proton.Context, state *proton.Clickable, text string) bool
```

---

## सामान्य पैटर्न

### पंक्ति की पुष्टि करें/रद्द करें (दाईं ओर संरेखित)

```go
type UI struct {
    save   proton.Clickable
    cancel proton.Clickable
}

proton.RowEnd(ctx,
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.OutlineButton(ctx, &u.cancel, "Cancel") {
                handleCancel()
            }
        })
    },
    func(ctx proton.Context) { proton.Gap(ctx, 8) },
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.save, "Save changes") {
                handleSave()
            }
        })
    },
)
```

`रोएंड` हर चीज़ को दाएँ किनारे पर धकेलता है - मानक प्लेसमेंट के लिए
जोड़ियों की पुष्टि/रद्द करें।

### टूलबार

```go
type UI struct {
    newFile  proton.Clickable
    openFile proton.Clickable
    saveFile proton.Clickable
}

proton.Row(ctx,
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.Button(ctx, &u.newFile, "New") { handleNew() }
        })
    },
    func(ctx proton.Context) { proton.Gap(ctx, 4) },
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.OutlineButton(ctx, &u.openFile, "Open") { handleOpen() }
        })
    },
    func(ctx proton.Context) { proton.Gap(ctx, 4) },
    func(ctx proton.Context) {
        proton.Pad(ctx, 4, func(ctx proton.Context) {
            if proton.OutlineButton(ctx, &u.saveFile, "Save") { handleSave() }
        })
    },
)
```

### क्लिक करने योग्य सूची पंक्तियाँ

```go
type UI struct {
    rows   [100]proton.Clickable
    chosen int
}

items := []string{"Alpha", "Beta", "Gamma", "Delta"}

proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
    if proton.Tappable(ctx, &u.rows[i], func(ctx proton.Context) {
        proton.PadV(ctx, 10, func(ctx proton.Context) {
            proton.PadH(ctx, 12, func(ctx proton.Context) {
                proton.Label(ctx, items[i])
            })
        })
    }) {
        u.chosen = i
    }
    proton.Divider(ctx)
})
```