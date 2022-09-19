//
//  FB2Section.swift
//  Document Reader
//
//  Created by Radzivon Bartoshyk on 23/04/2022.
//

import Foundation
import XMLCoder

public struct FB2HRefError: LocalizedError {
    public var errorDescription: String? {
        return "Couldn't find href to binary data"
    }
}

public struct FB2XMLRef: Codable, DynamicNodeDecoding {
    
    public let href: String
    public let alt: String?
    public let title: String?
    public let type: String?
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        if key.stringValue.contains("href")
            || key.stringValue.contains("id")
            || key.stringValue.contains("type")
            || key.stringValue.contains("alt")
            || key.stringValue.contains("title") {
            return .attribute
        }
        return .element
    }

    public init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        let container = try decoder.singleValueContainer()
        let dict = try container.decode([String: String].self)
        if let typeKey = dict.keys.first(where: { $0.contains("type") }) {
            self.type = dict[typeKey]
        } else {
            self.type = nil
        }
        guard let key = dict.keys.first(where: { $0.contains("href") }) else {
            throw FB2HRefError()
        }
        if let stringValue = dict[key] {
            self.href = stringValue
        } else {
            throw FB2HRefError()
        }
        alt = try keyedContainer.decodeIfPresent(String.self, forKey: .alt)
        title = try keyedContainer.decodeIfPresent(String.self, forKey: .title)
    }
}

public struct FB2XMLImageContainer: Codable {
    public let image: FB2XMLRef
}

public struct EmptyLine: Codable { }
