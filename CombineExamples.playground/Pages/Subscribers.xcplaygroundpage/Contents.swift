//: [Previous](@previous)

import Foundation
import Combine

example("simple sink example") {

    _ = [1, 2, 3, 4]
        .publisher
        .sink(receiveCompletion: { completion in
            print("completed: \(completion)")
        }, receiveValue: { value in
            print("received: \(value)")
        })
}

example("behind the scenes of sink") {
    // the sink method exists in an extension on Publisher

    // it creates a Subscribers.Sink instance:
    let subscriber = Subscribers.Sink<Int, Never>(
        receiveCompletion: { (completion) in
            print("completed: \(completion)")
        }, receiveValue: { (value) in
            print("received: \(value)")
        }
    )

    // then calls subscribe(_: Subscriber) to connect the publisher
    // to the subscriber
    [5, 6, 7, 8]
        .publisher
        .subscribe(subscriber)

    // and returns a cancellable
    let cancellable = AnyCancellable(subscriber)
}

example("behind the scenes of assign") {
    // the assign method exists in an extension on Publisher

    // it creates a Subscribers.Assign instance:
    let subscriber = Subscribers.Assign(object: PropertyHolder(), keyPath: \.property)

    // then calls subscribe(_: Subscriber) to connect the publisher
    // to the subscriber
    [9, 10, 11, 12]
        .publisher
        .subscribe(subscriber)

    // and returns a cancellable
    let cancellable = AnyCancellable(subscriber)
}

//: [Next](@next)
