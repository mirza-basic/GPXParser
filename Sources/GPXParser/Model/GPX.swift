//
//  GPX.swift
//  Atom
//
//  Created by Mirza Basic on 6. 8. 2023..
//
import Foundation

public typealias Latitude = Double
public typealias Longitude = Double
public typealias Elevation = Double

/// The main structure representing a GPX (GPS Exchange Format) object. GPX is an XML schema designed for the interchange of GPS data.
///
/// # Features
/// - Represents both versions 1.0 and 1.1 of the GPX format.
/// - Provides methods and properties to easily navigate and modify the GPX structure.
public struct GPX: Codable {
    
    /// The version of the GPX schema.
    public var version: GPXVersion?
    
    /// The software or device that created the GPX content.
    public var creator: String?
    
    /// Metadata about the GPX file and its content.
    public var metadata: Metadata?
    
    /// An array of geographic waypoints.
    public var waypoints: [Waypoint] = []
    
    /// An array of routes, each representing an ordered list of waypoints.
    public var routes: [Route] = []
    
    /// An array of tracks, each representing an ordered set of points describing a path.
    public var tracks: [Track] = []
    
    public init(version: GPXVersion? = nil, creator: String? = nil, metadata: Metadata? = nil, waypoints: [Waypoint] = [], routes: [Route] = [], tracks: [Track] = []) {
        self.version = version
        self.creator = creator
        self.metadata = metadata
        self.waypoints = waypoints
        self.routes = routes
        self.tracks = tracks
    }
    
    enum CodingKeys: String, CodingKey {
        case version, creator, metadata
        case waypoints = "wpt"
        case routes = "rte"
        case tracks = "trk"
    }
}

// MARK: - Version

/// Represents GPX versions supported.
public enum GPXVersion: String, Codable {
    case v1_1 = "1.1"
    case v1_0 = "1.0"
}

// MARK: - Metadata

/// Metadata about the GPX file.
public struct Metadata: Codable {
    
    /// The name of the GPX file.
    public var name: String?
    
    /// A description of the GPX file.
    public var desc: String?
    
    /// The person or organization who created the GPX file.
    public var author: Author?
    
    /// Copyright details for the GPX file.
    public var copyright: Copyright?
    
    /// An array of links related to the content in the GPX file.
    public var links: [Link] = []
    
    /// The timestamp when the data was created.
    public var time: Date?
    
    /// Keywords associated with the GPX file.
    public var keywords: String?
    
    /// Minimum and maximum coordinates which describe the extent of the coordinates in the GPX file.
    public var bounds: Bounds?
    
    public init(name: String? = nil, desc: String? = nil, author: Author? = nil, copyright: Copyright? = nil,
                links: [Link] = [], time: Date? = nil, keywords: String? = nil, bounds: Bounds? = nil) {
        self.name = name
        self.desc = desc
        self.author = author
        self.copyright = copyright
        self.links = links
        self.time = time
        self.keywords = keywords
        self.bounds = bounds
    }
}

// MARK: - Author

/// Author of the GPX content.
public struct Author: Codable {
    
    /// Name of the author.
    public var name: String?
    
    /// Email address of the author.
    public var email: String?
    
    /// Link to the web site or other external information about the author.
    public var link: Link?

    public init(name: String? = nil, email: String? = nil, link: Link? = nil) {
        self.name = name
        self.email = email
        self.link = link
    }
}

// MARK: - Copyright

/// Copyright information of the GPX content.
public struct Copyright: Codable {
    
    /// Name of the copyright holder.
    public var author: String?
    
    /// Year of the copyright.
    public var year: String?
    
    /// URL linking to the license on the web.
    public var license: URL?
    
    public init(author: String? = nil, year: String? = nil, license: URL? = nil) {
        self.author = author
        self.year = year
        self.license = license
    }
}

// MARK: - Link

/// A link to external resources or references.
public struct Link: Codable {
    
    /// The URL of the hyperlink.
    public var href: URL?
    
    /// Descriptive text for the hyperlink.
    public var text: String?
    
    /// Mime type of the content (e.g., "text/html").
    public var type: String?
    
    enum CodingKeys: String, CodingKey {
        case href
        case text
        case type
    }
    
    public init(href: URL? = nil, text: String? = nil, type: String? = nil) {
        self.href = href
        self.text = text
        self.type = type
    }
}

// MARK: - Bounds

/// Bounds that define the spatial extent of the GPX file.
public struct Bounds: Codable {
    
    /// Minimum latitude of the bounding box.
    public var minLat: Latitude
    
    /// Minimum longitude of the bounding box.
    public var minLon: Longitude
    
    /// Maximum latitude of the bounding box.
    public var maxLat: Latitude
    
    /// Maximum longitude of the bounding box.
    public var maxLon: Longitude

    enum CodingKeys: String, CodingKey {
        case minLat = "minlat"
        case minLon = "minlon"
        case maxLat = "maxlat"
        case maxLon = "maxlon"
    }
    
    public init(minLat: Latitude, minLon: Longitude, maxLat: Latitude, maxLon: Longitude) {
        self.minLat = minLat
        self.minLon = minLon
        self.maxLat = maxLat
        self.maxLon = maxLon
    }
}

// MARK: - Waypoint

/// Represents a geographic waypoint, which is a specific point on Earth defined by its latitude, longitude, and optional additional attributes.
///
/// A waypoint can be anything from a notable landmark to a desired destination or a point of interest.
public struct Waypoint: Codable {
    
    /// Latitude of the waypoint. A valid value is between -90 and 90.
    public var latitude: Latitude

    /// Longitude of the waypoint. A valid value is between -180 and 180.
    public var longitude: Longitude
    
    /// Elevation of the waypoint in meters above sea level. This is optional as not all waypoints may have elevation data.
    public var elevation: Elevation?
    
    /// The time the waypoint was recorded. This can be useful for tracking movements or determining when the waypoint was created.
    public var time: Date?
    
    /// Magnetic variation (in degrees) at the waypoint. This can be used for navigation purposes.
    public var magneticVariation: Double?
    
    /// Height (in meters) of the geoid (mean sea level) above the WGS84 earth ellipsoid. Useful in geodetic computations.
    public var geoidHeight: Double?
    
    /// The name or label of the waypoint.
    public var name: String?
    
    /// Comment about the waypoint. Can be used to store additional information about the waypoint.
    public var cmt: String?
    
    /// A description of the waypoint. Can provide more detailed information than the comment.
    public var desc: String?
    
    /// Source of the waypoint data.
    public var src: String?
    
    /// Links to additional information about the waypoint.
    public var links: [Link] = []
    
    /// Text representation (e.g., a symbol) for displaying the waypoint on maps.
    public var sym: String?
    
    /// Type classification of the waypoint (e.g., "campground", "water source").
    public var type: String?
    
    /// The type of GPS fix. Examples include: "dgps", "pps", "fix", "none".
    public var fix: String?
    
    /// Number of satellites used to determine the GPS fix.
    public var sat: Int?
    
    /// Horizontal dilution of precision. Represents the error in the horizontal position.
    public var hdop: Double?
    
    /// Vertical dilution of precision. Represents the error in the vertical position.
    public var vdop: Double?
    
    /// Overall dilution of precision of the fix.
    public var pdop: Double?
    
    /// Age of the differential GPS (DGPS) data in seconds.
    public var ageOfDGPSData: Double?
    
    /// ID of the DGPS station used to determine the fix.
    public var dgpsID: Int?

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case elevation = "ele"
        case time, magneticVariation = "magvar", geoidHeight = "geoidheight", name, cmt, desc, src
        case links = "link"
        case sym, type, fix, sat, hdop, vdop, pdop, ageOfDGPSData, dgpsID
    }
    
    public init(latitude: Latitude, longitude: Longitude, elevation: Elevation? = nil, time: Date? = nil,
         magneticVariation: Double? = nil, geoidHeight: Double? = nil, name: String? = nil, cmt: String? = nil,
         desc: String? = nil, src: String? = nil, links: [Link] = [], sym: String? = nil, type: String? = nil,
         fix: String? = nil, sat: Int? = nil, hdop: Double? = nil, vdop: Double? = nil, pdop: Double? = nil,
         ageOfDGPSData: Double? = nil, dgpsID: Int? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.elevation = elevation
        self.time = time
        self.magneticVariation = magneticVariation
        self.geoidHeight = geoidHeight
        self.name = name
        self.cmt = cmt
        self.desc = desc
        self.src = src
        self.links = links
        self.sym = sym
        self.type = type
        self.fix = fix
        self.sat = sat
        self.hdop = hdop
        self.vdop = vdop
        self.pdop = pdop
        self.ageOfDGPSData = ageOfDGPSData
        self.dgpsID = dgpsID
    }
}

// MARK: - TraRouteck

/// Represents a route in GPX, which is an ordered list of waypoints representing a series of turn points leading to a destination.
///
/// A route is intended to provide navigation instructions to a particular destination, often created by a user on a device or application and can be followed for guidance.
public struct Route: Codable {
    
    /// The name or title of the route. This can be used to provide a quick reference or label for the route.
    public var name: String?
    
    /// Comment regarding the route. Useful for storing additional context or brief notes about the route.
    public var cmt: String?
    
    /// A detailed description of the route. This can provide more in-depth information or instructions about the route.
    public var desc: String?
    
    /// Source of the route data. Can be used to track where the route information originated or was derived from.
    public var src: String?
    
    /// Links to web pages or other external sources of information related to the route.
    public var links: [Link] = []
    
    /// A number or identifier for the route, which can be useful for organizing or ordering routes.
    public var number: Int?
    
    /// A classification or type of the route. For example, "hiking", "cycling", "driving".
    public var type: String?
    
    /// An ordered list of waypoints that make up the route. These can be used for navigation purposes.
    public var routePoints: [Waypoint] = []
    
    enum CodingKeys: String, CodingKey {
        case name, cmt, desc, src
        case links = "link"
        case number, type
        case routePoints = "rtept"
    }
    
    public init(name: String? = nil, cmt: String? = nil, desc: String? = nil, src: String? = nil, links: [Link] = [], number: Int? = nil, type: String? = nil, routePoints: [Waypoint] = []) {
        self.name = name
        self.cmt = cmt
        self.desc = desc
        self.src = src
        self.links = links
        self.number = number
        self.type = type
        self.routePoints = routePoints
    }
}

// MARK: - Track

/// Represents a track in GPX, which is an ordered set of points describing the path of the track.
///
/// A track differs from a route in that it typically represents a recorded path. While a route is a set of turn points to be followed, a track represents where one has been.
public struct Track: Codable {
    
    /// The name or label of the track. Can be used as a quick reference or identifier.
    public var name: String?
    
    /// Comment about the track. Useful for adding brief notes or context.
    public var cmt: String?
    
    /// A more detailed description of the track, which can provide insights or specifics about the journey or path taken.
    public var desc: String?
    
    /// Source of the track data. Can provide information about where or how the track was recorded.
    public var src: String?
    
    /// Links to web pages or other external sources of information related to the track.
    public var links: [Link] = []
    
    /// A number or identifier for the track, useful for organizing or sequencing tracks.
    public var number: Int?
    
    /// Classification or type of the track, e.g., "hiking", "cycling", "driving".
    public var type: String?
    
    /// Segments that make up the track. A track can have multiple segments, which can represent different parts or phases of the journey.
    public var segments: [TrackSegment] = []

    enum CodingKeys: String, CodingKey {
        case name, cmt, desc, src
        case links = "link"
        case number, type
        case segments = "trkseg"
    }
    
    public init(name: String? = nil, cmt: String? = nil, desc: String? = nil, src: String? = nil, links: [Link] = [], number: Int? = nil, type: String? = nil, segments: [TrackSegment] = []) {
        self.name = name
        self.cmt = cmt
        self.desc = desc
        self.src = src
        self.links = links
        self.number = number
        self.type = type
        self.segments = segments
    }
}

// MARK: - TrackSegment

/// Represents a segment of a track.
public struct TrackSegment: Codable {
    public var trackpoints: [Waypoint] = []  // List of waypoints that make up this segment.

    enum CodingKeys: String, CodingKey {
        case trackpoints = "trkpt"
    }
    
    public init(trackpoints: [Waypoint] = []) {
        self.trackpoints = trackpoints
    }
}
