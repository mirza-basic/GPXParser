//
//  Copyright.swift
//  
//
//  Created by Mirza Basic on 9. 3. 2024..
//

import Foundation

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
