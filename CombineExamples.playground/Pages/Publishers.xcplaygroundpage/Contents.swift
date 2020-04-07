//: [Previous](@previous)

import Foundation
import Combine

/*:
 # Publishers
 There are several `Publishers` provided by the Combine framework. You should rarely need to create your own.

 ## Just
 Just publishers emit only one value and complete.

 ### Example
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

/*:
 ## Fail
 Always fails with the supplied error.

 ### Example
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

/*:
 ## Empty
 Never sends values or failures and optionally completes.

 ### Example 1
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

/*:
 ### Example 2
 Does not complete immediately, so it must be cancelled.
 */
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

/*:
 ## Publishers.Sequence
 Receives values in sequence

 ### Example
 */
example("Publishers.Sequence ") {
    _ = [1, 2, 3, 4].publisher
        .sink { (value) in
            print("received \(value)")
        }
}

/*:
 ## Future


 ### Example
 */
example("Future") {
    let future = Future<String, Error> { promise in
        print("note that this prints immediately")

        somethingThatMayTakeTime { result in
            switch result {
            case .success(let value):
                promise(.success(value))

            case .failure(let error):
                promise(.failure(error))
            }
        }
    }

    print("the Future closure is called before this")

    future.sink(receiveCompletion: { completion in
        print("received completion: \(completion)")
    }, receiveValue: { value in
        print("received value: \(value)")
    })
}

/*:
 ## Deferred


 ### Example
 */
example("Deferred") {
    let deferred = Deferred {
        return Future<String, Error> { promise in
            print("this doesn't print until subscribed")

            somethingThatMayTakeTime { result in
                switch result {
                case .success(let value):
                    promise(.success(value))

                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }

    print("this is called before the Future closure")

    deferred.sink(receiveCompletion: { completion in
        print("received completion: \(completion)")
    }, receiveValue: { value in
        print("received value: \(value)")
    })
}

/*:
 ## Record
 Similar to `PassthroughSubject`. Can send multiple values through the `Recording` closure.

 ### Example
 */
example("Record") {

    let recordPublisher = Record<String, Error> { (recording) in
        recording.receive("One")
        recording.receive("Two")
        recording.receive(completion: .finished)
    }

    _ = recordPublisher.sink(receiveCompletion: { (completion) in
        print("received completeion: \(completion)")
    }, receiveValue: { value in
        print("received value: \(value)")
    })
}

/*:
 ## Result

 ### Example
 Using the [Imperative API Example](Imperative_API_Example), but subscribing to the
 Result.publisher instead.
 */
example("Result") {
    let url = URL(string: "https://de-coding-test.s3.amazonaws.com/books.json")!
    fetchBooks(for: url) { (result) in
        result
            .publisher
            .sink(receiveCompletion: { completion in
                print("received completion: \(completion)")
            }, receiveValue: { value in
                print("received value: \(value.count) books")
            })
    }
}

/*:
 Many More!
 - Timer
 - NotificationCenter
 - URLSession
 - KVO
 - @Published
 - ObservableObject
 - ConnectablePublisher
 */

//: [Next](@next)
