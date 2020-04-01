//: [Previous](@previous)

import Combine
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

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

let url = URL(string: "https://de-coding-test.s3.amazonaws.com/books.json")!
let subscriber = fetchBooks(for: url)
    .sink(receiveCompletion: { (completion) in
        print("completed: \(completion)")
        PlaygroundPage.current.finishExecution()
    }, receiveValue: { (books) in
        print("received books: \(books.count)")
    })

//: [Next](@next)
