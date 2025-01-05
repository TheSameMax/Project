//
//  HistoryManager.swift
//  WeatherUI
//
//  Created by Максим Попов on 26.12.2024.
//

import Foundation

class HistoryManager {
    private let historyKey = "searchHistory"

    func loadHistory() -> [String] {
        return UserDefaults.standard.stringArray(forKey: historyKey) ?? []
    }

    func saveCity(_ city: String) {
        var history = loadHistory()
        if !history.contains(city) {
            history.append(city)
            UserDefaults.standard.setValue(history, forKey: historyKey)
        }
    }
}
