# FB2 Parser

A swift implementation for simple parsing FB2 format, extracting thumbnail if coverpage exists and convert file to HTML

```swift
let imageData = try FB2Book.getCoverpage(url: URL())
let fb2Book: FB2XMLFictionBook = try FB2Book.openBook(url: URL())
let html = fb2Book.getHTML()
```
