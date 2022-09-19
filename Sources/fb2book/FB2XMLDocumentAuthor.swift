//
//  FB2XMLDocumentAuthor.swift
//  Document Reader
//
//  Created by Radzivon Bartoshyk on 23/04/2022.
//

import Foundation

public struct FB2DocumentAuthor: Codable {
    public let firstName: String?
    public let middleName: String?
    public let lastName: String?
    public let nickname: String?
    public let homePage: String?
    public let email: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first-name"
        case middleName = "middle-name"
        case lastName = "last-name"
        case nickname = "nickname"
        case homePage = "home-page"
        case email = "email"
    }
    
}
