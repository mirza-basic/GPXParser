# GPXParser for Swift

`GPXParser` is a Swift package designed for parsing GPX (GPS Exchange Format) data. It supports both GPX versions 1.0 and 1.1, providing a consistent representation and handling regardless of the data's original version.

## Features:
- Parses GPX versions 1.0 and 1.1.
- Converts GPX 1.0 data into the GPX 1.1 structure.
- Provides clear error messages for parsing issues through the `GPXParserError` type.
- Can parse GPX data from both `URL` and `Data` types.

## Installation

For now, manually drag and drop the source files into your project. In future releases, integration via Swift Package Manager will be available.

## Usage

### Parsing from a URL:

```swift
do {
    let gpx = try GPXParser().parseGPX(from: URL(string: "path/to/gpx/file.gpx")!)
    print(gpx)
} catch let error as GPXParserError {
    print(error.localizedDescription)
}
