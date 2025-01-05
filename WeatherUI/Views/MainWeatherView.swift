//
//  MainWeatherView.swift
//  WeatherUI
//
//  Created by Максим Попов on 27.12.2024.
//

import SwiftUI
import CoreLocation

struct MainWeatherView: View {
    @ObservedObject var authManager: AuthManager
    let weatherService: WeatherService
    @State private var city: String = ""
    @State private var weatherData: WeatherData?
    @State private var history: [String] = []
    @State private var locationManager = CLLocationManager()
    @State private var isLoading = false
    private let historyManager: HistoryManager

    init(authManager: AuthManager, weatherService: WeatherService, historyManager: HistoryManager) {
        self.authManager = authManager
        self.weatherService = weatherService
        self.historyManager = historyManager
    }

    var body: some View {
        VStack {
            TextField("Enter the name of the city", text: $city, onCommit: {
                fetchWeather(for: city)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()

            Button("Get weather by geolocation") {
                getLocationWeather()
            }
            .padding()

            if isLoading {
                ShimmerView() 
            } else if let weather = weatherData {
                VStack {
                    Text("\(weather.name)")
                        .font(.largeTitle)
                    Text("Temperature: \(weather.temperature, specifier: "%.1f")°C")
                    Text("Humidity: \(weather.humidity)%")
                    Text("Pressure: \(weather.pressure) gPa")
                    Text("Description: \(weather.description)")
                    if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png") {
                        AsyncImage(url: iconURL) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ShimmerView()
                        }
                        .frame(width: 100, height: 100)
                    }
                }
                .padding()
            }

            List(history, id: \.self) { city in
                Text(city)
                    .onTapGesture {
                        fetchWeather(for: city)
                    }
            }

            Button("Logout") {
                authManager.logout()
            }
            .padding()
        }
        .navigationTitle("The Best Weather App")
        .onAppear {
            history = historyManager.loadHistory()
        }
    }

    private func fetchWeather(for city: String) {
        isLoading = true
        weatherService.fetchWeather(for: city) { data in
            DispatchQueue.main.async {
                isLoading = false
                self.weatherData = data
                if let city = data?.name {
                    historyManager.saveCity(city)
                    history = historyManager.loadHistory()
                }
            }
        }
    }

    private func getLocationWeather() {
        locationManager.requestWhenInUseAuthorization()
        if let location = locationManager.location {
            fetchWeather(for: location)
        } else {
            print("Location not available")
        }
    }

    private func fetchWeather(for location: CLLocation) {
        isLoading = true
        weatherService.fetchWeather(for: location) { data in
            DispatchQueue.main.async {
                isLoading = false
                self.weatherData = data
                if let city = data?.name {
                    historyManager.saveCity(city)
                    history = historyManager.loadHistory()
                }
            }
        }
    }
}

