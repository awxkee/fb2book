//
//  FB2Body.swift
//  Document Reader
//
//  Created by Radzivon Bartoshyk on 23/04/2022.
//

import Foundation
import XMLCoder

public struct FB2XMLBody: Codable {
    
    public let title: FB2XMLTitle
    public let sections: [[FB2XMLSectionContents]]
    
    enum CodingKeys: String, CodingKey {
        case title
        case sections = "section"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(FB2XMLTitle.self, forKey: .title)
        self.sections = try container.decode([[FB2XMLSectionContents]].self, forKey: .sections)
    }
}
