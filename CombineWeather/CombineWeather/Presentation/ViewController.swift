//
//  ViewController.swift
//  CombineWeather
//
//  Created by Kyle Watson on 3/16/20.
//  Copyright © 2020 Kyle Watson. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController {

    var subscriber: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // TODO: this will go in something like a ViewModel.
        // TODO: simplify API
        let client = OpenWeatherAPIClient()
        let cityQuery = OpenWeather.Query(city: "Atlanta")
        let location = OpenWeather.Location.query(cityQuery)

        subscriber = client.currentConditions(for: location)
            .sink(receiveCompletion: { (completion) in
                print("completed: \(completion)")
            }, receiveValue: { (value) in
                print("received value: \(value)")
            })
    }
}

