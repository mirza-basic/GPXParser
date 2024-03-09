//
//  File.swift
//  
//
//  Created by Mirza Basic on 16. 8. 2023..
//

import Foundation

/// Extension providing functionality to serialize the GPX object into XML format.
public extension GPX {
    /**
     Returns the XML representation of the GPX object.
     
     - Returns: A string representing the GPX object in XML format.
     */
    func toXML() -> String {
        var xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <gpx
        """
        xml += " version=\"1.1\""

        if let creator = creator {
            xml += " creator=\"\(creator)\">"
        }

        // Metadata
        if let metadata = metadata {
            xml += metadata.toXML()
        }

        // Waypoints
        waypoints.forEach { xml += $0.toXML(elementName: "wpt") }

        // Routes
        routes.forEach { xml += $0.toXML() }

        // Tracks
        tracks.forEach { xml += $0.toXML() }

        xml += "</gpx>"
        return xml.formatXML()
    }
}

/// Extension providing functionality to serialize Metadata into XML format.
public extension Metadata {
    /**
     Returns the XML representation of the Metadata object.
     
     - Returns: A string representing the Metadata in XML format.
     */
    func toXML() -> String {
        var xml = "<metadata>"

        if let name = self.name {
            xml += "<name>\(name)</name>"
        }

        if let desc = self.desc {
            xml += "<desc>\(desc)</desc>"
        }

        if let author = self.author {
            xml += author.toXML()
        }

        if let copyright = self.copyright {
            xml += copyright.toXML()
        }

        for link in self.links {
            xml += link.toXML()
        }

        if let time = self.time {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            xml += "<time>\(dateFormatter.string(from: time))</time>"
        }

        if let keywords = self.keywords {
            xml += "<keywords>\(keywords)</keywords>"
        }

        if let bounds = self.bounds {
            xml += bounds.toXML()
        }

        xml += "</metadata>"
        return xml
    }
}

/// Extension providing functionality to serialize Author information into XML format.
public extension Author {
    /**
     Returns the XML representation of the Author object.
     
     - Returns: A string representing the Author in XML format.
     */
    func toXML() -> String {
        var xml = "<author>"

        if let name = self.name {
            xml += "<name>\(name)</name>"
        }

        if let email = self.email {
            xml += "<email>\(email)</email>"
        }

        if let link = self.link {
            xml += link.toXML()
        }

        xml += "</author>"
        return xml
    }
}

/// Extension providing functionality to serialize Copyright information into XML format.
public extension Copyright {
    /**
     Returns the XML representation of the Copyright object.
     
     - Returns: A string representing the Copyright in XML format.
     */
    func toXML() -> String {
        var xml = "<copyright author=\"\(self.author ?? "")\">"

        if let year = self.year {
            xml += "<year>\(year)</year>"
        }

        if let license = self.license {
            xml += "<license>\(license.absoluteString)</license>"
        }

        xml += "</copyright>"
        return xml
    }
}

/// Extension providing functionality to serialize Bounds information into XML format.
public extension Bounds {
    /**
     Returns the XML representation of the Bounds object.
     
     - Returns: A string representing the Bounds in XML format.
     */
    func toXML() -> String {
        return """
        <bounds minlat="\(minLat)" minlon="\(minLon)" maxlat="\(maxLat)" maxlon="\(maxLon)" />
        """
    }
}

/// Extension providing functionality to serialize Waypoint data into XML format.
public extension Waypoint {
    /**
     Returns the XML representation of the Waypoint object.
     
     - Parameter elementName: The XML element name for the waypoint.
     - Returns: A string representing the Waypoint in XML format.
     */
    func toXML(elementName: String) -> String {
        var xml = "<\(elementName) lat=\"\(latitude)\" lon=\"\(longitude)\">"

        if let elevation = elevation {
            xml += "<ele>\(elevation)</ele>"
        }

        if let time = time {
            let formatter = ISO8601DateFormatter()
            xml += "<time>\(formatter.string(from: time))</time>"
        }

        if let magneticVariation = magneticVariation {
            xml += "<magvar>\(magneticVariation)</magvar>"
        }

        if let geoidHeight = geoidHeight {
            xml += "<geoidheight>\(geoidHeight)</geoidheight>"
        }

        if let name = name {
            xml += "<name>\(name)</name>"
        }

        if let cmt = cmt {
            xml += "<cmt>\(cmt)</cmt>"
        }

        if let desc = desc {
            xml += "<desc>\(desc)</desc>"
        }

        if let src = src {
            xml += "<src>\(src)</src>"
        }

        for link in links {
            xml += link.toXML()
        }

        if let sym = sym {
            xml += "<sym>\(sym)</sym>"
        }

        if let type = type {
            xml += "<type>\(type)</type>"
        }

        if let fix = fix {
            xml += "<fix>\(fix)</fix>"
        }

        if let sat = sat {
            xml += "<sat>\(sat)</sat>"
        }

        if let hdop = hdop {
            xml += "<hdop>\(hdop)</hdop>"
        }

        if let vdop = vdop {
            xml += "<vdop>\(vdop)</vdop>"
        }

        if let pdop = pdop {
            xml += "<pdop>\(pdop)</pdop>"
        }

        if let ageOfDGPSData = ageOfDGPSData {
            xml += "<ageofdgpsdata>\(ageOfDGPSData)</ageofdgpsdata>"
        }

        if let dgpsID = dgpsID {
            xml += "<dgpsid>\(dgpsID)</dgpsid>"
        }

        xml += "</\(elementName)>"
        return xml
    }
}

/// Extension providing functionality to serialize Link data into XML format.
public extension Link {
    /**
     Returns the XML representation of the Link object.
     
     - Returns: A string representing the Link in XML format.
     */
    func toXML() -> String {
        var xml = "<link"
        if let href = href {
            xml += " href=\"\(href.absoluteString)\""
        }
        xml += ">"

        if let text = text {
            xml += "<text>\(text)</text>"
        }

        if let type = type {
            xml += "<type>\(type)</type>"
        }

        xml += "</link>"
        return xml
    }
}

/// Extension providing functionality to serialize Route data into XML format.
public extension Route {
    /**
     Returns the XML representation of the Route object.
     
     - Returns: A string representing the Route in XML format.
     */
    func toXML() -> String {
        var xml = "<rte>"

        if let name = self.name {
            xml += "<name>\(name)</name>"
        }

        if let cmt = self.cmt {
            xml += "<cmt>\(cmt)</cmt>"
        }

        if let desc = self.desc {
            xml += "<desc>\(desc)</desc>"
        }

        if let src = self.src {
            xml += "<src>\(src)</src>"
        }

        for link in self.links {
            xml += link.toXML()
        }

        if let number = self.number {
            xml += "<number>\(number)</number>"
        }

        if let type = self.type {
            xml += "<type>\(type)</type>"
        }

        for routePoint in self.routePoints {
            xml += routePoint.toXML(elementName: "rtept")
        }

        xml += "</rte>"
        return xml
    }
}

/// Extension providing functionality to serialize Track data into XML format.
public extension Track {
    /**
     Returns the XML representation of the Track object.
     
     - Returns: A string representing the Track in XML format.
     */
    func toXML() -> String {
        var xml = "<trk>"

        if let name = self.name {
            xml += "<name>\(name)</name>"
        }

        if let cmt = self.cmt {
            xml += "<cmt>\(cmt)</cmt>"
        }

        if let desc = self.desc {
            xml += "<desc>\(desc)</desc>"
        }

        if let src = self.src {
            xml += "<src>\(src)</src>"
        }

        for link in self.links {
            xml += link.toXML()
        }

        if let number = self.number {
            xml += "<number>\(number)</number>"
        }

        if let type = self.type {
            xml += "<type>\(type)</type>"
        }

        for segment in self.segments {
            xml += segment.toXML()
        }

        xml += "</trk>"
        return xml
    }
}

/// Extension providing functionality to serialize TrackSegment data into XML format.
public extension TrackSegment {
    /**
     Returns the XML representation of the TrackSegment object.
     
     - Returns: A string representing the TrackSegment in XML format.
     */
    func toXML() -> String {
        var xml = "<trkseg>"

        for trackpoint in self.trackpoints {
            xml += trackpoint.toXML(elementName: "trkpt")
        }

        xml += "</trkseg>"
        return xml
    }
}
