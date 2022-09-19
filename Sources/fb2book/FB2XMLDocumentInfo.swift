//
//  FB2DocumentInfo.swift
//  Document Reader
//
//  Created by Radzivon Bartoshyk on 23/04/2022.
//

import Foundation
import XMLCoder

public struct FB2XMLDocumentInfo: Codable {
    public let author: FB2DocumentAuthor
    public let programUsed: String?
    public let date: FB2XMLDate
    public  let version: String
    public let id: String
    
    enum CodingKeys: String, CodingKey {
        case author = "author"
        case programUsed = "program-used"
        case date = "date"
        case version = "version"
        case id = "id"
    }
}
