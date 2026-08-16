# प्रोटॉन डॉक्स

**अपनी भाषा में दस्तावेज़ पढ़ें:** [अंग्रेजी](https://github.com/CzaxStudio/proton-documentation/blob/main/docs/README.md) | [Español](https://github.com/CzaxStudio/proton-documentation/blob/main/docs/es/README.md) | [फ़्रांसीसी](https://github.com/CzaxStudio/proton-documentation/blob/main/docs/fr/README.md) | [Ελληνικά](https://github.com/CzaxStudio/proton-documentation/blob/main/docs/el/README.md) | [हिन्दी](https://github.com/CzaxStudio/proton-documentation/blob/main/docs/hi/README.md)

कॉपीराइट © [CzaxStudio](https://github.com/CzaxStudio/) (नेक्सस-प्रोटॉन)

प्रोटॉन के साथ डेस्कटॉप ऐप्स बनाने के लिए आपको जो कुछ भी चाहिए वह सब कुछ। 
कोई विषय चुनें या उन्हें क्रम से पढ़ें - दोनों ठीक काम करते हैं।

---

| फ़ाइल | इसमें क्या है |
|---|---|
| [00-getting-started.md](./00-getting-started.md) | स्थापित करें, पहली विंडो, राज्य संरचना पैटर्न |
| [01-text.md](./01-text.md) | लेबल, एच1-एच6, बॉडी2, कैप्शन, कस्टम टेक्स्ट |
| [02-बटन.एमडी](./02-बटन.एमडी) | बटन, आउटलाइनबटन, आइकनबटन, टैप करने योग्य |
| [03-inputs.md](./03-inputs.md) | इनपुट, टेक्स्टएरिया, चेकबॉक्स, टॉगल, रेडियोबटन, स्लाइडर, प्रोग्रेसबार |
| [04-लेआउट.एमडी](./04-लेआउट.एमडी) | रो, कॉलम, स्प्लिट, पैड, गैप, ग्रिड, ग्रोरो, सेंटर |
| [05-सूचियाँ.md](./05-सूचियाँ.md) | सूची, एचलिस्ट, स्क्रॉल |
| [06-विज़ुअल्स.एमडी](./06-विज़ुअल्स.एमडी) | डिवाइडर, रेक्ट, राउंडरेक्ट, कार्ड, बैज, छवि, न्यूनतम आकार, अधिकतम चौड़ाई |
| [07-थीमिंग.एमडी](./07-थीमिंग.एमडी) | पैलेट, कस्टम रंग, फ़ॉन्ट स्केल |
| [08-advanced.md](./08-advanced.md) | टोस्ट, ऑनकी, गोरोइन्स, टूलटिप, मल्टीपल विंडो |
| [09-examples.md](./09-examples.md) | संपूर्ण कॉपी-पेस्ट उदाहरण |

---

## जानने योग्य एक बात

प्रोटॉन तत्काल मोड है. आपका ड्रा फ़ंक्शन हर फ़्रेम पर चलता है। आप कॉल करें
विजेट फ़ंक्शन, वे उसी क्रम में स्क्रीन पर दिखाई देते हैं। राज्य में रहता है
आपकी अपनी संरचना. इतना ही।

```go
type UI struct {
    btn proton.Clickable
}

u := &UI{}

a.Window("App", 400, 300, func(win proton.Context) {
    proton.Label(win, "Click the button.")
    proton.Gap(win, 8)
    proton.Pad(win, 8, func(win proton.Context) {
        if proton.Button(win, &u.btn, "Hello") {
            println("hello!")
        }
    })
})
```

विजेट लंबवत रूप से ढेर हो जाते हैं। राज्य आपकी संरचना में रहता है। वह पूरा मॉडल है.

**[प्रोटॉन-रेपो](https://github.com/CzaxStudio/Proton)**