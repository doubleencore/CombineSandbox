//: [Previous](@previous)

import Foundation
import Combine

/*:
 # Combination Operators
 Operators that combine outputs from multiple `Publishers` into a single input.

 ## combineLatest
 A publisher that receives and combines the latest elements from two publishers.
 */
example("combineLatest") {
    let namePublisher = PassthroughSubject<String, Never>()
    let agePublisher = PassthroughSubject<Int, Never>()

    _ = Publishers.CombineLatest(namePublisher, agePublisher)
        .sink { (name, age) in
            print("name: \(name), age: \(age)")
        }

    // can also use:
//    namePublisher.combineLatest(agePublisher)

    namePublisher.send("Kim")
    namePublisher.send("Jim")
    agePublisher.send(22)
    agePublisher.send(29)
    namePublisher.send("Tim")
}

/*:
 ## zip
 Combines elements of publishers and delivers groups of elements as tuples at the corresponding index.
 */
example("zip") {
    let namePublisher = PassthroughSubject<String, Never>()
    let agePublisher = PassthroughSubject<Int, Never>()

    _ = Publishers.Zip(namePublisher, agePublisher)
        .sink { (name, age) in
            print("name: \(name), age: \(age)")
        }

    // can also use:
//    namePublisher.zip(agePublisher)

    namePublisher.send("Kim")
    namePublisher.send("Jim")
    agePublisher.send(22)
    agePublisher.send(29)
    namePublisher.send("Tim")
}

/*:
 ## merge
 Combines elements of publishers, delivering an interleaved sequence of elements.
 */
example("merge") {
    let publisher1 = [1, 2, 3, 4, 5].publisher
    let publisher2 = [100, 200, 300, 400].publisher

    Publishers.Merge(publisher1, publisher2)
        .sink { value in
            print("received: \(value)")
        }

    // can also use:
//    publisher1.merge(with: publisher2)
}

//: [Next](@next)
