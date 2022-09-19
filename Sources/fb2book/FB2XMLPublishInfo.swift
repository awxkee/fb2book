//
//  FB2PublishInfo.swift
//  Document Reader
//
//  Created by Radzivon Bartoshyk on 23/04/2022.
//

import Foundation
import XMLCoder

public struct FB2XMLPublishInfo: Codable {
    public let bookName: String?
    public let publisher: String?
    public let city: String?
    public let year: String?
    public let isbn: String?
    
    enum CodingKeys: String, CodingKey {
        case bookName = "book-name"
        case publisher = "publisher"
        case city = "city"
        case year = "year"
        case isbn = "isbn"
    }
}
