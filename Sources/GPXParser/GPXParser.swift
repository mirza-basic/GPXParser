//
//  GPXParser.swift
//  Atom
//
//  Created by Mirza Basic on 6. 8. 2023..
//

import Foundation

public class GPXParser: NSObject {
    private enum Element: String {
        case gpx, metadata, wpt, ele, link, rte, rtept, trk,
             trkseg, trkpt, author, copyright, bounds, name,
             desc, year, license, email, time, url, urlname, text
    }
    
    private enum Atribute: String {
        case version, creator, lat, lon, href, author, minlat, minlon, maxlat, maxlon
    }
    
    private var gpx: GPX = GPX()
    private var elementStack: [Element] = []
    private var currentElement: Element?
    private var currentMetadata: Metadata?
    private var currentWaypoint: Waypoint?
    private var currentLink: Link?
    private var currentRoute: Route?
    private var currentTrack: Track?
    private var currentSegment: TrackSegment?
    private var currentAuthor: Author?
    private var currentCopyright: Copyright?
    private var currentBounds: Bounds?
    private var currentValue: String?
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
    
    public func parse(contentsOf url: URL) throws -> GPX {
        let parser = XMLParser(contentsOf: url)
        parser?.delegate = self
        if parser?.parse() == true {
            return gpx
        }
        throw parser?.parserError ?? GPXParserError.general
    }
}

extension GPXParser: XMLParserDelegate {
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        guard let element = Element(rawValue: elementName) else {
            return
        }
        currentValue = nil
        currentElement = element
        
        switch element {
        case .wpt, .rte, .rtept, .trk, .trkseg, .trkpt, .metadata, .link, .author:
            elementStack.append(element)
        default:
            break
        }
        
        switch currentElement {
        case .gpx:
            if let version = attributeDict[Atribute.version.rawValue] {
                gpx.version = GPXVersion(rawValue: version)
            }
            gpx.creator = attributeDict[Atribute.creator.rawValue]

            if gpx.version == .v1_0 {
                elementStack.append(.metadata)
                currentLink = Link()
                currentMetadata = Metadata()
                currentAuthor = Author()
            }
        case .metadata:
            currentMetadata = Metadata()
        case .wpt, .trkpt, .rtept:
            if let lat = Double(attributeDict[Atribute.lat.rawValue] ?? ""),
               let lon = Double(attributeDict[Atribute.lon.rawValue] ?? "") {
                currentWaypoint = Waypoint(latitude: lat, longitude: lon)
            }
        case .link:
            if let href = URL(string: attributeDict[Atribute.href.rawValue] ?? "") {
                currentLink = Link(href: href)
            }
        case .rte:
            currentRoute = Route()
        case .trk:
            currentTrack = Track()
        case .trkseg:
            currentSegment = TrackSegment()
        case .author:
            if gpx.version == .v1_1 {
                currentAuthor = Author()
            }
        case .copyright:
            if let author = attributeDict[Atribute.author.rawValue] {
                currentCopyright = Copyright(author: author)
            }
        case .bounds:
            if let minLat = Double(attributeDict[Atribute.minlat.rawValue] ?? ""),
               let minLon = Double(attributeDict[Atribute.minlon.rawValue] ?? ""),
               let maxLat = Double(attributeDict[Atribute.maxlat.rawValue] ?? ""),
               let maxLon = Double(attributeDict[Atribute.maxlon.rawValue] ?? "") {
                currentBounds = Bounds(minLat: minLat, minLon: minLon, maxLat: maxLat, maxLon: maxLon)
            }
        default:
            break
        }
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        let value = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if !value.isEmpty {
            currentValue = value
        }
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard let element = Element(rawValue: elementName) else {
            return
        }
        currentElement = element
        let parentElement = elementStack.last
        switch currentElement {
        case .gpx:
            if gpx.version == .v1_0 {
                currentAuthor?.link = currentLink
                currentMetadata?.author = currentAuthor
                gpx.metadata = currentMetadata
                currentMetadata = nil
            }
        case .metadata:
            gpx.metadata = currentMetadata
            currentMetadata = nil
            _ = elementStack.popLast()
        case .wpt:
            if let waypoint = currentWaypoint {
                gpx.waypoints.append(waypoint)
            }
            currentWaypoint = nil
            _ = elementStack.popLast()
        case .ele:
            if let currentValue, let elevation = Double(currentValue) {
                currentWaypoint?.elevation = elevation
            }
        case .link:
            if let link = currentLink {
                currentMetadata?.links?.append(link)
            }
            currentLink = nil
            _ = elementStack.popLast()
        case .url:
            if gpx.version == .v1_0 {
                currentLink?.href = URL(string: currentValue ?? "")
            }
        case .urlname:
            if gpx.version == .v1_0 {
                currentLink?.text = currentValue
            }
        case .rte:
            if let route = currentRoute {
                gpx.routes.append(route)
            }
            currentRoute = nil
            _ = elementStack.popLast()
        case .rtept:
            if let routePoint = currentWaypoint {
                currentRoute?.routePoints.append(routePoint)
            }
            currentWaypoint = nil
            _ = elementStack.popLast()
        case .trk:
            if let track = currentTrack {
                gpx.tracks.append(track)
            }
            currentTrack = nil
            _ = elementStack.popLast()
        case .trkseg:
            if let segment = currentSegment {
                currentTrack?.segments.append(segment)
            }
            currentSegment = nil
            _ = elementStack.popLast()
        case .trkpt:
            if let trackpoint = currentWaypoint {
                currentSegment?.trackpoints.append(trackpoint)
            }
            currentWaypoint = nil
            _ = elementStack.popLast()
        case .author:
            if gpx.version == .v1_0 {
                currentAuthor?.name = currentValue
            } else {
                currentMetadata?.author = currentAuthor
                currentAuthor = nil
            }
            _ = elementStack.popLast()
        case .copyright:
            currentMetadata?.copyright = currentCopyright
            currentCopyright = nil
        case .bounds:
            currentMetadata?.bounds = currentBounds
            currentBounds = nil
        case .time:
            if let currentValue, let date = dateFormatter.date(from: currentValue) {
                switch parentElement {
                case .metadata:
                    currentMetadata?.time = date
                case .wpt, .rtept, .trkpt:
                    currentWaypoint?.time = date
                default:
                    break
                }
            }
        case .name:
            switch parentElement {
            case .metadata:
                currentMetadata?.name = currentValue
            case .wpt, .rtept, .trkpt:
                currentWaypoint?.name = currentValue
            case .rte:
                currentRoute?.name = currentValue
            case .trk:
                currentTrack?.name = currentValue
            case .author:
                currentAuthor?.name = currentValue
            default:
                break
            }
        case .desc:
            switch parentElement {
            case .metadata:
                currentMetadata?.desc = currentValue
            case .wpt, .rtept, .trkpt:
                currentWaypoint?.desc = currentValue
            case .rte:
                currentRoute?.desc = currentValue
            case .trk:
                currentTrack?.desc = currentValue
            default:
                break
            }
        case .text:
            switch parentElement {
            case .link:
                currentLink?.text = currentValue
            default:
                break
            }
        case .year:
            currentCopyright?.year = currentValue
        case .license:
            currentCopyright?.license = URL(string: currentValue ?? "")
        case .email:
            currentAuthor?.email = currentValue
        default:
            break
        }
    }
}
