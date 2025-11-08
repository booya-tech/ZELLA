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
    var verificationCode = ""
    var isLoading = false
    var errorMessage: String?
    
    // MARK: - Verification
    
    func confirmCode() async -> Bool {
        guard !verificationCode.isEmpty else {
            errorMessage = AppString.emptyVerificationCode
            return false
        }
        
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Implement verification with Firebase
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
    
    func resendCode() {
        // TODO: Implement resend
        Logger.log("Resending verification code")
    }
}
