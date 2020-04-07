//: [Previous](@previous)

import Foundation
import Combine


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
