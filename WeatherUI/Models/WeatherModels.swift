//
//  WeatherModel.swift
//  WeatherUI
//
//  Created by Максим Попов on 22.12.2024.
//

import Foundation

struct WeatherResponse: Codable {
    let main: Main
    let weather: [Weather]
    let name: String

    struct Main: Codable {
        let temp: Double
        let humidity: Int
        let pressure: Int
    }

    struct Weather: Codable {
        let description: String
        let icon: String
    }
}

struct WeatherData {
    let name: String
    let temperature: Double
    let humidity: Int
    let pressure: Int
    let description: String
    let icon: String

    init(from response: WeatherResponse) {
        self.name = response.name
        self.temperature = response.main.temp
        self.humidity = response.main.humidity
        self.pressure = response.main.pressure
        self.description = response.weather.first?.description ?? "No description"
        self.icon = response.weather.first?.icon ?? "01d"
    }
}
