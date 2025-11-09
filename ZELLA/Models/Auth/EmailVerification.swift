//
//  EmailVerification.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/9/25.
//

import Foundation
import FirebaseFirestore

/// Represents an email verification document
/// Stored at: users/{uid}/verification/email
struct EmailVerification: Codable {
    var code: String
    var createdAt: Timestamp
    var expiresAt: Timestamp
    var attempts: Int
    var lastResendAt: Timestamp?
    var resendCount: Int

    // Helper to check if the code is expired
    var isExpired: Bool {
        return Date() > expiresAt.dateValue()
    }

    // Helper to check if too many attempts
    var hasExceededAttempts: Bool {
        return attempts >= 5
    }

    // Helper to check if can resend (max 3 times per hour)
    func canResend() -> Bool {
        guard let lastResend = lastResendAt else { return true }
        let oneHourAgo = Date().addingTimeInterval(-3600)

        // If last resend was more than one hour ago, reset count
        if lastResend.dateValue() < oneHourAgo {
            return true
        }

        // Otherwise, check if under limit
        return resendCount < 3
    }
}
