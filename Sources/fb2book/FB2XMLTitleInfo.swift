//
//  FB2TitleInfo.swift
//  Document Reader
//
//  Created by Radzivon Bartoshyk on 23/04/2022.
//

import Foundation

public struct FB2XMLTitleInfo: Codable {
    public let genres: [String]
    public let author: [FB2XMLAuthor]
    public let bookTitle: String
    public let lang: String?
    public let annotation: FB2XMLAnnotation?
    public let coverpage: FB2XMLCoverpage?
    
    enum CodingKeys: String, CodingKey {
        case genres = "genre"
        case author
        case bookTitle = "book-title"
        case lang = "lang"
        case annotation
        case coverpage
    }
    
}
