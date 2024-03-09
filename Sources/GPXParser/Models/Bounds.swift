//
//  Bounds.swift
//
//
//  Created by Mirza Basic on 9. 3. 2024..
//

import Foundation
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
