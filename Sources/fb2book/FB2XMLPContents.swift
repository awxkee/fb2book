//
//  FB2XMLPContents.swift
//  Document Reader
//
//  Created by Radzivon Bartoshyk on 23/04/2022.
//

import Foundation
import XMLCoder

public enum FB2XMLPContents {
    case image(FB2XMLRef)
    case strong(String)
    case emphasis([FB2XMLPContents])
    case a([FB2XMLPContents], FB2XMLRef)
    case strikethrough(String)
    case text(String)
    case sub(String)
    case sup(String)
    case code(String)
}

extension FB2XMLPContents: Codable {
    enum CodingKeys: String, XMLChoiceCodingKey {
        case image
        case strong
        case emphasis
        case a
        case text
        case sub
        case sup
        case code
    }

    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if container.contains(.image) {
                let image = try container.decode(FB2XMLRef.self, forKey: .image)
                self = .image(image)
                return
            }
            if container.contains(.strong) {
                let str = try container.decode(String.self, forKey: .strong)
                self = .strong(str)
                return
            }
            if container.contains(.emphasis) {
                let str = try container.decode([FB2XMLPContents].self, forKey: .emphasis)
                self = .emphasis(str)
                return
            }
            if container.contains(.a) {
                let str = try container.decode([FB2XMLPContents].self, forKey: .a)
                let ref = try container.decode(FB2XMLRef.self, forKey: .a)
                self = .a(str, ref)
                return
            }
            if container.contains(.sub) {
                let str = try container.decode(String.self, forKey: .sub)
                self = .sub(str)
                return
            }
            if container.contains(.sup) {
                let str = try container.decode(String.self, forKey: .sup)
                self = .sup(str)
                return
            }
            if container.contains(.code) {
                let str = try container.decode(String.self, forKey: .code)
                self = .code(str)
                return
            }
            do {
                let content = try decoder.singleValueContainer().decode(String.self)
                self = .text(content)
            } catch {
                self = .text("")
            }
        } catch {
            self = .text("")
        }
    }
}
