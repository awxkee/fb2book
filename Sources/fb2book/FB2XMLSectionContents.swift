//
//  FB2XMLSectionContents.swift
//  Document Reader
//
//  Created by Radzivon Bartoshyk on 23/04/2022.
//

import Foundation
import XMLCoder

public enum FB2XMLSectionContents {
    case section([FB2XMLSectionContents])
    case title(FB2XMLTitle)
    case p(FB2XMLP)
    case emptyLine
    case image(FB2XMLRef)
    case epigraph([FB2XMLEpigraph])
    case subtitle(String)
    case cite(FB2XMLP)
    case poem(FB2XMLPoem)
    case unknown
}

extension FB2XMLSectionContents: Codable {
    enum CodingKeys: String, XMLChoiceCodingKey {
        case section
        case title
        case p
        case emptyLine = "empty-line"
        case image
        case unknown
        case subtitle
        case epigraph = "epigraph"
        case cite
        case poem
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.section) {
            let contents = try container.decode([FB2XMLSectionContents].self, forKey: .section)
            self = .section(contents)
            return
        }
        if container.contains(.epigraph) {
            let contents = try container.decode([FB2XMLEpigraph].self, forKey: .epigraph)
            self = .epigraph(contents)
            return
        }
        if container.contains(.p) {
            let str = try container.decode(FB2XMLP.self, forKey: .p)
            self = .p(str)
            return
        }
        if container.contains(.emptyLine) {
            _ = try container.decode(EmptyLine.self, forKey: .emptyLine)
            self = .emptyLine
            return
        }
        if container.contains(.title) {
            let contents = try container.decode(FB2XMLTitle.self, forKey: .title)
            self = .title(contents)
            return
        }
        if container.contains(.subtitle) {
            self = .subtitle(try container.decode(String.self, forKey: .subtitle))
            return
        }
        if container.contains(.poem) {
            self = .poem(try container.decode(FB2XMLPoem.self, forKey: .poem))
            return
        }
        if container.contains(.cite) {
            self = .cite(try container.decode(FB2XMLP.self, forKey: .cite))
            return
        }
        self = .unknown
    }
}
