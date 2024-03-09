//
//  GPXParserError.swift
//  
//
//  Created by Mirza Basic on 7. 8. 2023..
//

import Foundation

enum GPXParserError: Error {
    case initializationError(String)   // For errors that occur during XMLParser initialization
    case parsingError(String)          // For errors specifically from the XMLParser
    case general(String)               // For other general, non-specific errors

    var localizedDescription: String {
        switch self {
        case .initializationError(let description):
            return "Initialization error: \(description)"
        case .parsingError(let description):
            return "Parsing error: \(description)"
        case .general(let description):
            return "General error: \(description)"
        }
    }
}
