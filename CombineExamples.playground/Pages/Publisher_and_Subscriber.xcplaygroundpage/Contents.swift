//: [Previous](@previous)

import Foundation
import Combine

/*:
# Publisher and Subscriber
 - A publisher transmits a sequence of values over time
 - A subscriber receives input from a publisher

 ## Publisher
 - Publishers declare the types of values and errors they produce via two `associatedtypes`:
    - `associatedtype Output`                     // types of _values_ published
    - `associatedtype Failure: Error`   // type of _error_ published (upon failure)
 - Publishers publish values to one or more subscribers
 - Publishers  emit zero or more values until they complete or fail with an error

 ### Example
 Since nothing ever subscribes to this publisher, nothing is ever emitted
*/
example("Just Publisher with no subscribers") {
    let publisher = Just("some value")  // one of the simplest publishers you can create
}

/*:
 ----
 ## Subscriber
 - Subscribers declare types of values and errors they can receive, which must match the `Output` and
 `Failure` of the publisher they subscribe to.
    - `associatedtype Input`                       // type of _values_ it can receive
    - `associatedtype Failure: Error`   // type of _error_ it can receive
 - Subscribers can only subscribe to one publisher
 - There are currently two built-in subscribers:
    - `sink(receiveCompletion:receiveValue:)`
    - `assign(to:on:)`

 ### Example 1
 _Subscribes_ to a `Just` publisher, which publishes one value and completes. Uses the `sink` subscriber
 to subscribe.
 */
example("Just Publisher subscribed with sink") {
    let publisher = Just("some value")

    let subscriber = publisher.sink(receiveCompletion: { completion in
        print("completed: \(completion)")
    }, receiveValue: { value in
        print("received value: \(value)")
    })
}

/*:
 ### Example 2
 Uses the `assign` subscriber to assign the received value to a property on a given instance.
 */
example("Just Publisher subscribed with assign") {
    class PropertyHolder {
        var property = "initial value"
    }

    let publisher = Just("new value")

    let object = PropertyHolder()
    print("property before assign: \(object.property)")

    _ = publisher.assign(to: \.property, on: object)
    print("property after assign: \(object.property)")
}

/*:
 ### Example 3
 Uses the `assign` subscriber to assign multiple received values to a property on a given instance.
 */
example("Publisher.Sequence subscribed with assign") {
    class PropertyHolder {
        var property = 0 {
            didSet {
                print("set property value to \(property)")
            }
        }
    }

    let object = PropertyHolder()
    print("initial property value: \(object.property)")

    _ = [1, 2, 3, 4]
        .publisher
        .assign(to: \.property, on: object)
}

//: [Next](@next)
