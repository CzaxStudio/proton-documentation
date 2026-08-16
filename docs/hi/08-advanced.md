# विकसित

कीबोर्ड शॉर्टकट, एसिंक गोरआउट्स, टोस्ट नोटिफिकेशन, मोडल, टैब,
अकॉर्डियन, संदर्भ मेनू, और बाकी सब कुछ जो अच्छी तरह से फिट नहीं बैठता है
पहले के पन्ने.

---

## टोस्ट सूचनाएं

एक समयबद्ध संदेश प्रकट होता है, कुछ सेकंड तक रहता है और गायब हो जाता है
अपना. कोई संवाद नहीं, कोई उपयोगकर्ता को अवरुद्ध नहीं कर रहा।

```go
type UI struct {
    toast proton.ToastState
}

// trigger from anywhere — goroutine-safe
u.toast.Show("File saved!", 2*time.Second)

// draw it LAST in your draw function so it renders on top of everything
proton.Toast(ctx, &u.toast)
```

यदि कोई सक्रिय टोस्ट नहीं है, तो `टोस्ट` कुछ नहीं खींचता। पहले जांचने की जरूरत नहीं.

```go
func (t *ToastState) Show(msg string, duration time.Duration)
proton.Toast(ctx proton.Context, state *proton.ToastState)
```

---

## ओवरले/मोडल

हर चीज़ के शीर्ष पर केंद्रित सामग्री के साथ एक धुंधली पृष्ठभूमि।

```go
type UI struct {
    modal    proton.OverlayState
    openBtn  proton.Clickable
    closeBtn proton.Clickable
}

// open it
proton.Pad(ctx, 4, func(ctx proton.Context) {
    if proton.Button(ctx, &u.openBtn, "Open dialog") {
        u.modal.Show()
    }
})

// draw it — also at the end of your draw function
proton.Overlay(ctx, &u.modal, func(ctx proton.Context) {
    proton.MinSize(ctx, 300, 0, func(ctx proton.Context) {
        proton.Card(ctx, proton.RGB(0x2e3440), 12, 24, func(ctx proton.Context) {
            proton.H5(ctx, "Are you sure?")
            proton.Gap(ctx, 8)
            proton.Label(ctx, "This cannot be undone.")
            proton.Gap(ctx, 20)
            proton.RowEnd(ctx,
                func(ctx proton.Context) {
                    proton.Pad(ctx, 4, func(ctx proton.Context) {
                        if proton.OutlineButton(ctx, &u.closeBtn, "Cancel") {
                            u.modal.Hide()
                        }
                    })
                },
                func(ctx proton.Context) { proton.Gap(ctx, 8) },
                func(ctx proton.Context) {
                    proton.Pad(ctx, 4, func(ctx proton.Context) {
                        if proton.Button(ctx, &u.openBtn, "Confirm") {
                            u.modal.Hide()
                            doThing()
                        }
                    })
                },
            )
        })
    })
})
```

```go
func (o *OverlayState) Show()
func (o *OverlayState) Hide()
func (o *OverlayState) Toggle()

proton.Overlay(ctx proton.Context, state *proton.OverlayState, content func(proton.Context))
```

जब `state.Visible` गलत है, तो `ओवरले` कुछ नहीं खींचता है, इसलिए आप इसे कॉल कर सकते हैं
प्रत्येक फ़्रेम बिना किसी रैपिंग शर्त के।

---

## कुंजीपटल अल्प मार्ग

कुंजी संयोजन दबाए जाने पर फ़ंक्शन को सक्रिय करने के लिए पंजीकृत करें।

```go
proton.OnKey(ctx, proton.ModCtrl, "S", func() { save() })
proton.OnKey(ctx, proton.ModCtrl, "Z", func() { undo() })
proton.OnKey(ctx, proton.ModCtrl|proton.ModShift, "N", func() { newFile() })
proton.OnKey(ctx, proton.ModNone, proton.KeyEscape, func() { closeDialog() })
```

अपने ड्रा फ़ंक्शन के अंदर `ऑनकी` को कॉल करें। यह उसके लिए शॉर्टकट पंजीकृत करता है
ढाँचा। चूंकि ड्रॉ फ़ंक्शन हर फ़्रेम पर चलता है, इसलिए शॉर्टकट सक्रिय रहते हैं
जब तक खिड़की खुली है.

```go
proton.OnKey(ctx proton.Context, modifiers proton.Modifier, keyName string, fn func())
```

**संशोधक स्थिरांक:**

```go
proton.ModNone   // no modifier — just the key
proton.ModCtrl   // Ctrl (Cmd on macOS)
proton.ModShift
proton.ModAlt

// combine with |
proton.ModCtrl | proton.ModShift
```

**कुंजी नाम स्थिरांक** (गैर-अक्षर कुंजियों के लिए):

```go
proton.KeyEscape
proton.KeyReturn
proton.KeyBackspace
proton.KeyDelete
proton.KeyTab
proton.KeySpace
proton.KeyUp
proton.KeyDown
proton.KeyLeft
proton.KeyRight
```

अक्षर कुंजियाँ केवल स्ट्रिंग हैं: `"S"`, `"Z"`, `"N"`, `"A"`।

---

## टैब्स

एक सामग्री क्षेत्र के साथ एक क्षैतिज टैब बार जो इसके आधार पर स्विच करता है
चयनित टैब.

```go
type UI struct {
    tabs    proton.TabState
    tabBtns [3]proton.Clickable
}

proton.Tabs(ctx,
    []string{"Files", "Settings", "About"},
    u.tabBtns[:],
    &u.tabs,
    func(ctx proton.Context, i int) {
        switch i {
        case 0: drawFiles(ctx)
        case 1: drawSettings(ctx)
        case 2: drawAbout(ctx)
        }
    },
)
```

`u.tabs.Selected` सक्रिय टैब इंडेक्स रखता है। आप इसे प्रोग्रामेटिक रूप से सेट कर सकते हैं
कोड से टैब स्विच करने के लिए.

```go
proton.Tabs(ctx proton.Context, labels []string, btns []proton.Clickable, state *proton.TabState, content func(proton.Context, int))
```

`बीटीएनएस` स्लाइस को प्रति टैब एक `क्लिक करने योग्य` की आवश्यकता है। `u.tabBtns[:]` पास करना है
मुहावरेदार तरीका जब आप अपनी संरचना में एक निश्चित आकार की सरणी घोषित करते हैं।

---

## अकॉर्डियन

क्लिक करने योग्य हेडर के साथ एक संक्षिप्त करने योग्य अनुभाग।

```go
type UI struct {
    sec1    proton.AccordionState
    sec1btn proton.Clickable
}

proton.Accordion(ctx, &u.sec1, &u.sec1btn, "Advanced Options", func(ctx proton.Context) {
    proton.Label(ctx, "These options are hidden until the user expands this.")
    proton.Gap(ctx, 8)
    proton.Toggle(ctx, &u.expertMode, "Expert mode")
})
```

```go
proton.Accordion(ctx proton.Context, state *proton.AccordionState, btn *proton.Clickable, title string, content func(proton.Context))
```

`state.Open` ट्रैक करता है कि इसका विस्तार हुआ है या नहीं। आप इसे सीधे प्रारंभ करने के लिए सेट कर सकते हैं
एक अकॉर्डियन खुला: `u.sec1.Open = true`।

---

## संदर्भ मेनू

एक राइट-क्लिक मेनू जो कर्सर स्थिति पर दिखाई देता है।

```go
type UI struct {
    menu    proton.ContextMenuState
    menuTag proton.FrameTag
}

items := []proton.ContextMenuItem{
    {Label: "Copy"},
    {Label: "Paste"},
    {Label: "Delete"},
    {Label: "Disabled option", Disabled: true},
}

chosen := proton.ContextMenu(ctx, &u.menu, &u.menuTag, items, func(ctx proton.Context) {
    proton.Label(ctx, "Right-click anywhere in this area")
})

if chosen >= 0 {
    fmt.Println("User picked:", items[chosen].Label)
}
```

```go
proton.ContextMenu(ctx proton.Context, state *proton.ContextMenuState, tag *proton.FrameTag, items []proton.ContextMenuItem, content func(proton.Context)) int
```

जब कुछ भी नहीं चुना गया तो -1 लौटाता है, और फ़्रेम पर आइटम इंडेक्स देता है
कुछ क्लिक हो जाता है. चयन के बाद मेनू स्वचालित रूप से बंद हो जाता है।

---

## एसिंक अपडेट और गोरोइन्स

आपका ड्रा फ़ंक्शन मुख्य थ्रेड पर चलता है। जब कोई गोरौटाइन काम ख़त्म कर लेता है
और स्थिति बदलती है, पुनः ड्रा के लिए पूछने के लिए `ctx.Invalidate()` पर कॉल करें।

```go
type UI struct {
    loading bool
    result  string
    fetchBtn proton.Clickable
}

// in your draw function
proton.Pad(ctx, 4, func(ctx proton.Context) {
    if proton.Button(ctx, &u.fetchBtn, "Fetch") && !u.loading {
        u.loading = true
        go func() {
            data := fetchFromAPI()        // takes a while
            u.result = data
            u.loading = false
            ctx.Invalidate()              // wake up the render loop
        }()
    }
})

if u.loading {
    proton.Row(ctx,
        func(ctx proton.Context) { proton.Spinner(ctx, &u.spin, 18) },
        func(ctx proton.Context) { proton.Gap(ctx, 8) },
        func(ctx proton.Context) { proton.Muted(ctx, "Loading...") },
    )
} else if u.result != "" {
    proton.Label(ctx, u.result)
}
```

`ctx.Invalidate()` के बिना, उपयोगकर्ता के हिलने तक विंडो दोबारा नहीं बनेगी
माउस या उसके साथ इंटरैक्ट करता है। हमेशा स्थिति बदलने के बाद इसे कॉल करें
एक गोरौटाइन.

---

## स्पिनर

एक एनिमेटेड लोडिंग सूचक. `स्पिनर` को कॉल करने से स्वचालित रूप से रहता है
विंडो पुनः आरेखण - कोई `अमान्य()` लूप की आवश्यकता नहीं है।

```go
type UI struct {
    spin proton.SpinnerState
}

proton.Spinner(ctx, &u.spin, 32)  // 32dp diameter
```

```go
proton.Spinner(ctx proton.Context, state *proton.SpinnerState, sizeDp float32)
```

`स्पिनरस्टेट` एनीमेशन प्रारंभ समय को ट्रैक करता है। प्रति स्पिनर एक घोषित करें
आपके राज्य संरचना में.

---

## सेलेक्टबॉक्स (ड्रॉपडाउन)

```go
type UI struct {
    langSel proton.SelectBoxState
}

langs := []string{"Go", "Rust", "Zig", "C", "Python"}
i := proton.SelectBox(ctx, &u.langSel, langs)
proton.Caption(ctx, "Selected: "+langs[i])
```

ड्रॉपडाउन बटन के नीचे खुलता है और चयन या बाहरी क्लिक पर बंद हो जाता है।

```go
proton.SelectBox(ctx proton.Context, state *proton.SelectBoxState, options []string) int
```

---

## यदि - सशर्त प्रतिपादन

कोई शर्त सत्य होने पर ही सामग्री प्रस्तुत करता है। जब आप `if` ब्लॉक सहेजते हैं
बस एक विजेट दिखाना या छिपाना चाहता हूँ।

```go
proton.If(ctx, user.IsAdmin, func(ctx proton.Context) {
    proton.Pad(ctx, 4, func(ctx proton.Context) {
        if proton.Button(ctx, &u.deleteBtn, "Delete everything") {
            deleteEverything()
        }
    })
})
```

```go
proton.If(ctx proton.Context, cond bool, content func(proton.Context))
```

---

## फ़ोकसएरिया - स्कोप्ड कुंजी हैंडलिंग

जब आपको केवल यूआई के एक विशिष्ट क्षेत्र के अंदर सक्रिय कीबोर्ड ईवेंट की आवश्यकता होती है,
विश्व स्तर पर नहीं. आमतौर पर `ऑनकी` पर्याप्त है - जब आपके पास दो हों तो इस तक पहुंचें
पैनल जिनमें स्वतंत्र कीबोर्ड शॉर्टकट होने चाहिए।

```go
type UI struct {
    editorTag proton.FrameTag
}

proton.FocusArea(ctx, &u.editorTag, "A", func(ctx proton.Context) {
    proton.TextArea(ctx, &u.text, "Type here...")
})
```

```go
proton.FocusArea(ctx proton.Context, tag *proton.FrameTag, keyName string, content func(proton.Context))
```

---

## विंडो विकल्प

```go
// fullscreen
a.WindowEx("App", 800, 600, []proton.WindowOption{
    proton.Fullscreen(),
}, draw)

// maximized
a.WindowEx("App", 800, 600, []proton.WindowOption{
    proton.Maximized(),
}, draw)
```

```go
proton.Fullscreen() proton.WindowOption
proton.Maximized()  proton.WindowOption
```

---

## एनिमेशन चालू रखना

प्रोटॉन केवल तभी पुनः बनाता है जब उपयोगकर्ता इनपुट होता है या आप `ctx.Invalidate()` कहते हैं।
एनिमेशन के लिए - प्रगति पट्टियाँ जो समय, उलटी गिनती, कुछ भी भरती हैं
समय-आधारित - पुनः ड्रॉ बनाए रखने के लिए प्रत्येक फ्रेम के अंत में 'अमान्य' पर कॉल करें
जा रहा हूँ:

```go
func draw(ctx proton.Context, u *UI) {
    if u.animating {
        u.progress += 0.01
        if u.progress >= 1.0 {
            u.progress = 0
            u.animating = false
        }
        proton.ProgressBar(ctx, u.progress)
        ctx.Invalidate()  // draw again next frame
    }
}
```

जब `u.animating` गलत हो जाता है, तो `Invalidate` को कॉल किया जाना बंद हो जाता है और Proton
केवल उपयोगकर्ता इनपुट पर पुन: आरेखण पर वापस जाता है। स्पिनर विजेट यह करता है
स्वचालित रूप से - आपको इसे स्वयं प्रबंधित करने की आवश्यकता नहीं है।