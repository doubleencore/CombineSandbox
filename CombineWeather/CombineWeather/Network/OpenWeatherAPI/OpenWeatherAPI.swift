//
//  OpenWeatherAPI.swift
//  CombineWeather
//
//  Created by Kyle Watson on 3/16/20.
//  Copyright © 2020 Kyle Watson. All rights reserved.
//

import Foundation
import Combine

typealias OpenWeatherAPIClient = OpenWeather.APIClient

struct OpenWeather {

    enum APIError: Error {
        case malformedUrl(href: String)
        case invalidResponse
        case unsuccessfulStatusCode(Int)
    }

    class APIClient {

        private let urlSession: URLSession

        init(urlSession: URLSession = .shared) {
            self.urlSession = urlSession
        }

        func doIt<T: Codable>(request: APIRequest) -> AnyPublisher<T, Error> {

            // build URLRequest from APIRequest
            let urlRequest = URLRequest(url: URL(string: "")!)

            return urlSession.dataTaskPublisher(for: urlRequest)
                .map { $0.data }
                .decode(type: T.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }


        // TODO: one APIClient method building from APIRequest (e.g., doIt() above)...? What about handling responses differently?
        // TODO: use APIRequest instead of URLRequest...? (Only Network code should use URLRequest. Dependent code should not)
        /// current conditions
        func currentConditions(request: URLRequest) -> AnyPublisher<Condition, Error> {
            // https://api.openweathermap.org/data/2.5/weather

            return urlSession.dataTaskPublisher(for: request)
                .tryMap(dataIfStatusIsSuccess)
                .decode(type: Condition.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }

        /// 5 day with data every 3 hours
        func forecast(request: URLRequest) -> AnyPublisher<Forecast, Error> {
            // https://api.openweathermap.org/data/2.5/forecast

            return urlSession.dataTaskPublisher(for: request)
                .tryMap(dataIfStatusIsSuccess)
                .decode(type: Forecast.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }

        /// 4 days with data every hour
        func hourlyForecast() {
            // https://api.openweathermap.org/data/2.5/forecast/hourly
        }

        /// 16 days with daily averages
        func dailyForecast() {
            // https://api.openweathermap.org/data/2.5/forecast/daily
        }

        private func dataIfStatusIsSuccess(data: Data, response: URLResponse) throws -> Data {
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            guard httpResponse.statusCode >= 200, httpResponse.statusCode < 300 else {
                throw APIError.unsuccessfulStatusCode(httpResponse.statusCode)
            }

            return data
        }

        func currentConditions(for location: Location, units: Unit = .imperial) -> AnyPublisher<Condition, Error> {

            // quick and dirty

            var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather?appid=")!

            var queryItems = [URLQueryItem(name: "units", value: units.rawValue)]

            switch location {
            case let .query(query):
                queryItems.append(URLQueryItem(name: "q", value: String(describing: query)))

            case let .cityIdentifier(identifier):
                queryItems.append(URLQueryItem(name: "id", value: String(describing: identifier)))

            case let .coordinates(lat, lon):
                queryItems.append(URLQueryItem(name: "lat", value: String(describing: lat)))
                queryItems.append(URLQueryItem(name: "lon", value: String(describing: lon)))
            }

            urlComponents.queryItems?.append(contentsOf: queryItems)

            guard let url = urlComponents.url else {
                return Fail<OpenWeather.Condition, Error>(error: APIError.malformedUrl(href: urlComponents.description))
                    .eraseToAnyPublisher()
            }

            return urlSession.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse,
                        httpResponse.statusCode >= 200, httpResponse.statusCode < 300 else {
                            throw APIError.invalidResponse
                    }
                    return data
                }
                .decode(type: OpenWeather.Condition.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }
    }
}

