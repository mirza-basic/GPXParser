//
//  Link.swift
//  
//
//  Created by Mirza Basic on 9. 3. 2024..
//

import Foundation
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
