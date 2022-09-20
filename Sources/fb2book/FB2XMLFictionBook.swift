//
//  FB2FictionBook.swift
//  Document Reader
//
//  Created by Radzivon Bartoshyk on 23/04/2022.
//

import Foundation
import XMLCoder
import Html

public struct FB2XMLFictionBook: Codable {

    static let regex = try! NSRegularExpression(pattern: "xmlns", options: .caseInsensitive)
    static let regexCaptureLink = try! NSRegularExpression(pattern: "xmlns:.+", options: .caseInsensitive)

    let description: FB2XMLDescription
    let body: FB2XMLBody
    let binary: [FB2XMLBinary]

    public func getHTML() -> String {
        var finalNodes: [Node] = []
        if let cover = getCoverImageXML() {
            finalNodes.append(.div(.img(base64: cover.data.base64EncodedString(),
                                        type: .image(cover.contentType == "image/jpeg" ? .jpeg : .png),
                                        alt: "",
                                        attributes: [.style(safe: "object-fit: contain; width: 100%")])))
        }

        if let annotation = self.description.titleInfo.annotation?.sections {
            let ttl = annotation
            for each in ttl {
                let contents = toContent(contents: each.contents)
                var node = Node.strong()
                for content in contents {
                    node.append(content)
                }
                finalNodes.append(node)
            }
        }

        if let ttl = self.body.title {
            switch ttl {
            case .p(let fB2XMLP):
                let contents = toContent(contents: fB2XMLP.contents)
                var node = Node.h1()
                for content in contents {
                    node.append(content)
                }
                finalNodes.append(node)
            case .emptyLine:
                break
            }
        }
        finalNodes.append(.br)
        var nodes = [Node]()
        for each in self.body.sections {
            nodes.append(Node.div(Node.fragment(renderNested(contents: each))))
        }
        for node in nodes {
            finalNodes.append(node)
            finalNodes.append(Node.br)
        }
        let finalDiv = Node.div(attributes: [.style(safe: "font-size: calc(100% + 2vw); padding: 8px")], Node.fragment(finalNodes))
        let doc = Node.document(
            .html(.head(.meta(name: "charset", content: "UTF-8"),
                        .meta(contentType: .text(.html, charset: .utf8)),
                        .meta(viewport: .width(.deviceWidth), .initialScale(1.0))),
                  .body(attributes: [.style(safe: "")], finalDiv)))
        return render(doc)
    }

    private func renderNested(contents: [FB2XMLSectionContents]) -> [Node] {
        var node = [Node]()
        for content in contents {
            node.append(contentsOf: toContent(sectionContent: content))
        }
        return node
    }

    private func toContent(sectionContent: FB2XMLSectionContents) -> [Node] {
        switch sectionContent {
        case .section(let array):
            return [.div(Node.fragment(renderNested(contents: array)))]
        case .title(let fB2XMLTitle):
            switch fB2XMLTitle {
            case .p(let fB2XMLP):
                return toContent(contents: fB2XMLP.contents)
            case .emptyLine:
                return [Node.br]
            }
        case .p(let fB2XMLP):
            return [Node.div(Node.fragment(toContent(contents: fB2XMLP.contents)))]
        case .emptyLine:
            return [Node.br]
        case .image(let fB2XMLRef):
            return [getImage(ref: fB2XMLRef)]
        case .epigraph(let array):
            return getEpigraph(epigraphs: array)
        case .subtitle(let string):
            return [Node.h2(.text(string))]
        case .cite(let fB2XMLP):
            let contents = toContent(contents: fB2XMLP.contents)
            var nodes = [Node]()
            for content in contents {
                nodes.append(content)
            }
            return [Node.cite(Node.fragment(nodes))]
        case .poem(let fB2XMLPoem):
            //TODO: Poem
            let title = fB2XMLPoem.title
            var finalNodes = [Node]()
            let subtitle = fB2XMLPoem.subtitle
            switch subtitle {
            case .p(let fB2XMLP):
                let contents = toContent(contents: fB2XMLP.contents)
                var nodes = [Node]()
                for content in contents {
                    nodes.append(content)
                }
                let cite = Node.h2(Node.fragment(nodes))
                finalNodes.append(cite)
            case .emptyLine:
                finalNodes.append(.br)
            }
            switch title {
            case .p(let fB2XMLP):
                let contents = toContent(contents: fB2XMLP.contents)
                var nodes = [Node]()
                for content in contents {
                    nodes.append(content)
                }
                let cite = Node.h1(Node.fragment(nodes))
                finalNodes.append(cite)
            case .emptyLine:
                finalNodes.append(.br)
            }
            let epigraph = getEpigraph(epigraphs: fB2XMLPoem.epigraph)
            finalNodes.append(contentsOf: epigraph)
            let mapped = fB2XMLPoem.stanza.flatMap { $0.v.map { toContent(contents: $0.contents) }.flatMap { $0 } }
            finalNodes.append(contentsOf: mapped)
            return finalNodes
        case .unknown:
            return [Node.br]
        }
    }

    private func getEpigraph(epigraphs: [FB2XMLEpigraph]) -> [Node] {
        var nodes = [Node]()
        for epigraph in epigraphs {
            switch epigraph {
            case .p(let fB2XMLP):
                nodes.append(Node.div(Node.fragment(toContent(contents: fB2XMLP.contents))))
            case .emptyLine:
                nodes.append(.br)
            case .unknown:
                nodes.append(.br)
            case .textAuthor(let fB2XMLP):
                nodes.append(contentsOf: toContent(contents: fB2XMLP.contents))
            }
        }
        return nodes
    }

    private func toContent(contents: [FB2XMLPContents]) -> [Node] {
        var nn = [Node]()
        for content in contents {
            nn.append(toContent(content: content))
        }
        return nn
    }

    private func toContent(content: FB2XMLPContents) -> Node {
        switch content {
        case .image(let fB2XMLRef):
            return getImage(ref: fB2XMLRef)
        case .strong(let string):
            return Node.strong(.text(string))
        case .emphasis(let string):
            return Node.em(.text(string))
        case .a(let string, let fB2XMLRef):
            return Node.a(.text(string))
        case .strikethrough(let string):
            return Node.text(string)
        case .text(let string):
            return Node.p(.text(string))
        case .sub(let string):
            return Node.sub(.text(string))
        case .sup(let string):
            return Node.sup(.text(string))
        case .code(let string):
            return Node.code(.text(string))
        }
    }

    private func getImage(ref: FB2XMLRef) -> Node {
        var node = Node.div()
        let href = ref.href
        if href.starts(with: "#") {
            var pk = href
            pk.removeFirst()
            let realRef = "\(pk)"
            if let firstComplaintBinary = binary.first(where: { $0.id == realRef }) {
                node.append(.img(base64: firstComplaintBinary.data.base64EncodedString(),
                                 type: .image(firstComplaintBinary.contentType == "image/jpeg" ? .jpeg : .png),
                                 alt: "",
                                 attributes: [.style(safe: "object-fit: contain; width: 100%")]))
            }
        }
        return node
    }

    public func getCoverImageXML() -> FB2XMLBinary? {
        if let ref = description.titleInfo.coverpage?.image.href {
            if ref.starts(with: "#") {
                var pk = ref
                pk.removeFirst()
                let realRef = "\(pk)"
                let firstComplaintBinary = binary.first(where: { $0.id == realRef })
                return firstComplaintBinary
            } else {
                // DON'T KNOW WHAT TO DO
                return nil
            }
        } else {
            return nil
        }
    }

    public func getCoverImage() -> Data? {
        return getCoverImageXML()?.data
    }

    public enum CodingKeys: String, CodingKey {
        case description
        case body = "body"
        case binary
    }

    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        let range = NSRange(location: 0, length: key.stringValue.count)
        if regex.firstMatch(in: key.stringValue, range: range) != nil
            || regexCaptureLink.firstMatch(in: key.stringValue, range: range) != nil {
            return .attribute
        } else {
            return .element
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try container.decode(FB2XMLDescription.self, forKey: .description)
        self.body = try container.decode(FB2XMLBody.self, forKey: .body)
        self.binary = try container.decode([FB2XMLBinary].self, forKey: .binary)
    }
}
