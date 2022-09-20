//
//  FB2XMLAnnotation.swift
//  Document Reader
//
//  Created by Radzivon Bartoshyk on 19/09/2022.
//

import Foundation

public struct FB2XMLAnnotation: Codable {
    public let id: String?
    public let sections: [FB2XMLP]?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        do {
            let singleValueContainer = try decoder.singleValueContainer()
            self.sections = try singleValueContainer.decode([FB2XMLP].self)
        } catch {
            self.sections = nil
        }
    }
}
