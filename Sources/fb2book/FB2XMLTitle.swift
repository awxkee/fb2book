//
//  FB2XMLTitle.swift
//  Document Reader
//
//  Created by Radzivon Bartoshyk on 23/04/2022.
//

import Foundation
import XMLCoder

public enum FB2XMLTitle {
    case p(FB2XMLP)
    case emptyLine
}

extension FB2XMLTitle: Codable {
    enum CodingKeys: String, XMLChoiceCodingKey {
        case p
        case emptyLine = "empty-line"
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
        self = .emptyLine
    }
}
