# Text

प्रत्येक आकार को कवर करने वाले दस टेक्स्ट फ़ंक्शन "मैं चाहता हूं कि लोग इसे यहां से पढ़ें
पूरे कमरे में" से "कृपया कोई भी इस बढ़िया प्रिंट को न पढ़े"

---

## शीर्षक

```go
proton.H1(ctx, "I am enormous")
proton.H2(ctx, "Large")
proton.H3(ctx, "Medium-large")
proton.H4(ctx, "Medium — good for section titles")
proton.H5(ctx, "Medium-small")
proton.H6(ctx, "Small heading with dignity")
```

HTML के समान आकार का पैमाना. H1 तब के लिए है जब आप वास्तव में कोई वक्तव्य देना चाहते हैं।
H4 और H5 वे हैं जिनका आप वास्तव में सबसे अधिक उपयोग करेंगे।

**Signature** (same for all six):
```go
proton.H1(ctx proton.Context, text string)
```

---

## Label

नियमित मुख्य पाठ. आपके ऐप में अधिकांश शब्द यही हैं।

```go
proton.Label(ctx, "This is a label.")
```

```go
proton.Label(ctx proton.Context, text string)
```

---

## बॉडी2

लेबल से थोड़ा छोटा. द्वितीयक जानकारी के लिए जो मायने रखती है लेकिन
मुख्य सामग्री के साथ प्रतिस्पर्धा नहीं करनी चाहिए।

```go
proton.Label(ctx, "Price: $29.99")
proton.Body2(ctx, "Excluding taxes and the general unfairness of life.")
```

```go
proton.Body2(ctx proton.Context, text string)
```

---

## कैप्शन

सबसे छोटा पाठ. संकेत, टाइमस्टैम्प, बढ़िया प्रिंट, वे चीज़ें जो आपको कहने की ज़रूरत है
लेकिन वास्तव में नहीं चाहते कि लोग पढ़ें।

```go
proton.Caption(ctx, "Last synced 3 years ago")
```

```go
proton.Caption(ctx proton.Context, text string)
```

---

## मौन

हल्के रंग में बॉडी2-आकार का टेक्स्ट। द्वितीयक लेबल, सहायक पाठ के लिए,
ऐसे विवरण जो मुख्य सामग्री से प्रतिस्पर्धा किए बिना उसका समर्थन करते हैं।

```go
proton.Label(ctx, "Alice Johnson")
proton.Muted(ctx, "alice@example.com — last seen Tuesday")
```

```go
proton.Muted(ctx proton.Context, text string)
```

---

## Text — Custom Styling

When the preset sizes don't work, `Text` lets you control size, color,
and weight directly.

```go
// 28sp, coral red, bold
proton.Text(ctx, "Warning!", 28, proton.RGB(0xf87171), true)

// 16sp, custom blue, not bold
proton.Text(ctx, "Note", 16, proton.RGB(0x60a5fa), false)

// pass color.NRGBA{} to use the theme's default text color
proton.Text(ctx, "Normal weight, bigger", 20, proton.NRGBA{}, false)
```

```go
proton.Text(ctx proton.Context, s string, size float32, c color.NRGBA, bold bool)
```

आकार `sp` (स्केल्ड पिक्सल) में है। डिफ़ॉल्ट बॉडी का आकार लगभग 14sp है।

---

## अर्थपूर्ण रंग सहायक

सामान्य स्थिति टेक्स्ट के लिए शॉर्टकट. यदि स्ट्रिंग खाली है तो प्रत्येक व्यक्ति कुछ नहीं करता,
जो उन्हें अतिरिक्त `if` के बिना सशर्त उपयोग करने के लिए सुरक्षित बनाता है।

```go
proton.ErrorText(ctx, "Invalid email address.")     // red
proton.SuccessText(ctx, "Changes saved.")           // green
proton.WarningText(ctx, "This cannot be undone.")   // yellow
```

```go
proton.ErrorText(ctx proton.Context, text string)
proton.SuccessText(ctx proton.Context, text string)
proton.WarningText(ctx proton.Context, text string)
```

सत्यापन के लिए खाली-स्ट्रिंग व्यवहार उपयोगी है:

```go
proton.ErrorText(ctx, validationErr) // draws nothing when validationErr == ""
```

---

## रंगीन पाठ

संपूर्ण `टेक्स्ट` कॉल के बिना, एक विशिष्ट रंग वाले लेबल के लिए वन-लाइनर।

```go
proton.ColoredText(ctx, "Connected", proton.RGB(0x4ade80))
proton.ColoredText(ctx, "Disconnected", proton.RGB(0xf87171))
```

```go
proton.ColoredText(ctx proton.Context, text string, c color.NRGBA)
```

---

## रंग

```go
// from a 24-bit hex value
proton.RGB(0xff6b6b)   // coral red
proton.RGB(0x4ecdc4)   // teal
proton.RGB(0xffffff)   // white
proton.RGB(0x000000)   // black

// with explicit alpha (0 = transparent, 255 = fully opaque)
proton.RGBA(255, 107, 107, 255)  // same coral, fully opaque
proton.RGBA(0, 0, 0, 128)        // 50% transparent black

// from a CSS hex string
proton.HexColor("#ff6b6b")
proton.HexColor("ff6b6b")   // hash is optional
proton.HexColor("#f66")     // shorthand also works
```

---

## पाठ रैपिंग

लंबा टेक्स्ट उपलब्ध चौड़ाई में स्वचालित रूप से रैप हो जाता है।
आपको कुछ खास करने की जरूरत नहीं है.

```go
proton.Label(ctx, "This is a very long sentence that will wrap gracefully "+
    "onto multiple lines when the window is too narrow to fit it all in one.")
```

---

## एक विशिष्ट सामग्री अनुभाग

```go
proton.H4(ctx, "Account Settings")
proton.Gap(ctx, 4)
proton.Muted(ctx, "Manage your profile and notification preferences.")
proton.Gap(ctx, 16)
proton.Divider(ctx)
proton.Gap(ctx, 16)
```