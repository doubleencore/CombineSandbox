import Foundation

public func somethingThatMayTakeTime(timeToWait: TimeInterval = 0, completion: @escaping (Result<String, Error>) -> Void) {

    let result = Result<String, Error>.success("some future result")

    if timeToWait > 0 {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeToWait) {
            completion(result)
        }
    } else {
        completion(result)
    }
}

public func fetchBooks(for url: URL, completion: @escaping (Result<[Book], Error>) -> Void) {
    URLSession.shared.dataTask(with: url) { (data, response, error) in
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
    }.resume()
}
