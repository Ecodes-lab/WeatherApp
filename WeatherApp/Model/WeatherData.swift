//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Chukwubuikem Chukwudi on 05/03/22.
//

import Foundation

struct WeatherData: Codable {
//    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
//    let name: String
}

struct WeatherGeo: Codable {
    let name: String
}
