//
//  SignInViewModel.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/8/25.
//
import Foundation
import AuthenticationServices
import Observation

@Observable
class SignInViewModel {
    var email = ""
    var password = ""
    var isLoading = false
    var errorMessage: String?
    
    private let authService = AuthService.shared
    
    // MARK: - Email Sign In
    func signInWithEmail() async -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = AppString.emptyEmailPassword
            return false
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await authService.signInWithEmail(
                email: email,
                password: password
            )
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    // MARK: - Apple Sign In
    func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) async {
        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                errorMessage = "Invalid Apple credential"
                return
            }
            
            do {
                try await authService.handleSignInWithApple(credential: credential)
            } catch {
                errorMessage = error.localizedDescription
            }
            
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
    
    func startAppleSignInFlow() -> String {
        return authService.startSignInWithAppleFlow()
    }
    
    // MARK: - Social Sign In (Placeholders)
    func signInWithFacebook() {
        errorMessage = AppString.facebookComingSoon
    }
    
    func signInWithGoogle() {
        errorMessage = AppString.googleComingSoon
    }
}
