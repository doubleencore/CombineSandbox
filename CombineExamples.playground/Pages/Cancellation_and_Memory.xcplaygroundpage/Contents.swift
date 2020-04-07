//: [Previous](@previous)

import Foundation
import Combine

/*:
 # Cancellable
 Subscribers conform to the `Cancellable` protocol. `AnyCancellable` is a type-erased reference that
 converts subscribers to the type `AnyCancellable`.  This allows the use of `.cancel()` on that type
 without accessing the subscription itself.

 _It is important to store a reference to the subscriber. Once it's deallocated it will implicitly cancel its operation._
 */

playgroundShouldContinueIndefinitely()

func sayHelloPublisher(_ debugPrefix: String) -> AnyPublisher<String, Never> {
    return Future<String, Never> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                promise(.success("hello there!"))
            }
        }
        .print(debugPrefix)    // prints log messages for all publishing events
        .eraseToAnyPublisher()
}

// this subscription is cancelled because the subscriber is not retained
sayHelloPublisher("subscriber 1")
    .sink { _ in } // cancelled before anything is received

// retain the cancellable subscriber so it's not cancelled
let cancellable = sayHelloPublisher("subscriber 2")
    .sink { _ in }

// you can also use `.store(in:)` to store cancellables in a collection. This is useful
// if you have a lot of subscriptions and do not want to add many ivars.
var cancellables = Set<AnyCancellable>() // or [AnyCancellable]()
sayHelloPublisher("subscriber 3")
    .sink { _ in }
    .store(in: &cancellables)

//: [Next](@next)
