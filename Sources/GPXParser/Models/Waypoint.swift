//
//  Waypoint.swift
//  
//
//  Created by Mirza Basic on 9. 3. 2024..
//

import Foundation
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

    public init(
        latitude: Latitude,
        longitude: Longitude,
        elevation: Elevation? = nil,
        time: Date? = nil,
        magneticVariation: Double? = nil,
        geoidHeight: Double? = nil,
        name: String? = nil,
        cmt: String? = nil,
        desc: String? = nil,
        src: String? = nil,
        links: [Link] = [],
        sym: String? = nil,
        type: String? = nil,
        fix: String? = nil,
        sat: Int? = nil,
        hdop: Double? = nil,
        vdop: Double? = nil,
        pdop: Double? = nil,
        ageOfDGPSData: Double? = nil,
        dgpsID: Int? = nil
    ) {
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
