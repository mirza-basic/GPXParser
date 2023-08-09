//
//  GPXParser.swift
//  Atom
//
//  Created by Mirza Basic on 6. 8. 2023..
//

import Foundation

/// `GPXParser` is responsible for parsing GPX (GPS Exchange Format) data.
///
/// This parser supports both GPX versions 1.0 and 1.1. While both versions have differences in structure and elements,
/// this parser handles these distinctions and parses GPX 1.0 data into the GPX 1.1 version structure for a uniform
/// representation.
///
/// By leveraging this design, the parser ensures the consistent handling and representation of GPX data, regardless
/// of its original version, making it easier for the subsequent processing and manipulation of the parsed data.
fileprivate class GPXBuilder {
    var gpx = GPX()
    
    // Variables for temporarily storing parsed data before attaching them to main `GPX` structure.
    var currentMetadata: Metadata?
    var currentWaypoint: Waypoint?
    var currentMetadataLink: Link?
    var currentLink: Link?
    var currentRoute: Route?
    var currentTrack: Track?
    var currentSegment: TrackSegment?
    var currentAuthor: Author?
    var currentCopyright: Copyright?
    var currentBounds: Bounds?
    var currentValue: String?
    
    // Date formatter for handling time strings in the GPX XML.
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
}

public class GPXParser: NSObject {
    /// Defines the supported XML elements within the GPX format.
    private enum Element: String {
        case gpx, metadata, wpt, ele, link, rte, rtept, trk,
             trkseg, trkpt, author, copyright, bounds, name,
             desc, year, license, email, time, url, urlname, text,
             magvar, geoidheight, cmt, src, sym, type,
             fix, sat, hdop, vdop, pdop, ageofdgpsdata, dgpsid, number
        
        static var stacked: [Element] {
            [.wpt, .rte, .rtept, .trk, .trkseg, .trkpt, .metadata, .link, .author]
        }
    }
    /// Defines the supported XML attributes within the GPX format.
    private enum Atribute: String {
        case version, creator, lat, lon, href, author, minlat, minlon, maxlat, maxlon
    }
    
    /// The `GPXBuilder` instance used by the parser to build a `GPX` object from XML data.
    ///
    /// This builder keeps track of the current state and provides methods to accumulate data
    /// as the XML parsing progresses. It also encapsulates the complex object creation logic
    /// ensuring that the `GPXParser` focuses only on parsing tasks.
    private var builder: GPXBuilder = GPXBuilder()
    
    /// A stack to keep track of the nested XML elements as they are parsed.
    ///
    /// This stack helps to understand the context or hierarchy of the XML as it's parsed.
    /// For instance, when an element closes, this stack helps determine its parent element
    /// and decide where the parsed data should be stored. This is especially useful for XML
    /// formats like GPX which can have deeply nested structures.
    private var elementStack: [Element] = []
    
    /// The current XML element being processed by the parser.
    ///
    /// This property is updated every time the parser starts or ends processing an element.
    /// It helps in determining what action should be taken based on the current element and its content.
    private var currentElement: Element?
   
    /// Parses a GPX (GPS Exchange Format) file from a given `URL`.
    ///
    /// This function attempts to initialize an XML parser with the given URL and parse the GPX contents.
    /// If the parsing is successful, it returns a `GPX` object. In case of failure, appropriate `GPXParserError`
    /// is thrown to provide detailed information about the error.
    ///
    /// - Parameter url: The `URL` pointing to the GPX file to be parsed.
    ///
    /// - Throws:
    ///   - `GPXParserError.initializationError` if the XML parser fails to initialize with the provided URL.
    ///   - `GPXParserError.parsingError` if there's a specific error during parsing.
    ///   - `GPXParserError.general` for non-specific errors that occur during parsing.
    ///
    /// - Returns: A `GPX` object representing the parsed data.
    ///
    /// # Example
    /// ```swift
    /// do {
    ///     let gpx = try GPXParser().parseGPX(from: URL(string: "path/to/gpx/file.gpx")!)
    ///     print(gpx)
    /// } catch let error as GPXParserError {
    ///     print(error.localizedDescription)
    /// }
    /// ```
    public func parseGPX(from url: URL) throws -> GPX {
        guard let parser = XMLParser(contentsOf: url) else {
            throw GPXParserError.initializationError("Failed to initialize the XML parser with the given URL.")
        }
        
        parser.delegate = self
        
        if parser.parse() {
            return builder.gpx
        } else {
            if let specificError = parser.parserError {
                throw GPXParserError.parsingError(specificError.localizedDescription)
            } else {
                throw GPXParserError.general("Unknown parsing error occurred.")
            }
        }
    }
    
    /// Parses a GPX (GPS Exchange Format) data from a given `Data` object.
    ///
    /// This function attempts to initialize an XML parser with the provided data and parse the GPX contents.
    /// If the parsing is successful, it returns a `GPX` object. In case of failure, an appropriate `GPXParserError`
    /// is thrown to provide detailed information about the error.
    ///
    /// - Parameter data: The `Data` object containing GPX formatted content.
    ///
    /// - Throws:
    ///   - `GPXParserError.parsingError` if there's a specific error during parsing.
    ///   - `GPXParserError.general` for non-specific errors that occur during parsing.
    ///
    /// - Returns: A `GPX` object representing the parsed data.
    ///
    /// # Example
    /// ```swift
    /// if let gpxData = try? Data(contentsOf: URL(string: "path/to/gpx/file.gpx")!) {
    ///     do {
    ///         let gpx = try GPXParser().parseGPX(from: gpxData)
    ///         print(gpx)
    ///     } catch let error as GPXParserError {
    ///         print(error.localizedDescription)
    ///     }
    /// }
    /// ```
    public func parseGPX(from data: Data) throws -> GPX {
        let parser = XMLParser(data: data)
        parser.delegate = self
        
        if parser.parse() {
            return builder.gpx
        } else {
            if let specificError = parser.parserError {
                throw GPXParserError.parsingError(specificError.localizedDescription)
            } else {
                throw GPXParserError.general("Unknown parsing error occurred.")
            }
        }
    }
}

// MARK: - XMLParserDelegate

/// Extension of GPXParser to conform to the XMLParserDelegate protocol. This extension manages the parsing
/// of the GPX (GPS Exchange Format) XML data, transforming the XML elements into their corresponding GPX objects.
extension GPXParser: XMLParserDelegate {
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        guard let element = Element(rawValue: elementName) else {
            return
        }
        builder.currentValue = nil
        currentElement = element
        
        if Element.stacked.contains(element) {
            elementStack.append(element)
        }
        switch currentElement {
        case .gpx:
            prepareGPX(attributeDict: attributeDict)
        case .metadata:
            builder.currentMetadata = Metadata()
        case .wpt, .trkpt, .rtept:
            prepareWaypoint(attributeDict: attributeDict)
        case .link:
            prepareLink(attributeDict: attributeDict)
        case .rte:
            builder.currentRoute = Route()
        case .trk:
            builder.currentTrack = Track()
        case .trkseg:
            builder.currentSegment = TrackSegment()
        case .author:
            prepareAuthor()
        case .copyright:
           prepareCopyright(attributeDict: attributeDict)
        case .bounds:
           prepareBounds(attributeDict: attributeDict)
        default:
            break
        }
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        let value = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if !value.isEmpty {
            builder.currentValue = value
        }
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard let element = Element(rawValue: elementName) else {
            return
        }
        
        currentElement = element
        var parentElement = elementStack.last
        if Element.stacked.contains(element) {
            _ = elementStack.removeLast()
            parentElement = elementStack.last
        }
        switch currentElement {
        case .gpx:
            handleGPX()
        case .metadata:
           handleMetadata()
        case .wpt:
            handleWaypoint()
        case .ele:
            handleElevation()
        case .link:
            handleLink(parent: parentElement)
        case .url:
            handleUrl(parent: parentElement)
        case .urlname:
            handleUrlName(parent: parentElement)
        case .rte:
            handleRoute()
        case .rtept:
            handleRoutePoint()
        case .trk:
            handleTrack()
        case .trkseg:
           handleTrackSegment()
        case .trkpt:
           handleTrackpoint()
        case .author:
            handleAuthor()
        case .copyright:
            handleCopright()
        case .bounds:
            handleBounds()
        case .time:
            handleTime(parent: parentElement)
        case .name:
           handleName(parent: parentElement)
        case .desc:
           handleDescription(parent: parentElement)
        case .number:
            handleNumber(parent: parentElement)
        case .text:
           handleLinkText(parent: parentElement)
        case .year:
            builder.currentCopyright?.year = builder.currentValue
        case .license:
            builder.currentCopyright?.license = URL(string: builder.currentValue ?? "")
        case .email:
            builder.currentAuthor?.email = builder.currentValue
        case .magvar:
            builder.currentWaypoint?.magneticVariation = Double(builder.currentValue ?? "")
        case .geoidheight:
            builder.currentWaypoint?.geoidHeight = Double(builder.currentValue ?? "")
        case .cmt:
            handleComment(parent: parentElement)
        case .src:
            builder.currentWaypoint?.src = builder.currentValue
        case .sym:
            builder.currentWaypoint?.sym = builder.currentValue
        case .type:
            handleType(parent: parentElement)
        case .fix:
            builder.currentWaypoint?.fix = builder.currentValue
        case .sat:
            builder.currentWaypoint?.sat = Int(builder.currentValue ?? "")
        case .hdop:
            builder.currentWaypoint?.hdop = Double(builder.currentValue ?? "")
        case .vdop:
            builder.currentWaypoint?.vdop = Double(builder.currentValue ?? "")
        case .pdop:
            builder.currentWaypoint?.pdop = Double(builder.currentValue ?? "")
        case .ageofdgpsdata:
            builder.currentWaypoint?.ageOfDGPSData = Double(builder.currentValue ?? "")
        case .dgpsid:
            builder.currentWaypoint?.dgpsID = Int(builder.currentValue ?? "")
        default:
            break
        }
    }
}

// MARK: - Preparation Functions

/// Extension containing helper functions for preparing the `GPXParser` state based on parsed XML attributes.
extension GPXParser {
    
    /// Prepares the GPX object by setting its version and creator.
    /// - Parameter attributeDict: The attributes dictionary associated with the GPX element.
    private func prepareGPX(attributeDict: [String : String]) {
        if let version = attributeDict[Atribute.version.rawValue] {
            builder.gpx.version = GPXVersion(rawValue: version)
        }
        builder.gpx.creator = attributeDict[Atribute.creator.rawValue]

        if builder.gpx.version == .v1_0 {
            elementStack.append(.metadata)
            builder.currentMetadataLink = Link()
            builder.currentMetadata = Metadata()
            builder.currentAuthor = Author()
        }
    }
    
    /// Prepares a waypoint object based on latitude and longitude attributes.
    /// - Parameter attributeDict: The attributes dictionary associated with the waypoint element.
    private func prepareWaypoint(attributeDict: [String : String]) {
        if let latValue = attributeDict[Atribute.lat.rawValue], let lat = Double(latValue),
           let lonValue = attributeDict[Atribute.lon.rawValue], let lon = Double(lonValue) {
            builder.currentWaypoint = Waypoint(latitude: lat, longitude: lon)
        }
    }
    
    /// Prepares a link object using href attribute.
    /// - Parameter attributeDict: The attributes dictionary associated with the link element.
    private func prepareLink(attributeDict: [String : String]) {
        if let hrefValue = attributeDict[Atribute.href.rawValue], let href = URL(string: hrefValue) {
            builder.currentLink = Link(href: href)
        }
    }
    
    /// Prepares an author object based on the GPX version.
    private func prepareAuthor() {
        if builder.gpx.version == .v1_1 {
            builder.currentAuthor = Author()
        }
    }
    
    /// Prepares a copyright object using the author attribute.
    /// - Parameter attributeDict: The attributes dictionary associated with the copyright element.
    private func prepareCopyright(attributeDict: [String : String]) {
        if let author = attributeDict[Atribute.author.rawValue] {
            builder.currentCopyright = Copyright(author: author)
        }
    }
    
    /// Prepares a bounds object using minimum and maximum latitude and longitude attributes.
    /// - Parameter attributeDict: The attributes dictionary associated with the bounds element.
    private func prepareBounds(attributeDict: [String : String]) {
        if let minLatValue = attributeDict[Atribute.minlat.rawValue], let minLat = Double(minLatValue),
           let minLonValue = attributeDict[Atribute.minlon.rawValue], let minLon = Double(minLonValue),
           let maxLatValue = attributeDict[Atribute.maxlat.rawValue], let maxLat = Double(maxLatValue),
           let maxLonValue = attributeDict[Atribute.maxlon.rawValue], let maxLon = Double(maxLonValue) {
            builder.currentBounds = Bounds(minLat: minLat, minLon: minLon, maxLat: maxLat, maxLon: maxLon)
        }
    }
}

// MARK: - Handler Functions

/// Extension containing helper functions to handle the completion of parsed XML elements,
/// and update the state or structures of the `GPXParser`.
extension GPXParser {
    
    /// Handles the description of different GPX elements based on their parent.
    /// - Parameter parent: The parent GPX element.
    private func handleDescription(parent: Element?) {
        switch parent {
        case .metadata:
            builder.currentMetadata?.desc = builder.currentValue
        case .wpt, .rtept, .trkpt:
            builder.currentWaypoint?.desc = builder.currentValue
        case .rte:
            builder.currentRoute?.desc = builder.currentValue
        case .trk:
            builder.currentTrack?.desc = builder.currentValue
        default:
            break
        }
    }
    
    /// Processes the name of various GPX elements based on their parent element.
    /// - Parameter parent: The parent GPX element.
    private func handleName(parent: Element?) {
        switch parent {
        case .metadata:
            builder.currentMetadata?.name = builder.currentValue
        case .wpt, .rtept, .trkpt:
            builder.currentWaypoint?.name = builder.currentValue
        case .rte:
            builder.currentRoute?.name = builder.currentValue
        case .trk:
            builder.currentTrack?.name = builder.currentValue
        case .author:
            builder.currentAuthor?.name = builder.currentValue
        default:
            break
        }
    }
    
    /// Handles the number of different GPX elements based on their parent.
    /// - Parameter parent: The parent GPX element.
    private func handleNumber(parent: Element?) {
        guard let value = builder.currentValue else {
            return
        }
        switch parent {
        case .trk:
            builder.currentTrack?.number = Int(value)
        case .rte:
            builder.currentRoute?.number = Int(value)
        default:
            break
        }
    }
    
    /// Processes the type of various GPX elements based on their parent element.
    /// - Parameter parent: The parent GPX element.
    private func handleType(parent: Element?) {
        switch parent {
        case .wpt:
            builder.currentWaypoint?.type = builder.currentValue
        case .link:
            builder.currentLink?.type = builder.currentValue
        default:
            break
        }
    }
    
    /// Handles the cmt of different GPX elements based on their parent.
    /// - Parameter parent: The parent GPX element.
    private func handleComment(parent: Element?) {
        switch parent {
        case .wpt:
            builder.currentWaypoint?.cmt = builder.currentValue
        case .trk:
            builder.currentTrack?.cmt = builder.currentValue
        case .rte:
            builder.currentRoute?.cmt = builder.currentValue
        default:
            break
        }
    }
    
    /// Processes the time data for specific GPX elements.
    /// - Parameter parent: The parent GPX element.
    private func handleTime(parent: Element?) {
        guard let value = builder.currentValue, let date = builder.dateFormatter.date(from: value) else {
            return
        }
        switch parent {
        case .metadata:
            builder.currentMetadata?.time = date
        case .wpt, .rtept, .trkpt:
            builder.currentWaypoint?.time = date
        default:
            break
        }
    }
    
    /// Updates the author information based on the GPX version.
    private func handleAuthor() {
        if builder.gpx.version == .v1_0 {
            builder.currentAuthor?.name = builder.currentValue
        } else {
            builder.currentMetadata?.author = builder.currentAuthor
            builder.currentAuthor = nil
        }
    }
    
    /// Adds a trackpoint to the current segment.
    private func handleTrackpoint() {
        guard let trackpoint = builder.currentWaypoint else {
            return
        }
        builder.currentSegment?.trackpoints.append(trackpoint)
        builder.currentWaypoint = nil
    }
    
    /// Appends a track segment to the current track.
    private func handleTrackSegment() {
        guard let segment = builder.currentSegment else {
            return
        }
        builder.currentTrack?.segments.append(segment)
        builder.currentSegment = nil
    }
    
    /// Appends a track to the GPX structure.
    private func handleTrack() {
        guard var track = builder.currentTrack else {
            return
        }
        if builder.gpx.version == .v1_0, let link = builder.currentLink {
            track.links.append(link)
            builder.currentLink = nil
        }
        builder.gpx.tracks.append(track)
        builder.currentTrack = nil
    }
    
    /// Adds a route point to the current route.
    private func handleRoutePoint() {
        guard let routePoint = builder.currentWaypoint else {
            return
        }
        builder.currentRoute?.routePoints.append(routePoint)
        builder.currentWaypoint = nil
    }
    
    /// Appends a route to the GPX structure.
    private func handleRoute() {
        guard var route = builder.currentRoute else {
            return
        }
        if builder.gpx.version == .v1_0, let link = builder.currentLink {
            route.links.append(link)
            builder.currentLink = nil
        }
        builder.gpx.routes.append(route)
        builder.currentRoute = nil
    }
    
    /// Sets the text of a link element.
    /// - Parameter parent: The parent GPX element.
    private func handleLinkText(parent: Element?) {
        if parent == .link {
            builder.currentLink?.text = builder.currentValue
        }
    }
    
    /// Updates the bounds of the current metadata object.
    private func handleBounds() {
        builder.currentMetadata?.bounds = builder.currentBounds
        builder.currentBounds = nil
    }
    
    /// Sets the copyright for the current metadata.
    private func handleCopright() {
        builder.currentMetadata?.copyright = builder.currentCopyright
        builder.currentCopyright = nil
    }
    
    /// Sets the URL name for a link based on the GPX version.
    private func handleUrlName(parent: Element?) {
        guard builder.gpx.version == .v1_0 else {
            return
        }
        switch parent {
        case .metadata:
            builder.currentMetadataLink?.text = builder.currentValue
        case .wpt, .trk, .rte:
            if builder.currentLink == nil {
                builder.currentLink = Link()
            }
            builder.currentLink?.text = builder.currentValue
        default:
            break
        }
    }
    
    /// Sets the URL for a link based on the GPX version.
    private func handleUrl(parent: Element?) {
        guard builder.gpx.version == .v1_0, let url = builder.currentValue else {
            return
        }
        switch parent {
        case .metadata:
            builder.currentMetadataLink?.href = URL(string: url)
        case .wpt, .trk, .rte:
            if builder.currentLink == nil {
                builder.currentLink = Link()
            }
            builder.currentLink?.href = URL(string: url)
        default:
            break
        }
    }
    
    /// Appends a link to the current waypoint.
    private func handleLink(parent: Element?) {
        guard let link = builder.currentLink else {
            return
        }
        switch parent {
        case .metadata:
            builder.currentMetadata?.links.append(link)
        case .author:
            builder.currentAuthor?.link = link
        case .wpt:
            builder.currentWaypoint?.links.append(link)
        case .rte:
            builder.currentRoute?.links.append(link)
        case .trk:
            builder.currentTrack?.links.append(link)
        default:
            break
        }
        builder.currentLink = nil
    }
 
    /// Sets the elevation for the current waypoint.
    private func handleElevation() {
        guard let elevation = builder.currentValue else {
            return
        }
        builder.currentWaypoint?.elevation = Double(elevation)
    }
    
    /// Appends a waypoint to the GPX structure.
    private func handleWaypoint() {
        guard var waypoint = builder.currentWaypoint else {
            return
        }
        if builder.gpx.version == .v1_0, let link = builder.currentLink {
            waypoint.links.append(link)
            builder.currentLink = nil
        }
        builder.gpx.waypoints.append(waypoint)
        builder.currentWaypoint = nil
       
    }
    
    /// Sets the metadata for the GPX structure.
    private func handleMetadata() {
        builder.gpx.metadata = builder.currentMetadata
        builder.currentMetadata = nil
    }
    
    /// Processes the GPX element's ending, applying metadata and author information if needed.
    private func handleGPX() {
        if builder.gpx.version == .v1_0 {
            builder.currentMetadata?.author = builder.currentAuthor
            if builder.gpx.version == .v1_0, let link = builder.currentMetadataLink, link.href != nil {
                builder.currentMetadata?.links.append(link)
                builder.currentMetadataLink = nil
            }
            builder.gpx.metadata = builder.currentMetadata
            builder.currentMetadata = nil
            builder.currentAuthor = nil
        }
    }
}
