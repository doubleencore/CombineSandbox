//
//  Requests.swift
//  CombineWeather
//
//  Created by Kyle Watson on 3/16/20.
//  Copyright © 2020 Kyle Watson. All rights reserved.
//

import Foundation

extension OpenWeather {

    struct APIRequest {
        let endpoint: URITemplate
    }

    struct Query {
        let city: String
        let state: String?
        let countryCode: String?

        init(city: String, state: String? = nil, countryCode: String? = nil) {
            self.city = city
            self.state = state
            self.countryCode = countryCode
        }
    }

    enum Location {
        case query(Query)
        case cityIdentifier(Int)
        case coordinates(Int, Int)
    }

    enum Unit: String {
        case standard
        case imperial
        case metric
    }
}

extension OpenWeather.Query: CustomStringConvertible {
    var description: String {
        var query = [city]

        if let state = state {
            query.append(state)
        }

        if let countryCode = countryCode {
            query.append(countryCode)
        }

        return query.joined(separator: ",")
    }
}
