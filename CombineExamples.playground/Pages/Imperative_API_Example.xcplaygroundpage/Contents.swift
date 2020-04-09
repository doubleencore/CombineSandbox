import Foundation
import PlaygroundSupport

func fetchBooks(for url: URL, completion: @escaping (Result<[Book], Error>) -> Void) {

    // Consists of a series of imperatives, or steps, to be completed
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        let result = Result<[Book], Error> {
            guard error == nil else {
                throw error ?? TestError.test
            }

            guard let data = data else {
                throw NetworkError.missingData
            }

            guard let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse
            }

            return try JSONDecoder()
                .decode([Book].self, from: data)
        }
        completion(result)
    }

    task.resume()
}

PlaygroundPage.current.needsIndefiniteExecution = true

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
