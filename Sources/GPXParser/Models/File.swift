//
//  TrackSegment.swift
//  
//
//  Created by Mirza Basic on 9. 3. 2024..
//

import Foundation
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
