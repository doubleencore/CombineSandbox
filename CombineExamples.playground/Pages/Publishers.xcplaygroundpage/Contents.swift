//: [Previous](@previous)

import Foundation
import Combine

/*:
 # Publishers
 There are several provided `Publishers`
 */

// Just
/*:
 Just publishers emit only one value and complete.
 */
example("Just publisher") {
    _ = Just(99)
        .sink { (value) in
            print("received value: \(value)")
        }
    // because the `Failure` type for `Just` is `Never` we can use
    // `sink(receiveValue:)` instead of `sink(receiveCompletion:receiveValue)`
    // (completion block is optional)
}

// Fail
/*:
 Always fails with the supplied error.
 */
example("Fail publisher") {
    _ = Fail<Int, TestError>(error: TestError.test)
        .sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                print("completed with error: \(error)")
            case .finished:
                print("completed without error")
            }
        }, receiveValue: { _ in
            print("never called")
        })
}
// Empty
/*:
 Never sends values or failures and optionally completes.
 */
example("Empty publisher") {
    // completes immediately by default
    _ = Empty<Int, Error>()
        .handleEvents(receiveSubscription: { _ in
            print("received subscription")
        }, receiveCancel: {
            print("never called")
        })
        .sink(receiveCompletion: { (completion) in
            print("completed: \(completion)")
        }, receiveValue: { value in
            print("never called")
        })
}

example("Empty publisher 2") {
    let subscription = Empty<Int, Error>(completeImmediately: false)
        .handleEvents(receiveSubscription: { _ in
            print("received subscription")
        }, receiveCancel: {
            print("received cancellation")
        })
        .sink(receiveCompletion: { (completion) in
            print("never called")
        }, receiveValue: { value in
            print("never called")
        })

    print("never completes, can only be cancelled")

    subscription.cancel()
}

// Publishers.Sequence
/*:
 Receives values in sequence
 */
example("Publishers.Sequence ") {
    _ = [1, 2, 3, 4].publisher
        .sink { (value) in
            print("received \(value)")
        }
}

// Future
example("") {
//    let future = Future<String, Error> { promise in
//        print("note that this prints immediately")
//        somethingThatTakesTime() { result in
//            switch result {
//            case .success(let value):
//                promise(.success(value))
//
//            case .failure(let error):
//                promise(.failure(error))
//            }
//        }
//    }
}

// Deferred
example("") {

}

// Record
example("") {

}

// MORE!!:
/*
 MakeConnectable
 SwiftUI
 ObservableObject
 @Published
 Foundation
 NotificationCenter
 Timer
 KVO
 URLSession
 Result
 
 */
//: [Next](@next)
