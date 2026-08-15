# सूचियाँ और स्क्रॉलिंग

चीज़ों का संग्रह प्रदर्शित करने के लिए, और सामग्री क्षेत्रों को स्क्रॉल करने योग्य बनाने के लिए।

---

## List — Vertical Scrollable List

The standard list. Only draws the items currently visible on screen, so
10,000 items is fine.

```go
type UI struct {
    scroll proton.Scrollable
}

items := []string{"Apples", "Bananas", "Cherries", "Durian (why)"}

proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
    proton.Label(ctx, items[i])
})
```

कॉलबैक को इंडेक्स `i` प्राप्त होता है। प्रत्येक पंक्ति के लिए आप जो चाहें बनाएं।

```go
proton.List(ctx proton.Context, state *proton.Scrollable, length int, draw func(proton.Context, int))
```

प्रति सूची एक `प्रोटॉन.स्क्रॉल करने योग्य` घोषित करें। यह स्क्रॉल स्थिति को ट्रैक करता है।
दो सूचियों के बीच एक को साझा न करें - वे स्क्रॉल स्थिति पर लड़ेंगे और
दोनों हार जाते हैं.

---

## HList - क्षैतिज स्क्रॉल करने योग्य सूची

सूची के समान लेकिन आइटम बाएँ से दाएँ जाते हैं।

```go
proton.HList(ctx, &u.hscroll, len(items), func(ctx proton.Context, i int) {
    proton.PadH(ctx, 8, func(ctx proton.Context) {
        proton.Label(ctx, items[i])
    })
})
```

```go
proton.HList(ctx proton.Context, state *proton.Scrollable, length int, draw func(proton.Context, int))
```

---

## स्क्रॉल - स्क्रॉल करने योग्य सामग्री क्षेत्र

मनमानी सामग्री के लिए जो अतिप्रवाहित हो सकती है, अनुक्रमित वस्तुओं के लिए नहीं। सामग्री
फ़ंक्शन जितने चाहें उतने विजेट कॉल कर सकता है।

```go
type UI struct {
    scroll proton.Scrollable
}

proton.Scroll(ctx, &u.scroll, func(ctx proton.Context) {
    proton.H5(ctx, "A very long page")
    proton.Gap(ctx, 8)
    proton.Label(ctx, "Paragraph one...")
    proton.Gap(ctx, 8)
    proton.Label(ctx, "Paragraph two...")
    proton.Gap(ctx, 8)
    // as many widgets as you need
})
```

```go
proton.Scroll(ctx proton.Context, state *proton.Scrollable, content func(proton.Context))
```

जब आपके पास अनुक्रमित डेटा हो तो `सूची` का उपयोग करें। मिश्रित सामग्री वाले पृष्ठ के लिए `स्क्रॉल` का उपयोग करें।

---

## TextView — Read-Only Scrollable Text

स्क्रॉल करने योग्य, मोनोस्पेस दृश्य में पाठ का एक बड़ा ब्लॉक प्रदर्शित करता है।
फ़ाइल सामग्री, सहायता पाठ, पूर्वावलोकन कोड के लिए अच्छा है।

```go
type UI struct {
    scroll proton.Scrollable
}

proton.TextView(ctx, &u.scroll, longText)
```

```go
proton.TextView(ctx proton.Context, state *proton.Scrollable, text string)
```

पाठ को नई पंक्तियों में विभाजित किया गया है और प्रत्येक पंक्ति एक आभासी सूची आइटम है, इसलिए यह
बहुत लंबे दस्तावेज़ों को बिना किसी समस्या के संभालता है।

---

## लॉगव्यू - ऑटो-स्क्रॉलिंग लॉग आउटपुट

टेक्स्टव्यू की तरह लेकिन जब भी नई सामग्री जोड़ी जाती है तो नीचे की ओर स्वतः स्क्रॉल हो जाता है।
सामान्य लॉग उपसर्गों को स्वचालित रूप से रंग-कोड करता है।

```go
type UI struct {
    logScroll proton.Scrollable
    logText   string
}

// append to logText from anywhere
u.logText += fmt.Sprintf("[OK] Step completed at %s\n", time.Now().Format("15:04:05"))

// draw it — auto-scrolls to the latest line
proton.LogView(ctx, &u.logScroll, u.logText)
```

```go
proton.LogView(ctx proton.Context, state *proton.Scrollable, text string)
```

लाइन उपसर्ग के आधार पर रंग कोडिंग स्वचालित रूप से होती है:

| उपसर्ग | रंग |
|---|---|
| `[ठीक है]`, `हो गया`, `सफलता` | हरा |
| `[चेतावनी]`, `चेतावनी` | पीला |
| `[त्रुटि]`, `त्रुटि` | लाल |
| और कुछ भी | मौन |

---

## सूची की पंक्तियाँ बनाना अच्छा लगता है

सूची पंक्ति में एक खाली `proton.Label` काम करता है लेकिन अच्छा नहीं दिखता। कुछ जोड़ें
गद्दी और संरचना.

### गद्देदार पंक्तियाँ

```go
proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
    proton.PadV(ctx, 8, func(ctx proton.Context) {
        proton.PadH(ctx, 12, func(ctx proton.Context) {
            proton.Label(ctx, items[i].Name)
            proton.Gap(ctx, 2)
            proton.Muted(ctx, items[i].Description)
        })
    })
    proton.Divider(ctx)
})
```

### पाठ के दो कॉलम

```go
type Contact struct {
    Name  string
    Email string
}

proton.List(ctx, &u.scroll, len(contacts), func(ctx proton.Context, i int) {
    c := contacts[i]
    proton.PadV(ctx, 10, func(ctx proton.Context) {
        proton.PadH(ctx, 12, func(ctx proton.Context) {
            proton.Label(ctx, c.Name)
            proton.Gap(ctx, 3)
            proton.Muted(ctx, c.Email)
        })
    })
    proton.Divider(ctx)
})
```

### होवर हाइलाइट के साथ क्लिक करने योग्य पंक्तियाँ

```go
type UI struct {
    rows     [256]proton.Clickable
    selected int
    scroll   proton.Scrollable
}

proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
    bg  := proton.RGB(0x2e3440)
    hov := proton.RGB(0x3b4252)
    if u.selected == i {
        bg  = proton.RGB(0x4c566a)
        hov = bg
    }
    proton.PadV(ctx, 2, func(ctx proton.Context) {
        if proton.HoverCard(ctx, &u.rows[i], bg, hov, 6, func(ctx proton.Context) {
            proton.PadV(ctx, 10, func(ctx proton.Context) {
                proton.PadH(ctx, 12, func(ctx proton.Context) {
                    proton.Label(ctx, items[i].Name)
                    proton.Gap(ctx, 2)
                    proton.Muted(ctx, items[i].Sub)
                })
            })
        }) {
            u.selected = i
        }
    })
})
```

### कार्ड के अंदर सूची

```go
proton.Card(ctx, proton.RGB(0x1e1e2e), 10, 0, func(ctx proton.Context) {
    proton.List(ctx, &u.scroll, len(items), func(ctx proton.Context, i int) {
        proton.PadV(ctx, 8, func(ctx proton.Context) {
            proton.PadH(ctx, 12, func(ctx proton.Context) {
                proton.Label(ctx, items[i])
            })
        })
        if i < len(items)-1 {
            proton.Divider(ctx)
        }
    })
})
```

---

## प्रदर्शन

`सूची` और `एचलिस्ट` वर्चुअल रेंडरिंग का उपयोग करते हैं - केवल दृश्यमान आइटम ही प्राप्त करते हैं
ड्रा फ़ंक्शन को बुलाया गया। 50,000 वस्तुओं का एक टुकड़ा बिना 60 एफपीएस पर स्क्रॉल करता है
पसीना छूट रहा है.

`स्क्रॉल` प्रत्येक फ्रेम में सामग्री फ़ंक्शन में सब कुछ प्रस्तुत करता है। इसके लिए इसका उपयोग करें
उचित संख्या में विजेट वाले पृष्ठ, विशाल गतिशील डेटासेट के लिए नहीं।