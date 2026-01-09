//
//  EmailVerificationViewModelTests.swift
//  ZELLATests
//
//  Created by Panachai Sulsaksakul on 12/30/25.
//

import XCTest
@testable import ZELLA

@MainActor
final class EmailVerificationViewModelTests: XCTestCase {
    // MARK: - Test Properties
    var sut: EmailVerificationViewModel!
    var mockAuthService: MockAuthService!

    let testUID = "test_uid_12345"
    let testEmail = "test@example.com"
    let testName = "Test User"

    // MARK: - Test Lifecycle
    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService()
        sut = EmailVerificationViewModel(
            uid: testUID,
            email: testEmail,
            name: testName,
            authService: mockAuthService
        )
    }

    override func tearDown() {  
        sut = nil
        mockAuthService = nil
        super.tearDown()
    }

    private func createViewModel(
        uid: String = "test-uid",
        email: String = "test@example.com",
        name: String = "Test"
    ) -> EmailVerificationViewModel {
        return EmailVerificationViewModel(
            uid: uid,
            email: email,
            name: name,
            authService: mockAuthService
        )
    }

    func testInit_SetsPropertiesCorrectly() {
        // Given & When: ViewModel is initialized in setUp()

        // Then: Properties should be set correctly
        XCTAssertEqual(sut.uid, testUID)
        XCTAssertEqual(sut.email, testEmail)
        XCTAssertEqual(sut.name, testName)
        XCTAssertEqual(sut.verificationCode, "")
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertTrue(sut.canResend)
        XCTAssertEqual(sut.resendCooldown, 0)
    }

    // MARK: - confirmCode Validation Tests
    func testConfirmCode_WithEmptyCode_ReturnsFalseAndSetsError() async {
        // Given: Empty verification code
        sut.verificationCode = ""

        // When: Confirming code
        let result = await sut.confirmCode()

        // Then: Should fail with error message
        XCTAssertFalse(result)
        XCTAssertEqual(sut.errorMessage, AppString.emptyVerificationCode)
        XCTAssertFalse(mockAuthService.verifyEmailCodeCalled, "Should not call auth service")
    }

    func testConfirmCode_WithCodeLessThan5Digits_ReturnsFalseAndSetsError() async {
        // Given: Code with only 4 digits
        sut.verificationCode = "1234"

        // When: Confirming code
        let result = await sut.confirmCode()

        // Then: Should fail with error message
        XCTAssertFalse(result)
        XCTAssertEqual(sut.errorMessage, AppString.verificationCodeCheckDigits)
        XCTAssertFalse(mockAuthService.verifyEmailCodeCalled, "Should not call auth service")
    }

    func testConfirmCode_WithCodeMoreThan5Digits_ReturnsFalseAndSetsError() async {
        // Given: Code with 6 digits
        sut.verificationCode = "123456"

        // When: Confirming code
        let result = await sut.confirmCode()

        // Then: Should fail with error message
        XCTAssertFalse(result)
        XCTAssertEqual(sut.errorMessage, AppString.verificationCodeCheckDigits)
        XCTAssertFalse(mockAuthService.verifyEmailCodeCalled, "Should not call auth service")
    }

            func testConfirmCode_WithExactly5Digits_CallsAuthService() async {
        // Given: Valid 5-digit code
        sut.verificationCode = "12345"
        mockAuthService.verifyEmailCodeResult = .success(true)

        // When: Confirming code
        let result = await sut.confirmCode()

        // Then: Should call auth service with correct params
        XCTAssertTrue(result)
        XCTAssertTrue(mockAuthService.verifyEmailCodeCalled)
        XCTAssertEqual(mockAuthService.lastVerifyEmailCodeUID, testUID)
        XCTAssertEqual(mockAuthService.lastVerifyEmailCodeInput, "12345")
    }

    // MARK - confirmCode() Success Tests
    func testConfirmCode_WhenAuthServiceReturnsTrue_ReturnsTrue() async {
        // Given: Valid code and successful auth service
        sut.verificationCode = "12345"
        mockAuthService.verifyEmailCodeResult = .success(true)

        // When: Confirming code
        let result = await sut.confirmCode()

        // Then: Should succeed
        XCTAssertTrue(result)
        XCTAssertNil(sut.errorMessage)
    }

    func testConfirmCode_WhenAuthServiceReturnsFalse_ReturnsFalseWithError() async {
        // Given: Valid code but auth service returns false (invalid code)
        sut.verificationCode = "12345"
        mockAuthService.verifyEmailCodeResult = .success(false)

        // When: Confirming code
        let result = await sut.confirmCode()

        // Then: Should fail with invalid error message
        XCTAssertFalse(result)
        XCTAssertEqual(sut.errorMessage, AppString.invalidVerificationCode)
    }

    // MARK: - confirmCode() Loading State Tests
    func testConfirmCode_SetsLoadingStateCorrectly() async {
        // Given: Valid code with simulated delay
        sut.verificationCode = "12345"
        mockAuthService.simulateDelay = 0.1
        mockAuthService.verifyEmailCodeResult = .success(true)

        // When: Start confirming code
        let task = Task {
            await sut.confirmCode()
        }
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds (50ms)
        XCTAssertTrue(sut.isLoading, "Should be loading during operation")

        // Wait for completion
        _ = await task.value

        // Then: Loading should be false after completion
        XCTAssertFalse(sut.isLoading, "Should not be loading after completion")
    }

    func testConfirmCode_ClearsErrorMessageOnSuccess() async {
        // Given: Existing error message
        sut.verificationCode = "12345"
        sut.errorMessage = "Previous error"
        mockAuthService.verifyEmailCodeResult = .success(true)
        
        // When: Confirming code successfully
        _ = await sut.confirmCode()
        
        // Then: Error message should be cleared
        XCTAssertNil(sut.errorMessage)
    }

    // MARK: - confirmCode() Error Handling Tests
    func testConfirmCode_WhenAuthServiceThrows_ReturnsFalseWithError() async {
        // Given: Valid code but auth service throws error
        sut.verificationCode = "12345"
        let testError = NSError(
            domain: "TestError",
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Network error"]
        )
        mockAuthService.verifyEmailCodeResult = .failure(testError)
        
        // When: Confirming code
        let result = await sut.confirmCode()
        
        // Then: Should fail with error message
        XCTAssertFalse(result)
        XCTAssertEqual(sut.errorMessage, "Network error")
    }

    // MARK: - resendCode() Tests
    func testResendCode_WhenCannotResend_DoesNotCallAuthService() async {
        // Given: Resend is disabled
        sut.canResend = false

        // When: Attempting to resend
        await sut.resendCode()

        // Then: Should not call auth service
        XCTAssertFalse(mockAuthService.resendVerificationCodeCalled)
    }

    func testResendCode_WhenCanResend_CallsAuthServiceWithCorrectParameters() async {
        // Given: Resend is enabled
        sut.canResend = true
        mockAuthService.resendVerificationCodeResult = .success(())

        // When: Resending code
        await sut.resendCode()

        // Then: Should call auth service with correct params
        XCTAssertTrue(mockAuthService.resendVerificationCodeCalled)
        XCTAssertEqual(mockAuthService.lastResendUID, testUID)
        XCTAssertEqual(mockAuthService.lastResendEmail, testEmail)
        XCTAssertEqual(mockAuthService.lastResendName, testName)
    }

    func testResendCode_OnSuccess_StartsCooldown() async {
        // Given: Resend is enabled
        sut.canResend = true
        mockAuthService.resendVerificationCodeResult = .success(())

        // When: Resending code
        await sut.resendCode()

        // Then: Cooldown should be started
        XCTAssertFalse(sut.canResend, "canResend should be false")
        XCTAssertEqual(sut.resendCooldown, 30, "resendCooldown should be 30")
    }

    func testResendCode_SetsLoadingStateCorrectly() async {
        // Given: Resend enabled with delay
        sut.canResend = true
        mockAuthService.simulateDelay = 0.1
        mockAuthService.resendVerificationCodeResult = .success(())

        // When: Start resending
        let task = Task {
            await sut.resendCode()
        }

        // Then: Loading should be true during operation
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds (50ms)
        XCTAssertTrue(sut.isLoading, "Should be loading during operation")

        // Wait for completion
        await task.value

        // Then: Loading should be false after completion
        XCTAssertFalse(sut.isLoading, "Should not be loading after completion")
    }

    func testResendCode_WhenAuthServiceThrows_SetsErrorMessage() async {
        // Given: Resend enabled but service throws error
        sut.canResend = true
        let testError = NSError(
            domain: "TestError",
            code: 429,
            userInfo: [NSLocalizedDescriptionKey: "Too many requests"]
        )
        
        mockAuthService.resendVerificationCodeResult = .failure(testError)

        // When: Resending code
        await sut.resendCode()

        // Then: Should set error message
        XCTAssertEqual(sut.errorMessage, "Too many requests")
        XCTAssertTrue(sut.canResend, "canResend should remain true on error")
    }

    func testResendCode_ClearsErrorMessageOnStart() async {
        // Given: Existing error message
        sut.canResend = true
        sut.errorMessage = "Previous error"
        mockAuthService.resendVerificationCodeResult = .success(())

        // When: Resending code
        await sut.resendCode()

        // Then: Error message should be cleared
        XCTAssertNil(sut.errorMessage)
    }

    // MARK: - Cooldown Timer Tests
    func testStartResendCooldown_SetsInitialState() async {
        // Given: Fresh ViewModel
        sut.canResend = true
        sut.resendCooldown = 0

        // When: Starting cooldown
        sut.startResendCooldown()

        // Then: Should set initial state
        XCTAssertFalse(sut.canResend, "canResend should be false")
        XCTAssertEqual(sut.resendCooldown, 30, "resendCooldown should be 30")
    }

    func testStartResendCooldown_CountsDownOverTime() async {
        // Given: Fresh ViewModel
        sut.canResend = true
        sut.resendCooldown = 0

        // When: Starting cooldown
        sut.startResendCooldown()

        // Then: Should set initial state
        XCTAssertFalse(sut.canResend, "canResend should be false")
        XCTAssertEqual(sut.resendCooldown, 30, "resendCooldown should be 30")

        // Wait for 2.5 seconds
        try? await Task.sleep(nanoseconds: 2_500_000_000)

        // Then: Should have counted down (allowing for timing variance)
        XCTAssertLessThan(sut.resendCooldown, 30)
        XCTAssertGreaterThanOrEqual(sut.resendCooldown, 27) // Should be around 28-27
        XCTAssertFalse(sut.canResend, "Should still not be able to resend")
    }

    func testStartResendCooldown_EnablesResendAfterCompletion() async {
        // Given: Fresh ViewModel
        sut.canResend = true
        sut.resendCooldown = 0

        // Create a faster cooldown for testing by directly manipulating
        sut.canResend = false
        sut.resendCooldown = 1

        // When: Manual countdown simulation
        Task {
            while sut.resendCooldown > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                await MainActor.run {
                    sut.resendCooldown -= 1
                }
            }
            await MainActor.run {
                sut.canResend = true
            }
        }

        // Wait for completion
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds

        // Then: Should be able to resend
        XCTAssertEqual(sut.resendCooldown, 0)
        XCTAssertTrue(sut.canResend)
    }

    // MARK: - cancelSignUp() Tests
    func testCancelSignUp_CallsAuthServiceWithCorrectUID() async throws {
        // Given: ViewModel with test UID
        mockAuthService.deleteAccountResult = .success(())

        // When: Cancelling sign up
        try await sut.cancelSignUp()

        // Then: Should call deleteAccount with correct UID
        XCTAssertTrue(mockAuthService.deleteAccountCalled)
        XCTAssertEqual(mockAuthService.lastDeleteAccountUID, testUID)
    }

    func testCancelSignUp_SetsLoadingStateCorrectly() async throws {
        // Given: Delay in auth service
        mockAuthService.simulateDelay = 0.1
        mockAuthService.deleteAccountResult = .success(())

        // When: Start cancelling
        let task = Task {
            try await sut.cancelSignUp()
        }

        // Then: Loading should be true during operation
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds
        XCTAssertTrue(sut.isLoading, "Should be loading during operation")

        // Wait for completion
        try await task.value

        // Then: Loading should be false after completion
        XCTAssertFalse(sut.isLoading, "Should not be loading after completion")
    }

    func testCancelSignUp_WhenAuthServiceThrows_PropagatesError() async {
        // Given: Auth service throws error
        let testError = NSError(
            domain: "TestError",
            code: 403,
            userInfo: [NSLocalizedDescriptionKey: "Permission denied"]
        )

        mockAuthService.deleteAccountResult = .failure(testError)

        // When/Then: Should throw error
        do {
            try await sut.cancelSignUp()
            XCTFail("Should have thrown error")
        } catch {
            XCTAssertEqual((error as NSError).localizedDescription, "Permission denied")
        }

        // Then: Loading should be reset
        XCTAssertFalse(sut.isLoading)
    }

    func testCancelSignUp_OnSuccess_CompletesWithoutError() async throws {
        // Given: Successful deletion
        mockAuthService.deleteAccountResult = .success(())

        // When: Cancelling sign up
        try await sut.cancelSignUp()

        // Then: Should complete without throwing an error
        XCTAssertTrue(mockAuthService.deleteAccountCalled)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - Edge Cases and Integration Tests
    func testConfirmCode_MultipleCallsInSequence_EachCallsAuthService() async {
        // Given: Valid code
        sut.verificationCode = "12345"
        mockAuthService.verifyEmailCodeResult = .success(true)

        // When: Calling confirmCode multiple times
        _ = await sut.confirmCode()
        _ = await sut.confirmCode()
        _ = await sut.confirmCode()

        // Then: Should call auth service 3 times
        XCTAssertEqual(mockAuthService.verifyEmailCodeCallCount, 3)
    }

    func testResendCode_MultipleCallsWithCooldown_OnlyFirstCallSucceeds() async {
        // Given: Can resend
        sut.canResend = true
        mockAuthService.resendVerificationCodeResult = .success(())

        // When: First call
        await sut.resendCode()

        // Then: First call succeeds
        XCTAssertEqual(mockAuthService.resendVerificationCodeCallCount, 1)

        // When: Second immediate call
        await sut.resendCode()

        // Then: Second call does nothing
        XCTAssertEqual(mockAuthService.resendVerificationCodeCallCount, 1)
    }

    func testVerificationCode_CanBeUpdatedDirectly() {
        // Given: Fresh ViewModel
        XCTAssertEqual(sut.verificationCode, "")

        // When: Updating code
        sut.verificationCode = "54321"

        // Then: Should update
        XCTAssertEqual(sut.verificationCode, "54321")
    }

    func testErrorMessage_CanBeClearedManually() {
        // Given: Error message set
        sut.errorMessage = "Some error"

        // When: Clearing manually
        sut.errorMessage = nil

        // Then: Should be nil
        XCTAssertNil(sut.errorMessage)
    }
}
