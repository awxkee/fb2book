//
//  FB2Poem.swift
//  Document Reader
//
//  Created by Radzivon Bartoshyk on 23/04/2022.
//

import Foundation

public struct FB2XMLPoem: Codable {
    public let title: FB2XMLTitle
    public let epigraph: [FB2XMLEpigraph]
    public let subtitle: FB2XMLTitle
    public let stanza: [FB2XMLStanza]
}
