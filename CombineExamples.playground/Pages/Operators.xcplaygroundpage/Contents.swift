//: [Previous](@previous)

import Foundation
import Combine

playgroundShouldContinueIndefinitely()

var cancellables = Set<AnyCancellable>()

/*:
 # Operators
 - Operators take `<Input, Failure>` and emit a new `<Output, Failure>`.
 - They can change either type or the publisher completely.

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
 ### Example

 */
example("flatMap") {

    Just(URL(string: "https://de-coding-test.s3.amazonaws.com/books.json")!)
        .flatMap { url in
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: [Book].self, decoder: JSONDecoder())
                .replaceError(with: [])
        }
        .sink(receiveCompletion: { completion in
            print("completed: \(completion)")
        }, receiveValue: { books in
            print("books: \(books.count)")
        })
        .store(in: &cancellables)
}

//let url = URL(string: "https://de-coding-test.s3.amazonaws.com/books.json")!
//let books = URLSession.shared.dataTaskPublisher(for: url)
//    .map { $0.data }
//    .decode(type: [Book].self, decoder: JSONDecoder())
//    .replaceError(with: [])
//    .print()
//    .makeConnectable()
//
//books
//    .sink(receiveValue: {
//        print("subscription1 value: \($0.count)")
//    })
//    .store(in: &cancellables)
//
//books
//    .sink(receiveValue: {
//        print("subscription2 value: \($0.count)")
//    })
//    .store(in: &cancellables)
//
//books.connect()
//    .store(in: &cancellables)

//let subject = PassthroughSubject<Int, Never>()
//let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
//    .publisher
//    .print()
//    .multicast(subject: subject)
//
//numbers
//    .sink(receiveValue: {
//        print("1: \($0)")
//    })
//    .store(in: &cancellables)
//
//numbers
//    .sink(receiveValue: {
//        print("2: \($0)")
//    })
//    .store(in: &cancellables)
//
//numbers.connect()
//    .store(in: &cancellables)
//: [Next](@next)
