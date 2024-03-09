//
//  Route.swift
//  
//
//  Created by Mirza Basic on 9. 3. 2024..
//

import Foundation
// MARK: - Route

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
