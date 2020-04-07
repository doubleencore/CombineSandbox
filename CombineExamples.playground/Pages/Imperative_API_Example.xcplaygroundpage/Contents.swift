import Foundation
import PlaygroundSupport

func fetchBooks(for url: URL, completion: @escaping (Result<[Book], Error>) -> Void) {
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        completion(Result<[Book], Error> {
            guard let data = data else {
                throw error ?? NetworkError.missingData
            }

            guard let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse
            }

            return try JSONDecoder()
                .decode([Book].self, from: data)
        })
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
