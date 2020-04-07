//: [Previous](@previous)

import Foundation
import Combine

/*:
 */
example("receive(on:)") {
    let queue = DispatchQueue(label: "receive")
    let subject = PassthroughSubject<String, Never>()

    _ = subject
        .receive(on: queue)
        .sink { value in
            print("received \(value) on \(Thread.current)")
        }

    subject.send("hello")
}

/*:
 */
printExampleHeader("subscribe(on:)")
let sub = [1, 2, 3, 4, 5]
    .publisher
    .subscribe(on: DispatchQueue.global())
    .handleEvents(receiveOutput: { value in
        print("output \(value) emitted on \(Thread.current)")
    })
    .receive(on: DispatchQueue.main)
    .sink { value in
        print("received \(value) on \(Thread.current)")
    }

//: [Next](@next)
