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
        
        // TODO: Implement Firebase email sign up
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
}
