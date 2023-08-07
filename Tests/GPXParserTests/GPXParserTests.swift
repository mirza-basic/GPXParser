import XCTest
@testable import GPXParser

final class GPXParserTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        if let gpxURL = Bundle.module.url(forResource: "mystic_basin_trail", withExtension: "gpx") {
            do {
                let gpx = try GPXParser().parse(contentsOf: gpxURL)
                gpx.metadata
            } catch {
                XCTFail(error.localizedDescription)
            }
            
        } else {
            XCTFail("Failed to find the .gpx resource!")
        }


    }
}
