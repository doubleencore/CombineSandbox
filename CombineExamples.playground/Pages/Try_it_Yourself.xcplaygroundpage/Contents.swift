//: [Previous](@previous)

import Foundation
import Combine
import UIKit

playgroundShouldContinueIndefinitely()

class BooksAPI {
    func fetchBooks() -> AnyPublisher<[Book], Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Book].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}


//: [Next](@next)
