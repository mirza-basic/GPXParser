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

    public init(
        version: GPXVersion? = nil,
        creator: String? = nil,
        metadata: Metadata? = nil,
        waypoints: [Waypoint] = [],
        routes: [Route] = [],
        tracks: [Track] = []
    ) {
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
