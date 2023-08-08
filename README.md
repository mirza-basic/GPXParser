# GPXParser for Swift 🌍

`GPXParser` is a sophisticated and efficient Swift package tailored for parsing GPX (GPS Exchange Format) data. Designed with the latest standards in mind, it offers seamless support for both GPX versions 1.0 and 1.1, ensuring a unified representation no matter the original version of your data.

## Features 🚀
- 🗺 Parses both GPX versions 1.0 and 1.1.
- 🔄 Automatic conversion of GPX 1.0 data into the GPX 1.1 structure.
- 🔍 Clear and comprehensive error feedback with the `GPXParserError` type.
- 🌐 Capability to parse GPX data from a variety of sources including `URL` and `Data` types.

## Installation 📦

### Swift Package Manager
You can use The [Swift Package Manager](https://swift.org/package-manager/) to install `GPXParser` by adding the proper description to your `Package.swift` file:

```
swift
.package(url: "https://github.com/YourUsername/GPXParser.git", from: "1.0.0")
```



Then, include it in your target dependencies:
```
.target(name: "YourTarget", dependencies: ["GPXParser"])
```


Lastly, run swift build in your terminal.

Usage 🛠
Parsing from a URL:


```
do {
    let gpx = try GPXParser().parseGPX(from: URL(string: "path/to/gpx/file.gpx")!)
    print(gpx)
} catch let error as GPXParserError {
    print(error.localizedDescription)
}
```


Parsing from a Data object:

```
if let gpxData = try? Data(contentsOf: URL(string: "path/to/gpx/file.gpx")!) {
    do {
        let gpx = try GPXParser().parseGPX(from: gpxData)
        print(gpx)
    } catch let error as GPXParserError {
        print(error.localizedDescription)
    }
}
```


Detailed documentation can be found in the source code, presented in a clear and thorough manner for developers of all levels. It contains insightful comments, explanations, and usage examples.

Contributing 🤝
We value and appreciate contributions from the community! Whether it's bug fixes, improvements, or new feature proposals, we welcome them all. Start by creating a pull request, and we'll take it from there.

License ⚖️
This project is licensed under the MIT License. See the LICENSE file for more details.

Happy coding and stay adventurous with GPX data! 🌍🛤
