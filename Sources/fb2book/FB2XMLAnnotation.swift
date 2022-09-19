//
//  FB2XMLAnnotation.swift
//  Document Reader
//
//  Created by Radzivon Bartoshyk on 19/09/2022.
//

import Foundation

public struct FB2XMLAnnotation: Codable {
    public let id: String?
    public let contents: [FB2XMLP]?
}
