//
//  WeatherService.swift
//  CombineWeather
//
//  Created by Kyle Watson on 3/18/20.
//  Copyright © 2020 Kyle Watson. All rights reserved.
//

import Foundation
import Combine

// config should only be used in domain
//
class WeatherService {

    private let weatherClient = OpenWeatherAPIClient()

//    func currentConditions(for locations: [OpenWeather.Location]) -> AnyPublisher<WeatherCondition, Error> {
//
//    }

    func currentConditions(forCity city: String, state: String? = nil, countryCode: String? = nil) -> AnyPublisher<OpenWeather.Condition, Error> {

        // endpoint from config
        // build APIRequest (or URLRequest)
        let url = URL(string: "")!
        let request = URLRequest(url: url)
//        weatherClient.currentConditions(request: request)

        // or
//        weatherClient.performRequest(request)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw OpenWeather.APIError.invalidResponse
                }

                guard httpResponse.statusCode >= 200, httpResponse.statusCode < 300 else {
                    throw OpenWeather.APIError.unsuccessfulStatusCode(httpResponse.statusCode)
                }

                return data
            }
            .decode(type: OpenWeather.Condition.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

//    func currentConditions(forCityIdentifier cityId: String) -> AnyPublisher<OpenWeather.Condition, Error> {
//
//    }
}
