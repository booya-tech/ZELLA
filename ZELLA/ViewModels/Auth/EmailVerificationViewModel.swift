//
//  EmailVerificationViewModel.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/8/25.
//

import Foundation
import Observation

@Observable
class EmailVerificationViewModel {
    private let authService = AuthService.shared
    var verificationCode: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var canResend: Bool = true
    var resendCooldown: Int = 0

    // User info passed from signup
    var uid: String
    var email: String
    var name: String

    init(uid: String, email: String, name: String) {
        self.uid = uid
        self.email = email
        self.name = name
    }
    
    // MARK: - Verification
    func confirmCode() async -> Bool {
        guard !verificationCode.isEmpty else {
            errorMessage = AppString.emptyVerificationCode
            return false
        }

        guard verificationCode.count == 5 else {
            errorMessage = AppString.verificationCodeCheckDigits
            return false
        }
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let success = try await authService.verifyEmailCode(uid: uid, inputCode: verificationCode)

            if success {
                Logger.log("🟢 Email verification successful")
                return true
            } else {
                errorMessage = AppString.invalidVerificationCode
                return false
            }
        } catch {
            Logger.log("🔴 Verification error: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            return false
        }

    }
    
    /// Resends verification code with cooldown timer
    func resendCode() async {
        guard canResend else {
            Logger.log("⚠️ Cannot resend yet. Cooldown active.")
            return
        }
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            try await authService.resendVerificationCode(
                uid: uid,
                email: email,
                name: name
            )
            
            Logger.log("🟢 Verification code resent successfully")
            
            // Start cooldown (60 seconds)
            startResendCooldown()
            
        } catch {
            Logger.log("🔴 Resend error: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Cooldown Timer
    private func startResendCooldown() {
        canResend = false
        resendCooldown = 30
        
        Task {
            while resendCooldown > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                await MainActor.run {
                    resendCooldown -= 1
                }
            }
            await MainActor.run {
                canResend = true
            }
        }
    }

    // MARK: - Cancel Sign up
    func cancelSignUp() async throws {
        isLoading = true
        defer { isLoading = false }

        do {
            try await authService.deleteAccount(uid: uid)
            Logger.log("🟢 Sign up cancelled successfully")
        } catch {
            Logger.log("🔴 Error cancelling sign up: \(error.localizedDescription)")
            throw error
        }
    }
}
