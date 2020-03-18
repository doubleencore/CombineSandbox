//
//  Forecast.swift
//  CombineWeather
//
//  Created by Kyle Watson on 3/16/20.
//  Copyright © 2020 Kyle Watson. All rights reserved.
//

import Foundation

extension OpenWeather {
    struct Forecast: Codable {
        let cnt: Int
        let list: [OpenWeather.Condition]
        let city: City

        struct City: Codable {
            let id: Int
            let name: String
            let coord: Coord
            let country: String
        }

        struct Coord: Codable {
            let lon, lat: Double
        }
    }
}

extension OpenWeather.Forecast {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(OpenWeather.Forecast.self, from: data) else { return nil }
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
