//
//  FB2Date.swift
//  Document Reader
//
//  Created by Radzivon Bartoshyk on 23/04/2022.
//

import Foundation
import XMLCoder

public struct FB2XMLDate: Codable, DynamicNodeDecoding {
    
    public let value: String?
    public let readable: String?
    
    enum CodingKeys: String, CodingKey {
        case value = "value"
        case readable
    }
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
        case CodingKeys.value:
            return .attribute
        default: return .element
        }
    }
    
}
