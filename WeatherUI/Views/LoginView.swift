//
//  LoginView.swift
//  WeatherUI
//
//  Created by Максим Попов on 27.12.2024.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = "" // Новая переменная для хранения email
    @State private var isPasswordVisible: Bool = false // Переменная для видимости пароля
    @ObservedObject var authManager: AuthManager
    @State private var loginError: String?

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Email", text: $email) // Поле для ввода email
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Toggle between SecureField and TextField based on isPasswordVisible
            if isPasswordVisible {
                TextField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            } else {
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }

            // Show/Hide Password Button
            Button(action: {
                isPasswordVisible.toggle() // Переключить видимость пароля
            }) {
                Text(isPasswordVisible ? "Hide Password" : "Show Password")
                    .foregroundColor(.blue)
                    .padding()
            }

            if let error = loginError {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }

            Button("Login") {
                guard !username.isEmpty, !password.isEmpty, !email.isEmpty else {
                    loginError = "Username, email, and password cannot be empty."
                    return
                }

                if !isValidUsername(username) {
                    loginError = "Username must be at least 3 characters long."
                    return
                }

                if !isValidEmail(email) { // Проверка на корректность email
                    loginError = "Invalid email format."
                    return
                }

                if !isValidPassword(password) {
                    loginError = "Password must be at least 6 characters long."
                    return
                }

                // Удален параметр email из вызова login
                if let errorMessage = authManager.login(username: username, password: password) {
                    loginError = errorMessage
                } else {
                    print("Login successful!")
                    loginError = nil
                }
            }
            .padding()

            NavigationLink(destination: RegistrationView(authManager: authManager)) {
                Text("Don't have an account? Register here.")
                    .padding()
            }
        }
        .padding()
        .navigationTitle("Login")
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
