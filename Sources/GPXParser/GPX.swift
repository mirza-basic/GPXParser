//
//  GPX.swift
//  Atom
//
//  Created by Mirza Basic on 6. 8. 2023..
//

import Foundation

// Type Aliases
typealias Latitude = Double
typealias Longitude = Double
typealias Elevation = Double

// Main GPX Structure
public struct GPX: Codable {
    var version: GPXVersion?
    var creator: String?
    var metadata: Metadata?
    var waypoints: [Waypoint] = []
    var routes: [Route] = []
    var tracks: [Track] = []
    var extensions: Extensions?

    enum CodingKeys: String, CodingKey {
        case version, creator, metadata
        case waypoints = "wpt"
        case routes = "rte"
        case tracks = "trk"
        case extensions = "extensions"
    }
}

// MARK: - Version

enum GPXVersion: String, Codable {
    case v1_1 = "1.1"
    case v1_0 = "1.0"
}

// MARK: - Metadata
struct Metadata: Codable {
    var name: String?
    var desc: String?
    var author: Author?
    var copyright: Copyright?
    var links: [Link]? = []
    var time: Date?
    var keywords: String?
    var bounds: Bounds?
    var extensions: Extensions?
}

struct Author: Codable {
    var name: String?
    var email: String?
    var link: Link?
}

struct Copyright: Codable {
    var author: String?
    var year: String?
    var license: URL?
}

struct Link: Codable {
    var href: URL?
    var text: String?
    var type: String?

    enum CodingKeys: String, CodingKey {
        case href
        case text = "text"
        case type = "type"
    }
}

struct Bounds: Codable {
    var minLat: Latitude
    var minLon: Longitude
    var maxLat: Latitude
    var maxLon: Longitude

    enum CodingKeys: String, CodingKey {
        case minLat = "minlat"
        case minLon = "minlon"
        case maxLat = "maxlat"
        case maxLon = "maxlon"
    }
}

// MARK: - Waypoints, Routes, and Tracks
struct Waypoint: Codable {
    var latitude: Latitude
    var longitude: Longitude
    var elevation: Elevation?
    var time: Date?
    var magneticVariation: Double?
    var geoidHeight: Double?
    var name: String?
    var cmt: String?
    var desc: String?
    var src: String?
    var links: [Link]?
    var sym: String?
    var type: String?
    var fix: String?
    var sat: Int?
    var hdop: Double?
    var vdop: Double?
    var pdop: Double?
    var ageOfDGPSData: Double?
    var dgpsID: Int?
    var extensions: Extensions?

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case elevation = "ele"
        case time, magneticVariation = "magvar", geoidHeight = "geoidheight", name, cmt, desc, src
        case links = "link"
        case sym, type, fix, sat, hdop, vdop, pdop, ageOfDGPSData, dgpsID, extensions
    }
}

struct Route: Codable {
    var name: String?
    var cmt: String?
    var desc: String?
    var src: String?
    var links: [Link] = []
    var number: Int?
    var type: String?
    var routePoints: [Waypoint] = []
    var extensions: Extensions?

    enum CodingKeys: String, CodingKey {
        case name, cmt, desc, src
        case links = "link"
        case number, type
        case routePoints = "rtept"
        case extensions
    }
}

struct Track: Codable {
    var name: String?
    var cmt: String?
    var desc: String?
    var src: String?
    var links: [Link] = []
    var number: Int?
    var type: String?
    var segments: [TrackSegment] = []
    var extensions: Extensions?

    enum CodingKeys: String, CodingKey {
        case name, cmt, desc, src
        case links = "link"
        case number, type
        case segments = "trkseg"
        case extensions
    }
}

struct TrackSegment: Codable {
    var trackpoints: [Waypoint] = []
    var extensions: Extensions?

    enum CodingKeys: String, CodingKey {
        case trackpoints = "trkpt"
        case extensions
    }
}

// MARK: - Extensions
struct Extensions: Codable {
    // Extend based on specific requirements.
    // This struct can contain any elements that you need to support but aren't part of the GPX 1.1 specification.
}
