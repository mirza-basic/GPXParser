//
//  Author.swift
//  
//
//  Created by Mirza Basic on 9. 3. 2024..
//

import Foundation
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
