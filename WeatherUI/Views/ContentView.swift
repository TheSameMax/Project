//
//  ContentView.swift
//  WeatherUI
//
//  Created by Максим Попов on 22.12.2024.
//  da2ac41a7e6d9512ea22bb385514471f

import SwiftUI
import CoreLocation

struct ContentView: View {
    @ObservedObject var authManager = AuthManager()
    @StateObject private var weatherService = WeatherService()
    @State private var city: String = ""
    @State private var weatherData: WeatherData?
    @State private var history: [String] = []
    private var locationManager = CLLocationManager()
    @State private var isLoading = false
    private let historyManager = HistoryManager()

    var body: some View {
        NavigationView {
            if authManager.isAuthenticated {
                MainWeatherView(authManager: authManager, weatherService: weatherService, historyManager: historyManager)
            } else {
                LoginView(authManager: authManager)
            }
        }
    }
}
