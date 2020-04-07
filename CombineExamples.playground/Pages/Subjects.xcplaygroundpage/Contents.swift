//: [Previous](@previous)

import Foundation
import Combine

/*:
 # Subjects
 - A subject acts as a publisher in that it can pass values:
    - It can pass values it receives from other publishers
    - It can pass values manually using `send(_: Output)`
 - A subject also acts as a subscriber and can subscribe to publishers

 ## PassthroughSubject
 Think of PassthroughSubject as a relay. If values are published before any subscriber has subscribed,
 then the value  is not received. These can be useful when bridging a delegation-based (imperative) API to
 a declarative API.

 ### Example
 Creates a `PassthroughValueSubject`, send the value "before" (which is never received), then sends
 the values "Hello" and "world". It also demonstrates that adding another subscriber without sending any new
 values results in the subscriber never receiving anything.
 */
example("PassthroughSubject") {
    let subject = PassthroughSubject<String, Never>()

    subject.send("before")    // never received

    _ = subject.sink { value in
        print("received value: \(value)")
    }

    subject.send("Hello")
    subject.send("world")

    _ = subject.sink { value in
        print("never called")   // nothing received
    }
}

/*:
 ## CurrentValueSubject
 Think of `CurrentValueSubject` as a variable. It holds onto the current value and sends it to any new subscribers
 until the current value changes. `CurrentValueSubject`s are good for when you want an instance variable
 to retain the current state. New subscribers can see the current state and existing subscribers are notified on
 change.

 ### Example
 Notice that `CurrentValueSubject` retains the last delivered value and sends it to new subscribers.
 */
example("CurrentValueSubject") {
    let subject = CurrentValueSubject<String, Never>("Hello")

    _ = subject.sink { value in
        print("received value: \(value)")
    }

    subject.send("world")

    _ = subject.sink { value in
        print("current value: \(value)")    // receives current value
    }
}

/*:
 ## Subject as Subscriber
 A subject can subscribe to publishers and emit the publisher's values as their own.

 ### Example
 Shows how a `Subject` can emit values as well as subscribe to an existing publisher. Once the subscribed
 publisher completes, the subject also completes and no new values are sent.
 */
example("Subject subscribing to publisher") {
    let subject = PassthroughSubject<String, Never>()

    _ = subject.sink(receiveCompletion: { (completion) in
        print("received completion: \(completion)")
    }, receiveValue: { (value) in
        print("received value: \(value)")
    })

    subject.send("Hello")

    let publisher = ["world!", "Here", "we", "go"].publisher
    publisher.subscribe(subject)

    // if the subscribed publisher completes, then the subject completes and
    // nothing new can be sent

    subject.send("y'all")   // not sent
}

//: [Next](@next)
