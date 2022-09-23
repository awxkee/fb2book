//
//  FB2XMLP.swift
//  Document Reader
//
//  Created by Radzivon Bartoshyk on 23/04/2022.
//

import Foundation

public struct FB2XMLP: Codable {
    public let contents: [FB2XMLPContents]

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        do {
            self.contents = try container.decode([FB2XMLPContents].self)
        } catch {
            self.contents = [.text(try container.decode(String.self))]
        }
    }
}
