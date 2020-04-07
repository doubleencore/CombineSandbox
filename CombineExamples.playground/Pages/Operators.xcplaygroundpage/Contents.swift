//: [Previous](@previous)

import Foundation
import Combine

playgroundShouldContinueIndefinitely()

/*:
 # Operators
 - Operators take `<Input, Failure>` and emit a new `<Output, Failure>`.
 - They can change either type or the publisher completely.
 - Operators can be combined as much as needed

 ## Types of Operators
 There are dozens of operators and we won't cover them all here. Below is a list of the current types of
 operators, which is likely to change.
 - mapping elements
 - filtering elements
 - reducing elements
 - scheduler and thread handling
 - mathematic operations on elements
 - matching criteria to elements
 - applying sequence operations to elements
 - combining elements from publishers
 - handling errors
 - adapting publisher types
 - controlling timing
 - encoding/decoding
 - working with multiple subscribers
 - debugging
 - type erasure

 # Some common operators
 
 ## map
 Transforms all elements from the upstream publisher with a provided closure

 ### Example
 Transform each value using `map(_:)`
 */
example("map") {
    _ = [1, 2, 3, 4, 5].publisher
        .map { $0 * $0 }
        .sink { (value) in
            print("received: \(value)")
        }
}

/*:
 ## filter
 Republishes all elements that match a provided closure

 ### Example
 Filter odd values using `filter(_:)`
 */
example("filter") {
    _ = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].publisher
        .filter { $0 % 2 == 0 }
        .sink { (value) in
            print("received: \(value)")
        }
}

/*:
 ## eraseToAnyPublisher
 When chaining operators together, the resulting signature can accumulate all of the types, seen in the
 `crazySignature` function below. Using `eraseToAnyPublisher` erases the type back to
 `AnyPublisher` which provides a cleaner type for external declarations.

 ### Example
 */
example("eraseToAnyPublisher") {

    func crazySignature() -> Publishers.Decode<Publishers.Map<URLSession.DataTaskPublisher, JSONDecoder.Input>, [Book], JSONDecoder> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Book].self, decoder: JSONDecoder())
    }

    func erasedSignature() -> AnyPublisher<[Book], Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Book].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

}

var cancellables = Set<AnyCancellable>()

/*:
 ## flatMap
 Transforms all elements from upstream publisher into a new or existing publisher.

 ### Example
 Useful for using the result of an upstream publisher to create a new publisher
 */
example("flatMap") {

    Result<URL, Error>.Publisher(url)
        .flatMap { url in
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: [Book].self, decoder: JSONDecoder())
        }
        .sink(receiveCompletion: { completion in
            print("completed: \(completion)")
        }, receiveValue: { books in
            print("books: \(books.count)")
        })
        .store(in: &cancellables)
}

//: [Next](@next)
