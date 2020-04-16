//
//  WeatherData.swift
//  Clima
//
//  Created by Seyi Ipaye on 02/03/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    var name: String
    var main: Main
    var weather: [Weather]
}

struct Main: Decodable{
    var temp: Double
}

struct Weather: Decodable {
    var description: String
    var id: Int
}
