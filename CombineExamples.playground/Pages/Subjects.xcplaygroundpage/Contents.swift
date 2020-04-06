//: [Previous](@previous)

import Foundation
import Combine

let subject = PassthroughSubject<String, Never>()

let cancellable1 = subject
    .sink { value in
        print("1: \(value)")
    }

let cancellable2 = subject
    .sink { (value) in
        print("2: \(value)")
    }

// sending values to the subject
subject.send("Hello")

// subscribe a subject to a publisher
let publisher = Just("world!")
publisher.subscribe(subject)

cancellable1.cancel()


// sending errors
enum SubjectError: LocalizedError {
    case unknown
}
let errorSubject = PassthroughSubject<String, Error>()
errorSubject.send(completion: .failure(SubjectError.unknown))
let c = errorSubject.sink(receiveCompletion: { (completion) in
    switch completion {
    case .failure(let error):
        print("error: \(error)")
    case .finished:
        print("finished")
    }
}) { (value) in
    print("value: \(value)")
}

let publisher1 = Just("world1!")

let c1 = publisher1.sink { (value) in
    print("1s: \(value)")
}

let c2 = publisher1.sink { (value) in
    print("2s: \(value)")
}



//: [Next](@next)
