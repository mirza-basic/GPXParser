//
//  Track.swift
//  
//
//  Created by Mirza Basic on 9. 3. 2024..
//

import Foundation
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
