//
//  File.swift
//  
//
//  Created by Mirza Basic on 16. 8. 2023..
//

import Foundation

extension String {
    func formatXML() -> String {
        guard let data = self.data(using: .utf8) else {
            return self
        }

        let parser = XMLParser(data: data)
        let formatter = XMLFormatter(withXML: self)
        parser.delegate = formatter

        guard parser.parse() else {
            print("XML parsing error: \(parser.parserError?.localizedDescription ?? "Unknown error")")
            return self
        }

        return formatter.formattedXML
    }
}

class XMLFormatter: NSObject, XMLParserDelegate {
    var formattedXML = ""
    private var level = 0
    private var text = ""
    private var xmlDeclaration: String?

    init(withXML xml: String) {
        super.init()

        if let declarationRange = xml.range(of: "^<\\?xml.*?\\?>", options: .regularExpression) {
            xmlDeclaration = String(xml[declarationRange])
        }
    }

    func parserDidStartDocument(_ parser: XMLParser) {
        if let xmlDeclaration = xmlDeclaration {
            formattedXML += xmlDeclaration + "\n"
        }
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        formattedXML += "\n" + String(repeating: "\t", count: level) + "<\(elementName)"
        for (key, value) in attributeDict {
            formattedXML += " \(key)=\"\(value)\""
        }
        formattedXML += ">"
        level += 1
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        level -= 1
        if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            formattedXML += text
            text = ""
        }
        formattedXML += "\n" + String(repeating: "\t", count: level) + "</\(elementName)>"
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        text += string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
