//
//  AuthManagers.swift
//  WeatherUI
//
//  Created by Максим Попов on 27.12.2024.
//

import Foundation
import Combine

class AuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    private let tokenKey = "authToken"
    private let userKey = "users"

    init() {
        isAuthenticated = UserDefaults.standard.string(forKey: tokenKey) != nil
    }

    func login(username: String, password: String) -> String? {
        guard !username.isEmpty, !password.isEmpty else {
            return "Username and password cannot be empty."
        }

        let users = loadUsers()
        guard let savedPassword = users[username] else {
            return "Login error: Incorrect username or password."
        }

        if password == savedPassword {
            let token = generateToken()
            UserDefaults.standard.set(token, forKey: tokenKey)
            isAuthenticated = true
            print("Login successful!")
            return nil
        } else {
            return "Login error: Incorrect username or password."
        }
    }

    func register(username: String, password: String, email: String) -> String? {
        guard !username.isEmpty, !password.isEmpty else {
            return "Username and password cannot be empty."
        }

        if username.count < 3 {
            return "Registration error: Username must be at least 3 characters long."
        }
        if password.count < 6 {
            return "Registration error: Password must be at least 6 characters long."
        }

        var users = loadUsers()

        if users[username] != nil {
            return "Registration error: Username is already taken."
        }

        users[username] = password
        saveUsers(users)

        let token = generateToken()
        UserDefaults.standard.set(token, forKey: tokenKey)

        print("Username saved: \(username)")
        print("Password saved.")

        isAuthenticated = true
        print("Registration successful!")
        return nil
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        isAuthenticated = false
        print("Logout successful.")
    }

    private func generateToken() -> String {
        return UUID().uuidString
    }

    private func loadUsers() -> [String: String] {
        if let data = UserDefaults.standard.data(forKey: userKey),
           let users = try? JSONDecoder().decode([String: String].self, from: data) {
            return users
        }
        return [:]
    }

    private func saveUsers(_ users: [String: String]) {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: userKey)
        }
    }
}
