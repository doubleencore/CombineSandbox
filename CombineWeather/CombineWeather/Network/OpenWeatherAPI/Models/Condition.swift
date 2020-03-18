//
//  Condition.swift
//  CombineWeather
//
//  Created by Kyle Watson on 3/16/20.
//  Copyright © 2020 Kyle Watson. All rights reserved.
//

import Foundation

extension OpenWeather {

    struct Condition: Codable {
        let coordinate: Coordinate?
        let weather: [Weather]
        let main: Main
        let visibility: Double?
        let wind: Wind
        let clouds: Clouds
        let datetimeOfCalculation: Int  // datetime of calculation used for hourly/daily (epoch)
        let systemProperties: Sys       // sunrise/sunset
        let cityId: Int?                // city ID
        let cityName: String?           // city name

        enum CodingKeys: String, CodingKey {
            case coordinate = "coord"
            case weather, main, visibility, wind, clouds
            case datetimeOfCalculation = "dt"
            case systemProperties = "sys"
            case cityId = "id"
            case cityName = "name"
        }

        struct Clouds: Codable {
            let all: Int
        }

        struct Coordinate: Codable {
            let latitude: Double
            let longitude: Double

            enum CodingKeys: String, CodingKey {
                case latitude = "lat"
                case longitude = "lon"
            }
        }

        struct Main: Codable {
            let temp, tempMin, tempMax: Double
            let pressure, humidity: Double

            enum CodingKeys: String, CodingKey {
                case temp, pressure, humidity
                case tempMin = "temp_min"
                case tempMax = "temp_max"
            }
        }

        struct Sys: Codable {
            let sunrise, sunset: Int?
        }

        struct Weather: Codable {
            let id: Int
            let main, description, icon: String
        }

        struct Wind: Codable {
            let speed, deg: Double
        }
    }
}

extension OpenWeather.Condition {

    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(OpenWeather.Condition.self, from: data) else { return nil }
        self = me
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
