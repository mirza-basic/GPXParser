import XCTest
@testable import GPXParser

class GPXParserTests: XCTestCase {
    
    var parser: GPXParser!

    override func setUp() {
        super.setUp()
        parser = GPXParser()
    }
    
    override func tearDown() {
        parser = nil
        super.tearDown()
    }
    
    func testGPXParserFor1_1Version() {
        guard let url = Bundle.module.url(forResource: "chatgpt1_1", withExtension: "gpx") else {
            XCTFail("Failed to load chatgpt1_0.gpx")
            return
        }
        
        do {
            let gpx = try parser.parseGPX(from: url)
            
            // Test version and creator
            XCTAssertEqual(gpx.version, .v1_1)
            XCTAssertEqual(gpx.creator, "TestApp")

            // Test metadata properties
            let metadata = gpx.metadata
            XCTAssertEqual(metadata?.name, "Test Track 1")
            XCTAssertEqual(metadata?.desc, "Description of the track")
            XCTAssertEqual(metadata?.links.first?.href?.absoluteString, "http://metadata-link.com")
            XCTAssertEqual(metadata?.links.first?.text, "Metadata Link")
            XCTAssertEqual(metadata?.links.first?.type, "meta")
            
            // Test author properties
            let author = metadata?.author
            XCTAssertEqual(author?.name, "John Doe")
            XCTAssertEqual(author?.email, "johndoe@example.com")
            XCTAssertEqual(author?.link?.href?.absoluteString, "http://example.com")
            XCTAssertEqual(author?.link?.text, "Example Link")
            XCTAssertEqual(author?.link?.type, "web")

            XCTAssertNotNil(gpx.waypoints.first)
            let waypoint = gpx.waypoints.first

            // Now, assert each individual property
            XCTAssertEqual(waypoint?.latitude, 10.0)
            XCTAssertEqual(waypoint?.longitude, 10.0)
            XCTAssertEqual(waypoint?.elevation, 100.0)
            XCTAssertEqual(waypoint?.time, ISO8601DateFormatter().date(from: "2023-08-09T12:00:00Z"))
            XCTAssertEqual(waypoint?.magneticVariation, 0.0)
            XCTAssertEqual(waypoint?.geoidHeight, 0.0)
            XCTAssertEqual(waypoint?.name, "Sample Waypoint")
            XCTAssertEqual(waypoint?.cmt, "Sample Comment")
            XCTAssertEqual(waypoint?.desc, "Sample Description")
            XCTAssertEqual(waypoint?.src, "Sample Source")
            XCTAssertNotNil(waypoint?.links.first)
            XCTAssertEqual(waypoint?.links.first?.href, URL(string: "http://sample-link.com"))
            XCTAssertEqual(waypoint?.links.first?.text, "Sample Link")
            XCTAssertEqual(waypoint?.links.first?.type, "sample")
            XCTAssertEqual(waypoint?.sym, "Sample Symbol")
            XCTAssertEqual(waypoint?.type, "Sample Type")
            XCTAssertEqual(waypoint?.fix, "none")
            XCTAssertEqual(waypoint?.sat, 5)
            XCTAssertEqual(waypoint?.hdop, 0.0)
            XCTAssertEqual(waypoint?.vdop, 0.0)
            XCTAssertEqual(waypoint?.pdop, 0.0)
            XCTAssertEqual(waypoint?.ageOfDGPSData, 0.0)
            XCTAssertEqual(waypoint?.dgpsID, 0)
            
            // Test track
            let track = gpx.tracks.first
            XCTAssertEqual(track?.name, "Track 1")
            XCTAssertEqual(track?.cmt, "Track Comment")
            XCTAssertEqual(track?.desc, "Track Description")
            XCTAssertEqual(track?.links.first?.href?.absoluteString, "http://track-link.com")

            // Test track segment
            let segment = track?.segments.first
            XCTAssertEqual(segment?.trackpoints.count, 3)
            XCTAssertEqual(segment?.trackpoints.count, 3)
            
        } catch {
            XCTFail("Failed to parse chatgpt1_1.gpx with error: \(error)")
        }
    }
    
    func testGPXParserFor1_0Version() {
        guard let url = Bundle.module.url(forResource: "chatgpt1_0", withExtension: "gpx") else {
            XCTFail("Failed to load chatgpt1_0.gpx")
            return
        }
        
        do {
            let gpx = try parser.parseGPX(from: url)
            
            // Test version and creator
            XCTAssertEqual(gpx.version, .v1_0)
            XCTAssertEqual(gpx.creator, "TestApp")

            // Test metadata properties
            let metadata = gpx.metadata
            XCTAssertEqual(metadata?.name, "Test Track 1")
            XCTAssertEqual(metadata?.desc, "Description of the track")
            XCTAssertEqual(metadata?.links.first?.href?.absoluteString, "http://example.com")
            XCTAssertEqual(metadata?.links.first?.text, "Example Link")
            XCTAssertNil(metadata?.links.first?.type)
            
            // Test author properties
            let author = metadata?.author
            XCTAssertEqual(author?.name, "John Doe")
            XCTAssertEqual(author?.email, "johndoe@example.com")

            XCTAssertNotNil(gpx.waypoints.first)
            let waypoint = gpx.waypoints.first

            // Now, assert each individual property
            XCTAssertEqual(waypoint?.latitude, 10.0)
            XCTAssertEqual(waypoint?.longitude, 10.0)
            XCTAssertEqual(waypoint?.elevation, 100.0)
            XCTAssertEqual(waypoint?.time, ISO8601DateFormatter().date(from: "2023-08-09T12:00:00Z"))
            XCTAssertEqual(waypoint?.magneticVariation, 0.0)
            XCTAssertEqual(waypoint?.geoidHeight, 0.0)
            XCTAssertEqual(waypoint?.name, "Sample Waypoint")
            XCTAssertEqual(waypoint?.cmt, "Sample Comment")
            XCTAssertEqual(waypoint?.desc, "Sample Description")
            XCTAssertEqual(waypoint?.src, "Sample Source")
            XCTAssertNotNil(waypoint?.links.first)
            XCTAssertEqual(waypoint?.links.first?.href, URL(string: "http://sample-link.com"))
            XCTAssertEqual(waypoint?.links.first?.text, "Sample Link")
            XCTAssertNil(waypoint?.links.first?.type)
            XCTAssertEqual(waypoint?.sym, "Sample Symbol")
            XCTAssertEqual(waypoint?.type, "Sample Type")
            XCTAssertEqual(waypoint?.fix, "none")
            XCTAssertEqual(waypoint?.sat, 5)
            XCTAssertEqual(waypoint?.hdop, 0.0)
            XCTAssertEqual(waypoint?.vdop, 0.0)
            XCTAssertEqual(waypoint?.pdop, 0.0)
            XCTAssertEqual(waypoint?.ageOfDGPSData, 0.0)
            XCTAssertEqual(waypoint?.dgpsID, 0)
            
            // Test track
            let track = gpx.tracks.first
            XCTAssertEqual(track?.name, "Track 1")
            XCTAssertEqual(track?.cmt, "Track Comment")
            XCTAssertEqual(track?.desc, "Track Description")
            XCTAssertEqual(track?.links.first?.href?.absoluteString, "http://track-link.com")

            // Test track segment
            let segment = track?.segments.first
            XCTAssertEqual(segment?.trackpoints.count, 3)
            XCTAssertEqual(segment?.trackpoints.count, 3)
            
        } catch {
            XCTFail("Failed to parse chatgpt1_0.gpx with error: \(error)")
        }
    }
}
