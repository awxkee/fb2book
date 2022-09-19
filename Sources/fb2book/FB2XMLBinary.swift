//
//  FB2XMLBinary.swift
//  Document Reader
//
//  Created by Radzivon Bartoshyk on 23/04/2022.
//

import Foundation
import XMLCoder

public struct FB2XMLBinary: Codable {
    public let id: String
    public let contentType: String
    public let data: Data
    
    enum CodingKeys: String, XMLChoiceCodingKey {
        case id
        case contentType = "content-type"
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.contentType = try container.decode(String.self, forKey: .contentType)
        let contents = try decoder.singleValueContainer().decode(String.self)
        if let data = Data(base64Encoded: contents, options: .ignoreUnknownCharacters) {
            self.data = data
        } else {
            throw FB2InvalidStateError()
        }
    }
}
