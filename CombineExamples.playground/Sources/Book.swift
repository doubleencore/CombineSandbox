import Foundation

public struct Book {
    public let title: String
    public let author: String?
    public let imageHref: URL?
}

extension Book: Decodable {

}
