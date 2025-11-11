//
//  SignUpViewModel.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/8/25.
//

import Foundation
import Observation

@Observable
class SignUpViewModel {
    private let authService = AuthService.shared

    var email = ""
    var name = ""
    var password = ""
    var confirmPassword = ""
    var isLoading = false
    var errorMessage: String?
    
    // MARK: - Validation
    func signUp() async -> Bool {
        guard !email.isEmpty else {
            errorMessage = AppString.emptyEmail
            return false
        }
        
        guard !name.isEmpty else {
            errorMessage = AppString.emptyName
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = AppString.passwordTooShort
            return false
        }
        
        guard password == confirmPassword else {
            errorMessage = AppString.passwordMismatch
            return false
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await authService.signUpWithEmail(
                email: email,
                password: password,
                name: name
            )
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    // MARK: - Clear Form
    func clearForm() {
        email = ""
        name = ""
        password = ""
        confirmPassword = ""
        errorMessage = nil
    }
}
