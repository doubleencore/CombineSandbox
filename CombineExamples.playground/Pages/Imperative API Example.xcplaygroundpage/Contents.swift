import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

func fetchBooks(for url: URL, completion: @escaping (Result<[Book], Error>) -> Void) {
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        completion(Result<[Book], Error> {
            guard let data = data else {
                throw error ?? NetworkError.missingData
            }

            guard let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse
            }

            return try JSONDecoder().decode([Book].self, from: data)
        })
    }.resume()
}

let url = URL(string: "https://de-coding-test.s3.amazonaws.com/books.json")!
fetchBooks(for: url) { (result) in
    switch result {
    case let .success(books):
        print("number of books: \(books.count)")

    case let .failure(error):
        print("an error occurred: \(error)")
    }

    PlaygroundPage.current.finishExecution()
}

//: [Next](@next)
