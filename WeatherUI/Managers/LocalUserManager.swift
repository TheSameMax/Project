//
//  LocalUserManager.swift
//  WeatherUI
//
//  Created by Максим Попов on 28.12.2024.
//

import Foundation

class LocalUserManager {
    private var users: [AppUser] = []
    
    func register(username: String, password: String) -> Bool {
        if users.contains(where: { $0.username == username }) {
            return false
        }
        
        let newUser = AppUser(username: username, password: password)
        users.append(newUser)
        return true
    }
    
    func login(username: String, password: String) -> Bool {
        return users.contains(where: { $0.username == username && $0.password == password })
    }
    
    func allUsers() -> [AppUser] {
        return users
    }
}

struct AppUser {
    let username: String
    let password: String
}
