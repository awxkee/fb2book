//
//  FB2XMLEpigraph.swift
//  Document Reader
//
//  Created by Radzivon Bartoshyk on 23/04/2022.
//

import Foundation
import XMLCoder

public enum FB2XMLEpigraph {
    case p(FB2XMLP)
    case emptyLine
    case unknown
    case textAuthor(FB2XMLP)
}

extension FB2XMLEpigraph: Codable {
    enum CodingKeys: String, XMLChoiceCodingKey {
        case p
        case emptyLine = "empty-line"
        case textAuthor = "text-author"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.p) {
            let contents = try container.decode(FB2XMLP.self, forKey: .p)
            self = .p(contents)
            return
        }
        if container.contains(.emptyLine) {
            self = .emptyLine
            return
        }
        if container.contains(.textAuthor) {
            let contents = try container.decode(FB2XMLP.self, forKey: .textAuthor)
            self = .p(contents)
            return
        }
        self = .emptyLine
    }
}
