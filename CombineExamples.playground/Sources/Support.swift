import Foundation
import Combine

public let url = URL(string: "https://de-coding-test.s3.amazonaws.com/books.json")!

public extension Publisher {
    func debug_sink() -> AnyCancellable {
        return sink(receiveCompletion: { (completion) in
            Swift.print("completed: \(completion)")
        }, receiveValue: { value in
            Swift.print("received value: \(value)")
        })
    }
}
