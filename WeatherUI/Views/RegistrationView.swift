//
//  RegistrationViw.swift
//  WeatherUI
//
//  Created by Максим Попов on 28.12.2024.
//

import SwiftUI

struct RegistrationView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var isPasswordVisible: Bool = false
    @ObservedObject var authManager: AuthManager
    @State private var registrationError: String?

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if isPasswordVisible {
                TextField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            } else {
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }

            Button(action: {
                isPasswordVisible.toggle()
            }) {
                Text(isPasswordVisible ? "Hide Password" : "Show Password")
                    .foregroundColor(.blue)
                    .padding()
            }

            if let error = registrationError {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }

            Button("Register") {
                guard !username.isEmpty, !password.isEmpty, !email.isEmpty else {
                    registrationError = "Username, email, and password cannot be empty."
                    return
                }

                if !isValidUsername(username) {
                    registrationError = "Username must be at least 3 characters long."
                    return
                }

                if !isValidEmail(email) {
                    registrationError = "Invalid email format."
                    return
                }

                if !isValidPassword(password) {
                    registrationError = "Password must be at least 6 characters long."
                    return
                }

                // Вызов метода register с тремя параметрами
                if let errorMessage = authManager.register(username: username, password: password, email: email) {
                    registrationError = errorMessage
                } else {
                    print("Registration successful!")
                    registrationError = nil
                }
            }
            .padding()
        }
        .navigationTitle("Register")
    }

    private func isValidUsername(_ username: String) -> Bool {
        return username.count >= 3
    }

    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
}

