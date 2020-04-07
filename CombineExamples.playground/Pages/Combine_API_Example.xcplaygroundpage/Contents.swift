//: [Previous](@previous)

import Combine
import Foundation
import PlaygroundSupport

func fetchBooks(for url: URL) -> AnyPublisher<[Book], Error> {
    return URLSession.shared.dataTaskPublisher(for: url)
        .tryMap { (data, response) in
            guard let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse
            }

            return data
        }
        .decode(type: [Book].self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
}

PlaygroundPage.current.needsIndefiniteExecution = true

let publisher = URLSession.shared.dataTaskPublisher(for: url)
    .map { $0.data }
    .decode(type: [Book].self, decoder: JSONDecoder())

let subscriber = publisher
    .sink(receiveCompletion: { (completion) in
        print("completed: \(completion)")
    }, receiveValue: { (books) in
        print("received books: \(books.count)")
    })

//: [Next](@next)
