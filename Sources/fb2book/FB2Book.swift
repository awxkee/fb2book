import Foundation
import XMLCoder

public class FB2Book {

    public static func openBook(url: URL) throws -> FB2XMLFictionBook {
        let data = try Data(contentsOf: url)
        return try openBook(data: data)
    }

    public static func openBook(data: Data) throws -> FB2XMLFictionBook {
        let decoder = XMLDecoder()
        decoder.shouldProcessNamespaces = true
        let fb2File = try decoder.decode(FB2XMLFictionBook.self, from: data)
        return fb2File
    }

    public static func getCoverpage(url: URL) throws -> Data? {
        let fb2Book = try openBook(url: url)
        return fb2Book.getCoverImage()
    }

    public static func getCoverpage(data: Data) throws -> Data? {
        let fb2Book = try openBook(data: data)
        return fb2Book.getCoverImage()
    }

}
