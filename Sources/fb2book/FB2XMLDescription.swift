//
//  FB2Description.swift
//  Document Reader
//
//  Created by Radzivon Bartoshyk on 23/04/2022.
//

import Foundation
import XMLCoder

public struct FB2XMLDescription: Codable {
    public let titleInfo: FB2XMLTitleInfo
    public let documentInfo: FB2XMLDocumentInfo?
    public let publishInfo: FB2XMLPublishInfo?
    
    enum CodingKeys: String, CodingKey {
        case titleInfo = "title-info"
        case documentInfo = "document-info"
        case publishInfo = "publish-info"
    }
    
}
