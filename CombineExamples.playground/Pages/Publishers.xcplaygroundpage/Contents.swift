//: [Previous](@previous)

import Foundation
import Combine

/*:
 # Publishers
 There are several `Publishers` provided by Apple. You should rarely need to create your own.

 ## Just
 Emits only one value and then completes.
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
 Completes immediately by default
 */
example("Empty publisher") {
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
    let sub = Empty<Int, Error>(completeImmediately: false)
        .handleEvents(receiveSubscription: { _ in
            print("received subscription")
        }, receiveCancel: {
            print("received cancellation")
        })
        .sink(receiveCompletion: { _ in
            print("never called")
        }, receiveValue: { _ in
            print("never called")
        })

    print("never completes, can only be cancelled")

    sub.cancel()
}

/*:
 ## Publishers.Sequence
 Produces a given sequence of elements, one element at a time
 */
example("Publishers.Sequence ") {
    _ = [1, 2, 3, 4].publisher
        .sink { (value) in
            print("received \(value)")
        }
}

/*:
 ## Future
 Eventually produces a single value and then finishes or fails
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
//    .print() // uncomment to see all publisher events

    print("the Future closure is called before this")

    future.sink(receiveCompletion: { completion in
        print("received completion: \(completion)")
    }, receiveValue: { value in
        print("received value: \(value)")
    })
}

/*:
 ## Deferred
 Awaits subscription before running the supplied closure to create a new publisher
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
//    .print() // uncomment to see all publisher events

    print("this is called before the Future closure")

    deferred.sink(receiveCompletion: { completion in
        print("received completion: \(completion)")
    }, receiveValue: { value in
        print("received value: \(value)")
    })
}

/*:
 ## Record
 Allows recording a series of outputs and a completion, for later playback to each subscriber.
 Similar to `PassthroughSubject`. Can send multiple values through the `Recording` closure.
 */
example("Record") {

    let recordPublisher = Record<String, Error> { (recording) in
        recording.receive("One")
        recording.receive("Two")
        recording.receive(completion: .finished)
    }

    _ = recordPublisher.sink(receiveCompletion: { (completion) in
        print("received completion: \(completion)")
    }, receiveValue: { value in
        print("received value: \(value)")
    })
}

/*:
 ## Result.Publisher
 Publishes a result then finishes normally, or fails without publishing any elements.
 This was renamed from Publishers.Once. This is similar to `Just`, but allows for failure.
 */
example("Result.Publisher") {
    _ = Result<URL, Error>.Publisher(url)
        .sink(receiveCompletion: { completion in
            print("received completion: \(completion)")
        }, receiveValue: { value in
            print("received value: \(value)")
        })

    // can also use Result.publisher
//    _ = Result<URL, Error> {
//            guard let url = URL(string: "") else {
//                throw TestError.test
//            }
//            return url
//        }
//        .publisher
//        .sink(receiveCompletion: { completion in
//            print("received completion: \(completion)")
//        }, receiveValue: { url in
//            print("received \(url)")
//        })
}

/*:
 ## Many More!
 - NotificationCenter.Publisher
 - URLSession.DataTaskPublisher
 - Optional.Publisher
 - Scene.Publisher
 - NSObject.KeyValueObservingPublisher
 - @Published
 - ObservableObjectPublisher
 - ConnectablePublisher
    - MakeConnectable
    - Multicast
    - Timer.TimerPublisher
 */

//: [Next](@next)
