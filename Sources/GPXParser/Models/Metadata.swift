//
//  Metadata.swift
//  
//
//  Created by Mirza Basic on 9. 3. 2024..
//

import Foundation
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
