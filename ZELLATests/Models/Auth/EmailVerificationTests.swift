//
//  EmailVerificationTests.swift
//  ZELLATests
//
//  Created by Panachai Sulsaksakul on 12/29/25.
//

import XCTest
import FirebaseFirestore
@testable import ZELLA

final class EmailVerificationTests: XCTestCase {
    // MARK: - Test Helpers
    /// Creates a test EmailVerification instance
    private func createVerification(
        code: String = "12345",
        createdAt: Date = Date(),
        expiresAt: Date = Date().addingTimeInterval(1800), // 30 mins from now
        attempts: Int = 0,
        lastResendAt: Date? = nil,
        resendCount: Int = 0
    ) -> EmailVerification {
        return EmailVerification(
            code: code,
            createdAt: Timestamp(date: createdAt),
            expiresAt: Timestamp(date: expiresAt),
            attempts: attempts,
            lastResendAt: lastResendAt != nil ? Timestamp(date: lastResendAt!) : nil,
            resendCount: resendCount
        )
    }
    
    // MARK: - isExpired Tests
    
    func testIsExpired_WhenCodeIsNotExpired_ReturnsFalse() {
        // Arrange: Create verification that expires in 30 minutes
        let verification = createVerification(
            expiresAt: Date().addingTimeInterval(1800)
        )
        
        // Act & Assert
        XCTAssertFalse(verification.isExpired, "Code should not be expired")
    }
    
    func testIsExpired_WhenCodeJustExpired_ReturnsTrue() {
        // Arrange: Create verification that expired 1 second ago
        let verification = createVerification(
            expiresAt: Date().addingTimeInterval(-1)
        )
        
        // Act & Assert
        XCTAssertTrue(verification.isExpired, "Code should be expired")
    }
    
    func testIsExpired_WhenCodeExpiredLongAgo_ReturnsTrue() {
        // Arrange: Create verification that expired 1 hour ago
        let verification = createVerification(
            expiresAt: Date().addingTimeInterval(-3600)
        )
        
        // Act & Assert
        XCTAssertTrue(verification.isExpired, "Code should be expired")
    }
    
    func testIsExpired_ExactlyAtExpirationTime_ReturnsTrue() {
        // Arrange: Create verification that expires exactly now
        // Note: This is a edge case - in reality Date() might be a few microseconds different
        let now = Date()
        let verification = createVerification(expiresAt: now)
        
        // Add tiny delay to ensure we're past expiration
        Thread.sleep(forTimeInterval: 0.001)
        
        // Act & Assert
        XCTAssertTrue(verification.isExpired, "Code at exact expiration time should be expired")
    }

    // MARK: - hasExceededAttempts Tests
    func testHasExceededAttempts_WithZeroAttempts_ReturnsFalse() {
        // Given
        let verification = createVerification(attempts: 0)

        // When & Then
        XCTAssertFalse(verification.hasExceededAttempts, "Should allow more attempts")
    }

    func testHasExceededAttempts_WithFourAttempts_ReturnsFalse() {
        // Given
        let verification = createVerification(attempts: 4)

        // When & Then
        XCTAssertFalse(verification.hasExceededAttempts, "Should allow more attempts")
    }

    func testHasExceededAttempts_WithFiveAttempts_ReturnsTrue() {
        // Given
        let verification = createVerification(attempts: 5)

        // When & Then
        XCTAssertTrue(verification.hasExceededAttempts, "Should block further attempts")
    }

    func testHasExceededAttempts_WithMoreThanFiveAttempts_ReturnsTrue() {
        // Given
        let verification = createVerification(attempts: 6)

        // When & Then
        XCTAssertTrue(verification.hasExceededAttempts, "Should block further attempts")
    }

    // MARK: - canResend Tests
    func testCanResend_WithNoLastResendAt_ReturnsTrue() {
        // Arrange: First time sending, no previous resend
        let verification = createVerification(
            lastResendAt: nil,
            resendCount: 0
        )
        
        // Act & Assert
        XCTAssertTrue(verification.canResend(), "Should allow first resend")
    }

    func testCanResend_WithOneResendLessThanHourAgo_ReturnsTrue() {
        // Given: Last resend was 10 minutes ago, 1 resend so far
        let tenMinutesAgo = Date().addingTimeInterval(-600)
        let verification = createVerification(
            lastResendAt: tenMinutesAgo,
            resendCount: 1
        )

        // When & Then
        XCTAssertTrue(verification.canResend(), "Should allow first resend")
    }

    func testCanResend_WithTwoResendsLessThanHourAgo_ReturnsTrue() {
        // Given: Last resend was 10 minutes ago, 2 resend so far
        let tenMinutesAgo = Date().addingTimeInterval(-600)
        let verification = createVerification(
            lastResendAt: tenMinutesAgo,
            resendCount: 2
        )

        // When & Then
        XCTAssertTrue(verification.canResend(), "Should allow second resend without hour")
    }

    func testCanResend_WithThreeResendsLessThanHourAgo_ReturnsFalse() {
        // Given: Last resend was 10 minutes ago, already hit limit (3 resends within hour)
        let tenMinutesAgo = Date().addingTimeInterval(-600)
        let verification = createVerification(
            lastResendAt: tenMinutesAgo,
            resendCount: 3
        )

        // When & Then
        XCTAssertFalse(verification.canResend(), "Should block resend after 3 attempts within hour")
    }

    func testCanResend_WithThreeResendsMoreThanHourAgo_ReturnsTrue() {
        // Given: Last resend was 2 hours ago, should reset limit
        let twoHoursAgo = Date().addingTimeInterval(-7200)
        let verification = createVerification(
            lastResendAt: twoHoursAgo,
            resendCount: 3
        )

        // When & Then
        XCTAssertTrue(verification.canResend(), "Should reset limit after 1 hour")
    }

    func testCanResend_ExactlyOneHourAgo_ReturnsTrue() {
        // Given: Last resend exactly 1 hour ago
        let oneHourAgo = Date().addingTimeInterval(-3600)
        let verification = createVerification(
            lastResendAt: oneHourAgo,
            resendCount: 3
        )

        // When & Then
        XCTAssertTrue(verification.canResend(), "Should reset at exactly 1 hour mark")
    }

    func testCanResend_JustUnderOneHour_WithThreeResends_ReturnsFalse() {
        // Given: Last resend exactly 1 hour ago
        let underHourAgo = Date().addingTimeInterval(-3540) // 59 minutes
        let verification = createVerification(
            lastResendAt: underHourAgo,
            resendCount: 3
        )

        // When & Then
        XCTAssertFalse(verification.canResend(), "Should still be blocked just under 1 hour")
    }

    // MARK: - Integration/Edge Case Tests
    func testCanResend_WithMaxResendsButExpiredCode_ReturnsFalse() {
        // Given: Code is expired and max resends reached
        // test business logic: even if expired, resend limit applies
        let verification = createVerification(
            expiresAt: Date().addingTimeInterval(-1), // expired
            lastResendAt: Date().addingTimeInterval(-600), // 10 min ago
            resendCount: 3
        )

        // When & Then
        XCTAssertFalse(verification.canResend(), "Should respect resend limit even if expired")
    }

    @MainActor
    func testCodableConformance_EncodesAndDecodes() throws {
        // Given: Create a verification
        let original = createVerification(
            code: "54321",
            attempts: 2,
            lastResendAt: Date(),
            resendCount: 1
        )

        // When: Endcode -> JSON
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)


        // When: Decode -> JSON
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(EmailVerification.self, from: data)

        // Then: All fields shoud match
        XCTAssertEqual(decoded.code, original.code)
        XCTAssertEqual(decoded.attempts, original.attempts)
        XCTAssertEqual(decoded.lastResendAt, original.lastResendAt)
        XCTAssertEqual(decoded.resendCount, original.resendCount)
    }
}
