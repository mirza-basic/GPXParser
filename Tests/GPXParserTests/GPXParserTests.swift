import XCTest
@testable import GPXParser

class GPXParserTests: XCTestCase {

    var gpxParser: GPXParser!
    var gpxURL: URL!

    override func setUpWithError() throws {
        super.setUp()
        gpxParser = GPXParser()
        if let url = Bundle.module.url(forResource: "chatgpt", withExtension: "gpx") {
            gpxURL = url
        }
    }

    override func tearDownWithError() throws {
        gpxParser = nil
        gpxURL = nil
        super.tearDown()
    }

    func testMetadataParsing() throws {
        guard let gpx = try? gpxParser.parseGPX(from: gpxURL) else {
            XCTFail("Failed to parse GPX data")
            return
        }
        
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return dateFormatter
        }()

        XCTAssertEqual(gpx.metadata?.name, "Sample GPX Data")
        XCTAssertEqual(gpx.metadata?.desc, "Sample GPX File generated by ChatGPT for demonstration.")
        XCTAssertEqual(gpx.metadata?.author?.name, "ChatGPT")
        XCTAssertEqual(gpx.metadata?.links.first?.href, URL(string: "http://www.example.com"))
        XCTAssertEqual(gpx.metadata?.links.first?.text, "Visit Example")
        XCTAssertEqual(gpx.metadata?.time, dateFormatter.date(from: "2023-08-06T12:00:00Z"))
    }

    func testWaypointParsing() throws {
        guard let gpx = try? gpxParser.parseGPX(from: gpxURL) else {
            XCTFail("Failed to parse GPX data")
            return
        }

        XCTAssertEqual(gpx.waypoints.count, 2)
        XCTAssertEqual(gpx.waypoints.first?.latitude, 40.7128)
        XCTAssertEqual(gpx.waypoints.first?.longitude, -74.0060)
        XCTAssertEqual(gpx.waypoints.first?.elevation, 15.0)
        XCTAssertEqual(gpx.waypoints.first?.name, "New York")
    }

    func testRouteParsing() throws {
        guard let gpx = try? gpxParser.parseGPX(from: gpxURL) else {
            XCTFail("Failed to parse GPX data")
            return
        }

        XCTAssertEqual(gpx.routes.count, 1)
        XCTAssertEqual(gpx.routes.first?.name, "Sample Route")
        XCTAssertEqual(gpx.routes.first?.routePoints.count, 2)
    }

    func testTrackParsing() throws {
        guard let gpx = try? gpxParser.parseGPX(from: gpxURL) else {
            XCTFail("Failed to parse GPX data")
            return
        }

        XCTAssertEqual(gpx.tracks.count, 1)
        XCTAssertEqual(gpx.tracks.first?.name, "Sample Track")
        XCTAssertEqual(gpx.tracks.first?.segments.count, 1)
        XCTAssertEqual(gpx.tracks.first?.segments.first?.trackpoints.count, 4)
    }
}
